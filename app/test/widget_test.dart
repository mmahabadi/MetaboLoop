import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:metaboloop/main.dart';

void main() {
  testWidgets('app launches on the welcome screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MetaboLoopApp()));
    await tester.pumpAndSettle();

    expect(find.text('MetaboLoop'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('goal selection continues to body stats once a goal is picked', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MetaboLoopApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text("What's your goal?"), findsOneWidget);

    // Continue is disabled until a goal is selected.
    final continueButton = find.widgetWithText(FilledButton, 'Continue');
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNull);

    await tester.tap(find.text('Lose fat'));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(continueButton).onPressed, isNotNull);

    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(find.text('Tell us about your body'), findsOneWidget);
  });
}
