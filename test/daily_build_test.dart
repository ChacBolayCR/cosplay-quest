import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosplay_copilot_mvp/l10n/app_localizations.dart';
import 'package:cosplay_copilot_mvp/models/cosplay_project.dart';
import 'package:cosplay_copilot_mvp/screens/piece_work_screen.dart';
import 'package:cosplay_copilot_mvp/screens/project_detail_screen.dart';
import 'package:cosplay_copilot_mvp/theme/cosplay_theme.dart';
import 'package:cosplay_copilot_mvp/widgets/hero_project_card.dart';
import 'package:cosplay_copilot_mvp/widgets/piece_work_widgets.dart';

CosplayProject dailyProject() => CosplayProject(
  name: 'Example hero',
  baseXp: 0,
  categories: [
    CosplayCategory(
      id: 'accessories',
      kind: CategoryKind.accessories,
      pieces: [
        CosplayPiece(
          id: 'belt',
          name: 'Belt',
          categoryId: 'accessories',
          acquisitionMethod: AcquisitionMethod.alreadyHave,
        ),
      ],
    ),
    CosplayCategory(
      id: 'armor',
      kind: CategoryKind.armor,
      pieces: [
        CosplayPiece(
          id: 'bracers',
          name: 'Bracers',
          categoryId: 'armor',
          acquisitionMethod: AcquisitionMethod.build,
          technique: 'EVA Foam',
          quests: [
            CosplayMission(
              title: '',
              type: MissionType.research,
              stage: QuestStage.references,
              completed: true,
            ),
            CosplayMission(
              title: '',
              type: MissionType.assembly,
              stage: QuestStage.assembly,
            ),
            CosplayMission(
              title: '',
              type: MissionType.finalTest,
              stage: QuestStage.finalTest,
            ),
          ],
        ),
        CosplayPiece(
          id: 'mask',
          name: 'Mask',
          categoryId: 'armor',
          acquisitionMethod: AcquisitionMethod.build,
          quests: [
            CosplayMission(
              title: '',
              type: MissionType.crafting,
              stage: QuestStage.build,
            ),
            CosplayMission(
              title: '',
              type: MissionType.painting,
              stage: QuestStage.finish,
            ),
          ],
        ),
      ],
    ),
    CosplayCategory(id: 'props', kind: CategoryKind.props),
  ],
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  for (final language in ['en', 'es']) {
    testWidgets(
      'daily build is direct, updates progress and remembers piece ($language)',
      (tester) async {
        tester.view.physicalSize = Size(language == 'es' ? 320 : 390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final project = dailyProject();
        final bracers = project.categories[1].pieces[0];
        final mask = project.categories[1].pieces[1];
        final es = language == 'es';
        await tester.pumpWidget(
          MaterialApp(
            theme: CosplayTheme.dark(),
            locale: Locale(language),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ProjectDetailScreen(
              project: project,
              onProjectChanged: () {},
              onCreateProject: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();
        final resume = find.byKey(const ValueKey('continue-piece'));
        expect(
          find.descendant(of: resume, matching: find.text('Bracers')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: resume,
            matching: find.text(es ? 'Continuar aventura' : 'Continue Quest'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: resume,
            matching: find.text(
              es ? 'Ensamble / Sujeción' : 'Assembly / Fastening',
            ),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(of: resume, matching: find.text('+30 XP')),
          findsOneWidget,
        );
        expect(find.byType(ExpansionTile), findsNothing);
        expect(find.byKey(const ValueKey('piece-row-mask')), findsOneWidget);
        expect(find.byKey(const ValueKey('filter-props')), findsNothing);

        // The first quest is actionable immediately after entering the project.
        final quickCheck = find.descendant(
          of: resume,
          matching: find.byType(Checkbox),
        );
        expect(tester.getRect(quickCheck).bottom, lessThan(844 - 56));
        await tester.tap(quickCheck);
        await tester.pumpAndSettle();
        expect(bracers.quests[1].completed, isTrue);
        expect(bracers.progress, closeTo(2 / 3, 0.00001));
        expect(project.progress, closeTo(5 / 9, 0.00001));
        expect(project.currentXp, 35);
        expect(
          tester.widget<HeroProjectCard>(find.byType(HeroProjectCard)).progress,
          project.progress,
        );

        // Filters are optional and do not precede piece discovery.
        await tapVisible(tester, find.byKey(const ValueKey('filter-armor')));
        expect(find.byKey(const ValueKey('piece-row-belt')), findsNothing);
        await tapVisible(tester, find.byKey(const ValueKey('piece-row-mask')));
        expect(find.byType(PieceWorkScreen), findsOneWidget);
        expect(
          find.text(es ? 'Siguiente misión' : 'Next quest'),
          findsOneWidget,
        );
        final next = find.byKey(const ValueKey('work-next-quest'));
        await tapVisible(
          tester,
          find.descendant(of: next, matching: find.byType(Checkbox)),
        );
        expect(mask.quests[0].completed, isTrue);
        expect(mask.progress, 0.5);
        expect(project.progress, closeTo(13 / 18, 0.00001));
        final progress = tester.widget<LinearProgressIndicator>(
          find.byKey(const ValueKey('work-piece-progress')),
        );
        expect(progress.value, 0.5);
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();
        expect(
          tester.widget<ContinuePieceCard>(resume).entry.piece,
          same(mask),
        );
        await tapVisible(
          tester,
          find.descendant(of: resume, matching: find.byType(Checkbox)),
        );
        expect(mask.isComplete, isTrue);
        expect(
          tester.widget<ContinuePieceCard>(resume).entry.piece,
          same(bracers),
        );
        await tapVisible(
          tester,
          find.descendant(of: resume, matching: find.byType(Checkbox)),
        );
        expect(project.progress, 1);
        expect(project.isComplete, isTrue);
        expect(resume, findsNothing);
        expect(
          find.text(es ? '🎉 ¡Cosplay completado!' : '🎉 Cosplay Complete!'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
