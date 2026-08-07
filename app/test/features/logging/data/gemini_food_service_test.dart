import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/features/logging/data/gemini_food_service.dart';

String _responseWithItems(List<Map<String, dynamic>> items) {
  return jsonEncode({
    'candidates': [
      {
        'content': {
          'parts': [
            {'text': jsonEncode(items)},
          ],
        },
      },
    ],
  });
}

void main() {
  group('GeminiFoodService.parseResponseBody', () {
    test('parses a well-formed multi-item response', () {
      final body = _responseWithItems([
        {
          'name': 'Grilled chicken breast',
          'estimatedGrams': 150,
          'calories': 250,
          'proteinGrams': 46,
          'carbsGrams': 0,
          'fatGrams': 5,
        },
        {
          'name': 'White rice',
          'estimatedGrams': 200,
          'calories': 260,
          'proteinGrams': 5,
          'carbsGrams': 56,
          'fatGrams': 0.5,
        },
      ]);

      final items = GeminiFoodService.parseResponseBody(body);

      expect(items, hasLength(2));
      expect(items[0].name, 'Grilled chicken breast');
      expect(items[0].estimatedGrams, 150);
      expect(items[1].calories, 260);
    });

    test('skips items missing a name', () {
      final body = _responseWithItems([
        {'estimatedGrams': 100, 'calories': 100},
        {'name': 'Apple', 'calories': 95},
      ]);

      final items = GeminiFoodService.parseResponseBody(body);

      expect(items, hasLength(1));
      expect(items.single.name, 'Apple');
    });

    test('returns an empty list when the response has no candidates', () {
      final body = jsonEncode({'candidates': <dynamic>[]});
      expect(GeminiFoodService.parseResponseBody(body), isEmpty);
    });
  });

  group('GeminiFoodService not-configured behavior', () {
    test('parsePhoto throws a clear error when no API key is set', () async {
      final service = GeminiFoodService();
      expect(service.isConfigured, isFalse);
      await expectLater(
        () => service.parsePhoto(const [1, 2, 3]),
        throwsA(isA<StateError>()),
      );
    });

    test(
      'parseDescription throws a clear error when no API key is set',
      () async {
        final service = GeminiFoodService();
        await expectLater(
          () => service.parseDescription('a bowl of oatmeal'),
          throwsA(isA<StateError>()),
        );
      },
    );
  });
}
