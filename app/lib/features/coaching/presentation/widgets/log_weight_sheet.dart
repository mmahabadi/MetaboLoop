import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units/units.dart';
import '../../../../core/units/units_providers.dart';
import '../../application/coaching_providers.dart';

Future<void> showLogWeightSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _LogWeightSheet(),
  );
}

class _LogWeightSheet extends ConsumerStatefulWidget {
  const _LogWeightSheet();

  @override
  ConsumerState<_LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends ConsumerState<_LogWeightSheet> {
  final _controller = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save(UnitSystem unitSystem) async {
    final entered = double.tryParse(_controller.text);
    if (entered == null || entered <= 0) return;
    final weightKg = unitSystem == UnitSystem.imperial
        ? lbToKg(entered)
        : entered;
    setState(() => _saving = true);
    await ref
        .read(weightRepositoryProvider)
        .logWeight(date: DateTime.now(), weightKg: weightKg);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final unitSystem = ref.watch(unitSystemProvider).value ?? UnitSystem.metric;
    final unitLabel = unitSystem == UnitSystem.imperial ? 'lb' : 'kg';

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
          Text(
            'Log today\'s weight',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(labelText: 'Weight ($unitLabel)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: !_saving && double.tryParse(_controller.text) != null
                ? () => _save(unitSystem)
                : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
    );
  }
}
