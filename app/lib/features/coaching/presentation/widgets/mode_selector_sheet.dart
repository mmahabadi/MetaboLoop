import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/coaching_providers.dart';
import '../../domain/coaching_mode.dart';

Future<void> showModeSelectorSheet(BuildContext context, CoachingMode current) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => _ModeSelectorSheet(current: current),
  );
}

class _ModeSelectorSheet extends ConsumerWidget {
  const _ModeSelectorSheet({required this.current});

  final CoachingMode current;

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
                'Coaching mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (final mode in CoachingMode.values)
            ListTile(
              title: Text(mode.label),
              subtitle: Text(mode.description),
              trailing: mode == current
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(coachingModeProvider.notifier).setMode(mode);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
