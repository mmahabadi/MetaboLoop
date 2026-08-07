import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../application/log_actions.dart';
import '../../domain/parsed_food_item.dart';

/// Shown after Snap or Describe returns parsed items: each is editable
/// before being logged, per the spec's "editable quantities before saving"
/// requirement.
class ParsedItemsReview extends ConsumerStatefulWidget {
  const ParsedItemsReview({
    super.key,
    required this.items,
    required this.method,
  });

  final List<ParsedFoodItem> items;
  final LogMethod method;

  @override
  ConsumerState<ParsedItemsReview> createState() => _ParsedItemsReviewState();
}

class _ParsedItemsReviewState extends ConsumerState<ParsedItemsReview> {
  final List<ParsedFoodItem> _items = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _items.addAll(widget.items);
  }

  Future<void> _logAll() async {
    setState(() => _saving = true);
    final actions = ref.read(logActionsProvider);
    for (final item in _items) {
      await actions.logParsedItem(item, method: widget.method);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  void _updateGrams(int index, double grams) {
    final item = _items[index];
    if (item.estimatedGrams <= 0) return;
    final factor = grams / item.estimatedGrams;
    setState(() {
      _items[index] = ParsedFoodItem(
        name: item.name,
        estimatedGrams: grams,
        calories: item.calories * factor,
        proteinGrams: item.proteinGrams * factor,
        carbsGrams: item.carbsGrams * factor,
        fatGrams: item.fatGrams * factor,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Center(child: Text('No food items were recognized.'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final item = _items[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text('${item.calories.round()} kcal'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: TextFormField(
                          initialValue: item.estimatedGrams.round().toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'g'),
                          onChanged: (v) {
                            final grams = double.tryParse(v);
                            if (grams != null && grams > 0) {
                              _updateGrams(index, grams);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _saving ? null : _logAll,
            child: Text('Log ${_items.length} item(s)'),
          ),
        ),
      ],
    );
  }
}
