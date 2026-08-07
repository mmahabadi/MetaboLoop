import 'package:shared_preferences/shared_preferences.dart';

import 'units.dart';

/// Display unit preference. The database always stores metric (kg, cm) —
/// this only affects how values are entered and shown.
class UnitsSettings {
  static const _key = 'unit_system';

  Future<UnitSystem> getUnitSystem() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_key);
    return UnitSystem.values.firstWhere(
      (u) => u.name == stored,
      orElse: () => UnitSystem.metric,
    );
  }

  Future<void> setUnitSystem(UnitSystem system) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, system.name);
  }
}
