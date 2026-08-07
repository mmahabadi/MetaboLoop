import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/database_provider.dart';
import '../../../coaching/application/coaching_providers.dart';
import 'dashboard_card.dart';

/// Daily logged calories for the last 7 days against the current target —
/// "macro adherence" scoped to calories for the chart itself (all three
/// macros for the same range are still visible in the Today tab's history,
/// this widget's job is the at-a-glance week view).
class MacroAdherenceWidget extends ConsumerWidget {
  const MacroAdherenceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetAsync = ref.watch(currentTargetProvider);
    final theme = Theme.of(context);

    return DashboardCard(
      title: 'Calories vs. target (7 days)',
      child: FutureBuilder<List<double>>(
        future: _last7DaysCalories(ref),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Could not load calorie history: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final days = snapshot.data!;
          final target = targetAsync.value?.calories;
          final maxY =
              [...days, target ?? 0].fold(0.0, (a, b) => a > b ? a : b) * 1.2;

          return SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: maxY == 0 ? 100 : maxY,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        final day = DateTime.now().subtract(
                          Duration(days: days.length - 1 - index),
                        );
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.E().format(day)[0],
                            style: theme.textTheme.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                extraLinesData: target == null
                    ? null
                    : ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: target,
                            color: theme.colorScheme.error,
                            strokeWidth: 1,
                            dashArray: [6, 4],
                          ),
                        ],
                      ),
                barGroups: [
                  for (var i = 0; i < days.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: days[i],
                          color: theme.colorScheme.primary,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<double>> _last7DaysCalories(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final totals = <double>[];
    for (var i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      final entries = await db.getLogEntriesForDate(day);
      totals.add(entries.fold(0.0, (sum, e) => sum + e.calories));
    }
    return totals;
  }
}
