import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_router.dart';
import '../../onboarding/application/onboarding_controller.dart';
import '../application/log_actions.dart';
import '../application/logging_providers.dart';
import '../domain/macro_totals.dart';
import 'widgets/log_entry_point_sheet.dart';
import 'widgets/log_entry_tile.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  static const _entryPoints = [
    LogEntryPoint(
      icon: Icons.search,
      label: 'Search',
      route: AppRoutes.logSearch,
    ),
    LogEntryPoint(
      icon: Icons.qr_code_scanner_rounded,
      label: 'Scan barcode',
      route: AppRoutes.logBarcode,
    ),
    LogEntryPoint(
      icon: Icons.bolt_rounded,
      label: 'Quick add',
      route: AppRoutes.logQuickAdd,
    ),
    LogEntryPoint(
      icon: Icons.camera_alt_rounded,
      label: 'Snap a photo',
      route: AppRoutes.logSnap,
    ),
    LogEntryPoint(
      icon: Icons.chat_bubble_outline_rounded,
      label: 'Describe a meal',
      route: AppRoutes.logDescribe,
    ),
    LogEntryPoint(
      icon: Icons.restaurant_menu_rounded,
      label: 'Add custom food',
      route: AppRoutes.logCustomFood,
    ),
    LogEntryPoint(
      icon: Icons.menu_book_rounded,
      label: 'Recipes',
      route: AppRoutes.recipes,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedLogDateProvider);
    final entriesAsync = ref.watch(logEntriesForDateProvider(date));
    final estimate = ref.watch(onboardingControllerProvider).estimate;
    final isToday = _isSameDay(date, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  ref.read(selectedLogDateProvider.notifier).state = date
                      .subtract(const Duration(days: 1)),
            ),
            Text(isToday ? 'Today' : DateFormat.MMMEd().format(date)),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  ref.read(selectedLogDateProvider.notifier).state = date.add(
                    const Duration(days: 1),
                  ),
            ),
          ],
        ),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load the log: $e')),
        data: (entries) {
          final totals = MacroTotals.ofEntries(entries);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _MacroSummary(
                  totals: totals,
                  targetCalories: estimate?.calories,
                ),
              ),
              Expanded(
                child: entries.isEmpty
                    ? _EmptyState(date: date)
                    : ListView(
                        children: [
                          for (final entry in entries)
                            LogEntryTile(
                              entry: entry,
                              onDelete: () => ref
                                  .read(logActionsProvider)
                                  .deleteEntry(entry.id),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route = await showLogEntryPointSheet(
            context,
            entryPoints: _entryPoints,
          );
          if (route != null && context.mounted) context.push(route);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _MacroSummary extends StatelessWidget {
  const _MacroSummary({required this.totals, this.targetCalories});

  final MacroTotals totals;
  final double? targetCalories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${totals.calories.round()}',
                  style: theme.textTheme.headlineMedium,
                ),
                if (targetCalories != null)
                  Text(
                    ' / ${targetCalories!.round()} kcal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Text(
                    ' kcal',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MacroLabel(label: 'Protein', grams: totals.proteinGrams),
                _MacroLabel(label: 'Carbs', grams: totals.carbsGrams),
                _MacroLabel(label: 'Fat', grams: totals.fatGrams),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroLabel extends StatelessWidget {
  const _MacroLabel({required this.label, required this.grams});

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

class _EmptyState extends ConsumerWidget {
  const _EmptyState({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 12),
          const Text('Nothing logged yet'),
          const SizedBox(height: 12),
          TextButton.icon(
            icon: const Icon(Icons.content_copy),
            label: const Text('Copy previous day'),
            onPressed: () async {
              final count = await ref
                  .read(logActionsProvider)
                  .copyPreviousDayInto(date);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Copied $count entries from the previous day',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
