import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/coaching/application/coaching_service.dart';
import 'package:metaboloop/features/coaching/domain/coaching_mode.dart';
import 'package:metaboloop/features/onboarding/domain/body_stats.dart';
import 'package:metaboloop/features/onboarding/domain/macro_estimate.dart';

const _estimate = MacroEstimate(
  bmr: 1500,
  tdee: 2200,
  calories: 1900,
  proteinGrams: 150,
  fatGrams: 60,
  carbsGrams: 180,
);

Future<void> _seedWeekOfData(
  AppDatabase db, {
  required DateTime weekStart,
  required List<double> dailyCalories,
  required double startWeightKg,
  required double endWeightKg,
}) async {
  for (var i = 0; i < dailyCalories.length; i++) {
    final day = weekStart.add(Duration(days: i));
    if (dailyCalories[i] > 0) {
      await db.insertLogEntry(
        LogEntriesCompanion.insert(
          id: 'e-$i',
          loggedAt: day,
          displayName: 'Day $i food',
          calories: dailyCalories[i],
          proteinGrams: 0,
          carbsGrams: 0,
          fatGrams: 0,
          quantityLabel: '1 serving',
          method: LogMethod.manual,
        ),
      );
    }
  }
  // A daily reading each day (rather than just two endpoints) so the EWMA
  // trend actually tracks the change over the week instead of damping a
  // single late jump — orchestration tests care about outcome/direction,
  // not reproducing the smoother's exact math (covered separately in
  // weight_trend_smoother_test.dart).
  for (var i = 0; i <= 7; i++) {
    final day = weekStart.add(Duration(days: i));
    final weight = startWeightKg + (endWeightKg - startWeightKg) * (i / 7);
    await db.upsertWeightEntry(
      WeightEntriesCompanion.insert(id: 'w-$i', date: day, weightKg: weight),
    );
  }
}

void main() {
  late AppDatabase db;
  late CoachingService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = CoachingService(db);
  });

  tearDown(() => db.close());

  test(
    'ensureInitialTarget creates exactly one target from the onboarding estimate',
    () async {
      await service.ensureInitialTarget(_estimate);
      await service.ensureInitialTarget(_estimate); // should no-op

      final history = await db.getTargetHistory();
      expect(history, hasLength(1));
      expect(history.single.calories, 1900);
      expect(history.single.source, TargetSource.onboarding);
    },
  );

  test('does not run before a full week has elapsed', () async {
    final start = DateTime(2026, 1, 1);
    await db.insertTarget(
      TargetsCompanion.insert(
        id: 't1',
        effectiveDate: start,
        calories: 1900,
        proteinGrams: 150,
        carbsGrams: 180,
        fatGrams: 60,
        reasoning: 'initial',
        source: TargetSource.onboarding,
      ),
    );

    final run = await service.runWeeklyRecalculationIfDue(
      mode: CoachingMode.automatic,
      goal: Goal.loseFat,
      now: start.add(const Duration(days: 3)),
    );

    expect(run, isNull);
  });

  test('automatic mode applies the recalculated target immediately', () async {
    final start = DateTime(2026, 1, 1);
    await db.insertTarget(
      TargetsCompanion.insert(
        id: 't1',
        effectiveDate: start,
        calories: 1900,
        proteinGrams: 150,
        carbsGrams: 180,
        fatGrams: 60,
        reasoning: 'initial',
        source: TargetSource.onboarding,
      ),
    );
    await _seedWeekOfData(
      db,
      weekStart: start,
      dailyCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
      startWeightKg: 80.0,
      endWeightKg: 79.5,
    );

    final run = await service.runWeeklyRecalculationIfDue(
      mode: CoachingMode.automatic,
      goal: Goal.loseFat,
      now: start.add(const Duration(days: 7)),
    );

    expect(run, isNotNull);
    expect(run!.outcome, CoachingRunOutcome.applied);
    expect(run.resultingTargetId, isNotNull);

    final current = await db.getCurrentTarget();
    expect(current!.source, TargetSource.coachingAlgorithm);
    expect(current.calories, run.newCalories);
    expect(
      current.calories,
      isNot(1900),
      reason: 'a week of real data should move the target',
    );
  });

  test(
    'collaborative mode suggests but does not change the active target until approved',
    () async {
      final start = DateTime(2026, 1, 1);
      await db.insertTarget(
        TargetsCompanion.insert(
          id: 't1',
          effectiveDate: start,
          calories: 1900,
          proteinGrams: 150,
          carbsGrams: 180,
          fatGrams: 60,
          reasoning: 'initial',
          source: TargetSource.onboarding,
        ),
      );
      await _seedWeekOfData(
        db,
        weekStart: start,
        dailyCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
        startWeightKg: 80.0,
        endWeightKg: 79.5,
      );

      final run = await service.runWeeklyRecalculationIfDue(
        mode: CoachingMode.collaborative,
        goal: Goal.loseFat,
        now: start.add(const Duration(days: 7)),
      );

      expect(run!.outcome, CoachingRunOutcome.suggested);
      expect(run.newCalories, isNotNull);

      final beforeApproval = await db.getCurrentTarget();
      expect(
        beforeApproval!.calories,
        1900,
        reason: 'unchanged until approved',
      );

      await service.approveSuggestion(run);

      final afterApproval = await db.getCurrentTarget();
      expect(afterApproval!.calories, run.newCalories);
      expect(afterApproval.source, TargetSource.coachingAlgorithm);
    },
  );

  test('manual mode never computes or changes targets', () async {
    final start = DateTime(2026, 1, 1);
    await db.insertTarget(
      TargetsCompanion.insert(
        id: 't1',
        effectiveDate: start,
        calories: 1900,
        proteinGrams: 150,
        carbsGrams: 180,
        fatGrams: 60,
        reasoning: 'initial',
        source: TargetSource.onboarding,
      ),
    );
    await _seedWeekOfData(
      db,
      weekStart: start,
      dailyCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
      startWeightKg: 80.0,
      endWeightKg: 79.5,
    );

    final run = await service.runWeeklyRecalculationIfDue(
      mode: CoachingMode.manual,
      goal: Goal.loseFat,
      now: start.add(const Duration(days: 7)),
    );

    expect(run!.outcome, CoachingRunOutcome.skippedManualMode);
    expect(run.newCalories, isNull);

    final current = await db.getCurrentTarget();
    expect(current!.calories, 1900);
  });

  test(
    'records insufficientData and leaves targets unchanged with too few logged days',
    () async {
      final start = DateTime(2026, 1, 1);
      await db.insertTarget(
        TargetsCompanion.insert(
          id: 't1',
          effectiveDate: start,
          calories: 1900,
          proteinGrams: 150,
          carbsGrams: 180,
          fatGrams: 60,
          reasoning: 'initial',
          source: TargetSource.onboarding,
        ),
      );
      await _seedWeekOfData(
        db,
        weekStart: start,
        dailyCalories: [2000, 1900, 0, 0, 0, 0, 0],
        startWeightKg: 80.0,
        endWeightKg: 79.8,
      );

      final run = await service.runWeeklyRecalculationIfDue(
        mode: CoachingMode.automatic,
        goal: Goal.loseFat,
        now: start.add(const Duration(days: 7)),
      );

      expect(run!.outcome, CoachingRunOutcome.insufficientData);
      final current = await db.getCurrentTarget();
      expect(current!.calories, 1900);
    },
  );
}
