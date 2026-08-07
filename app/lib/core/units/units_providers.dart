import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'units.dart';
import 'units_settings.dart';

final unitsSettingsProvider = Provider<UnitsSettings>((ref) {
  return UnitsSettings();
});

final unitSystemProvider =
    AsyncNotifierProvider<UnitSystemNotifier, UnitSystem>(
      UnitSystemNotifier.new,
    );

class UnitSystemNotifier extends AsyncNotifier<UnitSystem> {
  @override
  Future<UnitSystem> build() {
    return ref.watch(unitsSettingsProvider).getUnitSystem();
  }

  Future<void> setUnitSystem(UnitSystem system) async {
    await ref.read(unitsSettingsProvider).setUnitSystem(system);
    state = AsyncData(system);
  }
}
