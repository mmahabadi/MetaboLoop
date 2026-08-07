/// A product as returned by the Open Food Facts API — distinct from
/// [LocalFood] because it hasn't necessarily been cached locally yet.
class OffProduct {
  const OffProduct({
    required this.barcode,
    required this.name,
    this.brand,
    required this.caloriesPer100g,
    required this.proteinPer100gGrams,
    required this.carbsPer100gGrams,
    required this.fatPer100gGrams,
    this.servingSizeLabel,
  });

  final String barcode;
  final String name;
  final String? brand;
  final double caloriesPer100g;
  final double proteinPer100gGrams;
  final double carbsPer100gGrams;
  final double fatPer100gGrams;
  final String? servingSizeLabel;

  /// Parses a single OFF "product" JSON object. Returns null when the
  /// product is missing a name or per-100g calorie data — too incomplete
  /// to log against.
  static OffProduct? fromJson(Map<String, dynamic> json) {
    final name = (json['product_name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;

    final nutriments = json['nutriments'] as Map<String, dynamic>?;
    if (nutriments == null) return null;

    final calories = _asDouble(nutriments['energy-kcal_100g']);
    if (calories == null) return null;

    return OffProduct(
      barcode: (json['code'] as String?) ?? '',
      name: name,
      brand: (json['brands'] as String?)?.split(',').first.trim(),
      caloriesPer100g: calories,
      proteinPer100gGrams: _asDouble(nutriments['proteins_100g']) ?? 0,
      carbsPer100gGrams: _asDouble(nutriments['carbohydrates_100g']) ?? 0,
      fatPer100gGrams: _asDouble(nutriments['fat_100g']) ?? 0,
      servingSizeLabel: json['serving_size'] as String?,
    );
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
