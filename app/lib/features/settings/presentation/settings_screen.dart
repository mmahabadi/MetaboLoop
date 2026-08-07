import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/theme_mode_providers.dart';
import '../../../core/units/units.dart';
import '../../../core/units/units_providers.dart';
import '../../export/application/export_providers.dart';
import 'widgets/theme_mode_sheet.dart';
import 'widgets/units_sheet.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitSystem = ref.watch(unitSystemProvider).value ?? UnitSystem.metric;
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Preferences'),
          ListTile(
            leading: const Icon(Icons.straighten_outlined),
            title: const Text('Units'),
            subtitle: Text(
              unitSystem == UnitSystem.imperial
                  ? 'Imperial (lb, ft/in)'
                  : 'Metric (kg, cm)',
            ),
            onTap: () => showUnitsSheet(context, unitSystem),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Appearance'),
            subtitle: Text(_themeModeLabel(themeMode)),
            onTap: () => showThemeModeSheet(context, themeMode),
          ),
          const Divider(height: 1),
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.ios_share),
            title: const Text('Export data as CSV'),
            subtitle: const Text('Daily calories, macros, and weight'),
            onTap: () => _exportCsv(context, ref),
          ),
          const Divider(height: 1),
          const _SectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Account'),
            subtitle: const Text('Sign in, sign up, or manage your account'),
            onTap: () => context.push(AppRoutes.signIn),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium_outlined),
            title: const Text('Subscription'),
            onTap: () => context.push(AppRoutes.paywall),
          ),
          const Divider(height: 1),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Privacy'),
            subtitle: Text(
              'MetaboLoop does not use ad or tracking SDKs. Your data stays '
              'on-device unless you sign in to sync it.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('Health app sync & notifications'),
            subtitle: Text(
              'Apple Health / Google Fit sync and push notifications are '
              'not yet available in this build.',
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Match system';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(exportServiceProvider).exportDailyHistoryCsv();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
