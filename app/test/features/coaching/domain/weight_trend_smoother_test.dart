import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/coaching/domain/weight_trend_smoother.dart';

WeightEntry _entry(int day, double kg) {
  return WeightEntry(
    id: 'w$day',
    date: DateTime(2026, 1, day),
    weightKg: kg,
    createdAt: DateTime(2026, 1, day),
  );
}

void main() {
  group('WeightTrendSmoother.trendWeightAsOf', () {
    test('returns null with no entries', () {
      expect(
        WeightTrendSmoother.trendWeightAsOf(const [], DateTime(2026, 1, 5)),
        isNull,
      );
    });

    test('seeds the trend with the first entry', () {
      final entries = [_entry(1, 80.0)];
      expect(
        WeightTrendSmoother.trendWeightAsOf(entries, DateTime(2026, 1, 1)),
        80.0,
      );
    });

    test(
      'applies one EWMA step per entry, matching a hand-computed fixture',
      () {
        final entries = [
          _entry(1, 80.0),
          _entry(2, 80.5),
          _entry(3, 79.8),
          _entry(4, 80.2),
          _entry(5, 79.5),
        ];

        // alpha = 0.1:
        // t0 = 80.0
        // t1 = 0.1*80.5 + 0.9*80.0   = 80.05
        // t2 = 0.1*79.8 + 0.9*80.05  = 80.025
        // t3 = 0.1*80.2 + 0.9*80.025 = 80.0425
        // t4 = 0.1*79.5 + 0.9*80.0425 = 79.98825
        final trend = WeightTrendSmoother.trendWeightAsOf(
          entries,
          DateTime(2026, 1, 5),
        );

        expect(trend, closeTo(79.98825, 0.00001));
      },
    );

    test('ignores entries after asOf', () {
      final entries = [_entry(1, 80.0), _entry(2, 90.0)];

      final trend = WeightTrendSmoother.trendWeightAsOf(
        entries,
        DateTime(2026, 1, 1),
      );

      expect(trend, 80.0);
    });

    test('a steady weight stays flat regardless of alpha', () {
      final entries = List.generate(10, (i) => _entry(i + 1, 75.0));

      final trend = WeightTrendSmoother.trendWeightAsOf(
        entries,
        DateTime(2026, 1, 10),
      );

      expect(trend, 75.0);
    });
  });
}
