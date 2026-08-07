import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../application/progress_providers.dart';

Future<void> showMeasurementEntrySheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _MeasurementEntrySheet(),
  );
}

class _MeasurementEntrySheet extends ConsumerStatefulWidget {
  const _MeasurementEntrySheet();

  @override
  ConsumerState<_MeasurementEntrySheet> createState() =>
      _MeasurementEntrySheetState();
}

class _MeasurementEntrySheetState
    extends ConsumerState<_MeasurementEntrySheet> {
  final _waist = TextEditingController();
  final _chest = TextEditingController();
  final _hips = TextEditingController();
  final _arm = TextEditingController();
  final _thigh = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_waist, _chest, _hips, _arm, _thigh]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _num(TextEditingController c) => double.tryParse(c.text);

  bool get _hasAnyValue =>
      [_waist, _chest, _hips, _arm, _thigh].any((c) => _num(c) != null);

  Future<void> _save() async {
    setState(() => _saving = true);
    final now = DateTime.now();
    await ref
        .read(progressRepositoryProvider)
        .upsertMeasurement(
          BodyMeasurementsCompanion.insert(
            id: 'measurement-${DateTime(now.year, now.month, now.day).toIso8601String()}',
            date: DateTime(now.year, now.month, now.day),
            waistCm: Value(_num(_waist)),
            chestCm: Value(_num(_chest)),
            hipsCm: Value(_num(_hips)),
            armCm: Value(_num(_arm)),
            thighCm: Value(_num(_thigh)),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log measurements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          for (final (label, controller) in [
            ('Waist (cm)', _waist),
            ('Chest (cm)', _chest),
            ('Hips (cm)', _hips),
            ('Arm (cm)', _arm),
            ('Thigh (cm)', _thigh),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: label),
                onChanged: (_) => setState(() {}),
              ),
            ),
          FilledButton(
            onPressed: !_saving && _hasAnyValue ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
