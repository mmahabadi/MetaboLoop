import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../domain/macro_totals.dart';
import '../domain/parsed_food_item.dart';

const _uuid = Uuid();

/// Mutating operations on the daily log — kept separate from the read-side
/// providers in `logging_providers.dart` so screens that only display data
/// don't need to depend on the write path.
class LogActions {
  LogActions(this._db);

  final AppDatabase _db;

  Future<void> logFood({
    required LocalFood food,
    required double quantityGrams,
    required LogMethod method,
  }) {
    final totals = scaleFoodToQuantity(food, quantityGrams);
    return _db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: _uuid.v4(),
        loggedAt: DateTime.now(),
        displayName: food.name,
        calories: totals.calories,
        proteinGrams: totals.proteinGrams,
        carbsGrams: totals.carbsGrams,
        fatGrams: totals.fatGrams,
        quantityLabel: '${quantityGrams.round()} g',
        method: method,
        sourceFoodId: Value(food.id),
      ),
    );
  }

  Future<void> logRecipeServing({
    required String recipeId,
    required String recipeName,
    required double servings,
    required MacroTotals perServingTotals,
  }) {
    final totals = MacroTotals(
      calories: perServingTotals.calories * servings,
      proteinGrams: perServingTotals.proteinGrams * servings,
      carbsGrams: perServingTotals.carbsGrams * servings,
      fatGrams: perServingTotals.fatGrams * servings,
    );
    final servingsLabel = servings == servings.roundToDouble()
        ? servings.round().toString()
        : servings.toStringAsFixed(1);
    return _db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: _uuid.v4(),
        loggedAt: DateTime.now(),
        displayName: recipeName,
        calories: totals.calories,
        proteinGrams: totals.proteinGrams,
        carbsGrams: totals.carbsGrams,
        fatGrams: totals.fatGrams,
        quantityLabel: '$servingsLabel serving(s)',
        method: LogMethod.recipe,
        sourceRecipeId: Value(recipeId),
      ),
    );
  }

  Future<void> logQuickAdd({
    String name = 'Quick add',
    required double calories,
    double proteinGrams = 0,
    double carbsGrams = 0,
    double fatGrams = 0,
  }) {
    return _db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: _uuid.v4(),
        loggedAt: DateTime.now(),
        displayName: name,
        calories: calories,
        proteinGrams: proteinGrams,
        carbsGrams: carbsGrams,
        fatGrams: fatGrams,
        quantityLabel: 'Quick add',
        method: LogMethod.quickAdd,
      ),
    );
  }

  /// Logs an AI-parsed item (from Snap or Describe) after the user has
  /// reviewed/edited it — quantities are estimates, so the label makes
  /// that explicit.
  Future<void> logParsedItem(ParsedFoodItem item, {required LogMethod method}) {
    return _db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: _uuid.v4(),
        loggedAt: DateTime.now(),
        displayName: item.name,
        calories: item.calories,
        proteinGrams: item.proteinGrams,
        carbsGrams: item.carbsGrams,
        fatGrams: item.fatGrams,
        quantityLabel: '${item.estimatedGrams.round()} g (est.)',
        method: method,
      ),
    );
  }

  Future<void> deleteEntry(String id) => _db.deleteLogEntry(id);

  /// Duplicates every entry from the day before [targetDate] into
  /// [targetDate], preserving each entry's time-of-day.
  Future<int> copyPreviousDayInto(DateTime targetDate) async {
    final previousDay = targetDate.subtract(const Duration(days: 1));
    final entries = await _db.getLogEntriesForDate(previousDay);

    for (final entry in entries) {
      await _db.insertLogEntry(
        LogEntriesCompanion.insert(
          id: _uuid.v4(),
          loggedAt: DateTime(
            targetDate.year,
            targetDate.month,
            targetDate.day,
            entry.loggedAt.hour,
            entry.loggedAt.minute,
          ),
          displayName: entry.displayName,
          calories: entry.calories,
          proteinGrams: entry.proteinGrams,
          carbsGrams: entry.carbsGrams,
          fatGrams: entry.fatGrams,
          quantityLabel: entry.quantityLabel,
          method: entry.method,
          sourceFoodId: Value(entry.sourceFoodId),
          sourceRecipeId: Value(entry.sourceRecipeId),
        ),
      );
    }
    return entries.length;
  }
}

final logActionsProvider = Provider<LogActions>((ref) {
  return LogActions(ref.watch(databaseProvider));
});
