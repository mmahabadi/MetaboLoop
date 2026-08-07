import '../../../core/database/app_database.dart';
import '../../logging/domain/macro_totals.dart';

/// Builds a daily-grouped CSV: one row per calendar day that has either a
/// log entry or a weight entry, with logged macros summed for that day and
/// that day's weight (if any) alongside. Pure and date-format-stable so
/// it's easy to hand-verify in tests.
String buildDailyCsv({
  required List<LogEntry> logEntries,
  required List<WeightEntry> weightEntries,
}) {
  final totalsByDay = <DateTime, MacroTotals>{};
  for (final entry in logEntries) {
    final day = DateTime(
      entry.loggedAt.year,
      entry.loggedAt.month,
      entry.loggedAt.day,
    );
    final existing = totalsByDay[day] ?? const MacroTotals();
    totalsByDay[day] =
        existing +
        MacroTotals(
          calories: entry.calories,
          proteinGrams: entry.proteinGrams,
          carbsGrams: entry.carbsGrams,
          fatGrams: entry.fatGrams,
          fiberGrams: entry.fiberGrams,
          sugarGrams: entry.sugarGrams,
          sodiumMg: entry.sodiumMg,
        );
  }

  final weightByDay = <DateTime, double>{
    for (final w in weightEntries)
      DateTime(w.date.year, w.date.month, w.date.day): w.weightKg,
  };

  final allDays = {...totalsByDay.keys, ...weightByDay.keys}.toList()..sort();

  final buffer = StringBuffer()
    ..writeln(
      'date,calories,protein_g,carbs_g,fat_g,fiber_g,sugar_g,sodium_mg,weight_kg',
    );

  for (final day in allDays) {
    final totals = totalsByDay[day];
    final weight = weightByDay[day];
    buffer.writeln(
      [
        _formatDate(day),
        _num(totals?.calories),
        _num(totals?.proteinGrams),
        _num(totals?.carbsGrams),
        _num(totals?.fatGrams),
        _num(totals?.fiberGrams),
        _num(totals?.sugarGrams),
        _num(totals?.sodiumMg),
        _num(weight),
      ].join(','),
    );
  }

  return buffer.toString();
}

String _formatDate(DateTime d) {
  String pad2(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${pad2(d.month)}-${pad2(d.day)}';
}

String _num(double? value) => value == null ? '' : value.toString();
