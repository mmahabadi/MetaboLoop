import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';

/// Per-day custom targets (e.g. a higher-carb training day) — applies only
/// on the chosen date, independent of the versioned Targets history.
Future<void> showDayOverrideSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _DayOverrideSheet(),
  );
}

class _DayOverrideSheet extends ConsumerStatefulWidget {
  const _DayOverrideSheet();

  @override
  ConsumerState<_DayOverrideSheet> createState() => _DayOverrideSheetState();
}

class _DayOverrideSheetState extends ConsumerState<_DayOverrideSheet> {
  DateTime _date = DateTime.now();
  final _labelController = TextEditingController(text: 'Training day');
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _labelController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final calories = double.tryParse(_caloriesController.text);
    if (calories == null) return;
    setState(() => _saving = true);

    final day = DateTime(_date.year, _date.month, _date.day);
    await ref
        .read(databaseProvider)
        .upsertDayOverride(
          DayOverridesCompanion.insert(
            id: 'override-${day.toIso8601String()}',
            date: day,
            calories: calories,
            proteinGrams: double.tryParse(_proteinController.text) ?? 0,
            carbsGrams: double.tryParse(_carbsController.text) ?? 0,
            fatGrams: double.tryParse(_fatController.text) ?? 0,
            label: Value(
              _labelController.text.trim().isEmpty
                  ? null
                  : _labelController.text.trim(),
            ),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom target for a day',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                '${_date.year}-${_date.month.toString().padLeft(2, '0')}-'
                '${_date.day.toString().padLeft(2, '0')}',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(labelText: 'Label (optional)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Calories'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _proteinController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Protein (g)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _carbsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Carbs (g)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _fatController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Fat (g)'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed:
                  !_saving && double.tryParse(_caloriesController.text) != null
                  ? _save
                  : null,
              child: const Text('Save override'),
            ),
          ],
        ),
      ),
    );
  }
}
