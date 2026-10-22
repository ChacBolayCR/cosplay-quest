import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_copilot_mvp/l10n/app_localizations.dart';
import 'package:cosplay_copilot_mvp/models/cosplay_project.dart';
import 'package:cosplay_copilot_mvp/screens/create_project_screen.dart';
import 'package:cosplay_copilot_mvp/screens/project_detail_screen.dart';
import 'package:cosplay_copilot_mvp/theme/cosplay_theme.dart';

Widget app(Widget home, String locale) => MaterialApp(
  theme: CosplayTheme.dark(),
  locale: Locale(locale),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

Future<void> tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  for (final locale in ['en', 'es']) {
    testWidgets('mobile creation edits and removes draft pieces ($locale)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final es = locale == 'es';
      CosplayProject? result;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<CosplayProject>(
                    MaterialPageRoute(
                      builder: (_) => const CreateProjectScreen(),
                    ),
                  );
                },
                child: const Text('start'),
              ),
            ),
          ),
          locale,
        ),
      );
      await tap(tester, find.text('start'));
      await tester.enterText(
        find.byKey(const ValueKey('character')),
        'Example hero',
      );
      await tester.enterText(
        find.byKey(const ValueKey('franchise')),
        'Example world',
      );
      await tap(tester, find.text(es ? 'Continuar' : 'Continue'));
      await tap(tester, find.text(es ? 'Armadura' : 'Armor'));
      await tap(tester, find.text(es ? 'Continuar' : 'Continue'));
      await tap(tester, find.text(es ? 'Agregar pieza' : 'Add piece'));
      await tester.enterText(find.byKey(const ValueKey('pieceName')), 'Mask');
      await tap(tester, find.text(es ? 'Guardar' : 'Save'));
      await tap(tester, find.byTooltip(es ? 'Editar pieza' : 'Edit piece'));
      await tester.enterText(find.byKey(const ValueKey('pieceName')), 'Helmet');
      await tap(tester, find.text(es ? 'Guardar' : 'Save'));
      expect(find.text('Helmet'), findsOneWidget);
      await tap(tester, find.byTooltip(es ? 'Eliminar pieza' : 'Remove piece'));
      expect(find.text('Helmet'), findsNothing);
      await tap(tester, find.text(es ? 'Agregar pieza' : 'Add piece'));
      await tester.enterText(find.byKey(const ValueKey('pieceName')), 'Bracer');
      await tester.enterText(
        find.byType(TextFormField).last,
        'Handwoven wire and fabric',
      );
      await tap(tester, find.text(es ? 'Guardar' : 'Save'));
      await tap(tester, find.text(es ? 'Crear aventura' : 'Create Quest'));
      expect(result!.characterName, 'Example hero');
      expect(result!.franchise, 'Example world');
      expect(result!.variant, isNull);
      expect(result!.pieces.single.name, 'Bracer');
      expect(result!.pieces.single.quests, isNotEmpty);
      expect(result!.pieces.single.technique, 'Handwoven wire and fabric');
      expect(result!.progress, 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('fix quest stays on its nested piece and reopens completion', (
    tester,
  ) async {
    final child = CosplayPiece(
      id: 'child',
      name: 'Abdomen',
      categoryId: 'armor',
      acquisitionMethod: AcquisitionMethod.alreadyHave,
    );
    final parent = CosplayPiece(
      id: 'parent',
      name: 'Chest',
      categoryId: 'armor',
      acquisitionMethod: AcquisitionMethod.build,
      subpieces: [child],
    );
    final project = CosplayProject(
      name: 'Example',
      baseXp: 0,
      categories: [
        CosplayCategory(
          id: 'armor',
          kind: CategoryKind.armor,
          pieces: [parent],
        ),
      ],
    );
    await tester.pumpWidget(
      app(
        ProjectDetailScreen(
          project: project,
          onProjectChanged: () {},
          onCreateProject: () {},
        ),
        'en',
      ),
    );
    await tap(tester, find.text('Quests').last);
    await tap(tester, find.byKey(const ValueKey('piece-row-child')));
    await tap(tester, find.text('Add fix quest').first);
    await tester.enterText(find.byType(TextFormField), 'Adjust fit');
    await tap(tester, find.text('Add quest'));
    expect(child.quests.single.title, 'Adjust fit');
    expect(child.quests.single.type, MissionType.custom);
    expect(child.quests.single.xp, 10);
    expect(child.quests.single.completed, isFalse);
    expect(project.isComplete, isFalse);
    expect(project.currentXp, 0);
    await tester.pumpAndSettle(const Duration(seconds: 5));
    await tap(tester, find.byType(Checkbox).last);
    expect(project.progress, 1);
    expect(project.currentXp, 10);
    expect(tester.takeException(), isNull);
  });
}
