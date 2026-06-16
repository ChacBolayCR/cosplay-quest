import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosplay_copilot_mvp/main.dart';

void main() {
  testWidgets('Cosplay Quest opens projects and references tab', (
    tester,
  ) async {
    await tester.pumpWidget(const CosplayQuestApp());

    expect(find.text('Cosplay Quest'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('Crear proyecto'), findsOneWidget);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Tus proyectos cosplay'), findsOneWidget);
    expect(find.text('Ainz Ooal Gown'), findsOneWidget);

    await tester.tap(find.text('Ainz Ooal Gown').first);
    await tester.pumpAndSettle();

    expect(find.text('Misiones'), findsWidgets);
    expect(find.text('Referencias'), findsOneWidget);

    await tester.tap(find.text('Referencias'));
    await tester.pumpAndSettle();

    expect(find.text('Referencias Visuales'), findsOneWidget);
    expect(find.text('Vista frontal'), findsWidgets);
  });

  testWidgets('custom mission sheet adds a fixed XP pending mission', (
    tester,
  ) async {
    await tester.pumpWidget(const CosplayQuestApp());

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ainz Ooal Gown').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Misiones').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded).last);
    await tester.pumpAndSettle();

    expect(
      find.text('Las misiones personalizadas otorgan +10 XP.'),
      findsOneWidget,
    );
    await tester.enterText(
      find.byType(TextFormField),
      'Ajustar hombrera izquierda',
    );
    await tester.tap(find.text('Agregar misi\u00F3n'));
    await tester.pumpAndSettle();

    expect(find.text('Ajustar hombrera izquierda'), findsOneWidget);
    expect(find.text('Personalizada \u00B7 +10 XP'), findsOneWidget);
    expect(find.text('Pendiente'), findsWidgets);
    expect(find.text('Misi\u00F3n agregada +10 XP'), findsOneWidget);
  });
}
