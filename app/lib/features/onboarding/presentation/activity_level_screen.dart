import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../application/onboarding_controller.dart';
import '../domain/body_stats.dart';
import 'widgets/onboarding_scaffold.dart';

class ActivityLevelScreen extends ConsumerStatefulWidget {
  const ActivityLevelScreen({super.key});

  @override
  ConsumerState<ActivityLevelScreen> createState() =>
      _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends ConsumerState<ActivityLevelScreen> {
  ActivityLevel? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OnboardingScaffold(
      step: 3,
      totalSteps: 5,
      title: 'How active are you?',
      subtitle: 'A starting point — this gets refined automatically over time.',
      primaryActionEnabled: _selected != null,
      primaryActionLabel: 'See my estimate',
      onPrimaryAction: () {
        ref
            .read(onboardingControllerProvider.notifier)
            .setActivityLevelAndEstimate(_selected!);
        context.go(AppRoutes.estimate);
      },
      body: Column(
        children: ActivityLevel.values.map((level) {
          final selected = _selected == level;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: selected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _selected = level),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              level.label,
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              level.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.check_circle,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
