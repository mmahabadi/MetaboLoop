import 'package:shared_preferences/shared_preferences.dart';

import '../domain/coaching_mode.dart';

/// A single user preference (coaching mode), which is why this uses
/// shared_preferences directly rather than a one-row SQL table.
class CoachingModeSettings {
  static const _key = 'coaching_mode';

  Future<CoachingMode> getMode() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return CoachingMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => CoachingMode.collaborative,
    );
  }

  Future<void> setMode(CoachingMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}
