import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../coaching/application/coaching_providers.dart';
import 'dashboard_card.dart';

/// The algorithm's back-calculated TDEE over time, from the coaching run
/// history — the "what your body actually did with what you ate" view.
class ExpenditureWidget extends ConsumerWidget {
  const ExpenditureWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(coachingRunHistoryProvider);
    final theme = Theme.of(context);

    return DashboardCard(
      title: 'Expenditure over time',
      child: historyAsync.when(
        loading: () => const SizedBox(
          height: 140,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Could not load: $e'),
        data: (runs) {
          final points = runs
              .where((r) => r.calculatedTdee != null)
              .toList()
              .reversed
              .toList();
          if (points.isEmpty) {
            return const SizedBox(
              height: 100,
              child: Center(
                child: Text('Shows up after your first weekly check-in.'),
              ),
            );
          }

          final spots = [
            for (var i = 0; i < points.length; i++)
              FlSpot(i.toDouble(), points[i].calculatedTdee!),
          ];

          return SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: theme.colorScheme.tertiary,
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
