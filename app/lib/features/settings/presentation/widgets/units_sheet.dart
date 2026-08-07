import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/units/units.dart';
import '../../../../core/units/units_providers.dart';

Future<void> showUnitsSheet(BuildContext context, UnitSystem current) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => _UnitsSheet(current: current),
  );
}

class _UnitsSheet extends ConsumerWidget {
  const _UnitsSheet({required this.current});

  final UnitSystem current;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Units',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (final system in UnitSystem.values)
            ListTile(
              title: Text(
                system == UnitSystem.imperial
                    ? 'Imperial (lb, ft/in)'
                    : 'Metric (kg, cm)',
              ),
              trailing: system == current
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(unitSystemProvider.notifier).setUnitSystem(system);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
