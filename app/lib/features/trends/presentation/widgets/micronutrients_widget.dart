import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logging/domain/micronutrient_targets.dart';
import '../../application/trends_providers.dart';
import 'dashboard_card.dart';

/// Today's fiber/sugar/sodium against user-configurable targets. Fiber is
/// a floor (more is better, so the bar fills toward the target); sugar and
/// sodium are ceilings (less is better, so filling past the target reads
/// as over, not "complete").
class MicronutrientsWidget extends ConsumerWidget {
  const MicronutrientsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalsAsync = ref.watch(todayMicronutrientTotalsProvider);
    final targetsAsync = ref.watch(micronutrientTargetsProvider);

    return DashboardCard(
      title: "Today's micronutrients",
      child: Builder(
        builder: (context) {
          if (totalsAsync.hasError) {
            return Text('Could not load micronutrients: ${totalsAsync.error}');
          }
          if (targetsAsync.hasError) {
            return Text(
              'Could not load micronutrient targets: ${targetsAsync.error}',
            );
          }
          if (!totalsAsync.hasValue || !targetsAsync.hasValue) {
            return const SizedBox(
              height: 80,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final totals = totalsAsync.requireValue;
          final targets = targetsAsync.requireValue;

          return Column(
            children: [
              _MicronutrientRow(
                label: 'Fiber',
                value: totals.fiberGrams,
                target: targets.fiberGrams,
                unit: 'g',
                isFloor: true,
              ),
              const SizedBox(height: 12),
              _MicronutrientRow(
                label: 'Sugar',
                value: totals.sugarGrams,
                target: targets.sugarGramsMax,
                unit: 'g',
                isFloor: false,
              ),
              const SizedBox(height: 12),
              _MicronutrientRow(
                label: 'Sodium',
                value: totals.sodiumMg,
                target: targets.sodiumMgMax,
                unit: 'mg',
                isFloor: false,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showEditTargetsSheet(context, ref, targets),
                  child: const Text('Edit targets'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showEditTargetsSheet(
    BuildContext context,
    WidgetRef ref,
    MicronutrientTargets current,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _EditTargetsSheet(current: current),
    );
  }
}

class _MicronutrientRow extends StatelessWidget {
  const _MicronutrientRow({
    required this.label,
    required this.value,
    required this.target,
    required this.unit,
    required this.isFloor,
  });

  final double? value;
  final double target;
  final String label;
  final String unit;
  final bool isFloor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actual = value ?? 0;
    final ratio = target <= 0 ? 0.0 : (actual / target).clamp(0.0, 1.0);
    final isOver = !isFloor && actual > target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Text(
              '${actual.round()} / ${target.round()} $unit',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isOver ? theme.colorScheme.error : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            color: isOver ? theme.colorScheme.error : theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }
}

class _EditTargetsSheet extends ConsumerStatefulWidget {
  const _EditTargetsSheet({required this.current});

  final MicronutrientTargets current;

  @override
  ConsumerState<_EditTargetsSheet> createState() => _EditTargetsSheetState();
}

class _EditTargetsSheetState extends ConsumerState<_EditTargetsSheet> {
  late final _fiberController = TextEditingController(
    text: widget.current.fiberGrams.round().toString(),
  );
  late final _sugarController = TextEditingController(
    text: widget.current.sugarGramsMax.round().toString(),
  );
  late final _sodiumController = TextEditingController(
    text: widget.current.sodiumMgMax.round().toString(),
  );

  @override
  void dispose() {
    _fiberController.dispose();
    _sugarController.dispose();
    _sodiumController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final targets = MicronutrientTargets(
      fiberGrams:
          double.tryParse(_fiberController.text) ?? widget.current.fiberGrams,
      sugarGramsMax:
          double.tryParse(_sugarController.text) ??
          widget.current.sugarGramsMax,
      sodiumMgMax:
          double.tryParse(_sodiumController.text) ?? widget.current.sodiumMgMax,
    );
    await ref.read(micronutrientTargetsProvider.notifier).setTargets(targets);
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
          Text('Daily targets', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _fiberController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Fiber target (g)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sugarController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Sugar max (g)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _sodiumController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Sodium max (mg)'),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
    );
  }
}
