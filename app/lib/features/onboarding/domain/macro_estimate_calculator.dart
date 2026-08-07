import 'body_stats.dart';
import 'macro_estimate.dart';

/// Produces the Phase 1 *starting* calorie/macro estimate, shown to the
/// user clearly labeled as an estimate subject to weekly recalibration by
/// the Phase 3 adaptive coaching algorithm — this calculator is not that
/// algorithm, it only seeds it.
abstract final class MacroEstimateCalculator {
  static const double _kcalPerGramProtein = 4;
  static const double _kcalPerGramFat = 9;
  static const double _kcalPerGramCarb = 4;

  static const Map<Goal, double> _calorieAdjustmentFactor = {
    Goal.loseFat: 0.80, // ~20% deficit
    Goal.recomposition: 0.90, // ~10% deficit
    Goal.maintain: 1.00,
    Goal.gainMuscle: 1.10, // ~10% surplus
  };

  static const Map<Goal, double> _proteinGramsPerKg = {
    Goal.loseFat: 2.2, // higher protein preserves lean mass in a deficit
    Goal.recomposition: 2.0,
    Goal.gainMuscle: 1.8,
    Goal.maintain: 1.6,
  };

  static const double _fatShareOfCalories = 0.25;

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
    final calories = tdee * _calorieAdjustmentFactor[goal]!;

    final proteinGrams = _proteinGramsPerKg[goal]! * stats.weightKg;
    final fatGrams = (calories * _fatShareOfCalories) / _kcalPerGramFat;

    final remainingCalories =
        calories -
        (proteinGrams * _kcalPerGramProtein) -
        (fatGrams * _kcalPerGramFat);
    // A very low calorie target combined with a high bodyweight-based
    // protein floor can otherwise drive carbs negative.
    final carbsGrams = (remainingCalories / _kcalPerGramCarb).clamp(
      0,
      double.infinity,
    );

    return MacroEstimate(
      bmr: bmrValue,
      tdee: tdee,
      calories: calories,
      proteinGrams: proteinGrams,
      fatGrams: fatGrams,
      carbsGrams: carbsGrams.toDouble(),
    );
  }
}
