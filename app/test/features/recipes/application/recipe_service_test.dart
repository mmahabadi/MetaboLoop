import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/recipes/application/recipe_service.dart';
import 'package:metaboloop/features/recipes/domain/draft_ingredient_line.dart';

Future<LocalFood> _insertFood(
  AppDatabase db, {
  required String name,
  required double caloriesPer100g,
  double proteinPer100gGrams = 0,
  double carbsPer100gGrams = 0,
  double fatPer100gGrams = 0,
}) async {
  final food = LocalFood(
    id: name,
    name: name,
    caloriesPer100g: caloriesPer100g,
    proteinPer100gGrams: proteinPer100gGrams,
    carbsPer100gGrams: carbsPer100gGrams,
    fatPer100gGrams: fatPer100gGrams,
    source: FoodSource.custom,
    isVerified: false,
    createdAt: DateTime(2026, 1, 1),
  );
  await db.into(db.localFoods).insertOnConflictUpdate(food);
  return food;
}

void main() {
  late AppDatabase db;
  late RecipeService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = RecipeService(db);
  });

  tearDown(() => db.close());

  test('computes totals for a flat recipe (foods only)', () async {
    final flour = await _insertFood(
      db,
      name: 'Flour',
      caloriesPer100g: 364,
      carbsPer100gGrams: 76,
    );
    final milk = await _insertFood(
      db,
      name: 'Milk',
      caloriesPer100g: 42,
      proteinPer100gGrams: 3.4,
    );

    final recipeId = await service.saveRecipe(
      name: 'Pancake batter',
      servings: 2,
      lines: [
        DraftIngredientLine.food(food: flour, quantityGrams: 200),
        DraftIngredientLine.food(food: milk, quantityGrams: 300),
      ],
    );

    final total = await service.computeRecipeTotals(recipeId);
    // 200g flour: 728 kcal, 152g carbs. 300g milk: 126 kcal, 10.2g protein.
    expect(total.calories, closeTo(854, 0.5));
    expect(total.carbsGrams, closeTo(152, 0.5));
    expect(total.proteinGrams, closeTo(10.2, 0.5));

    final perServing = await service.perServingTotals(recipeId);
    expect(perServing.calories, closeTo(427, 0.5));
  });

  test('recursively totals a recipe nested inside another recipe', () async {
    final flour = await _insertFood(db, name: 'Flour', caloriesPer100g: 364);
    final eggs = await _insertFood(
      db,
      name: 'Eggs',
      caloriesPer100g: 155,
      proteinPer100gGrams: 13,
    );

    final batterId = await service.saveRecipe(
      name: 'Pancake batter',
      servings: 2,
      lines: [DraftIngredientLine.food(food: flour, quantityGrams: 200)],
    );
    // Total batter = 728 kcal over 2 servings -> 364 kcal/serving.

    final batterRecipe = Recipe(
      id: batterId,
      name: 'Pancake batter',
      servings: 2,
      createdAt: DateTime(2026, 1, 1),
    );

    final plateId = await service.saveRecipe(
      name: 'Breakfast plate',
      servings: 1,
      lines: [
        DraftIngredientLine.recipe(childRecipe: batterRecipe, servingsCount: 1),
        DraftIngredientLine.food(food: eggs, quantityGrams: 100),
      ],
    );

    final total = await service.computeRecipeTotals(plateId);
    // 1 serving of batter (364 kcal) + 100g eggs (155 kcal) = 519 kcal.
    expect(total.calories, closeTo(519, 0.5));
    expect(total.proteinGrams, closeTo(13, 0.5));
  });
}
