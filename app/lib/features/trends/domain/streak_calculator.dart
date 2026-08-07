/// Counts consecutive logged days ending at [now] (today), pure so it's
/// testable without a database. Today not yet having a log entry doesn't
/// break the streak — the day is still in progress — but any other gap
/// does.
int computeLoggingStreak(
  Set<DateTime> daysWithEntries, {
  required DateTime now,
}) {
  bool hasEntry(DateTime day) => daysWithEntries.contains(_dayOnly(day));

  var streak = 0;
  var day = _dayOnly(now);
  var isToday = true;

  while (true) {
    if (hasEntry(day)) {
      streak++;
    } else if (isToday) {
      // today just hasn't been logged yet — don't break the streak, but
      // don't count it either.
    } else {
      break;
    }
    isToday = false;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
