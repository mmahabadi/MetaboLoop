import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/features/onboarding/domain/body_stats.dart';
import 'package:metaboloop/features/onboarding/domain/macro_estimate_calculator.dart';

void main() {
  group('MacroEstimateCalculator', () {
    test('male, moderately active, maintain', () {
      const stats = BodyStats(
        sex: Sex.male,
        ageYears: 30,
        heightCm: 180,
        weightKg: 80,
      );

      final result = MacroEstimateCalculator.estimate(
        stats: stats,
        activityLevel: ActivityLevel.moderate,
        goal: Goal.maintain,
      );

      expect(result.bmr, closeTo(1780, 0.5));
      expect(result.tdee, closeTo(2759, 1));
      expect(result.calories, closeTo(2759, 1));
      expect(result.proteinGrams, closeTo(128, 0.5));
      expect(result.fatGrams, closeTo(76.6, 0.5));
      expect(result.carbsGrams, closeTo(389.3, 1));
    });

    test('female, sedentary, lose fat', () {
      const stats = BodyStats(
        sex: Sex.female,
        ageYears: 28,
        heightCm: 165,
        weightKg: 65,
      );

      final result = MacroEstimateCalculator.estimate(
        stats: stats,
        activityLevel: ActivityLevel.sedentary,
        goal: Goal.loseFat,
      );

      expect(result.bmr, closeTo(1380.25, 0.5));
      expect(result.tdee, closeTo(1656.3, 1));
      expect(result.calories, closeTo(1325, 1));
      expect(result.proteinGrams, closeTo(143, 0.5));
      expect(result.fatGrams, closeTo(36.8, 0.5));
      expect(result.carbsGrams, closeTo(105.4, 1));
    });

    test(
      'gain muscle applies a calorie surplus and lower protein floor than a cut',
      () {
        const stats = BodyStats(
          sex: Sex.male,
          ageYears: 24,
          heightCm: 178,
          weightKg: 70,
        );

        final maintain = MacroEstimateCalculator.estimate(
          stats: stats,
          activityLevel: ActivityLevel.active,
          goal: Goal.maintain,
        );
        final bulk = MacroEstimateCalculator.estimate(
          stats: stats,
          activityLevel: ActivityLevel.active,
          goal: Goal.gainMuscle,
        );
        final cut = MacroEstimateCalculator.estimate(
          stats: stats,
          activityLevel: ActivityLevel.active,
          goal: Goal.loseFat,
        );

        expect(bulk.calories, greaterThan(maintain.calories));
        expect(cut.calories, lessThan(maintain.calories));
        expect(cut.proteinGrams, greaterThan(bulk.proteinGrams));
      },
    );

    test('carb grams never go negative when protein + fat exceed calories', () {
      // Synthetic body proportions (not a realistic adult) chosen to push
      // the bodyweight-scaled protein floor above the calorie budget and
      // exercise the clamp guard in the calculator.
      const stats = BodyStats(
        sex: Sex.male,
        ageYears: 90,
        heightCm: 100,
        weightKg: 82,
      );

      final result = MacroEstimateCalculator.estimate(
        stats: stats,
        activityLevel: ActivityLevel.sedentary,
        goal: Goal.loseFat,
      );

      expect(result.carbsGrams, 0);
    });
  });
}
