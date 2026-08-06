enum Sex { male, female }

enum ActivityLevel {
  sedentary(
    multiplier: 1.2,
    label: 'Sedentary',
    description: 'Little or no exercise, desk job',
  ),
  light(
    multiplier: 1.375,
    label: 'Lightly active',
    description: '1-3 workouts/week',
  ),
  moderate(
    multiplier: 1.55,
    label: 'Moderately active',
    description: '3-5 workouts/week',
  ),
  active(
    multiplier: 1.725,
    label: 'Very active',
    description: '6-7 workouts/week',
  ),
  veryActive(
    multiplier: 1.9,
    label: 'Extra active',
    description: 'Physical job or twice-daily training',
  );

  const ActivityLevel({
    required this.multiplier,
    required this.label,
    required this.description,
  });

  final double multiplier;
  final String label;
  final String description;
}

enum Goal {
  loseFat(label: 'Lose fat'),
  gainMuscle(label: 'Gain muscle'),
  maintain(label: 'Maintain'),
  recomposition(label: 'Recomposition');

  const Goal({required this.label});

  final String label;
}

class BodyStats {
  const BodyStats({
    required this.sex,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
  });

  final Sex sex;
  final int ageYears;
  final double heightCm;
  final double weightKg;
}
