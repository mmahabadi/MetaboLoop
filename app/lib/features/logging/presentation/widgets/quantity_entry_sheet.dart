import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../application/log_actions.dart';

/// Shows a bottom sheet asking how much of [food] was eaten, then logs it.
/// Returns true if an entry was saved.
Future<bool> showQuantityEntrySheet(
  BuildContext context, {
  required LocalFood food,
  LogMethod method = LogMethod.manual,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _QuantityEntrySheet(food: food, method: method),
  );
  return result ?? false;
}

class _QuantityEntrySheet extends ConsumerStatefulWidget {
  const _QuantityEntrySheet({required this.food, required this.method});

  final LocalFood food;
  final LogMethod method;

  @override
  ConsumerState<_QuantityEntrySheet> createState() =>
      _QuantityEntrySheetState();
}

class _QuantityEntrySheetState extends ConsumerState<_QuantityEntrySheet> {
  late final _controller = TextEditingController(
    text: (widget.food.defaultServingGrams ?? 100).round().toString(),
  );
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _grams => double.tryParse(_controller.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grams = _grams;
    final factor = grams / 100;
    final calories = widget.food.caloriesPer100g * factor;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.food.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: const InputDecoration(labelText: 'Quantity (g)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Text('${calories.round()} kcal', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: grams > 0 && !_saving ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Log it'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref
        .read(logActionsProvider)
        .logFood(
          food: widget.food,
          quantityGrams: _grams,
          method: widget.method,
        );
    if (mounted) Navigator.of(context).pop(true);
  }
}
