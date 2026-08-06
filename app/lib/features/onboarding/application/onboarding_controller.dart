import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/body_stats.dart';
import '../domain/macro_estimate.dart';
import '../domain/macro_estimate_calculator.dart';

class OnboardingState {
  const OnboardingState({
    this.goal,
    this.sex,
    this.ageYears,
    this.heightCm,
    this.weightKg,
    this.activityLevel,
    this.estimate,
  });

  final Goal? goal;
  final Sex? sex;
  final int? ageYears;
  final double? heightCm;
  final double? weightKg;
  final ActivityLevel? activityLevel;
  final MacroEstimate? estimate;

  bool get hasBodyStats =>
      sex != null && ageYears != null && heightCm != null && weightKg != null;

  BodyStats? get bodyStats => hasBodyStats
      ? BodyStats(
          sex: sex!,
          ageYears: ageYears!,
          heightCm: heightCm!,
          weightKg: weightKg!,
        )
      : null;

  OnboardingState copyWith({
    Goal? goal,
    Sex? sex,
    int? ageYears,
    double? heightCm,
    double? weightKg,
    ActivityLevel? activityLevel,
    MacroEstimate? estimate,
  }) {
    return OnboardingState(
      goal: goal ?? this.goal,
      sex: sex ?? this.sex,
      ageYears: ageYears ?? this.ageYears,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      estimate: estimate ?? this.estimate,
    );
  }
}

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void setGoal(Goal goal) {
    state = state.copyWith(goal: goal);
  }

  void setBodyStats({
    required Sex sex,
    required int ageYears,
    required double heightCm,
    required double weightKg,
  }) {
    state = state.copyWith(
      sex: sex,
      ageYears: ageYears,
      heightCm: heightCm,
      weightKg: weightKg,
    );
  }

  /// Sets the activity level and computes the Phase 1 starting estimate.
  /// Requires [setGoal] and [setBodyStats] to have been called first.
  MacroEstimate setActivityLevelAndEstimate(ActivityLevel activityLevel) {
    final stats = state.bodyStats;
    final goal = state.goal;
    assert(stats != null, 'Body stats must be set before estimating.');
    assert(goal != null, 'Goal must be set before estimating.');

    final estimate = MacroEstimateCalculator.estimate(
      stats: stats!,
      activityLevel: activityLevel,
      goal: goal!,
    );

    state = state.copyWith(activityLevel: activityLevel, estimate: estimate);
    return estimate;
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
      OnboardingController.new,
    );
