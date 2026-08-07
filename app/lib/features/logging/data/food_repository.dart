import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import 'off_product.dart';
import 'open_food_facts_client.dart';

/// Combines the local (custom + previously-cached) food database with
/// Open Food Facts search, so results work offline for anything already
/// seen and fall back to network for new lookups. This is the boundary
/// between the offline-first local store and the remote food database
/// per Checkpoint 2.
class FoodRepository {
  FoodRepository(this._db, this._offClient);

  final AppDatabase _db;
  final OpenFoodFactsClient _offClient;
  static const _uuid = Uuid();

  Future<List<LocalFood>> search(String query) async {
    if (query.trim().isEmpty) return const [];

    final local = await _db.searchLocalFoods(query);
    final localBarcodes = local
        .map((f) => f.barcode)
        .whereType<String>()
        .toSet();

    List<OffProduct> remote;
    try {
      remote = await _offClient.search(query);
    } catch (_) {
      // Offline or the remote service is unreachable — local results
      // still work, per the offline-first requirement.
      remote = const [];
    }

    final remoteAsLocal = remote
        .where((p) => !localBarcodes.contains(p.barcode))
        .map(_toUncachedLocalFood)
        .toList();

    return [...local, ...remoteAsLocal];
  }

  /// Looks up a scanned barcode, checking the local cache first.
  Future<LocalFood?> lookupBarcode(String barcode) async {
    final cached = await _db.getFoodByBarcode(barcode);
    if (cached != null) return cached;

    final product = await _offClient.lookupBarcode(barcode);
    if (product == null) return null;

    final food = _toUncachedLocalFood(product);
    await cacheFood(food);
    return food;
  }

  /// Persists a food (typically one just selected from search results) so
  /// future searches and barcode scans find it locally without a network
  /// round-trip.
  Future<void> cacheFood(LocalFood food) {
    return _db.upsertFood(
      LocalFoodsCompanion.insert(
        id: food.id,
        name: food.name,
        brand: Value(food.brand),
        barcode: Value(food.barcode),
        caloriesPer100g: food.caloriesPer100g,
        proteinPer100gGrams: food.proteinPer100gGrams,
        carbsPer100gGrams: food.carbsPer100gGrams,
        fatPer100gGrams: food.fatPer100gGrams,
        defaultServingGrams: Value(food.defaultServingGrams),
        defaultServingLabel: Value(food.defaultServingLabel),
        source: food.source,
        isVerified: Value(food.isVerified),
      ),
    );
  }

  Future<LocalFood> createCustomFood({
    required String name,
    String? brand,
    required double caloriesPer100g,
    required double proteinPer100gGrams,
    required double carbsPer100gGrams,
    required double fatPer100gGrams,
    double? defaultServingGrams,
    String? defaultServingLabel,
  }) async {
    final food = LocalFood(
      id: _uuid.v4(),
      name: name,
      brand: brand,
      caloriesPer100g: caloriesPer100g,
      proteinPer100gGrams: proteinPer100gGrams,
      carbsPer100gGrams: carbsPer100gGrams,
      fatPer100gGrams: fatPer100gGrams,
      defaultServingGrams: defaultServingGrams,
      defaultServingLabel: defaultServingLabel,
      source: FoodSource.custom,
      isVerified: false,
      createdAt: DateTime.now(),
    );
    await cacheFood(food);
    return food;
  }

  LocalFood _toUncachedLocalFood(OffProduct product) {
    return LocalFood(
      id: _uuid.v4(),
      name: product.name,
      brand: product.brand,
      barcode: product.barcode.isEmpty ? null : product.barcode,
      caloriesPer100g: product.caloriesPer100g,
      proteinPer100gGrams: product.proteinPer100gGrams,
      carbsPer100gGrams: product.carbsPer100gGrams,
      fatPer100gGrams: product.fatPer100gGrams,
      defaultServingLabel: product.servingSizeLabel,
      source: FoodSource.openFoodFacts,
      isVerified: true,
      createdAt: DateTime.now(),
    );
  }
}
