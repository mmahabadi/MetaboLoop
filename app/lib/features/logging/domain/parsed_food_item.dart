/// An editable food item as suggested by AI photo or natural-language
/// parsing, before the user confirms it into the log.
class ParsedFoodItem {
  const ParsedFoodItem({
    required this.name,
    required this.estimatedGrams,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
  });

  final String name;
  final double estimatedGrams;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;

  static ParsedFoodItem? fromJson(Map<String, dynamic> json) {
    final name = (json['name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;

    return ParsedFoodItem(
      name: name,
      estimatedGrams: _asDouble(json['estimatedGrams']) ?? 100,
      calories: _asDouble(json['calories']) ?? 0,
      proteinGrams: _asDouble(json['proteinGrams']) ?? 0,
      carbsGrams: _asDouble(json['carbsGrams']) ?? 0,
      fatGrams: _asDouble(json['fatGrams']) ?? 0,
    );
  }

  static double? _asDouble(Object? value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
