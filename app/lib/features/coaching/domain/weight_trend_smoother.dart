import '../../../core/database/app_database.dart';

/// Exponentially-weighted moving average over raw weigh-ins, so the
/// coaching algorithm reacts to real trend changes rather than daily
/// water-weight/food-volume noise (Phase 4's weight-trend requirement,
/// pulled forward as a prerequisite for the Phase 3 algorithm below).
///
/// Simplification: each raw entry advances the trend by one EWMA step
/// regardless of the calendar gap since the previous entry. For the
/// roughly-daily weigh-in cadence this app expects, that's a reasonable
/// approximation; a gap-aware (per-calendar-day) version is a possible
/// future refinement, not needed for the algorithm below to be correct.
abstract final class WeightTrendSmoother {
  static const double defaultAlpha = 0.1;

  /// The smoothed trend weight (kg) using every entry on or before [asOf].
  /// Returns null if there are no entries yet. [entriesAscending] must
  /// already be sorted oldest-first.
  static double? trendWeightAsOf(
    List<WeightEntry> entriesAscending,
    DateTime asOf, {
    double alpha = defaultAlpha,
  }) {
    double? trend;
    for (final entry in entriesAscending) {
      if (entry.date.isAfter(asOf)) break;
      trend = trend == null
          ? entry.weightKg
          : alpha * entry.weightKg + (1 - alpha) * trend;
    }
    return trend;
  }

  /// The trend value at every entry, in the same order as
  /// [entriesAscending] — for plotting a smoothed line alongside the raw
  /// readings (Phase 4's Trends dashboard).
  static List<double> trendSeries(
    List<WeightEntry> entriesAscending, {
    double alpha = defaultAlpha,
  }) {
    final series = <double>[];
    double? trend;
    for (final entry in entriesAscending) {
      trend = trend == null
          ? entry.weightKg
          : alpha * entry.weightKg + (1 - alpha) * trend;
      series.add(trend);
    }
    return series;
  }
}
