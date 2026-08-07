import '../../../core/database/app_database.dart';

class MacroTotals {
  const MacroTotals({
    this.calories = 0,
    this.proteinGrams = 0,
    this.carbsGrams = 0,
    this.fatGrams = 0,
    this.fiberGrams,
    this.sugarGrams,
    this.sodiumMg,
  });

  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double? fiberGrams;
  final double? sugarGrams;
  final double? sodiumMg;

  MacroTotals operator +(MacroTotals other) {
    return MacroTotals(
      calories: calories + other.calories,
      proteinGrams: proteinGrams + other.proteinGrams,
      carbsGrams: carbsGrams + other.carbsGrams,
      fatGrams: fatGrams + other.fatGrams,
      fiberGrams: _sumNullable(fiberGrams, other.fiberGrams),
      sugarGrams: _sumNullable(sugarGrams, other.sugarGrams),
      sodiumMg: _sumNullable(sodiumMg, other.sodiumMg),
    );
  }

  static double? _sumNullable(double? a, double? b) {
    if (a == null && b == null) return null;
    return (a ?? 0) + (b ?? 0);
  }

  static MacroTotals ofEntries(Iterable<LogEntry> entries) {
    return entries.fold(
      const MacroTotals(),
      (total, entry) =>
          total +
          MacroTotals(
            calories: entry.calories,
            proteinGrams: entry.proteinGrams,
            carbsGrams: entry.carbsGrams,
            fatGrams: entry.fatGrams,
            fiberGrams: entry.fiberGrams,
            sugarGrams: entry.sugarGrams,
            sodiumMg: entry.sodiumMg,
          ),
    );
  }
}

/// Scales a food's per-100g nutrition to a specific logged quantity.
MacroTotals scaleFoodToQuantity(LocalFood food, double quantityGrams) {
  final factor = quantityGrams / 100;
  return MacroTotals(
    calories: food.caloriesPer100g * factor,
    proteinGrams: food.proteinPer100gGrams * factor,
    carbsGrams: food.carbsPer100gGrams * factor,
    fatGrams: food.fatPer100gGrams * factor,
    fiberGrams: food.fiberPer100gGrams == null
        ? null
        : food.fiberPer100gGrams! * factor,
    sugarGrams: food.sugarPer100gGrams == null
        ? null
        : food.sugarPer100gGrams! * factor,
    sodiumMg: food.sodiumPer100gMg == null
        ? null
        : food.sodiumPer100gMg! * factor,
  );
}
