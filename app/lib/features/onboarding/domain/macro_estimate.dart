class MacroEstimate {
  const MacroEstimate({
    required this.bmr,
    required this.tdee,
    required this.calories,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbsGrams,
  });

  /// Basal metabolic rate (kcal/day).
  final double bmr;

  /// Total daily energy expenditure before any goal adjustment (kcal/day).
  final double tdee;

  /// Goal-adjusted daily calorie target — the starting estimate.
  final double calories;

  final double proteinGrams;
  final double fatGrams;
  final double carbsGrams;
}
