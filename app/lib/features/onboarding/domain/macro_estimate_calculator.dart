import 'body_stats.dart';
import 'goal_macro_policy.dart';
import 'macro_estimate.dart';

/// Produces the Phase 1 *starting* calorie/macro estimate, shown to the
/// user clearly labeled as an estimate subject to weekly recalibration by
/// the Phase 3 adaptive coaching algorithm — this calculator is not that
/// algorithm, it only seeds it.
abstract final class MacroEstimateCalculator {
  static double bmr(BodyStats stats) {
    // Mifflin-St Jeor.
    final base =
        10 * stats.weightKg + 6.25 * stats.heightCm - 5 * stats.ageYears;
    return stats.sex == Sex.male ? base + 5 : base - 161;
  }

  static MacroEstimate estimate({
    required BodyStats stats,
    required ActivityLevel activityLevel,
    required Goal goal,
  }) {
    final bmrValue = bmr(stats);
    final tdee = bmrValue * activityLevel.multiplier;
    final calories = tdee * GoalMacroPolicy.calorieAdjustmentFactor[goal]!;

    final split = GoalMacroPolicy.splitMacros(
      calories: calories,
      goal: goal,
      bodyWeightKg: stats.weightKg,
    );

    return MacroEstimate(
      bmr: bmrValue,
      tdee: tdee,
      calories: calories,
      proteinGrams: split.proteinGrams,
      fatGrams: split.fatGrams,
      carbsGrams: split.carbsGrams,
    );
  }
}
