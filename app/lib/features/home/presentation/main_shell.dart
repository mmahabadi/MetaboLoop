import 'package:flutter/material.dart';

import '../../coaching/presentation/coach_screen.dart';
import '../../logging/presentation/today_screen.dart';
import '../../trends/presentation/trends_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _tabs = [
    _TabSpec(
      icon: Icons.today_rounded,
      label: 'Today',
      builder: TodayScreen.new,
    ),
    _TabSpec(
      icon: Icons.show_chart_rounded,
      label: 'Trends',
      builder: TrendsScreen.new,
    ),
    _TabSpec(
      icon: Icons.psychology_alt_rounded,
      label: 'Coach',
      builder: CoachScreen.new,
    ),
    _TabSpec(icon: Icons.settings_rounded, label: 'Settings', phase: 'Phase 5'),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_index];

    return Scaffold(
      // Tabs with their own screen supply their own AppBar/FAB; others
      // share this outer chrome until their phase builds them.
      appBar: tab.builder != null ? null : AppBar(title: Text(tab.label)),
      body: tab.builder != null ? tab.builder!() : _ComingSoon(tab: tab),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _tabs
            .map(
              (t) => NavigationDestination(icon: Icon(t.icon), label: t.label),
            )
            .toList(),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec({
    required this.icon,
    required this.label,
    this.phase,
    this.builder,
  });

  final IconData icon;
  final String label;
  final String? phase;
  final Widget Function()? builder;
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.tab});

  final _TabSpec tab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(tab.icon, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '${tab.label} is built in ${tab.phase}',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This tab establishes the confirmed information architecture '
              'now; the feature itself lands in a later phase.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
