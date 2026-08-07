import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../application/workout_providers.dart';
import '../domain/workout_type_label.dart';
import 'widgets/log_workout_sheet.dart';

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(workoutsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: workoutsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load workouts: $e')),
        data: (workouts) {
          if (workouts.isEmpty) {
            return const Center(
              child: Text('No workouts logged yet. Tap + to add one.'),
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final workout in workouts)
                Dismissible(
                  key: ValueKey(workout.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) => ref
                      .read(workoutRepositoryProvider)
                      .deleteWorkout(workout.id),
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center_outlined),
                    title: Text(workout.type.label),
                    subtitle: Text(
                      [
                        DateFormat.yMMMd().format(workout.date),
                        '${workout.durationMinutes} min',
                        if (workout.caloriesBurned != null)
                          '${workout.caloriesBurned} kcal',
                      ].join(' · '),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showLogWorkoutSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Log workout'),
      ),
    );
  }
}
