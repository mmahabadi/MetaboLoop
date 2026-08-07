import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../coaching/domain/weight_trend_smoother.dart';
import '../../application/trends_providers.dart';
import 'dashboard_card.dart';

class WeightTrendWidget extends ConsumerWidget {
  const WeightTrendWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allWeightEntriesProvider);

    return DashboardCard(
      title: 'Weight trend',
      child: entriesAsync.when(
        loading: () => const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Could not load weight data: $e'),
        data: (entries) {
          if (entries.length < 2) {
            return const SizedBox(
              height: 120,
              child: Center(
                child: Text('Log your weight a few times to see a trend.'),
              ),
            );
          }

          final recent = entries.length > 90
              ? entries.sublist(entries.length - 90)
              : entries;
          final trend = WeightTrendSmoother.trendSeries(recent);
          final rawSpots = [
            for (var i = 0; i < recent.length; i++)
              FlSpot(i.toDouble(), recent[i].weightKg),
          ];
          final trendSpots = [
            for (var i = 0; i < trend.length; i++)
              FlSpot(i.toDouble(), trend[i]),
          ];
          final theme = Theme.of(context);

          return SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: rawSpots,
                    isCurved: false,
                    color: theme.colorScheme.outlineVariant,
                    barWidth: 1,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: trendSpots,
                    isCurved: true,
                    color: theme.colorScheme.primary,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
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
