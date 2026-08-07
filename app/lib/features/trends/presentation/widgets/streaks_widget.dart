import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/trends_providers.dart';
import 'dashboard_card.dart';

class StreaksWidget extends ConsumerWidget {
  const StreaksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(loggingStreakProvider);
    final theme = Theme.of(context);

    return DashboardCard(
      title: 'Logging streak',
      child: streakAsync.when(
        loading: () => const SizedBox(
          height: 60,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Could not load: $e'),
        data: (streak) => Row(
          children: [
            Icon(Icons.local_fire_department, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              '$streak day${streak == 1 ? '' : 's'}',
              style: theme.textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
