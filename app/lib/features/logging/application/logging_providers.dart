import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../data/food_repository.dart';
import '../data/gemini_food_service.dart';
import '../data/open_food_facts_client.dart';

final openFoodFactsClientProvider = Provider<OpenFoodFactsClient>((ref) {
  return OpenFoodFactsClient();
});

final geminiFoodServiceProvider = Provider<GeminiFoodService>((ref) {
  return GeminiFoodService();
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(
    ref.watch(databaseProvider),
    ref.watch(openFoodFactsClientProvider),
  );
});

/// The date currently shown on the Today timeline.
final selectedLogDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final logEntriesForDateProvider =
    StreamProvider.family<List<LogEntry>, DateTime>((ref, date) {
      return ref.watch(databaseProvider).watchLogEntriesForDate(date);
    });

final recentFoodsProvider = FutureProvider<List<LocalFood>>((ref) {
  return ref.watch(databaseProvider).getRecentlyLoggedFoods();
});
