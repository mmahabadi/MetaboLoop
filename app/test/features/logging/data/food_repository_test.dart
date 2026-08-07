import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/features/logging/data/food_repository.dart';
import 'package:metaboloop/features/logging/data/open_food_facts_client.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  test('search combines local custom foods with remote results', () async {
    final mock = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'products': [
            {
              'code': '111',
              'product_name': 'Oatmeal',
              'nutriments': {
                'energy-kcal_100g': 379,
                'proteins_100g': 13.2,
                'carbohydrates_100g': 67.7,
                'fat_100g': 6.9,
              },
            },
          ],
        }),
        200,
      );
    });
    final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

    await repo.createCustomFood(
      name: 'Oat protein shake',
      caloriesPer100g: 120,
      proteinPer100gGrams: 20,
      carbsPer100gGrams: 5,
      fatPer100gGrams: 2,
    );

    final results = await repo.search('oat');

    expect(
      results.map((f) => f.name),
      containsAll(['Oat protein shake', 'Oatmeal']),
    );
  });

  test(
    'a remote result already cached locally by barcode is not duplicated',
    () async {
      const yogurt = {
        'code': '222',
        'product_name': 'Greek Yogurt',
        'nutriments': {
          'energy-kcal_100g': 59,
          'proteins_100g': 10,
          'carbohydrates_100g': 3.6,
          'fat_100g': 0.4,
        },
      };
      final mock = MockClient((request) async {
        if (request.url.path.startsWith('/api/v2/product/')) {
          return http.Response(
            jsonEncode({'status': 1, 'product': yogurt}),
            200,
          );
        }
        return http.Response(
          jsonEncode({
            'products': [yogurt],
          }),
          200,
        );
      });
      final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

      final cached = await repo.lookupBarcode('222');
      expect(cached, isNotNull);

      final results = await repo.search('yogurt');

      expect(results.where((f) => f.barcode == '222'), hasLength(1));
    },
  );

  test(
    'lookupBarcode caches the result so a second lookup is served locally',
    () async {
      var callCount = 0;
      final mock = MockClient((request) async {
        callCount++;
        return http.Response(
          jsonEncode({
            'status': 1,
            'product': {
              'code': '333',
              'product_name': 'Almonds',
              'nutriments': {
                'energy-kcal_100g': 579,
                'proteins_100g': 21.2,
                'carbohydrates_100g': 21.6,
                'fat_100g': 49.9,
              },
            },
          }),
          200,
        );
      });
      final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

      final first = await repo.lookupBarcode('333');
      final second = await repo.lookupBarcode('333');

      expect(first, isNotNull);
      expect(second, isNotNull);
      expect(second!.id, first!.id);
      expect(
        callCount,
        1,
        reason: 'second lookup should be served from the local cache',
      );
    },
  );

  test(
    'lookupBarcode persists fiber/sugar/sodium from the remote product',
    () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'status': 1,
            'product': {
              'code': '444',
              'product_name': 'Lentils',
              'nutriments': {
                'energy-kcal_100g': 116,
                'proteins_100g': 9,
                'carbohydrates_100g': 20,
                'fat_100g': 0.4,
                'fiber_100g': 7.9,
                'sugars_100g': 1.8,
                'sodium_100g': 0.002,
              },
            },
          }),
          200,
        );
      });
      final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

      final food = await repo.lookupBarcode('444');

      expect(food, isNotNull);
      expect(food!.fiberPer100gGrams, 7.9);
      expect(food.sugarPer100gGrams, 1.8);
      expect(food.sodiumPer100gMg, closeTo(2, 0.001));

      final cached = await db.getFoodByBarcode('444');
      expect(cached!.fiberPer100gGrams, 7.9);
      expect(cached.sugarPer100gGrams, 1.8);
      expect(cached.sodiumPer100gMg, closeTo(2, 0.001));
    },
  );

  test(
    'createCustomFood persists optional fiber/sugar/sodium values',
    () async {
      final mock = MockClient((request) async => http.Response('', 503));
      final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

      final food = await repo.createCustomFood(
        name: 'High-fiber cereal',
        caloriesPer100g: 350,
        proteinPer100gGrams: 10,
        carbsPer100gGrams: 70,
        fatPer100gGrams: 3,
        fiberPer100gGrams: 15,
        sugarPer100gGrams: 4,
        sodiumPer100gMg: 300,
      );

      expect(food.fiberPer100gGrams, 15);
      expect(food.sugarPer100gGrams, 4);
      expect(food.sodiumPer100gMg, 300);
    },
  );

  test(
    'search still returns local results when the network is unreachable',
    () async {
      final mock = MockClient(
        (request) async => throw Exception('network unreachable'),
      );
      final repo = FoodRepository(db, OpenFoodFactsClient(httpClient: mock));

      await repo.createCustomFood(
        name: 'Homemade granola',
        caloriesPer100g: 450,
        proteinPer100gGrams: 10,
        carbsPer100gGrams: 55,
        fatPer100gGrams: 20,
      );

      final results = await repo.search('granola');

      expect(results, hasLength(1));
      expect(results.single.name, 'Homemade granola');
    },
  );
}
