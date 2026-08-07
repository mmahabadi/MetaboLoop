import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/progress_repository.dart';

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(ref.watch(databaseProvider));
});

final bodyMeasurementsProvider = StreamProvider<List<BodyMeasurement>>((ref) {
  return ref.watch(databaseProvider).watchBodyMeasurements();
});

final progressPhotosProvider = StreamProvider<List<ProgressPhoto>>((ref) {
  return ref.watch(databaseProvider).watchProgressPhotos();
});
