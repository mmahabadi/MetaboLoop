import 'package:shared_preferences/shared_preferences.dart';

import '../domain/micronutrient_targets.dart';

/// User-configurable daily fiber/sugar/sodium targets — a single set of
/// preference values, so shared_preferences rather than a SQL table.
class MicronutrientTargetSettings {
  static const _fiberKey = 'micronutrient_fiber_target_g';
  static const _sugarKey = 'micronutrient_sugar_max_g';
  static const _sodiumKey = 'micronutrient_sodium_max_mg';

  Future<MicronutrientTargets> getTargets() async {
    final prefs = await SharedPreferences.getInstance();
    const defaults = MicronutrientTargets();
    return MicronutrientTargets(
      fiberGrams: prefs.getDouble(_fiberKey) ?? defaults.fiberGrams,
      sugarGramsMax: prefs.getDouble(_sugarKey) ?? defaults.sugarGramsMax,
      sodiumMgMax: prefs.getDouble(_sodiumKey) ?? defaults.sodiumMgMax,
    );
  }

  Future<void> setTargets(MicronutrientTargets targets) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fiberKey, targets.fiberGrams);
    await prefs.setDouble(_sugarKey, targets.sugarGramsMax);
    await prefs.setDouble(_sodiumKey, targets.sodiumMgMax);
  }
}
