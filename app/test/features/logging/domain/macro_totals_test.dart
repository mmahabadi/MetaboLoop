import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/logging/domain/macro_totals.dart';

LogEntry _entry({
  required double calories,
  required double protein,
  required double carbs,
  required double fat,
  double? fiber,
  double? sugar,
  double? sodium,
}) {
  return LogEntry(
    id: 'e',
    loggedAt: DateTime(2026, 1, 1),
    displayName: 'Test food',
    calories: calories,
    proteinGrams: protein,
    carbsGrams: carbs,
    fatGrams: fat,
    fiberGrams: fiber,
    sugarGrams: sugar,
    sodiumMg: sodium,
    quantityLabel: '100 g',
    method: LogMethod.manual,
  );
}

void main() {
  group('MacroTotals.ofEntries', () {
    test('sums an empty list to zero', () {
      final total = MacroTotals.ofEntries(const []);
      expect(total.calories, 0);
      expect(total.proteinGrams, 0);
      expect(total.carbsGrams, 0);
      expect(total.fatGrams, 0);
    });

    test('sums multiple entries', () {
      final entries = [
        _entry(calories: 200, protein: 10, carbs: 20, fat: 5),
        _entry(calories: 150, protein: 8, carbs: 15, fat: 3),
      ];

      final total = MacroTotals.ofEntries(entries);

      expect(total.calories, 350);
      expect(total.proteinGrams, 18);
      expect(total.carbsGrams, 35);
      expect(total.fatGrams, 8);
    });

    test(
      'sums fiber/sugar/sodium, treating missing values as absent, not zero',
      () {
        final entries = [
          _entry(
            calories: 200,
            protein: 10,
            carbs: 20,
            fat: 5,
            fiber: 3,
            sugar: 8,
            sodium: 400,
          ),
          _entry(calories: 150, protein: 8, carbs: 15, fat: 3),
        ];

        final total = MacroTotals.ofEntries(entries);

        expect(total.fiberGrams, 3);
        expect(total.sugarGrams, 8);
        expect(total.sodiumMg, 400);
      },
    );

    test('fiber/sugar/sodium stay null when no entry logged them', () {
      final entries = [_entry(calories: 200, protein: 10, carbs: 20, fat: 5)];

      final total = MacroTotals.ofEntries(entries);

      expect(total.fiberGrams, isNull);
      expect(total.sugarGrams, isNull);
      expect(total.sodiumMg, isNull);
    });
  });

  group('scaleFoodToQuantity', () {
    test('scales per-100g nutrition to the logged quantity', () {
      final food = LocalFood(
        id: 'f1',
        name: 'Chicken breast',
        caloriesPer100g: 165,
        proteinPer100gGrams: 31,
        carbsPer100gGrams: 0,
        fatPer100gGrams: 3.6,
        sodiumPer100gMg: 74,
        source: FoodSource.usda,
        isVerified: true,
        createdAt: DateTime(2026, 1, 1),
      );

      final result = scaleFoodToQuantity(food, 150);

      expect(result.calories, closeTo(247.5, 0.01));
      expect(result.proteinGrams, closeTo(46.5, 0.01));
      expect(result.carbsGrams, 0);
      expect(result.fatGrams, closeTo(5.4, 0.01));
      expect(result.sodiumMg, closeTo(111, 0.01));
      expect(result.fiberGrams, isNull);
    });

    test('a 100g quantity returns the per-100g values unchanged', () {
      final food = LocalFood(
        id: 'f2',
        name: 'Banana',
        caloriesPer100g: 89,
        proteinPer100gGrams: 1.1,
        carbsPer100gGrams: 22.8,
        fatPer100gGrams: 0.3,
        source: FoodSource.openFoodFacts,
        isVerified: true,
        createdAt: DateTime(2026, 1, 1),
      );

      final result = scaleFoodToQuantity(food, 100);

      expect(result.calories, 89);
      expect(result.proteinGrams, 1.1);
      expect(result.carbsGrams, 22.8);
      expect(result.fatGrams, 0.3);
    });
  });
}
