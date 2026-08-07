import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';

LogEntriesCompanion _entry(String id, DateTime loggedAt) {
  return LogEntriesCompanion.insert(
    id: id,
    loggedAt: loggedAt,
    displayName: 'Entry $id',
    calories: 100,
    proteinGrams: 5,
    carbsGrams: 10,
    fatGrams: 2,
    quantityLabel: '1 serving',
    method: LogMethod.manual,
  );
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test(
    'getLogEntriesForDate only returns entries logged on that day',
    () async {
      final day1 = DateTime(2026, 3, 1, 9);
      final day2 = DateTime(2026, 3, 2, 9);

      await db.insertLogEntry(_entry('a', day1));
      await db.insertLogEntry(_entry('b', DateTime(2026, 3, 1, 20)));
      await db.insertLogEntry(_entry('c', day2));

      final entriesForDay1 = await db.getLogEntriesForDate(day1);

      expect(entriesForDay1.map((e) => e.id), containsAll(['a', 'b']));
      expect(entriesForDay1.map((e) => e.id), isNot(contains('c')));
    },
  );

  test('deleteLogEntry removes only the targeted entry', () async {
    await db.insertLogEntry(_entry('a', DateTime(2026, 3, 1)));
    await db.insertLogEntry(_entry('b', DateTime(2026, 3, 1)));

    await db.deleteLogEntry('a');

    final remaining = await db.getLogEntriesForDate(DateTime(2026, 3, 1));
    expect(remaining.map((e) => e.id), ['b']);
  });

  test('getFoodByBarcode finds a cached food by its barcode', () async {
    await db.upsertFood(
      LocalFoodsCompanion.insert(
        id: 'f1',
        name: 'Test food',
        barcode: const Value('999'),
        caloriesPer100g: 100,
        proteinPer100gGrams: 1,
        carbsPer100gGrams: 1,
        fatPer100gGrams: 1,
        source: FoodSource.custom,
      ),
    );

    final found = await db.getFoodByBarcode('999');
    final notFound = await db.getFoodByBarcode('000');

    expect(found?.name, 'Test food');
    expect(notFound, isNull);
  });
}
