import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_providers.dart';

Future<void> showThemeModeSheet(BuildContext context, ThemeMode current) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => _ThemeModeSheet(current: current),
  );
}

class _ThemeModeSheet extends ConsumerWidget {
  const _ThemeModeSheet({required this.current});

  final ThemeMode current;

  static const _labels = {
    ThemeMode.system: 'Match system',
    ThemeMode.light: 'Light',
    ThemeMode.dark: 'Dark',
  };

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
                'Appearance',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (final mode in ThemeMode.values)
            ListTile(
              title: Text(_labels[mode]!),
              trailing: mode == current
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                ref.read(themeModeProvider.notifier).setThemeMode(mode);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
