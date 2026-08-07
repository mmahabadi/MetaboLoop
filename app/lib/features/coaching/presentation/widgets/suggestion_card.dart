import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../application/coaching_providers.dart';

/// Shown when the most recent coaching run is a collaborative-mode
/// suggestion still awaiting the user's approval.
class SuggestionCard extends ConsumerStatefulWidget {
  const SuggestionCard({super.key, required this.run});

  final CoachingRun run;

  @override
  ConsumerState<SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends ConsumerState<SuggestionCard> {
  bool _working = false;

  Future<void> _approve() async {
    setState(() => _working = true);
    await ref.read(coachingServiceProvider).approveSuggestion(widget.run);
    ref.read(coachingRefreshProvider.notifier).state++;
  }

  Future<void> _dismiss() async {
    setState(() => _working = true);
    await ref.read(coachingServiceProvider).rejectSuggestion(widget.run);
    ref.read(coachingRefreshProvider.notifier).state++;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final run = widget.run;

    return Card(
      color: theme.colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New target suggested',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${run.newCalories!.round()} kcal '
              '(was ${run.previousCalories?.round() ?? '—'})',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              run.reasoning,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton(
                  onPressed: _working ? null : _approve,
                  child: const Text('Approve'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _working ? null : _dismiss,
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
