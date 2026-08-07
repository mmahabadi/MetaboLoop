import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:metaboloop/features/logging/data/open_food_facts_client.dart';

void main() {
  group('OpenFoodFactsClient.search', () {
    test('parses a well-formed search response', () async {
      final mock = MockClient((request) async {
        expect(request.url.host, 'world.openfoodfacts.org');
        expect(request.url.queryParameters['search_terms'], 'banana');
        return http.Response(
          jsonEncode({
            'products': [
              {
                'code': '1234567890123',
                'product_name': 'Banana',
                'brands': 'Chiquita, Fresh',
                'nutriments': {
                  'energy-kcal_100g': 89,
                  'proteins_100g': 1.1,
                  'carbohydrates_100g': 22.8,
                  'fat_100g': 0.3,
                },
                'serving_size': '118 g',
              },
            ],
          }),
          200,
        );
      });

      final client = OpenFoodFactsClient(httpClient: mock);
      final results = await client.search('banana');

      expect(results, hasLength(1));
      final product = results.first;
      expect(product.name, 'Banana');
      expect(product.brand, 'Chiquita');
      expect(product.barcode, '1234567890123');
      expect(product.caloriesPer100g, 89);
      expect(product.proteinPer100gGrams, 1.1);
      expect(product.carbsPer100gGrams, 22.8);
      expect(product.fatPer100gGrams, 0.3);
      expect(product.servingSizeLabel, '118 g');
    });

    test('skips products missing a name or calorie data', () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'products': [
              {
                'product_name': '',
                'nutriments': {'energy-kcal_100g': 100},
              },
              {
                'product_name': 'No calories listed',
                'nutriments': {'proteins_100g': 5},
              },
              {
                'product_name': 'Valid product',
                'nutriments': {'energy-kcal_100g': 50},
              },
            ],
          }),
          200,
        );
      });

      final client = OpenFoodFactsClient(httpClient: mock);
      final results = await client.search('x');

      expect(results, hasLength(1));
      expect(results.single.name, 'Valid product');
    });

    test('returns an empty list on a non-200 response', () async {
      final mock = MockClient((request) async => http.Response('', 503));
      final client = OpenFoodFactsClient(httpClient: mock);

      expect(await client.search('x'), isEmpty);
    });
  });

  group('OpenFoodFactsClient.lookupBarcode', () {
    test('parses a found product', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/v2/product/3017620422003.json');
        return http.Response(
          jsonEncode({
            'status': 1,
            'product': {
              'code': '3017620422003',
              'product_name': "Nutella",
              'brands': 'Ferrero',
              'nutriments': {
                'energy-kcal_100g': 539,
                'proteins_100g': 6.3,
                'carbohydrates_100g': 57.5,
                'fat_100g': 30.9,
              },
            },
          }),
          200,
        );
      });

      final client = OpenFoodFactsClient(httpClient: mock);
      final product = await client.lookupBarcode('3017620422003');

      expect(product, isNotNull);
      expect(product!.name, 'Nutella');
      expect(product.caloriesPer100g, 539);
    });

    test('returns null when the product is not found', () async {
      final mock = MockClient((request) async {
        return http.Response(jsonEncode({'status': 0}), 200);
      });

      final client = OpenFoodFactsClient(httpClient: mock);
      expect(await client.lookupBarcode('0000000000000'), isNull);
    });
  });
}
