import 'package:flutter/material.dart';

class LogEntryPoint {
  const LogEntryPoint({
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String route;
}

Future<String?> showLogEntryPointSheet(
  BuildContext context, {
  required List<LogEntryPoint> entryPoints,
}) {
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final entryPoint in entryPoints)
            ListTile(
              leading: Icon(entryPoint.icon),
              title: Text(entryPoint.label),
              onTap: () => Navigator.of(context).pop(entryPoint.route),
            ),
        ],
      ),
    ),
  );
}
