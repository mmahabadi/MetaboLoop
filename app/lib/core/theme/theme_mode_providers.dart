import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_mode_settings.dart';

final themeModeSettingsProvider = Provider<ThemeModeSettings>((ref) {
  return ThemeModeSettings();
});

final themeModeProvider = AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() {
    return ref.watch(themeModeSettingsProvider).getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(themeModeSettingsProvider).setThemeMode(mode);
    state = AsyncData(mode);
  }
}
