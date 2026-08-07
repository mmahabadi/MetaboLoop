import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/recipe_service.dart';
import '../domain/draft_ingredient_line.dart';
import 'widgets/add_ingredient_sheet.dart';

class RecipeBuilderScreen extends ConsumerStatefulWidget {
  const RecipeBuilderScreen({super.key});

  @override
  ConsumerState<RecipeBuilderScreen> createState() =>
      _RecipeBuilderScreenState();
}

class _RecipeBuilderScreenState extends ConsumerState<RecipeBuilderScreen> {
  final _nameController = TextEditingController();
  final _servingsController = TextEditingController(text: '1');
  final _lines = <DraftIngredientLine>[];
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  Future<void> _addIngredient() async {
    final line = await showAddIngredientSheet(context);
    if (line != null) setState(() => _lines.add(line));
  }

  Future<void> _save() async {
    final servings = int.tryParse(_servingsController.text) ?? 1;
    if (_nameController.text.trim().isEmpty || _lines.isEmpty) return;

    setState(() => _saving = true);
    await ref
        .read(recipeServiceProvider)
        .saveRecipe(
          name: _nameController.text.trim(),
          servings: servings,
          lines: _lines,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final canSave = _nameController.text.trim().isNotEmpty && _lines.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New recipe'),
        actions: [
          TextButton(
            onPressed: canSave && !_saving ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Recipe name'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _servingsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Servings'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ingredients',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          if (_lines.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No ingredients yet. A recipe can include other saved recipes.',
              ),
            ),
          for (var i = 0; i < _lines.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _lines[i].childRecipe != null
                    ? Icons.menu_book_rounded
                    : Icons.restaurant_rounded,
              ),
              title: Text(_lines[i].displayName),
              subtitle: Text(_lines[i].quantityLabel),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _lines.removeAt(i)),
              ),
            ),
        ],
      ),
    );
  }
}
