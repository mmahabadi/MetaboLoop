import 'package:drift/drift.dart';

enum FoodSource { usda, openFoodFacts, custom, aiGenerated }

enum LogMethod { manual, barcode, photo, naturalLanguage, quickAdd, recipe }

/// Locally cached/custom foods, normalized per 100g so any logged quantity
/// can be computed without re-fetching. Records pulled from a remote
/// database (USDA/Open Food Facts) are cached here on first use.
class LocalFoods extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100gGrams => real()();
  RealColumn get carbsPer100gGrams => real()();
  RealColumn get fatPer100gGrams => real()();
  RealColumn get defaultServingGrams => real().nullable()();
  TextColumn get defaultServingLabel => text().nullable()();
  TextColumn get source => textEnum<FoodSource>()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// A recipe: a named collection of ingredients (foods and/or nested
/// recipes) that together yield a number of servings.
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get servings => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// One line in a recipe: either a food + quantity, or a nested recipe +
/// number of servings of that nested recipe — never both.
class RecipeIngredients extends Table {
  TextColumn get id => text()();
  @ReferenceName('ingredientLines')
  TextColumn get recipeId =>
      text().references(Recipes, #id, onDelete: KeyAction.cascade)();
  TextColumn get foodId => text().nullable().references(LocalFoods, #id)();
  @ReferenceName('parentIngredientLines')
  TextColumn get childRecipeId => text().nullable().references(Recipes, #id)();
  RealColumn get quantityGrams => real().nullable()();
  RealColumn get servingsCount => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A timeline entry in the daily log. Nutrition values are snapshotted at
/// log time (rather than joined live from LocalFoods/Recipes) so editing a
/// food or recipe later never rewrites history.
class LogEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get displayName => text()();
  RealColumn get calories => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  TextColumn get quantityLabel => text()();
  TextColumn get method => textEnum<LogMethod>()();
  TextColumn get sourceFoodId =>
      text().nullable().references(LocalFoods, #id)();
  TextColumn get sourceRecipeId => text().nullable().references(Recipes, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
