import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../onboarding/domain/body_stats.dart';
import '../../onboarding/domain/macro_estimate.dart';
import '../domain/coaching_calculation.dart';
import '../domain/coaching_mode.dart';
import '../domain/weight_trend_smoother.dart';

const _uuid = Uuid();

/// Orchestrates the weekly coaching job: decides whether a week has
/// actually elapsed since the last run, gathers the real data the
/// algorithm needs, calls it, and — depending on [CoachingMode] — either
/// applies the result, records it as a suggestion awaiting approval, or
/// skips it. This is the interim client-side implementation of the
/// Checkpoint 2 architecture decision (a scheduled server-side Supabase
/// Edge Function); see app/README.md.
class CoachingService {
  CoachingService(this._db);

  final AppDatabase _db;

  /// Called once, right after onboarding, so there's a first versioned
  /// target for the algorithm to build on and the Coach tab to show.
  /// No-ops if a target already exists.
  Future<void> ensureInitialTarget(MacroEstimate estimate) async {
    final existing = await _db.getCurrentTarget();
    if (existing != null) return;

    await _db.insertTarget(
      TargetsCompanion.insert(
        id: _uuid.v4(),
        effectiveDate: DateTime.now(),
        calories: estimate.calories,
        proteinGrams: estimate.proteinGrams,
        carbsGrams: estimate.carbsGrams,
        fatGrams: estimate.fatGrams,
        reasoning:
            'Starting estimate from onboarding, based on your body stats '
            'and activity level — this is a guess until there\'s enough '
            'logged data to recalculate from.',
        source: TargetSource.onboarding,
      ),
    );
  }

  /// Runs the weekly recalculation if a full week has elapsed since the
  /// last one (or since the initial target, if no run has happened yet).
  /// Returns null if it's not due yet or there's no target to build on.
  Future<CoachingRun?> runWeeklyRecalculationIfDue({
    required CoachingMode mode,
    required Goal goal,
    DateTime? now,
  }) async {
    final effectiveNow = now ?? DateTime.now();
    final currentTarget = await _db.getCurrentTarget();
    if (currentTarget == null) return null;

    final lastRun = await _db.getMostRecentCoachingRun();
    final weekStart = lastRun != null
        ? _dayOnly(lastRun.weekEnd)
        : _dayOnly(currentTarget.effectiveDate);
    final weekEnd = weekStart.add(const Duration(days: 7));

    if (effectiveNow.isBefore(weekEnd)) return null;

    if (mode == CoachingMode.manual) {
      return _recordRun(
        weekStart: weekStart,
        weekEnd: weekEnd,
        outcome: CoachingRunOutcome.skippedManualMode,
        reasoning:
            'Manual mode is active — targets are set by you, not '
            'recalculated automatically.',
      );
    }

    final dailyTotals = await _dailyLoggedCalories(weekStart);
    // A 60-day warm-up window gives the EWMA trend something to seed from
    // even if the user only started logging weight recently.
    final weightEntries = await _db.getWeightEntriesBetween(
      weekStart.subtract(const Duration(days: 60)),
      weekEnd,
    );
    final trendStart = WeightTrendSmoother.trendWeightAsOf(
      weightEntries,
      weekStart,
    );
    final trendEnd = WeightTrendSmoother.trendWeightAsOf(
      weightEntries,
      weekEnd,
    );

    final result = CoachingCalculator.calculate(
      dailyLoggedCalories: dailyTotals,
      trendWeightKgAtWeekStart: trendStart,
      trendWeightKgAtWeekEnd: trendEnd,
      // Unused by CoachingCalculator whenever the trend is null (the
      // insufficient-data branch returns before touching it); the
      // fallback here only avoids passing a bogus non-null default in
      // the one path where it's actually read.
      currentBodyWeightKg: trendEnd ?? trendStart ?? 0,
      goal: goal,
      previousCalories: currentTarget.calories,
    );

    if (result.outcome == CoachingCalculationOutcome.insufficientData) {
      return _recordRun(
        weekStart: weekStart,
        weekEnd: weekEnd,
        outcome: CoachingRunOutcome.insufficientData,
        reasoning: result.reasoning,
        avgDailyIntakeCalories: result.avgDailyIntakeCalories,
        weightChangeKg: result.weightChangeKg,
      );
    }

    final shouldApplyImmediately = mode == CoachingMode.automatic;
    String? newTargetId;
    if (shouldApplyImmediately) {
      newTargetId = await _applyNewTarget(
        calories: result.newCalories!,
        proteinGrams: result.newProteinGrams!,
        carbsGrams: result.newCarbsGrams!,
        fatGrams: result.newFatGrams!,
        reasoning: result.reasoning,
      );
    }

    return _recordRun(
      weekStart: weekStart,
      weekEnd: weekEnd,
      outcome: shouldApplyImmediately
          ? CoachingRunOutcome.applied
          : CoachingRunOutcome.suggested,
      reasoning: result.reasoning,
      avgDailyIntakeCalories: result.avgDailyIntakeCalories,
      weightChangeKg: result.weightChangeKg,
      calculatedTdee: result.calculatedTdee,
      previousCalories: currentTarget.calories,
      newCalories: result.newCalories,
      newProteinGrams: result.newProteinGrams,
      newCarbsGrams: result.newCarbsGrams,
      newFatGrams: result.newFatGrams,
      resultingTargetId: newTargetId,
    );
  }

  /// Approves a suggested (collaborative-mode) coaching run, applying its
  /// already-persisted suggested target as a new versioned target.
  Future<void> approveSuggestion(CoachingRun run) async {
    final targetId = await _applyNewTarget(
      calories: run.newCalories!,
      proteinGrams: run.newProteinGrams!,
      carbsGrams: run.newCarbsGrams!,
      fatGrams: run.newFatGrams!,
      reasoning: run.reasoning,
    );
    await (_db.update(
      _db.coachingRuns,
    )..where((r) => r.id.equals(run.id))).write(
      CoachingRunsCompanion(
        outcome: const Value(CoachingRunOutcome.applied),
        resultingTargetId: Value(targetId),
      ),
    );
  }

  /// Rejects a suggested coaching run — the current target is left
  /// unchanged and the suggestion won't be shown again.
  Future<void> rejectSuggestion(CoachingRun run) async {
    await (_db.update(
      _db.coachingRuns,
    )..where((r) => r.id.equals(run.id))).write(
      const CoachingRunsCompanion(outcome: Value(CoachingRunOutcome.rejected)),
    );
  }

  Future<String> _applyNewTarget({
    required double calories,
    required double proteinGrams,
    required double carbsGrams,
    required double fatGrams,
    required String reasoning,
  }) async {
    final id = _uuid.v4();
    await _db.insertTarget(
      TargetsCompanion.insert(
        id: id,
        effectiveDate: DateTime.now(),
        calories: calories,
        proteinGrams: proteinGrams,
        carbsGrams: carbsGrams,
        fatGrams: fatGrams,
        reasoning: reasoning,
        source: TargetSource.coachingAlgorithm,
      ),
    );
    return id;
  }

  Future<CoachingRun> _recordRun({
    required DateTime weekStart,
    required DateTime weekEnd,
    required CoachingRunOutcome outcome,
    required String reasoning,
    double? avgDailyIntakeCalories,
    double? weightChangeKg,
    double? calculatedTdee,
    double? previousCalories,
    double? newCalories,
    double? newProteinGrams,
    double? newCarbsGrams,
    double? newFatGrams,
    String? resultingTargetId,
  }) async {
    final id = _uuid.v4();
    final companion = CoachingRunsCompanion.insert(
      id: id,
      weekStart: weekStart,
      weekEnd: weekEnd,
      outcome: outcome,
      reasoning: reasoning,
      avgDailyIntakeCalories: Value(avgDailyIntakeCalories),
      weightChangeKg: Value(weightChangeKg),
      calculatedTdee: Value(calculatedTdee),
      previousCalories: Value(previousCalories),
      newCalories: Value(newCalories),
      newProteinGrams: Value(newProteinGrams),
      newCarbsGrams: Value(newCarbsGrams),
      newFatGrams: Value(newFatGrams),
      resultingTargetId: Value(resultingTargetId),
    );
    await _db.insertCoachingRun(companion);
    final saved = await (_db.select(
      _db.coachingRuns,
    )..where((r) => r.id.equals(id))).getSingle();
    return saved;
  }

  Future<List<double>> _dailyLoggedCalories(DateTime weekStart) async {
    final totals = <double>[];
    for (var i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final dayEntries = await _db.getLogEntriesForDate(day);
      totals.add(dayEntries.fold(0.0, (sum, e) => sum + e.calories));
    }
    return totals;
  }

  DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}
