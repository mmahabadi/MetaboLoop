import 'package:flutter/material.dart';

/// Shared layout for onboarding steps: a progress indicator, title/subtitle,
/// scrollable body, and a pinned primary action at the bottom.
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.step,
    required this.totalSteps,
    required this.title,
    this.subtitle,
    required this.body,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.primaryActionEnabled = true,
  });

  final int step;
  final int totalSteps;
  final String title;
  final String? subtitle;
  final Widget body;
  final String primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final bool primaryActionEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: step / totalSteps,
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    body,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: FilledButton(
                onPressed: primaryActionEnabled ? onPrimaryAction : null,
                child: Text(primaryActionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
