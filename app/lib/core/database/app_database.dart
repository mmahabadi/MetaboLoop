import 'package:drift/drift.dart';

import 'tables.dart';

export 'tables.dart' show FoodSource, LogMethod;

part 'app_database.g.dart';

@DriftDatabase(tables: [LocalFoods, Recipes, RecipeIngredients, LogEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  Future<List<LocalFood>> searchLocalFoods(String query) {
    final pattern = '%${query.trim()}%';
    return (select(localFoods)
          ..where((f) => f.name.like(pattern) | f.brand.like(pattern))
          ..limit(30))
        .get();
  }

  Future<LocalFood?> getFoodByBarcode(String barcode) {
    return (select(
      localFoods,
    )..where((f) => f.barcode.equals(barcode))).getSingleOrNull();
  }

  Future<void> upsertFood(LocalFoodsCompanion food) {
    return into(localFoods).insertOnConflictUpdate(food);
  }

  Future<void> insertLogEntry(LogEntriesCompanion entry) {
    return into(logEntries).insert(entry);
  }

  Future<void> deleteLogEntry(String id) {
    return (delete(logEntries)..where((e) => e.id.equals(id))).go();
  }

  Stream<List<LogEntry>> watchLogEntriesForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(logEntries)
          ..where((e) => e.loggedAt.isBetweenValues(start, end))
          ..orderBy([(e) => OrderingTerm.asc(e.loggedAt)]))
        .watch();
  }

  Future<List<LogEntry>> getLogEntriesForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return (select(logEntries)
          ..where((e) => e.loggedAt.isBetweenValues(start, end))
          ..orderBy([(e) => OrderingTerm.asc(e.loggedAt)]))
        .get();
  }

  Future<String> insertRecipe(RecipesCompanion recipe) async {
    final row = await into(
      recipes,
    ).insertReturning(recipe, mode: InsertMode.insertOrReplace);
    return row.id;
  }

  Future<void> insertRecipeIngredient(RecipeIngredientsCompanion ingredient) {
    return into(recipeIngredients).insert(ingredient);
  }

  Future<List<RecipeIngredient>> getRecipeIngredients(String recipeId) {
    return (select(
      recipeIngredients,
    )..where((i) => i.recipeId.equals(recipeId))).get();
  }

  Future<List<Recipe>> getAllRecipes() => select(recipes).get();

  /// A basic "smart suggestions" source: foods logged most recently,
  /// de-duplicated. Good enough for a quick-repeat list without needing
  /// the AI backend this project doesn't have configured yet.
  Future<List<LocalFood>> getRecentlyLoggedFoods({int limit = 10}) async {
    final recentEntries =
        await (select(logEntries)
              ..where((e) => e.sourceFoodId.isNotNull())
              ..orderBy([(e) => OrderingTerm.desc(e.loggedAt)])
              ..limit(50))
            .get();

    final foodIds = <String>[];
    final seen = <String>{};
    for (final entry in recentEntries) {
      final id = entry.sourceFoodId!;
      if (seen.add(id)) foodIds.add(id);
      if (foodIds.length >= limit) break;
    }
    if (foodIds.isEmpty) return const [];

    final foods = await (select(
      localFoods,
    )..where((f) => f.id.isIn(foodIds))).get();
    final byId = {for (final f in foods) f.id: f};
    return foodIds.map((id) => byId[id]).whereType<LocalFood>().toList();
  }
}
