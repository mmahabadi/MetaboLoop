/// Daily micronutrient targets. Defaults follow general dietary guideline
/// figures (not personalized) — micronutrient tracking is scoped to this
/// core subset (fiber, sugar, sodium) rather than a full vitamin/mineral
/// panel.
class MicronutrientTargets {
  const MicronutrientTargets({
    this.fiberGrams = 28,
    this.sugarGramsMax = 50,
    this.sodiumMgMax = 2300,
  });

  final double fiberGrams;
  final double sugarGramsMax;
  final double sodiumMgMax;

  MicronutrientTargets copyWith({
    double? fiberGrams,
    double? sugarGramsMax,
    double? sodiumMgMax,
  }) {
    return MicronutrientTargets(
      fiberGrams: fiberGrams ?? this.fiberGrams,
      sugarGramsMax: sugarGramsMax ?? this.sugarGramsMax,
      sodiumMgMax: sodiumMgMax ?? this.sodiumMgMax,
    );
  }
}
