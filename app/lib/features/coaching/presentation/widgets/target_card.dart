import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';

class TargetCard extends StatelessWidget {
  const TargetCard({super.key, required this.target});

  final Target target;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current target', style: theme.textTheme.labelLarge),
                Text(
                  _sourceLabel(target.source),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${target.calories.round()} kcal',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Macro(label: 'Protein', grams: target.proteinGrams),
                _Macro(label: 'Carbs', grams: target.carbsGrams),
                _Macro(label: 'Fat', grams: target.fatGrams),
              ],
            ),
            const SizedBox(height: 12),
            Text(target.reasoning, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }

  String _sourceLabel(TargetSource source) {
    switch (source) {
      case TargetSource.onboarding:
        return 'From onboarding';
      case TargetSource.coachingAlgorithm:
        return 'From weekly check-in';
      case TargetSource.userManual:
        return 'Set manually';
    }
  }
}

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.grams});

  final String label;
  final double grams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text('${grams.round()}g', style: theme.textTheme.titleSmall),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
