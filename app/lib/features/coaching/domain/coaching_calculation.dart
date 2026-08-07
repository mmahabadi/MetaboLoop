import '../../onboarding/domain/body_stats.dart';
import '../../onboarding/domain/goal_macro_policy.dart';

enum CoachingCalculationOutcome { computed, insufficientData }

/// The result of one weekly recalculation attempt. When [outcome] is
/// [CoachingCalculationOutcome.insufficientData], only [reasoning] and
/// [outcome] are meaningful — the rest are null.
class CoachingCalculation {
  const CoachingCalculation({
    required this.outcome,
    required this.reasoning,
    this.avgDailyIntakeCalories,
    this.weightChangeKg,
    this.calculatedTdee,
    this.newCalories,
    this.newProteinGrams,
    this.newCarbsGrams,
    this.newFatGrams,
  });

  final CoachingCalculationOutcome outcome;
  final String reasoning;
  final double? avgDailyIntakeCalories;
  final double? weightChangeKg;
  final double? calculatedTdee;
  final double? newCalories;
  final double? newProteinGrams;
  final double? newCarbsGrams;
  final double? newFatGrams;
}

/// The Phase 3 adaptive coaching algorithm: back-calculates true energy
/// expenditure from what was actually eaten and what actually happened to
/// body weight over a week, then derives a new calorie/macro target.
///
/// **Adherence-neutral by construction**: this function's inputs are only
/// the week's actual logged intake and actual weight-trend change — it has
/// no parameter for the *previous* target or how closely it was followed.
/// [previousCalories] is accepted only as an optional safety bound (how far
/// the number is allowed to move in one week), never as an input to the
/// TDEE/target math itself.
abstract final class CoachingCalculator {
  /// Standard approximation: 1 kg of body weight change corresponds to
  /// roughly this many kcal of cumulative energy balance.
  static const double kcalPerKgBodyWeight = 7700;

  /// Below this many logged days in a 7-day week, the average intake isn't
  /// trustworthy enough to recalculate from.
  static const int minLoggedDaysPerWeek = 4;

  /// The recalculated calorie target is not allowed to move more than this
  /// many kcal/day from [previousCalories] in a single week, even if the
  /// raw calculation implies a bigger swing — guards against one noisy
  /// week overcorrecting the plan.
  static const double maxWeeklyCalorieStepKcal = 250;

  static CoachingCalculation calculate({
    required List<double> dailyLoggedCalories,
    required double? trendWeightKgAtWeekStart,
    required double? trendWeightKgAtWeekEnd,
    required double currentBodyWeightKg,
    required Goal goal,
    required double previousCalories,
  }) {
    final loggedDays = dailyLoggedCalories.where((c) => c > 0).length;
    if (loggedDays < minLoggedDaysPerWeek) {
      return CoachingCalculation(
        outcome: CoachingCalculationOutcome.insufficientData,
        reasoning:
            'Only $loggedDays day(s) logged this week (need '
            '$minLoggedDaysPerWeek+) — targets are unchanged until there\'s '
            'enough data to recalculate from.',
      );
    }
    if (trendWeightKgAtWeekStart == null || trendWeightKgAtWeekEnd == null) {
      return const CoachingCalculation(
        outcome: CoachingCalculationOutcome.insufficientData,
        reasoning:
            'No weight trend available yet — log your weight regularly so '
            'targets can be recalculated from what actually happens to '
            'your weight.',
      );
    }

    final totalLoggedCalories = dailyLoggedCalories.fold(
      0.0,
      (sum, c) => sum + c,
    );
    final avgDailyIntake = totalLoggedCalories / loggedDays;

    final weightChangeKg = trendWeightKgAtWeekEnd - trendWeightKgAtWeekStart;
    final weeklyEnergyBalance = weightChangeKg * kcalPerKgBodyWeight;
    final avgDailyBalance = weeklyEnergyBalance / 7;
    final calculatedTdee = avgDailyIntake - avgDailyBalance;

    final rawNewCalories =
        calculatedTdee * GoalMacroPolicy.calorieAdjustmentFactor[goal]!;
    final newCalories = rawNewCalories.clamp(
      previousCalories - maxWeeklyCalorieStepKcal,
      previousCalories + maxWeeklyCalorieStepKcal,
    );

    final split = GoalMacroPolicy.splitMacros(
      calories: newCalories,
      goal: goal,
      bodyWeightKg: currentBodyWeightKg,
    );

    final direction = weightChangeKg > 0
        ? 'gained'
        : weightChangeKg < 0
        ? 'lost'
        : 'held steady at';
    final reasoning =
        'You averaged ${avgDailyIntake.round()} kcal/day over $loggedDays '
        'logged days and $direction ${weightChangeKg.abs().toStringAsFixed(1)} kg '
        'of trend weight this week, which puts your true expenditure at '
        'about ${calculatedTdee.round()} kcal/day — targets are updated '
        'from that, not from how closely you hit last week\'s numbers.';

    return CoachingCalculation(
      outcome: CoachingCalculationOutcome.computed,
      reasoning: reasoning,
      avgDailyIntakeCalories: avgDailyIntake,
      weightChangeKg: weightChangeKg,
      calculatedTdee: calculatedTdee,
      newCalories: newCalories.toDouble(),
      newProteinGrams: split.proteinGrams,
      newCarbsGrams: split.carbsGrams,
      newFatGrams: split.fatGrams,
    );
  }
}
