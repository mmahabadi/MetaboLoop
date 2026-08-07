import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/database/app_database.dart';

class LogEntryTile extends StatelessWidget {
  const LogEntryTile({super.key, required this.entry, required this.onDelete});

  final LogEntry entry;
  final VoidCallback onDelete;

  static const _methodIcons = {
    LogMethod.manual: Icons.search_rounded,
    LogMethod.barcode: Icons.qr_code_scanner_rounded,
    LogMethod.photo: Icons.camera_alt_rounded,
    LogMethod.naturalLanguage: Icons.chat_bubble_outline_rounded,
    LogMethod.quickAdd: Icons.bolt_rounded,
    LogMethod.recipe: Icons.menu_book_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(entry.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            _methodIcons[entry.method] ?? Icons.restaurant_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        title: Text(entry.displayName),
        subtitle: Text(
          '${entry.quantityLabel} · ${DateFormat.jm().format(entry.loggedAt)}',
        ),
        trailing: Text(
          '${entry.calories.round()} kcal',
          style: theme.textTheme.titleSmall,
        ),
      ),
    );
  }
}
