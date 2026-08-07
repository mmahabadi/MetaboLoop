import 'package:shared_preferences/shared_preferences.dart';

import '../../onboarding/domain/body_stats.dart';

/// The goal chosen during onboarding, persisted so it survives app
/// restarts — the weekly coaching job needs it (to pick the right
/// deficit/surplus factor) long after the in-memory onboarding state is
/// gone.
class UserGoalSettings {
  static const _key = 'user_goal';

  Future<Goal?> getGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    if (stored == null) return null;
    return Goal.values.where((g) => g.name == stored).firstOrNull;
  }

  Future<void> setGoal(Goal goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, goal.name);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
