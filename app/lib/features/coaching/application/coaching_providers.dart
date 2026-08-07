import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/weight_repository.dart';
import '../domain/coaching_mode.dart';
import 'coaching_mode_settings.dart';
import 'coaching_service.dart';
import 'user_goal_settings.dart';

final userGoalSettingsProvider = Provider<UserGoalSettings>((ref) {
  return UserGoalSettings();
});

final coachingServiceProvider = Provider<CoachingService>((ref) {
  return CoachingService(ref.watch(databaseProvider));
});

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return WeightRepository(ref.watch(databaseProvider));
});

final coachingModeSettingsProvider = Provider<CoachingModeSettings>((ref) {
  return CoachingModeSettings();
});

/// Bumped after any mutation (approving a suggestion, running a
/// recalculation, adding a day override) to invalidate the read-side
/// providers below without wiring a live stream for every coaching table.
final coachingRefreshProvider = StateProvider<int>((ref) => 0);

final currentTargetProvider = FutureProvider<Target?>((ref) {
  ref.watch(coachingRefreshProvider);
  return ref.watch(databaseProvider).getCurrentTarget();
});

final targetHistoryProvider = FutureProvider<List<Target>>((ref) {
  ref.watch(coachingRefreshProvider);
  return ref.watch(databaseProvider).getTargetHistory();
});

final coachingRunHistoryProvider = FutureProvider<List<CoachingRun>>((ref) {
  ref.watch(coachingRefreshProvider);
  return ref.watch(databaseProvider).getCoachingRunHistory();
});

final coachingModeProvider =
    AsyncNotifierProvider<CoachingModeNotifier, CoachingMode>(
      CoachingModeNotifier.new,
    );

class CoachingModeNotifier extends AsyncNotifier<CoachingMode> {
  @override
  Future<CoachingMode> build() {
    return ref.watch(coachingModeSettingsProvider).getMode();
  }

  Future<void> setMode(CoachingMode mode) async {
    await ref.read(coachingModeSettingsProvider).setMode(mode);
    state = AsyncData(mode);
  }
}
