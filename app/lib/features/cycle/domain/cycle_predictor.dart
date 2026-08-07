/// Average cycle length and predicted next start, derived from logged
/// period start dates — a simple average-of-recent-gaps model, not a
/// medical prediction.
class CyclePrediction {
  const CyclePrediction({this.averageCycleLengthDays, this.predictedNextStart});

  final int? averageCycleLengthDays;
  final DateTime? predictedNextStart;
}

/// [startDatesDescending] must be sorted most-recent-first. Needs at least
/// two logged starts to compute a gap; averages over at most the 6 most
/// recent gaps so an old irregular cycle doesn't dominate the estimate.
CyclePrediction predictNextCycle(List<DateTime> startDatesDescending) {
  if (startDatesDescending.length < 2) {
    return const CyclePrediction();
  }

  final gaps = <int>[];
  for (var i = 0; i < startDatesDescending.length - 1; i++) {
    gaps.add(
      startDatesDescending[i].difference(startDatesDescending[i + 1]).inDays,
    );
  }

  final recentGaps = gaps.take(6).toList();
  final averageDays = (recentGaps.reduce((a, b) => a + b) / recentGaps.length)
      .round();

  return CyclePrediction(
    averageCycleLengthDays: averageDays,
    predictedNextStart: startDatesDescending.first.add(
      Duration(days: averageDays),
    ),
  );
}
