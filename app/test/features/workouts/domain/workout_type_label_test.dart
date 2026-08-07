import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/workouts/domain/workout_type_label.dart';

void main() {
  test('every WorkoutType has a non-empty display label', () {
    for (final type in WorkoutType.values) {
      expect(type.label, isNotEmpty);
    }
  });

  test('labels are distinct across types', () {
    final labels = WorkoutType.values.map((t) => t.label).toSet();
    expect(labels, hasLength(WorkoutType.values.length));
  });
}
