import 'package:drift/drift.dart' show Value;

import '../../../core/database/app_database.dart';

class WorkoutRepository {
  WorkoutRepository(this._db);

  final AppDatabase _db;

  Future<void> logWorkout(
    String id, {
    required DateTime date,
    required WorkoutType type,
    required int durationMinutes,
    int? caloriesBurned,
    String? notes,
  }) {
    return _db.insertWorkout(
      WorkoutsCompanion.insert(
        id: id,
        date: DateTime(date.year, date.month, date.day),
        type: type,
        durationMinutes: durationMinutes,
        caloriesBurned: Value(caloriesBurned),
        notes: Value(notes),
      ),
    );
  }

  Future<void> deleteWorkout(String id) => _db.deleteWorkout(id);

  Stream<List<Workout>> watchAll() => _db.watchWorkouts();
}
