import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../logging/domain/macro_totals.dart';
import '../domain/draft_ingredient_line.dart';

const _uuid = Uuid();

/// Recipe creation and (recursively) recipe-within-recipe macro totals —
/// the nesting requirement from the Phase 2 spec.
class RecipeService {
  RecipeService(this._db);

  final AppDatabase _db;

  /// Totals for the whole recipe (all servings combined), computed by
  /// walking its ingredients — including nested recipes, recursively.
  Future<MacroTotals> computeRecipeTotals(String recipeId) async {
    final ingredients = await _db.getRecipeIngredients(recipeId);
    var total = const MacroTotals();

    for (final ingredient in ingredients) {
      if (ingredient.foodId != null) {
        final food = await (_db.select(
          _db.localFoods,
        )..where((f) => f.id.equals(ingredient.foodId!))).getSingle();
        total += scaleFoodToQuantity(food, ingredient.quantityGrams ?? 0);
      } else if (ingredient.childRecipeId != null) {
        total += await _servingsOfChildRecipe(
          ingredient.childRecipeId!,
          ingredient.servingsCount ?? 1,
        );
      }
    }
    return total;
  }

  Future<MacroTotals> _servingsOfChildRecipe(
    String childRecipeId,
    double servings,
  ) async {
    final childRecipe = await (_db.select(
      _db.recipes,
    )..where((r) => r.id.equals(childRecipeId))).getSingle();
    final childTotal = await computeRecipeTotals(childRecipeId);
    final perServing = MacroTotals(
      calories: childTotal.calories / childRecipe.servings,
      proteinGrams: childTotal.proteinGrams / childRecipe.servings,
      carbsGrams: childTotal.carbsGrams / childRecipe.servings,
      fatGrams: childTotal.fatGrams / childRecipe.servings,
    );
    return MacroTotals(
      calories: perServing.calories * servings,
      proteinGrams: perServing.proteinGrams * servings,
      carbsGrams: perServing.carbsGrams * servings,
      fatGrams: perServing.fatGrams * servings,
    );
  }

  Future<MacroTotals> perServingTotals(String recipeId) async {
    final recipe = await (_db.select(
      _db.recipes,
    )..where((r) => r.id.equals(recipeId))).getSingle();
    final total = await computeRecipeTotals(recipeId);
    return MacroTotals(
      calories: total.calories / recipe.servings,
      proteinGrams: total.proteinGrams / recipe.servings,
      carbsGrams: total.carbsGrams / recipe.servings,
      fatGrams: total.fatGrams / recipe.servings,
    );
  }

  Future<String> saveRecipe({
    required String name,
    required int servings,
    required List<DraftIngredientLine> lines,
  }) async {
    final recipeId = await _db.insertRecipe(
      RecipesCompanion.insert(
        id: _uuid.v4(),
        name: name,
        servings: Value(servings),
      ),
    );

    for (final line in lines) {
      await _db.insertRecipeIngredient(
        RecipeIngredientsCompanion.insert(
          id: _uuid.v4(),
          recipeId: recipeId,
          foodId: Value(line.food?.id),
          childRecipeId: Value(line.childRecipe?.id),
          quantityGrams: Value(line.quantityGrams),
          servingsCount: Value(line.servingsCount),
        ),
      );
    }
    return recipeId;
  }
}

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService(ref.watch(databaseProvider));
});
