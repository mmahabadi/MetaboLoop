enum UnitSystem { metric, imperial }

double kgToLb(double kg) => kg * 2.2046226218;

double lbToKg(double lb) => lb / 2.2046226218;

double cmToInches(double cm) => cm / 2.54;

double inchesToCm(double inches) => inches * 2.54;

/// Splits a total height in inches into whole feet and the remaining
/// inches (0-11), for display as e.g. "5 ft 9 in".
({int feet, int inches}) inchesToFeetAndInches(double totalInches) {
  final rounded = totalInches.round();
  return (feet: rounded ~/ 12, inches: rounded % 12);
}

double feetAndInchesToInches(int feet, int inches) =>
    (feet * 12 + inches).toDouble();
