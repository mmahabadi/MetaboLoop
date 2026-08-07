import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../application/workout_providers.dart';
import '../../domain/workout_type_label.dart';

const _uuid = Uuid();

Future<void> showLogWorkoutSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _LogWorkoutSheet(),
  );
}

class _LogWorkoutSheet extends ConsumerStatefulWidget {
  const _LogWorkoutSheet();

  @override
  ConsumerState<_LogWorkoutSheet> createState() => _LogWorkoutSheetState();
}

class _LogWorkoutSheetState extends ConsumerState<_LogWorkoutSheet> {
  WorkoutType _type = WorkoutType.strength;
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final duration = int.tryParse(_durationController.text);
    if (duration == null || duration <= 0) return;
    setState(() => _saving = true);
    await ref
        .read(workoutRepositoryProvider)
        .logWorkout(
          _uuid.v4(),
          date: DateTime.now(),
          type: _type,
          durationMinutes: duration,
          caloriesBurned: int.tryParse(_caloriesController.text),
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
          Text('Log workout', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              for (final type in WorkoutType.values)
                ChoiceChip(
                  label: Text(type.label),
                  selected: _type == type,
                  onSelected: (_) => setState(() => _type = type),
                ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _durationController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Duration (minutes)'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _caloriesController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Calories burned (optional)',
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed:
                !_saving && int.tryParse(_durationController.text) != null
                ? _save
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
