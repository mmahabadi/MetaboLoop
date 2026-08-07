import 'package:flutter/material.dart';

import '../../coaching/presentation/coach_screen.dart';
import '../../logging/presentation/today_screen.dart';
import '../../settings/presentation/settings_screen.dart';
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
    _TabSpec(
      icon: Icons.settings_rounded,
      label: 'Settings',
      builder: SettingsScreen.new,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Each tab's screen supplies its own AppBar/FAB.
      body: _tabs[_index].builder(),
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
    required this.builder,
  });

  final IconData icon;
  final String label;
  final Widget Function() builder;
}
