import 'package:shared_preferences/shared_preferences.dart';

import '../domain/dashboard_widget_type.dart';

/// Which dashboard widgets are shown and in what order — user-customizable
/// per the Phase 4 spec. Hidden widgets are simply the ones not in the
/// stored list; add-back always appends to the end.
class DashboardLayoutSettings {
  static const _key = 'dashboard_layout';

  Future<List<DashboardWidgetType>> getLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    if (stored == null) return DashboardWidgetType.values.toList();

    return stored
        .map(
          (name) => DashboardWidgetType.values
              .where((w) => w.name == name)
              .firstOrNull,
        )
        .whereType<DashboardWidgetType>()
        .toList();
  }

  Future<void> setLayout(List<DashboardWidgetType> layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, layout.map((w) => w.name).toList());
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
