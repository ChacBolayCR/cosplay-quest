import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_copilot_mvp/models/cosplay_project.dart';
import 'package:cosplay_copilot_mvp/l10n/app_localizations_en.dart';
import 'package:cosplay_copilot_mvp/l10n/app_localizations_es.dart';

CosplayPiece piece(
  String name,
  String category,
  AcquisitionMethod method, {
  List<CosplayPiece>? children,
}) => CosplayPiece(
  id: '$category-$name',
  name: name,
  categoryId: category,
  acquisitionMethod: method,
  technique: method.allowsTechnique ? 'Unusual technique' : null,
  quests: createPieceQuests(method),
  subpieces: children,
);

CosplayCategory category(
  CategoryKind kind,
  Map<String, AcquisitionMethod> names,
) => CosplayCategory(
  id: kind.name,
  kind: kind,
  pieces: names.entries.map((e) => piece(e.key, kind.name, e.value)).toList(),
);

void main() {
  const build = AcquisitionMethod.build;
  const commission = AcquisitionMethod.commission;
  test('Scorpion, Dante and Deathmask use one generic hierarchy', () {
    final scorpion = CosplayProject(
      name: 'Scorpion',
      franchise: 'Mortal Kombat',
      variant: 'MK11',
      baseXp: 0,
      categories: [
        category(CategoryKind.clothing, {
          'Main costume': commission,
          'Hood': commission,
        }),
        category(CategoryKind.armor, {
          'Mask': build,
          'Bracers': build,
          'Shin guards': build,
        }),
        category(CategoryKind.accessories, {'Belt': build}),
        category(CategoryKind.props, {'Kunai': build}),
      ],
    );
    final dante = CosplayProject(
      name: 'Dante',
      franchise: 'Devil May Cry',
      variant: 'DMC5',
      baseXp: 0,
      categories: [
        category(CategoryKind.clothing, {
          'Coat': AcquisitionMethod.modify,
          'Shirt': AcquisitionMethod.buy,
          'Pants': AcquisitionMethod.buy,
        }),
        category(CategoryKind.footwear, {'Boots': AcquisitionMethod.modify}),
        category(CategoryKind.head, {'Wig': AcquisitionMethod.buy}),
        category(CategoryKind.props, {
          'Rebellion': build,
          'Ebony': build,
          'Ivory': build,
        }),
        category(CategoryKind.accessories, {
          'Necklace': AcquisitionMethod.alreadyHave,
        }),
      ],
    );
    final armor = category(CategoryKind.armor, {
      'Mask': build,
      'Chest Armor': build,
      'Shoulder Armor': build,
      'Bracers': build,
      'Gloves': build,
      'Leg Armor': build,
    });
    armor.pieces[1].subpieces.addAll([
      piece('Upper Chest', armor.id, build),
      piece('Abdomen', armor.id, build),
    ]);
    final deathmask = CosplayProject(
      name: 'Deathmask',
      franchise: 'Saint Seiya',
      baseXp: 0,
      categories: [
        armor,
        category(CategoryKind.clothing, {'Undersuit': commission}),
        category(CategoryKind.head, {'Wig': AcquisitionMethod.buy}),
      ],
    );
    expect(scorpion.pieces.length, 7);
    expect(dante.pieces.length, 9);
    expect(deathmask.pieces.length, 8);
    expect(deathmask.variant, isNull);
    expect(armor.pieces[1].subpieces.length, 2);
    for (final project in [scorpion, dante, deathmask]) {
      expect(project.isComplete, isFalse);
      for (final quest in project.missions) {
        quest.completed = true;
      }
      expect(project.progress, 1);
      expect(project.isComplete, isTrue);
      expect(
        project.currentXp,
        project.missions.fold<int>(0, (xp, q) => xp + q.type.xp),
      );
    }
  });

  test(
    'piece progress, fixes, references and legacy quests remain consistent',
    () {
      final built = piece('Bracer', 'armor', build);
      final owned = piece('Belt', 'armor', AcquisitionMethod.alreadyHave);
      final project = CosplayProject(
        name: 'Example',
        baseXp: 0,
        categories: [
          CosplayCategory(
            id: 'armor',
            kind: CategoryKind.armor,
            pieces: [built, owned],
          ),
        ],
      );
      expect(owned.isComplete, isTrue);
      expect(project.progress, 0.5);
      expect(project.references.length, 6);
      expect(built.references, isEmpty);
      built.references.add(project.references.first);
      expect(built.references.length, 1);
      for (final q in built.quests) {
        q.completed = true;
      }
      final xpBefore = project.currentXp;
      final fix = CosplayMission(
        title: 'Adjust bracer pattern',
        type: MissionType.custom,
      );
      project.addCustomMission(fix, piece: built);
      expect(fix.completed, isFalse);
      expect(project.isComplete, isFalse);
      expect(project.currentXp, xpBefore);
      fix.completed = true;
      expect(project.isComplete, isTrue);
      expect(project.progress, 1);
      expect(project.currentXp, xpBefore + 10);
      final legacy = CosplayProject(
        name: 'Legacy',
        missions: createMockMissions(),
      );
      final extra = CosplayMission(title: 'Extra', type: MissionType.custom);
      legacy.addCustomMission(extra);
      expect(legacy.missions.last, same(extra));
      expect(legacy.missions.length, 8);
    },
  );

  test('XP table and localized generic labels remain stable', () {
    expect(MissionType.values.map((type) => type.xp), [
      5,
      10,
      20,
      20,
      30,
      40,
      10,
    ]);
    final en = AppLocalizationsEn();
    final es = AppLocalizationsEs();
    for (final kind in CategoryKind.values) {
      expect(kind.label(en), isNotEmpty);
      expect(kind.label(es), isNotEmpty);
    }
    for (final stage in QuestStage.values) {
      expect(stage.label(en), isNotEmpty);
      expect(stage.label(es), isNotEmpty);
    }
    expect(
      CosplayCategory(id: 'custom', customName: 'Wings').label(es),
      'Wings',
    );
    expect(AcquisitionMethod.commission.label(es), 'Encargar');
  });
}
