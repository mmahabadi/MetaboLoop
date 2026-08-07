import '../../../core/database/app_database.dart';

extension WorkoutTypeLabel on WorkoutType {
  String get label {
    switch (this) {
      case WorkoutType.strength:
        return 'Strength';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.mobility:
        return 'Mobility';
      case WorkoutType.sport:
        return 'Sport';
      case WorkoutType.other:
        return 'Other';
    }
  }
}
