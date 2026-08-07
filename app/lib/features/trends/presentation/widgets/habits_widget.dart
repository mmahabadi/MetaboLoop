import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../application/trends_providers.dart';
import 'dashboard_card.dart';

const _uuid = Uuid();

class HabitsWidget extends ConsumerWidget {
  const HabitsWidget({super.key});

  Future<void> _addHabit(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New habit'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. 10k steps'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    await ref
        .read(databaseProvider)
        .insertHabit(HabitsCompanion.insert(id: _uuid.v4(), name: name));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(activeHabitsProvider);
    final completionsAsync = ref.watch(todayHabitCompletionsProvider);

    return DashboardCard(
      title: 'Habits',
      child: habitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Could not load habits: $e'),
        data: (habits) {
          final completedIds =
              completionsAsync.value?.map((c) => c.habitId).toSet() ??
              const <String>{};

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (habits.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('No habits yet.'),
                ),
              for (final habit in habits)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: completedIds.contains(habit.id),
                  title: Text(habit.name),
                  onChanged: (_) => ref
                      .read(databaseProvider)
                      .toggleHabitCompletion(habit.id, DateTime.now()),
                ),
              TextButton.icon(
                onPressed: () => _addHabit(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add habit'),
              ),
            ],
          );
        },
      ),
    );
  }
}
