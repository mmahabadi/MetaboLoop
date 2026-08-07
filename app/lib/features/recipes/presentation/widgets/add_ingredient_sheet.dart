import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../logging/application/logging_providers.dart';
import '../../domain/draft_ingredient_line.dart';

/// Lets the recipe builder add either a food (by search) or another saved
/// recipe (nested recipe-within-recipe) as an ingredient line.
Future<DraftIngredientLine?> showAddIngredientSheet(BuildContext context) {
  return showModalBottomSheet<DraftIngredientLine>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _AddIngredientSheet(),
  );
}

class _AddIngredientSheet extends ConsumerStatefulWidget {
  const _AddIngredientSheet();

  @override
  ConsumerState<_AddIngredientSheet> createState() =>
      _AddIngredientSheetState();
}

class _AddIngredientSheetState extends ConsumerState<_AddIngredientSheet> {
  bool _foodMode = true;
  final _searchController = TextEditingController();
  List<LocalFood> _foodResults = const [];
  List<Recipe> _recipeResults = const [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (_foodMode) {
      final results = await ref.read(foodRepositoryProvider).search(query);
      if (mounted) setState(() => _foodResults = results);
    } else {
      final all = await ref.read(databaseProvider).getAllRecipes();
      if (mounted) {
        setState(
          () => _recipeResults = all
              .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
              .toList(),
        );
      }
    }
  }

  Future<void> _pickFood(LocalFood food) async {
    final grams = await _promptNumber(
      context,
      label: 'Quantity (g)',
      initial: 100,
    );
    if (grams == null || !mounted) return;
    Navigator.of(
      context,
    ).pop(DraftIngredientLine.food(food: food, quantityGrams: grams));
  }

  Future<void> _pickRecipe(Recipe recipe) async {
    final servings = await _promptNumber(
      context,
      label: 'Servings',
      initial: 1,
    );
    if (servings == null || !mounted) return;
    Navigator.of(context).pop(
      DraftIngredientLine.recipe(childRecipe: recipe, servingsCount: servings),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: 420,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Food')),
                ButtonSegment(value: false, label: Text('Recipe')),
              ],
              selected: {_foodMode},
              onSelectionChanged: (s) {
                setState(() {
                  _foodMode = s.first;
                  _foodResults = const [];
                  _recipeResults = const [];
                });
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _foodMode ? 'Search foods…' : 'Search your recipes…',
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _foodMode
                  ? ListView(
                      children: [
                        for (final food in _foodResults)
                          ListTile(
                            title: Text(food.name),
                            onTap: () => _pickFood(food),
                          ),
                      ],
                    )
                  : ListView(
                      children: [
                        for (final recipe in _recipeResults)
                          ListTile(
                            title: Text(recipe.name),
                            subtitle: Text('${recipe.servings} servings'),
                            onTap: () => _pickRecipe(recipe),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<double?> _promptNumber(
  BuildContext context, {
  required String label,
  required double initial,
}) {
  final controller = TextEditingController(text: initial.toString());
  return showDialog<double>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(label),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(double.tryParse(controller.text)),
          child: const Text('Add'),
        ),
      ],
    ),
  );
}
