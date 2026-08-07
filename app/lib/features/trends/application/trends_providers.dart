import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../logging/application/micronutrient_target_settings.dart';
import '../../logging/domain/macro_totals.dart';
import '../../logging/domain/micronutrient_targets.dart';
import '../domain/dashboard_widget_type.dart';
import '../domain/streak_calculator.dart';
import 'dashboard_layout_settings.dart';

final dashboardLayoutSettingsProvider = Provider<DashboardLayoutSettings>((
  ref,
) {
  return DashboardLayoutSettings();
});

final dashboardLayoutProvider =
    AsyncNotifierProvider<DashboardLayoutNotifier, List<DashboardWidgetType>>(
      DashboardLayoutNotifier.new,
    );

class DashboardLayoutNotifier extends AsyncNotifier<List<DashboardWidgetType>> {
  @override
  Future<List<DashboardWidgetType>> build() {
    return ref.watch(dashboardLayoutSettingsProvider).getLayout();
  }

  Future<void> reorder(List<DashboardWidgetType> newOrder) async {
    await ref.read(dashboardLayoutSettingsProvider).setLayout(newOrder);
    state = AsyncData(newOrder);
  }

  Future<void> hide(DashboardWidgetType widget) async {
    final current = state.value ?? const [];
    await reorder(current.where((w) => w != widget).toList());
  }

  Future<void> show(DashboardWidgetType widget) async {
    final current = state.value ?? const [];
    if (current.contains(widget)) return;
    await reorder([...current, widget]);
  }
}

final allWeightEntriesProvider = StreamProvider<List<WeightEntry>>((ref) {
  return ref.watch(databaseProvider).watchAllWeightEntries();
});

final activeHabitsProvider = StreamProvider<List<Habit>>((ref) {
  return ref.watch(databaseProvider).watchActiveHabits();
});

final todayHabitCompletionsProvider = StreamProvider<List<HabitCompletion>>((
  ref,
) {
  return ref
      .watch(databaseProvider)
      .watchHabitCompletionsForDate(DateTime.now());
});

/// Consecutive days (ending today or yesterday) with at least one log
/// entry — a simple streak, not a configurable habit. Looks back at most
/// 60 days, which is generous for a streak display.
final loggingStreakProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final daysWithEntries = <DateTime>{};

  for (var i = 0; i < 60; i++) {
    final day = DateTime(now.year, now.month, now.day - i);
    final entries = await db.getLogEntriesForDate(day);
    if (entries.isNotEmpty) daysWithEntries.add(day);
    // Once we've hit a gap that isn't "today", the streak can't extend
    // further back, so stop scanning early.
    if (entries.isEmpty && i > 0) break;
  }

  return computeLoggingStreak(daysWithEntries, now: now);
});

final micronutrientTargetSettingsProvider =
    Provider<MicronutrientTargetSettings>((ref) {
      return MicronutrientTargetSettings();
    });

final micronutrientTargetsProvider =
    AsyncNotifierProvider<MicronutrientTargetsNotifier, MicronutrientTargets>(
      MicronutrientTargetsNotifier.new,
    );

class MicronutrientTargetsNotifier extends AsyncNotifier<MicronutrientTargets> {
  @override
  Future<MicronutrientTargets> build() {
    return ref.watch(micronutrientTargetSettingsProvider).getTargets();
  }

  Future<void> setTargets(MicronutrientTargets targets) async {
    await ref.read(micronutrientTargetSettingsProvider).setTargets(targets);
    state = AsyncData(targets);
  }
}

/// Today's logged fiber/sugar/sodium, summed from the day's entries.
final todayMicronutrientTotalsProvider = FutureProvider<MacroTotals>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final entries = await db.getLogEntriesForDate(
    DateTime(now.year, now.month, now.day),
  );
  return MacroTotals.ofEntries(entries);
});
