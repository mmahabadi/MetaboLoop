import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/logging_providers.dart';
import 'widgets/quantity_entry_sheet.dart';

/// Custom food creation. AI-assisted creation from a label photo would
/// reuse the same Gemini backend as Snap/Describe — not configured in
/// this build, see those screens' "not configured" notices.
class CustomFoodScreen extends ConsumerStatefulWidget {
  const CustomFoodScreen({super.key});

  @override
  ConsumerState<CustomFoodScreen> createState() => _CustomFoodScreenState();
}

class _CustomFoodScreenState extends ConsumerState<CustomFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _fiberController = TextEditingController();
  final _sugarController = TextEditingController();
  final _sodiumController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _fiberController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Required' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final food = await ref
        .read(foodRepositoryProvider)
        .createCustomFood(
          name: _nameController.text.trim(),
          brand: _brandController.text.trim().isEmpty
              ? null
              : _brandController.text.trim(),
          caloriesPer100g: double.parse(_caloriesController.text),
          proteinPer100gGrams: double.tryParse(_proteinController.text) ?? 0,
          carbsPer100gGrams: double.tryParse(_carbsController.text) ?? 0,
          fatPer100gGrams: double.tryParse(_fatController.text) ?? 0,
          fiberPer100gGrams: double.tryParse(_fiberController.text),
          sugarPer100gGrams: double.tryParse(_sugarController.text),
          sodiumPer100gMg: double.tryParse(_sodiumController.text),
        );

    if (!mounted) return;
    final logged = await showQuantityEntrySheet(context, food: food);
    if (logged && mounted) Navigator.of(context).pop();
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New custom food')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrition per 100 g',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: _required,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand (optional)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _caloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories per 100g',
                ),
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Enter a number' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _proteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Protein (g)',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _carbsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Carbs (g)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fat (g)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Micronutrients per 100 g (optional)',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _fiberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Fiber (g)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _sugarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Sugar (g)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _sodiumController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Sodium (mg)',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Save and log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
