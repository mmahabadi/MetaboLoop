import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../application/onboarding_controller.dart';
import '../domain/body_stats.dart';
import 'widgets/onboarding_scaffold.dart';

class GoalSelectionScreen extends ConsumerStatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  ConsumerState<GoalSelectionScreen> createState() =>
      _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends ConsumerState<GoalSelectionScreen> {
  Goal? _selected;

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 1,
      totalSteps: 5,
      title: "What's your goal?",
      subtitle: 'This shapes your starting calorie and macro targets.',
      primaryActionEnabled: _selected != null,
      primaryActionLabel: 'Continue',
      onPrimaryAction: () {
        ref.read(onboardingControllerProvider.notifier).setGoal(_selected!);
        context.go(AppRoutes.bodyStats);
      },
      body: Column(
        children: Goal.values.map((goal) {
          final selected = _selected == goal;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GoalCard(
              goal: goal,
              selected: selected,
              onTap: () => setState(() => _selected = goal),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final Goal goal;
  final bool selected;
  final VoidCallback onTap;

  static const _descriptions = {
    Goal.loseFat: 'A calorie deficit while preserving lean mass.',
    Goal.gainMuscle: 'A calorie surplus to support muscle growth.',
    Goal.maintain: 'Hold your current weight steady.',
    Goal.recomposition: 'A modest deficit with higher protein.',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.label, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      _descriptions[goal]!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
