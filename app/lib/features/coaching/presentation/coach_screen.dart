import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../application/coaching_providers.dart';
import 'widgets/day_override_sheet.dart';
import 'widgets/log_weight_sheet.dart';
import 'widgets/mode_selector_sheet.dart';
import 'widgets/suggestion_card.dart';
import 'widgets/target_card.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  @override
  void initState() {
    super.initState();
    // Best-effort: check once per screen visit whether a week has elapsed.
    // This is the interim stand-in for the server-side scheduled job
    // described in Checkpoint 2 (see coaching_service.dart).
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _checkForDueRecalculation(),
    );
  }

  Future<void> _checkForDueRecalculation() async {
    try {
      final mode = await ref.read(coachingModeSettingsProvider).getMode();
      final goal = await ref.read(userGoalSettingsProvider).getGoal();
      if (goal == null) return;
      final run = await ref
          .read(coachingServiceProvider)
          .runWeeklyRecalculationIfDue(mode: mode, goal: goal);
      if (run != null) ref.read(coachingRefreshProvider.notifier).state++;
    } catch (_) {
      // No local database on this platform yet (e.g. web).
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetAsync = ref.watch(currentTargetProvider);
    final historyAsync = ref.watch(coachingRunHistoryProvider);
    final modeAsync = ref.watch(coachingModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.monitor_weight_outlined),
            tooltip: 'Log weight',
            onPressed: () => showLogWeightSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.event_repeat),
            tooltip: 'Custom day target',
            onPressed: () => showDayOverrideSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Coaching mode',
            onPressed: modeAsync.value == null
                ? null
                : () => showModeSelectorSheet(context, modeAsync.value!),
          ),
        ],
      ),
      body: targetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not load your targets: $e'),
          ),
        ),
        data: (target) {
          if (target == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Finish onboarding to get your starting targets.'),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (modeAsync.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '${modeAsync.value!.label} mode',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              TargetCard(target: target),
              const SizedBox(height: 16),
              historyAsync.maybeWhen(
                data: (history) {
                  final mostRecent = history.isEmpty ? null : history.first;
                  if (mostRecent == null ||
                      mostRecent.outcome != CoachingRunOutcome.suggested) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SuggestionCard(run: mostRecent),
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
              Text('History', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              historyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Could not load history: $e'),
                data: (history) {
                  if (history.isEmpty) {
                    return const Text(
                      'Your first weekly check-in happens once a week of '
                      'logging has gone by.',
                    );
                  }
                  return Column(
                    children: [for (final run in history) _RunTile(run: run)],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RunTile extends StatelessWidget {
  const _RunTile({required this.run});

  final CoachingRun run;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(_iconFor(run.outcome), color: theme.colorScheme.primary),
      title: Text(
        '${DateFormat.MMMd().format(run.weekStart)} – '
        '${DateFormat.MMMd().format(run.weekEnd)}',
      ),
      subtitle: Text(run.reasoning),
      isThreeLine: true,
    );
  }

  IconData _iconFor(CoachingRunOutcome outcome) {
    switch (outcome) {
      case CoachingRunOutcome.applied:
        return Icons.check_circle_outline;
      case CoachingRunOutcome.suggested:
        return Icons.lightbulb_outline;
      case CoachingRunOutcome.rejected:
        return Icons.cancel_outlined;
      case CoachingRunOutcome.insufficientData:
        return Icons.info_outline;
      case CoachingRunOutcome.skippedManualMode:
        return Icons.pause_circle_outline;
    }
  }
}
