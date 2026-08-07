import '../../../core/database/app_database.dart';

class MacroTotals {
  const MacroTotals({
    this.calories = 0,
    this.proteinGrams = 0,
    this.carbsGrams = 0,
    this.fatGrams = 0,
  });

  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  MacroTotals operator +(MacroTotals other) {
    return MacroTotals(
      calories: calories + other.calories,
      proteinGrams: proteinGrams + other.proteinGrams,
      carbsGrams: carbsGrams + other.carbsGrams,
      fatGrams: fatGrams + other.fatGrams,
    );
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
  );
}
