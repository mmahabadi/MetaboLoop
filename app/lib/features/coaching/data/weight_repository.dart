import '../../../core/database/app_database.dart';

class WeightRepository {
  WeightRepository(this._db);

  final AppDatabase _db;

  /// One entry per calendar day — logging again on the same day updates
  /// today's reading rather than creating a duplicate.
  Future<void> logWeight({required DateTime date, required double weightKg}) {
    final day = DateTime(date.year, date.month, date.day);
    return _db.upsertWeightEntry(
      WeightEntriesCompanion.insert(
        id: 'weight-${day.toIso8601String()}',
        date: day,
        weightKg: weightKg,
      ),
    );
  }

  Future<List<WeightEntry>> entriesBetween(DateTime start, DateTime end) {
    return _db.getWeightEntriesBetween(start, end);
  }

  Stream<List<WeightEntry>> watchAll() => _db.watchAllWeightEntries();
}
