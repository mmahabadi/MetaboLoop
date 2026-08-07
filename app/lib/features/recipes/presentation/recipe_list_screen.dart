import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';
import '../../logging/application/log_actions.dart';
import '../application/recipe_service.dart';
import 'recipe_builder_screen.dart';

class RecipeListScreen extends ConsumerStatefulWidget {
  const RecipeListScreen({super.key});

  @override
  ConsumerState<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends ConsumerState<RecipeListScreen> {
  late Future<List<Recipe>> _recipes = _load();

  Future<List<Recipe>> _load() => ref.read(databaseProvider).getAllRecipes();

  Future<void> _logServing(Recipe recipe) async {
    final perServing = await ref
        .read(recipeServiceProvider)
        .perServingTotals(recipe.id);
    if (!mounted) return;

    final servings = await showDialog<double>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: '1');
        return AlertDialog(
          title: Text(recipe.name),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Servings'),
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
              child: const Text('Log it'),
            ),
          ],
        );
      },
    );
    if (servings == null || !mounted) return;

    await ref
        .read(logActionsProvider)
        .logRecipeServing(
          recipeId: recipe.id,
          recipeName: recipe.name,
          servings: servings,
          perServingTotals: perServing,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const RecipeBuilderScreen()),
              );
              setState(() => _recipes = _load());
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipes,
        builder: (context, snapshot) {
          final recipes = snapshot.data ?? const [];
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (recipes.isEmpty) {
            return const Center(
              child: Text('No recipes yet — tap + to build one.'),
            );
          }
          return ListView(
            children: [
              for (final recipe in recipes)
                ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: Text(recipe.name),
                  subtitle: Text('${recipe.servings} servings'),
                  trailing: const Icon(Icons.add_circle_outline),
                  onTap: () => _logServing(recipe),
                ),
            ],
          );
        },
      ),
    );
  }
}
