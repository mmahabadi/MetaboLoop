import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/workouts/data/workout_repository.dart';

void main() {
  late AppDatabase db;
  late WorkoutRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = WorkoutRepository(db);
  });

  tearDown(() => db.close());

  test('logWorkout persists the workout, including the enum type', () async {
    await repo.logWorkout(
      'w1',
      date: DateTime(2026, 3, 1),
      type: WorkoutType.cardio,
      durationMinutes: 30,
      caloriesBurned: 250,
      notes: 'Easy run',
    );

    final workouts = await repo.watchAll().first;

    expect(workouts, hasLength(1));
    expect(workouts.single.type, WorkoutType.cardio);
    expect(workouts.single.durationMinutes, 30);
    expect(workouts.single.caloriesBurned, 250);
    expect(workouts.single.notes, 'Easy run');
  });

  test('caloriesBurned and notes are optional', () async {
    await repo.logWorkout(
      'w2',
      date: DateTime(2026, 3, 2),
      type: WorkoutType.strength,
      durationMinutes: 45,
    );

    final workouts = await repo.watchAll().first;

    expect(workouts.single.caloriesBurned, isNull);
    expect(workouts.single.notes, isNull);
  });

  test('watchAll orders workouts by date, most recent first', () async {
    await repo.logWorkout(
      'older',
      date: DateTime(2026, 3, 1),
      type: WorkoutType.mobility,
      durationMinutes: 20,
    );
    await repo.logWorkout(
      'newer',
      date: DateTime(2026, 3, 5),
      type: WorkoutType.sport,
      durationMinutes: 60,
    );

    final workouts = await repo.watchAll().first;

    expect(workouts.map((w) => w.id), ['newer', 'older']);
  });

  test('deleteWorkout removes the entry', () async {
    await repo.logWorkout(
      'to-delete',
      date: DateTime(2026, 3, 1),
      type: WorkoutType.other,
      durationMinutes: 10,
    );

    await repo.deleteWorkout('to-delete');

    final workouts = await repo.watchAll().first;
    expect(workouts, isEmpty);
  });
}
