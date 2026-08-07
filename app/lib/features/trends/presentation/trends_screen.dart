import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../export/application/export_providers.dart';
import '../application/trends_providers.dart';
import '../domain/dashboard_widget_type.dart';
import 'widgets/expenditure_widget.dart';
import 'widgets/habits_widget.dart';
import 'widgets/macro_adherence_widget.dart';
import 'widgets/manage_widgets_sheet.dart';
import 'widgets/micronutrients_widget.dart';
import 'widgets/streaks_widget.dart';
import 'widgets/weight_trend_widget.dart';

class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  static final _builders = <DashboardWidgetType, WidgetBuilder>{
    DashboardWidgetType.weightTrend: (_) => const WeightTrendWidget(),
    DashboardWidgetType.macroAdherence: (_) => const MacroAdherenceWidget(),
    DashboardWidgetType.expenditure: (_) => const ExpenditureWidget(),
    DashboardWidgetType.streaks: (_) => const StreaksWidget(),
    DashboardWidgetType.habits: (_) => const HabitsWidget(),
    DashboardWidgetType.micronutrients: (_) => const MicronutrientsWidget(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutAsync = ref.watch(dashboardLayoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trends'),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_camera_back_outlined),
            tooltip: 'Progress photos & measurements',
            onPressed: () => context.push(AppRoutes.progress),
          ),
          IconButton(
            icon: const Icon(Icons.water_drop_outlined),
            tooltip: 'Cycle tracking',
            onPressed: () => context.push(AppRoutes.cycle),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Export data as CSV',
            onPressed: () => _exportCsv(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.dashboard_customize_outlined),
            tooltip: 'Manage widgets',
            onPressed: () => showManageWidgetsSheet(context),
          ),
        ],
      ),
      body: layoutAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Could not load your dashboard: $e')),
        data: (layout) {
          if (layout.isEmpty) {
            return const Center(
              child: Text(
                'All widgets are hidden — add some from the icon above.',
              ),
            );
          }
          return ReorderableListView(
            padding: const EdgeInsets.all(16),
            onReorderItem: (oldIndex, newIndex) {
              final updated = List<DashboardWidgetType>.of(layout);
              final moved = updated.removeAt(oldIndex);
              updated.insert(newIndex, moved);
              ref.read(dashboardLayoutProvider.notifier).reorder(updated);
            },
            children: [
              for (final widgetType in layout)
                Padding(
                  key: ValueKey(widgetType),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _builders[widgetType]!(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(exportServiceProvider).exportDailyHistoryCsv();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }
}
