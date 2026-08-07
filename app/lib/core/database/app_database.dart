import 'package:drift/drift.dart';

import 'tables.dart';

export 'tables.dart'
    show FoodSource, LogMethod, TargetSource, CoachingRunOutcome, WorkoutType;

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalFoods,
    Recipes,
    RecipeIngredients,
    LogEntries,
    WeightEntries,
    Targets,
    CoachingRuns,
    DayOverrides,
    BodyMeasurements,
    ProgressPhotos,
    Habits,
    HabitCompletions,
    CycleEntries,
    Workouts,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      // Pre-launch: no real user data at stake yet, so schema changes just
      // recreate everything rather than writing per-version migrations.
      // Replace with real migrations before this ships with real users.
      for (final table in allTables) {
        await migrator.deleteTable(table.actualTableName);
      }
      await migrator.createAll();
    },
  );

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

  /// Every log entry ever recorded, oldest first — used for full-history
  /// CSV export rather than any on-screen view.
  Future<List<LogEntry>> getAllLogEntries() {
    return (select(
      logEntries,
    )..orderBy([(e) => OrderingTerm.asc(e.loggedAt)])).get();
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

  // --- Weight entries ---

  Future<void> upsertWeightEntry(WeightEntriesCompanion entry) {
    return into(weightEntries).insertOnConflictUpdate(entry);
  }

  /// Ascending by date — the shape [WeightTrendSmoother] expects.
  Future<List<WeightEntry>> getWeightEntriesBetween(
    DateTime start,
    DateTime end,
  ) {
    return (select(weightEntries)
          ..where((w) => w.date.isBetweenValues(start, end))
          ..orderBy([(w) => OrderingTerm.asc(w.date)]))
        .get();
  }

  Stream<List<WeightEntry>> watchAllWeightEntries() {
    return (select(
      weightEntries,
    )..orderBy([(w) => OrderingTerm.asc(w.date)])).watch();
  }

  // --- Targets ---

  Future<void> insertTarget(TargetsCompanion target) {
    return into(targets).insert(target);
  }

  /// The currently-active target: the most recent one whose effective
  /// date has arrived.
  Future<Target?> getCurrentTarget({DateTime? asOf}) {
    final cutoff = asOf ?? DateTime.now();
    return (select(targets)
          ..where((t) => t.effectiveDate.isSmallerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm.desc(t.effectiveDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Target>> getTargetHistory() {
    return (select(
      targets,
    )..orderBy([(t) => OrderingTerm.desc(t.effectiveDate)])).get();
  }

  // --- Coaching runs ---

  Future<void> insertCoachingRun(CoachingRunsCompanion run) {
    return into(coachingRuns).insert(run);
  }

  Future<List<CoachingRun>> getCoachingRunHistory() {
    return (select(
      coachingRuns,
    )..orderBy([(r) => OrderingTerm.desc(r.weekStart)])).get();
  }

  Future<CoachingRun?> getMostRecentCoachingRun() {
    return (select(coachingRuns)
          ..orderBy([(r) => OrderingTerm.desc(r.weekEnd)])
          ..limit(1))
        .getSingleOrNull();
  }

  // --- Day overrides ---

  Future<void> upsertDayOverride(DayOverridesCompanion override) {
    return into(dayOverrides).insertOnConflictUpdate(override);
  }

  Future<void> deleteDayOverride(String id) {
    return (delete(dayOverrides)..where((o) => o.id.equals(id))).go();
  }

  Future<DayOverride?> getDayOverride(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return (select(
      dayOverrides,
    )..where((o) => o.date.equals(day))).getSingleOrNull();
  }

  // --- Body measurements ---

  Future<void> upsertBodyMeasurement(BodyMeasurementsCompanion measurement) {
    return into(bodyMeasurements).insertOnConflictUpdate(measurement);
  }

  Stream<List<BodyMeasurement>> watchBodyMeasurements() {
    return (select(
      bodyMeasurements,
    )..orderBy([(m) => OrderingTerm.desc(m.date)])).watch();
  }

  // --- Progress photos ---

  Future<void> insertProgressPhoto(ProgressPhotosCompanion photo) {
    return into(progressPhotos).insert(photo);
  }

  Future<void> deleteProgressPhoto(String id) {
    return (delete(progressPhotos)..where((p) => p.id.equals(id))).go();
  }

  Stream<List<ProgressPhoto>> watchProgressPhotos() {
    return (select(
      progressPhotos,
    )..orderBy([(p) => OrderingTerm.desc(p.date)])).watch();
  }

  // --- Habits ---

  Future<void> insertHabit(HabitsCompanion habit) {
    return into(habits).insert(habit);
  }

  Future<void> archiveHabit(String id) {
    return (update(habits)..where((h) => h.id.equals(id))).write(
      const HabitsCompanion(archived: Value(true)),
    );
  }

  Stream<List<Habit>> watchActiveHabits() {
    return (select(habits)
          ..where((h) => h.archived.equals(false))
          ..orderBy([(h) => OrderingTerm.asc(h.createdAt)]))
        .watch();
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    final existing =
        await (select(habitCompletions)
              ..where((c) => c.habitId.equals(habitId) & c.date.equals(day)))
            .getSingleOrNull();
    if (existing != null) {
      await (delete(
        habitCompletions,
      )..where((c) => c.id.equals(existing.id))).go();
    } else {
      await into(habitCompletions).insert(
        HabitCompletionsCompanion.insert(
          id: '$habitId-${day.toIso8601String()}',
          habitId: habitId,
          date: day,
        ),
      );
    }
  }

  Stream<List<HabitCompletion>> watchHabitCompletionsForDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return (select(habitCompletions)..where((c) => c.date.equals(day))).watch();
  }

  // --- Cycle tracking ---

  Future<void> insertCycleEntry(CycleEntriesCompanion entry) {
    return into(cycleEntries).insert(entry);
  }

  Future<List<CycleEntry>> getCycleEntries() {
    return (select(
      cycleEntries,
    )..orderBy([(c) => OrderingTerm.desc(c.startDate)])).get();
  }

  Stream<List<CycleEntry>> watchCycleEntries() {
    return (select(
      cycleEntries,
    )..orderBy([(c) => OrderingTerm.desc(c.startDate)])).watch();
  }

  Future<void> deleteCycleEntry(String id) {
    return (delete(cycleEntries)..where((c) => c.id.equals(id))).go();
  }

  // --- Workouts ---

  Future<void> insertWorkout(WorkoutsCompanion workout) {
    return into(workouts).insert(workout);
  }

  Stream<List<Workout>> watchWorkouts() {
    return (select(
      workouts,
    )..orderBy([(w) => OrderingTerm.desc(w.date)])).watch();
  }

  Future<void> deleteWorkout(String id) {
    return (delete(workouts)..where((w) => w.id.equals(id))).go();
  }
}
