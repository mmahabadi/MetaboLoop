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

/// A raw daily body-weight reading. [WeightTrendSmoother] turns a series of
/// these into a smoothed trend the coaching algorithm reads — the raw
/// values themselves are never overwritten so the trend can be recomputed.
class WeightEntries extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weightKg => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Who/what produced a [Targets] row or day override.
enum TargetSource { onboarding, coachingAlgorithm, userManual }

/// Versioned calorie/macro targets (Checkpoint 2, Phase 3 transparency
/// requirement) — one row per change, never mutated in place, so the full
/// history of *why* targets changed over time is always available.
class Targets extends Table {
  TextColumn get id => text()();
  DateTimeColumn get effectiveDate => dateTime()();
  RealColumn get calories => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  TextColumn get reasoning => text()();
  TextColumn get source => textEnum<TargetSource>()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// What a weekly coaching run concluded, independent of whether a mode
/// allowed it to actually change [Targets].
enum CoachingRunOutcome {
  applied,
  suggested,
  rejected,
  insufficientData,
  skippedManualMode,
}

/// Audit trail of every weekly recalculation attempt — including the ones
/// that didn't change anything — so the algorithm's behavior is always
/// inspectable, per the Phase 3 transparency requirement.
class CoachingRuns extends Table {
  TextColumn get id => text()();
  DateTimeColumn get weekStart => dateTime()();
  DateTimeColumn get weekEnd => dateTime()();
  RealColumn get avgDailyIntakeCalories => real().nullable()();
  RealColumn get weightChangeKg => real().nullable()();
  RealColumn get calculatedTdee => real().nullable()();
  RealColumn get previousCalories => real().nullable()();
  RealColumn get newCalories => real().nullable()();
  // The full suggested target, persisted so a collaborative-mode
  // suggestion survives an app restart before the user approves it —
  // approval reads these columns directly rather than needing the
  // in-memory calculation result to still be around.
  RealColumn get newProteinGrams => real().nullable()();
  RealColumn get newCarbsGrams => real().nullable()();
  RealColumn get newFatGrams => real().nullable()();
  TextColumn get outcome => textEnum<CoachingRunOutcome>()();
  TextColumn get reasoning => text()();
  DateTimeColumn get runAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get resultingTargetId =>
      text().nullable().references(Targets, #id)();

  @override
  Set<Column> get primaryKey => {id};
}

/// A per-day override of the standing targets (e.g. a higher-carb training
/// day) — applies only on [date], doesn't touch the versioned [Targets]
/// history.
class DayOverrides extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get calories => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  TextColumn get label => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
