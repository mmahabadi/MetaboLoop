import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../domain/parsed_food_item.dart';

/// Thin wrapper around the Gemini API for AI photo ("Snap") and
/// natural-language ("Describe") food logging. No API key is configured in
/// this build — see app/README.md — so calls here throw a clear
/// [StateError] rather than silently failing; screens check
/// [isConfigured] before calling.
class GeminiFoodService {
  GeminiFoodService({http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final http.Client _client;

  bool get isConfigured => AppConfig.isGeminiConfigured;

  static const _model = 'gemini-2.5-flash';
  static const _promptSuffix =
      'Respond with ONLY a JSON array, no prose. Each element: '
      '{"name": string, "estimatedGrams": number, "calories": number, '
      '"proteinGrams": number, "carbsGrams": number, "fatGrams": number}.';

  Future<List<ParsedFoodItem>> parsePhoto(
    List<int> imageBytes, {
    String mimeType = 'image/jpeg',
  }) {
    return _generate([
      {
        'text':
            'Identify each distinct food item in this plate photo and '
            'estimate its quantity and nutrition. $_promptSuffix',
      },
      {
        'inline_data': {
          'mime_type': mimeType,
          'data': base64Encode(imageBytes),
        },
      },
    ]);
  }

  Future<List<ParsedFoodItem>> parseDescription(String description) {
    return _generate([
      {
        'text':
            'Parse this meal description into individual food items with '
            'estimated quantities and nutrition: "$description". $_promptSuffix',
      },
    ]);
  }

  Future<List<ParsedFoodItem>> _generate(
    List<Map<String, dynamic>> parts,
  ) async {
    if (!isConfigured) {
      throw StateError(
        'Gemini is not configured in this build. Set GEMINI_API_KEY to enable AI logging.',
      );
    }

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent'
      '?key=${AppConfig.geminiApiKey}',
    );

    final response = await _client.post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'parts': parts},
        ],
        'generationConfig': {'responseMimeType': 'application/json'},
      }),
    );

    if (response.statusCode != 200) {
      throw StateError('Gemini request failed (${response.statusCode}).');
    }

    return parseResponseBody(response.body);
  }

  /// Extracted for testability: parses a raw Gemini `generateContent`
  /// response body into food items, without needing a live API call.
  static List<ParsedFoodItem> parseResponseBody(String body) {
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>?;
    final text =
        (candidates?.firstOrNull as Map<String, dynamic>?)?['content']
            as Map<String, dynamic>?;
    final partsText =
        ((text?['parts'] as List<dynamic>?)?.firstOrNull
                as Map<String, dynamic>?)?['text']
            as String?;
    if (partsText == null) return const [];

    final items = jsonDecode(partsText) as List<dynamic>;
    return items
        .cast<Map<String, dynamic>>()
        .map(ParsedFoodItem.fromJson)
        .whereType<ParsedFoodItem>()
        .toList();
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
