import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../application/cycle_providers.dart';

const _uuid = Uuid();

class CycleScreen extends ConsumerWidget {
  const CycleScreen({super.key});

  Future<void> _logPeriodStart(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date == null) return;
    await ref.read(cycleRepositoryProvider).logPeriodStart(_uuid.v4(), date);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(cycleEntriesProvider);
    final prediction = ref.watch(cyclePredictionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle tracking')),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load cycle data: $e')),
        data: (entries) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prediction',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      if (prediction.averageCycleLengthDays == null)
                        const Text(
                          'Log at least two period starts to see an average '
                          'cycle length and a predicted next date.',
                        )
                      else ...[
                        Text(
                          'Average cycle length: ${prediction.averageCycleLengthDays} days',
                        ),
                        Text(
                          'Predicted next start: ${DateFormat.yMMMd().format(prediction.predictedNextStart!)}',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('History', style: Theme.of(context).textTheme.titleMedium),
              if (entries.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No period starts logged yet.')),
                ),
              for (final entry in entries)
                Dismissible(
                  key: ValueKey(entry.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) =>
                      ref.read(cycleRepositoryProvider).deleteEntry(entry.id),
                  child: ListTile(
                    leading: const Icon(Icons.water_drop_outlined),
                    title: Text(DateFormat.yMMMd().format(entry.startDate)),
                    subtitle: entry.notes == null ? null : Text(entry.notes!),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _logPeriodStart(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Log period start'),
      ),
    );
  }
}
