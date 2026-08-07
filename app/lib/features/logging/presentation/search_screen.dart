import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../application/logging_providers.dart';
import 'widgets/quantity_entry_sheet.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<LocalFood>? _results;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() => _results = null);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(query));
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    final repo = ref.read(foodRepositoryProvider);
    final results = await repo.search(query);
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  Future<void> _select(LocalFood food) async {
    final logged = await showQuantityEntrySheet(context, food: food);
    if (logged && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final recentAsync = ref.watch(recentFoodsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search foods…',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results == null
          ? recentAsync.when(
              data: (recent) => recent.isEmpty
                  ? const Center(
                      child: Text('Search for a food to get started'),
                    )
                  : ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
                          child: Text(
                            'RECENTLY LOGGED',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (final food in recent)
                          _FoodResultTile(
                            food: food,
                            onTap: () => _select(food),
                          ),
                      ],
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            )
          : _results!.isEmpty
          ? const Center(child: Text('No results'))
          : ListView(
              children: [
                for (final food in _results!)
                  _FoodResultTile(food: food, onTap: () => _select(food)),
              ],
            ),
    );
  }
}

class _FoodResultTile extends StatelessWidget {
  const _FoodResultTile({required this.food, required this.onTap});

  final LocalFood food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(food.name),
      subtitle: Text(
        [
          if (food.brand != null) food.brand!,
          '${food.caloriesPer100g.round()} kcal / 100g',
        ].join(' · '),
      ),
      trailing: const Icon(Icons.add_circle_outline),
      onTap: onTap,
    );
  }
}
