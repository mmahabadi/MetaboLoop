import '../../../core/database/app_database.dart';

/// An ingredient line being edited in the recipe builder, before it's
/// persisted. Exactly one of [food]/[quantityGrams] or
/// [childRecipe]/[servingsCount] is set — a recipe-within-recipe line
/// references another saved [Recipe] rather than a [LocalFood].
class DraftIngredientLine {
  const DraftIngredientLine.food({
    required this.food,
    required this.quantityGrams,
  }) : childRecipe = null,
       servingsCount = null;

  const DraftIngredientLine.recipe({
    required this.childRecipe,
    required this.servingsCount,
  }) : food = null,
       quantityGrams = null;

  final LocalFood? food;
  final double? quantityGrams;
  final Recipe? childRecipe;
  final double? servingsCount;

  String get displayName => food?.name ?? childRecipe?.name ?? '';

  String get quantityLabel {
    if (food != null) return '${quantityGrams!.round()} g';
    final servings = servingsCount!;
    final label = servings == servings.roundToDouble()
        ? servings.round().toString()
        : servings.toStringAsFixed(1);
    return '$label serving(s)';
  }
}
