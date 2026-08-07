import 'dart:convert';

import 'package:http/http.dart' as http;

import 'off_product.dart';

/// Thin client for the public Open Food Facts API (no API key required).
/// [httpClient] is injectable so callers can supply a fake for tests
/// without hitting the network.
class OpenFoodFactsClient {
  OpenFoodFactsClient({http.Client? httpClient})
    : _client = httpClient ?? http.Client();

  final http.Client _client;
  static const _baseUrl = 'https://world.openfoodfacts.org';

  Future<List<OffProduct>> search(String query) async {
    final uri = Uri.parse('$_baseUrl/cgi/search.pl').replace(
      queryParameters: {
        'search_terms': query,
        'search_simple': '1',
        'action': 'process',
        'json': '1',
        'page_size': '20',
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) return const [];

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final products = body['products'] as List<dynamic>? ?? const [];

    return products
        .cast<Map<String, dynamic>>()
        .map(OffProduct.fromJson)
        .whereType<OffProduct>()
        .toList();
  }

  Future<OffProduct?> lookupBarcode(String barcode) async {
    final uri = Uri.parse('$_baseUrl/api/v2/product/$barcode.json');
    final response = await _client.get(uri);
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['status'] != 1) return null;

    final product = body['product'] as Map<String, dynamic>?;
    if (product == null) return null;
    return OffProduct.fromJson(product);
  }
}
