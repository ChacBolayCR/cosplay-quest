import 'package:flutter_test/flutter_test.dart';

import 'package:cosplay_copilot_mvp/main.dart';

void main() {
  testWidgets('Cosplay Quest starts at welcome and opens projects', (
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
  });
}
