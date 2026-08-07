import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metaboloop/core/database/app_database.dart';
import 'package:metaboloop/core/database/database_provider.dart';
import 'package:metaboloop/features/logging/presentation/today_screen.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<void> pumpTodayScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: TodayScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  // drift's stream cleanup schedules a timer when a watch query is
  // cancelled; disposing the widget tree ourselves (instead of leaving it
  // to the test framework's implicit end-of-test teardown) and pumping
  // once more lets that timer fire before flutter_test's "no pending
  // timers" invariant check runs.
  Future<void> disposeCleanly(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(Duration.zero);
  }

  testWidgets(
    'shows an empty state and a copy-previous-day action with no entries',
    (tester) async {
      await pumpTodayScreen(tester);

      expect(find.text('Nothing logged yet'), findsOneWidget);
      expect(find.text('Copy previous day'), findsOneWidget);

      await disposeCleanly(tester);
    },
  );

  testWidgets('renders logged entries and their combined macro totals', (
    tester,
  ) async {
    final now = DateTime.now();
    await db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: 'e1',
        loggedAt: now,
        displayName: 'Oatmeal',
        calories: 300,
        proteinGrams: 10,
        carbsGrams: 50,
        fatGrams: 5,
        quantityLabel: '1 bowl',
        method: LogMethod.manual,
      ),
    );
    await db.insertLogEntry(
      LogEntriesCompanion.insert(
        id: 'e2',
        loggedAt: now,
        displayName: 'Banana',
        calories: 100,
        proteinGrams: 1,
        carbsGrams: 25,
        fatGrams: 0,
        quantityLabel: '1 medium',
        method: LogMethod.manual,
      ),
    );

    await pumpTodayScreen(tester);

    expect(find.text('Oatmeal'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
    // Combined calories (300 + 100 = 400) shown in the summary card.
    expect(find.text('400'), findsOneWidget);
    // Combined carbs (50 + 25 = 75g) shown in the summary card.
    expect(find.text('75g'), findsOneWidget);

    await disposeCleanly(tester);
  });
}
