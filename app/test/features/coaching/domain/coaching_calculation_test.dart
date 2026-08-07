import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/features/coaching/domain/coaching_calculation.dart';
import 'package:metaboloop/features/onboarding/domain/body_stats.dart';

void main() {
  group('CoachingCalculator.calculate — fixed-fixture math', () {
    test('weight loss week recalculates TDEE and a lower target', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
        trendWeightKgAtWeekStart: 80.0,
        trendWeightKgAtWeekEnd: 79.5,
        currentBodyWeightKg: 79.5,
        goal: Goal.loseFat,
        previousCalories: 1900,
      );

      expect(result.outcome, CoachingCalculationOutcome.computed);
      expect(result.avgDailyIntakeCalories, closeTo(2000, 0.01));
      expect(result.weightChangeKg, closeTo(-0.5, 0.0001));
      expect(result.calculatedTdee, closeTo(2550, 0.01));
      expect(result.newCalories, closeTo(2040, 0.01));
      expect(result.newProteinGrams, closeTo(174.9, 0.01));
      expect(result.newFatGrams, closeTo(56.6667, 0.001));
      expect(result.newCarbsGrams, closeTo(207.6, 0.01));
      expect(result.reasoning, contains('lost'));
    });

    test('weight gain week recalculates TDEE and a higher target', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [2800, 2750, 2900, 2850, 2800, 0, 0],
        trendWeightKgAtWeekStart: 75.0,
        trendWeightKgAtWeekEnd: 75.6,
        currentBodyWeightKg: 75.6,
        goal: Goal.gainMuscle,
        previousCalories: 2300,
      );

      expect(result.outcome, CoachingCalculationOutcome.computed);
      expect(result.avgDailyIntakeCalories, closeTo(2820, 0.01));
      expect(result.weightChangeKg, closeTo(0.6, 0.0001));
      expect(result.calculatedTdee, closeTo(2160, 0.01));
      expect(result.newCalories, closeTo(2376, 0.01));
      expect(result.newProteinGrams, closeTo(136.08, 0.01));
      expect(result.newFatGrams, closeTo(66, 0.01));
      expect(result.newCarbsGrams, closeTo(309.42, 0.01));
      expect(result.reasoning, contains('gained'));
    });

    test('a flat trend weight is reported as holding steady', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [2200, 2200, 2200, 2200, 2200, 0, 0],
        trendWeightKgAtWeekStart: 70.0,
        trendWeightKgAtWeekEnd: 70.0,
        currentBodyWeightKg: 70.0,
        goal: Goal.maintain,
        previousCalories: 2200,
      );

      expect(result.outcome, CoachingCalculationOutcome.computed);
      expect(result.weightChangeKg, 0);
      expect(result.calculatedTdee, closeTo(2200, 0.01));
      expect(result.reasoning, contains('held steady'));
    });

    test('clamps a large swing to the max weekly step', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [3000, 3000, 3000, 3000, 3000, 0, 0],
        trendWeightKgAtWeekStart: 80.0,
        trendWeightKgAtWeekEnd: 78.0, // an implausibly fast 2kg loss
        currentBodyWeightKg: 78.0,
        goal: Goal.loseFat,
        previousCalories: 1800,
      );

      // Raw calculation implies calories far above previousCalories + 250,
      // so the result should be clamped to exactly that ceiling.
      expect(result.newCalories, closeTo(2050, 0.01));
    });

    test('fewer than the minimum logged days returns insufficientData', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [2000, 1900, 0, 0, 0, 0, 0],
        trendWeightKgAtWeekStart: 80.0,
        trendWeightKgAtWeekEnd: 79.8,
        currentBodyWeightKg: 79.8,
        goal: Goal.loseFat,
        previousCalories: 1900,
      );

      expect(result.outcome, CoachingCalculationOutcome.insufficientData);
      expect(result.newCalories, isNull);
      expect(result.reasoning, contains('2 day'));
    });

    test('missing weight trend data returns insufficientData', () {
      final result = CoachingCalculator.calculate(
        dailyLoggedCalories: [2000, 2000, 2000, 2000, 2000, 2000, 2000],
        trendWeightKgAtWeekStart: null,
        trendWeightKgAtWeekEnd: 80.0,
        currentBodyWeightKg: 80.0,
        goal: Goal.maintain,
        previousCalories: 2000,
      );

      expect(result.outcome, CoachingCalculationOutcome.insufficientData);
      expect(result.reasoning, contains('weight trend'));
    });
  });

  group('CoachingCalculator.calculate — adherence-neutrality', () {
    test('the recalculated target is identical regardless of the previous '
        'target, as long as both stay within the clamp window (proving the '
        'algorithm reacts to what happened, not to how close the old target '
        'was)', () {
      final lowerPriorTarget = CoachingCalculator.calculate(
        dailyLoggedCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
        trendWeightKgAtWeekStart: 80.0,
        trendWeightKgAtWeekEnd: 79.5,
        currentBodyWeightKg: 79.5,
        goal: Goal.loseFat,
        previousCalories: 1900,
      );
      final higherPriorTarget = CoachingCalculator.calculate(
        dailyLoggedCalories: [2000, 1950, 2100, 1900, 2050, 0, 2000],
        trendWeightKgAtWeekStart: 80.0,
        trendWeightKgAtWeekEnd: 79.5,
        currentBodyWeightKg: 79.5,
        goal: Goal.loseFat,
        previousCalories: 2000,
      );

      expect(higherPriorTarget.newCalories, lowerPriorTarget.newCalories);
      expect(higherPriorTarget.calculatedTdee, lowerPriorTarget.calculatedTdee);
      expect(
        higherPriorTarget.newProteinGrams,
        lowerPriorTarget.newProteinGrams,
      );
    });

    test(
      'only days that were actually logged count toward the average — '
      'unlogged days are excluded rather than treated as zero-calorie days',
      () {
        // Same 5 logged days as the loss-week fixture, but spread across
        // a week with 2 unlogged days in different positions — the result
        // must be identical either way.
        final unloggedAtEnd = CoachingCalculator.calculate(
          dailyLoggedCalories: [2000, 1950, 2100, 1900, 2050, 0, 0],
          trendWeightKgAtWeekStart: 80.0,
          trendWeightKgAtWeekEnd: 79.5,
          currentBodyWeightKg: 79.5,
          goal: Goal.loseFat,
          previousCalories: 1900,
        );
        final unloggedInMiddle = CoachingCalculator.calculate(
          dailyLoggedCalories: [2000, 1950, 0, 2100, 1900, 0, 2050],
          trendWeightKgAtWeekStart: 80.0,
          trendWeightKgAtWeekEnd: 79.5,
          currentBodyWeightKg: 79.5,
          goal: Goal.loseFat,
          previousCalories: 1900,
        );

        expect(unloggedAtEnd.avgDailyIntakeCalories, closeTo(2000, 0.01));
        expect(
          unloggedInMiddle.avgDailyIntakeCalories,
          unloggedAtEnd.avgDailyIntakeCalories,
        );
      },
    );
  });
}
