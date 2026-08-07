import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/trends_providers.dart';
import '../../domain/dashboard_widget_type.dart';

Future<void> showManageWidgetsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => const _ManageWidgetsSheet(),
  );
}

class _ManageWidgetsSheet extends ConsumerWidget {
  const _ManageWidgetsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutAsync = ref.watch(dashboardLayoutProvider);
    final visible = layoutAsync.value ?? const [];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Dashboard widgets',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (final widget in DashboardWidgetType.values)
            CheckboxListTile(
              title: Text(widget.label),
              value: visible.contains(widget),
              onChanged: (checked) {
                final notifier = ref.read(dashboardLayoutProvider.notifier);
                if (checked ?? false) {
                  notifier.show(widget);
                } else {
                  notifier.hide(widget);
                }
              },
            ),
        ],
      ),
    );
  }
}
