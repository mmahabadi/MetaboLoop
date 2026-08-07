import 'body_stats.dart';

/// Goal-based calorie/macro policy shared by the Phase 1 starting estimate
/// ([MacroEstimateCalculator]) and the Phase 3 coaching algorithm's target
/// recalculation — one canonical source for "what a deficit/surplus and
/// macro split look like for each goal" so the two never drift apart.
abstract final class GoalMacroPolicy {
  static const double kcalPerGramProtein = 4;
  static const double kcalPerGramFat = 9;
  static const double kcalPerGramCarb = 4;

  static const Map<Goal, double> calorieAdjustmentFactor = {
    Goal.loseFat: 0.80, // ~20% deficit
    Goal.recomposition: 0.90, // ~10% deficit
    Goal.maintain: 1.00,
    Goal.gainMuscle: 1.10, // ~10% surplus
  };

  static const Map<Goal, double> proteinGramsPerKg = {
    Goal.loseFat: 2.2, // higher protein preserves lean mass in a deficit
    Goal.recomposition: 2.0,
    Goal.gainMuscle: 1.8,
    Goal.maintain: 1.6,
  };

  static const double fatShareOfCalories = 0.25;

  /// Splits a calorie target into protein/fat/carb grams for [goal] and
  /// [bodyWeightKg], clamping carbs at zero (a very low calorie target
  /// combined with a high bodyweight-based protein floor can otherwise
  /// drive carbs negative).
  static ({double proteinGrams, double fatGrams, double carbsGrams})
  splitMacros({
    required double calories,
    required Goal goal,
    required double bodyWeightKg,
  }) {
    final proteinGrams = proteinGramsPerKg[goal]! * bodyWeightKg;
    final fatGrams = (calories * fatShareOfCalories) / kcalPerGramFat;

    final remainingCalories =
        calories -
        (proteinGrams * kcalPerGramProtein) -
        (fatGrams * kcalPerGramFat);
    final carbsGrams = (remainingCalories / kcalPerGramCarb).clamp(
      0,
      double.infinity,
    );

    return (
      proteinGrams: proteinGrams,
      fatGrams: fatGrams,
      carbsGrams: carbsGrams.toDouble(),
    );
  }
}
