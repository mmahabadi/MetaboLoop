import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/cycle_repository.dart';
import '../domain/cycle_predictor.dart';

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository(ref.watch(databaseProvider));
});

final cycleEntriesProvider = StreamProvider<List<CycleEntry>>((ref) {
  return ref.watch(cycleRepositoryProvider).watchAll();
});

final cyclePredictionProvider = Provider<CyclePrediction>((ref) {
  final entries = ref.watch(cycleEntriesProvider).value ?? const [];
  return predictNextCycle(entries.map((e) => e.startDate).toList());
});
