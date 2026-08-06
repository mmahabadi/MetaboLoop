import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../application/onboarding_controller.dart';

class MacroEstimateScreen extends ConsumerWidget {
  const MacroEstimateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final estimate = ref.watch(onboardingControllerProvider).estimate;

    if (estimate == null) {
      // Defensive fallback: this screen is only reachable after the
      // activity-level step, which always computes an estimate first.
      return const Scaffold(
        body: Center(child: Text('Missing estimate — go back and try again.')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your starting estimate',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: theme.colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a starting point, not a fixed plan. Once you '
                        'start logging, we recalibrate your targets weekly '
                        'based on your real data.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text(
                      estimate.calories.round().toString(),
                      style: theme.textTheme.displaySmall,
                    ),
                    Text('calories / day', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _MacroTile(label: 'Protein', grams: estimate.proteinGrams),
                  _MacroTile(label: 'Carbs', grams: estimate.carbsGrams),
                  _MacroTile(label: 'Fat', grams: estimate.fatGrams),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go(AppRoutes.signIn),
                child: const Text('Create my account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  const _MacroTile({required this.label, required this.grams});

  final String label;
  final double grams;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text('${grams.round()}g', style: theme.textTheme.titleLarge),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
