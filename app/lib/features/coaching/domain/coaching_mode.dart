enum CoachingMode {
  automatic(
    label: 'Automatic',
    description: 'Targets update on their own each week.',
  ),
  collaborative(
    label: 'Collaborative',
    description:
        'A new target is suggested each week; you approve it before it applies.',
  ),
  manual(
    label: 'Manual',
    description: 'You set your own targets — no automatic recalculation.',
  );

  const CoachingMode({required this.label, required this.description});

  final String label;
  final String description;
}
