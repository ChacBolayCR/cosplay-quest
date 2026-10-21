import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosplay_copilot_mvp/main.dart';

void main() {
  testWidgets('Cosplay Quest opens projects and references tab', (
    tester,
  ) async {
    await tester.pumpWidget(const CosplayQuestApp());

    expect(find.text('Cosplay Quest'), findsOneWidget);
    expect(find.text('Enter'), findsOneWidget);
    expect(find.text('Create Quest'), findsOneWidget);

    await tester.tap(find.text('Enter'));
    await tester.pumpAndSettle();

    expect(find.text('Your cosplay projects'), findsOneWidget);
    expect(find.text('Ainz Ooal Gown'), findsOneWidget);

    await tester.tap(find.text('Ainz Ooal Gown').first);
    await tester.pumpAndSettle();

    expect(find.text('Quests'), findsWidgets);
    expect(find.text('References'), findsOneWidget);

    await tester.tap(find.text('References'));
    await tester.pumpAndSettle();

    expect(find.text('Visual References'), findsOneWidget);
    expect(find.text('Front view'), findsWidgets);
  });

  testWidgets('custom mission sheet adds a fixed XP pending mission', (
    tester,
  ) async {
    await tester.pumpWidget(const CosplayQuestApp());

    await tester.tap(find.text('Enter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ainz Ooal Gown').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quests').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded).last);
    await tester.pumpAndSettle();

    expect(find.text('Custom quests grant +10 XP.'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField),
      'Ajustar hombrera izquierda',
    );
    await tester.tap(find.text('Add quest'));
    await tester.pumpAndSettle();

    expect(find.text('Ajustar hombrera izquierda'), findsOneWidget);
    expect(find.text('Custom \u00B7 +10 XP'), findsOneWidget);
    expect(find.text('Pending'), findsWidgets);
    expect(find.text('Quest added +10 XP'), findsOneWidget);
  });

  testWidgets('app reacts to Spanish device locale', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('es')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const CosplayQuestApp());
    await tester.pump();

    expect(
      find.text('Todo gran cosplay comienza con una misi\u00F3n.'),
      findsOneWidget,
    );
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Crear aventura'), findsOneWidget);
  });
}
