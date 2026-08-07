import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/features/cycle/domain/cycle_predictor.dart';

void main() {
  group('predictNextCycle', () {
    test('returns no prediction with fewer than two entries', () {
      final result = predictNextCycle([DateTime(2026, 1, 1)]);

      expect(result.averageCycleLengthDays, isNull);
      expect(result.predictedNextStart, isNull);
    });

    test('returns no prediction with no entries', () {
      final result = predictNextCycle([]);

      expect(result.averageCycleLengthDays, isNull);
      expect(result.predictedNextStart, isNull);
    });

    test('averages a single gap between two entries', () {
      final result = predictNextCycle([
        DateTime(2026, 1, 29),
        DateTime(2026, 1, 1),
      ]);

      expect(result.averageCycleLengthDays, 28);
      expect(result.predictedNextStart, DateTime(2026, 2, 26));
    });

    test('averages multiple gaps, most-recent-first input', () {
      // Gaps (most recent first): 28, 30, 26 -> average 28
      final result = predictNextCycle([
        DateTime(2026, 3, 29), // most recent start
        DateTime(2026, 3, 1),
        DateTime(2026, 1, 30),
        DateTime(2026, 1, 4),
      ]);

      expect(result.averageCycleLengthDays, 28);
      expect(result.predictedNextStart, DateTime(2026, 4, 26));
    });

    test('caps the average at the 6 most recent gaps', () {
      // 8 entries -> 7 gaps of 20 days each, plus one very old outlier gap
      // of 200 days that should not affect the average once capped at 6.
      final dates = <DateTime>[DateTime(2026, 6, 1)];
      for (var i = 1; i <= 6; i++) {
        dates.add(dates.last.subtract(const Duration(days: 20)));
      }
      dates.add(dates.last.subtract(const Duration(days: 200)));

      final result = predictNextCycle(dates);

      expect(result.averageCycleLengthDays, 20);
    });
  });
}
