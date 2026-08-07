import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';

class CycleRepository {
  CycleRepository(this._db);

  final AppDatabase _db;

  Future<void> logPeriodStart(String id, DateTime date, {String? notes}) {
    return _db.insertCycleEntry(
      CycleEntriesCompanion.insert(
        id: id,
        startDate: DateTime(date.year, date.month, date.day),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteEntry(String id) => _db.deleteCycleEntry(id);

  Stream<List<CycleEntry>> watchAll() => _db.watchCycleEntries();
}
