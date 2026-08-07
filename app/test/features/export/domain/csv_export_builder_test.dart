import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/export/domain/csv_export_builder.dart';

LogEntry _entry({
  required DateTime loggedAt,
  required double calories,
  double protein = 0,
  double carbs = 0,
  double fat = 0,
  double? fiber,
  double? sugar,
  double? sodium,
}) {
  return LogEntry(
    id: 'e-${loggedAt.toIso8601String()}-$calories',
    loggedAt: loggedAt,
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

WeightEntry _weight(DateTime date, double kg) {
  return WeightEntry(
    id: 'w-${date.toIso8601String()}',
    date: date,
    weightKg: kg,
    createdAt: date,
  );
}

void main() {
  group('buildDailyCsv', () {
    test('emits just the header when there is no data', () {
      final csv = buildDailyCsv(logEntries: const [], weightEntries: const []);

      expect(
        csv,
        'date,calories,protein_g,carbs_g,fat_g,fiber_g,sugar_g,sodium_mg,weight_kg\n',
      );
    });

    test('sums same-day entries into a single row and pairs with weight', () {
      final csv = buildDailyCsv(
        logEntries: [
          _entry(
            loggedAt: DateTime(2026, 1, 1, 8),
            calories: 200,
            protein: 10,
            carbs: 20,
            fat: 5,
            fiber: 3,
            sugar: 8,
            sodium: 400,
          ),
          _entry(
            loggedAt: DateTime(2026, 1, 1, 19),
            calories: 300,
            protein: 15,
            carbs: 30,
            fat: 10,
          ),
        ],
        weightEntries: [_weight(DateTime(2026, 1, 1), 70.5)],
      );

      final rows = csv.trim().split('\n');
      expect(rows, hasLength(2));
      expect(rows[1], '2026-01-01,500.0,25.0,50.0,15.0,3.0,8.0,400.0,70.5');
    });

    test('a day with only a weight entry gets empty macro fields', () {
      final csv = buildDailyCsv(
        logEntries: const [],
        weightEntries: [_weight(DateTime(2026, 1, 2), 71.0)],
      );

      final rows = csv.trim().split('\n');
      expect(rows[1], '2026-01-02,,,,,,,,71.0');
    });

    test('a day with only logged food gets an empty weight field', () {
      final csv = buildDailyCsv(
        logEntries: [
          _entry(
            loggedAt: DateTime(2026, 1, 3),
            calories: 150,
            protein: 5,
            carbs: 10,
            fat: 2,
          ),
        ],
        weightEntries: const [],
      );

      final rows = csv.trim().split('\n');
      expect(rows[1], '2026-01-03,150.0,5.0,10.0,2.0,,,,');
    });

    test('rows are sorted chronologically regardless of input order', () {
      final csv = buildDailyCsv(
        logEntries: [
          _entry(loggedAt: DateTime(2026, 2, 1), calories: 100),
          _entry(loggedAt: DateTime(2026, 1, 1), calories: 100),
        ],
        weightEntries: const [],
      );

      final rows = csv.trim().split('\n').sublist(1);
      expect(rows[0].startsWith('2026-01-01'), isTrue);
      expect(rows[1].startsWith('2026-02-01'), isTrue);
    });
  });
}
