import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/features/trends/domain/streak_calculator.dart';

void main() {
  final now = DateTime(2026, 1, 10);

  group('computeLoggingStreak', () {
    test('zero when nothing has been logged', () {
      expect(computeLoggingStreak(const {}, now: now), 0);
    });

    test(
      'counts back-to-back days ending yesterday when today is not yet logged',
      () {
        final days = {
          DateTime(2026, 1, 9),
          DateTime(2026, 1, 8),
          DateTime(2026, 1, 7),
        };
        expect(computeLoggingStreak(days, now: now), 3);
      },
    );

    test('includes today when it has already been logged', () {
      final days = {
        DateTime(2026, 1, 10),
        DateTime(2026, 1, 9),
        DateTime(2026, 1, 8),
      };
      expect(computeLoggingStreak(days, now: now), 3);
    });

    test('stops at the first gap before today', () {
      final days = {
        DateTime(2026, 1, 9),
        DateTime(2026, 1, 8),
        // gap on Jan 7
        DateTime(2026, 1, 6),
      };
      expect(computeLoggingStreak(days, now: now), 2);
    });

    test('a gap yesterday (not just today) breaks the streak at zero', () {
      final days = {DateTime(2026, 1, 8), DateTime(2026, 1, 7)};
      expect(computeLoggingStreak(days, now: now), 0);
    });
  });
}
