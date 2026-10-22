import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

part 'cosplay_piece.dart';

class CosplayProject {
  CosplayProject({
    required this.name,
    this.eventName = '',
    this.deadline,
    this.level = 'beginner',
    this.estimatedBudget = 0,
    List<CosplayMission>? missions,
    String? characterName,
    this.franchise = '',
    this.variant,
    this.categories = const [],
    List<VisualReference>? references,
    this.baseXp = 1250,
    this.journalEntries = const [],
    this.journalEntryKeys = const [
      JournalEntryKey.firstSketch,
      JournalEntryKey.materialsBought,
      JournalEntryKey.firstPieceDone,
    ],
  }) : characterName = characterName ?? name,
       _legacyMissions = missions ?? [],
       references = references ?? createMockReferences();

  final String name;
  final String eventName;
  final DateTime? deadline;
  final String level;
  final double estimatedBudget;
  final int baseXp;
  final String characterName;
  final String franchise;
  final String? variant;
  final List<CosplayCategory> categories;
  final List<CosplayMission> _legacyMissions;

  Iterable<CosplayPiece> get pieces => categories.expand((c) => c.pieces);
  List<CosplayMission> get generalMissions =>
      List.unmodifiable(_legacyMissions);

  // Flat missions remain readable for projects created before decomposition.
  List<CosplayMission> get missions => [
    ..._legacyMissions,
    ...pieces.expand((piece) => piece.allQuests),
  ];

  void addCustomMission(CosplayMission mission, {CosplayPiece? piece}) {
    if (piece != null) {
      piece.quests.add(mission);
    } else {
      _legacyMissions.add(mission);
    }
  }

  final List<VisualReference> references;
  final List<String> journalEntries;
  final List<JournalEntryKey> journalEntryKeys;

  int get completedCount =>
      missions.where((mission) => mission.completed).length;

  bool get isComplete => pieces.isNotEmpty
      ? pieces.every((piece) => piece.isComplete) &&
            _legacyMissions.every((mission) => mission.completed)
      : missions.isNotEmpty && completedCount == missions.length;

  double get progress {
    if (pieces.isNotEmpty) {
      final values = [
        ...pieces.map((piece) => piece.progress),
        ..._legacyMissions.map((mission) => mission.completed ? 1.0 : 0.0),
      ];
      return values.reduce((a, b) => a + b) / values.length;
    }
    if (missions.isEmpty) return 0;
    return completedCount / missions.length;
  }

  int get currentXp {
    return baseXp +
        missions
            .where((mission) => mission.completed)
            .fold(0, (sum, mission) => sum + mission.xp);
  }

  int get daysRemaining {
    final deadline = this.deadline;
    if (deadline == null) return 0;
    final today = DateTime.now();
    final current = DateTime(today.year, today.month, today.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    return target.difference(current).inDays.clamp(0, 9999);
  }

  String localizedRank(AppLocalizations l10n) {
    if (progress >= 1) return l10n.rankWorkshopLegend;
    if (progress >= 0.65) return l10n.rankPropsMaster;
    if (progress >= 0.35) return l10n.rankFoamForger;
    return l10n.rankWorkshopApprentice;
  }

  String localizedNextMission(AppLocalizations l10n) {
    final pending = missions.where((mission) => !mission.completed);
    if (pending.isEmpty) return l10n.adventureComplete;
    return pending.first.localizedTitle(l10n);
  }

  List<String> localizedJournalEntries(AppLocalizations l10n) {
    return [
      ...journalEntryKeys.map((entry) => entry.localizedLabel(l10n)),
      ...journalEntries,
    ];
  }
}

enum MissionType {
  research(5, Icons.travel_explore),
  materials(10, Icons.shopping_bag),
  crafting(20, Icons.construction),
  painting(20, Icons.brush),
  assembly(30, Icons.handyman),
  finalTest(40, Icons.verified),
  custom(10, Icons.add_task);

  const MissionType(this.xp, this.icon);

  final int xp;
  final IconData icon;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MissionType.research => l10n.missionTypeResearch,
      MissionType.materials => l10n.missionTypeMaterials,
      MissionType.crafting => l10n.missionTypeCrafting,
      MissionType.painting => l10n.missionTypePainting,
      MissionType.assembly => l10n.missionTypeAssembly,
      MissionType.finalTest => l10n.missionTypeFinalTest,
      MissionType.custom => l10n.missionTypeCustom,
    };
  }
}

class CosplayMission {
  CosplayMission({
    required this.title,
    required this.type,
    IconData? icon,
    this.template,
    this.stage,
    this.completed = false,
  }) : icon = icon ?? type.icon;

  final String title;
  final MissionType type;
  final IconData icon;
  final MissionTemplate? template;
  final QuestStage? stage;
  bool completed;

  int get xp => type.xp;
  String localizedCategoryLabel(AppLocalizations l10n) =>
      type.localizedLabel(l10n);

  String localizedTitle(AppLocalizations l10n) {
    if (stage != null) return stage!.label(l10n);
    return switch (template) {
      MissionTemplate.researchReferences => l10n.missionResearchReferences,
      MissionTemplate.buyEvaFoam => l10n.missionBuyEvaFoam,
      MissionTemplate.cutHelmetPieces => l10n.missionCutHelmetPieces,
      MissionTemplate.sealSurface => l10n.missionSealSurface,
      MissionTemplate.paintGoldDetails => l10n.missionPaintGoldDetails,
      MissionTemplate.assembleStaff => l10n.missionAssembleStaff,
      MissionTemplate.finalCosplayTest => l10n.missionFinalCosplayTest,
      null => title,
    };
  }
}

enum MissionTemplate {
  researchReferences,
  buyEvaFoam,
  cutHelmetPieces,
  sealSurface,
  paintGoldDetails,
  assembleStaff,
  finalCosplayTest,
}

enum JournalEntryKey {
  firstSketch,
  materialsBought,
  firstPieceDone;

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      JournalEntryKey.firstSketch => l10n.journalFirstSketch,
      JournalEntryKey.materialsBought => l10n.journalMaterialsBought,
      JournalEntryKey.firstPieceDone => l10n.journalFirstPieceDone,
    };
  }
}

class VisualReference {
  const VisualReference({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.colors,
    this.template,
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<Color> colors;
  final ReferenceTemplate? template;

  String localizedTitle(AppLocalizations l10n) {
    return switch (template) {
      ReferenceTemplate.frontView => l10n.referenceFrontViewTitle,
      ReferenceTemplate.backView => l10n.referenceBackViewTitle,
      ReferenceTemplate.armorDetail => l10n.referenceArmorDetailTitle,
      ReferenceTemplate.staff => l10n.referenceStaffTitle,
      ReferenceTemplate.colorPalette => l10n.referenceColorPaletteTitle,
      ReferenceTemplate.materials => l10n.referenceMaterialsTitle,
      null => title,
    };
  }

  String localizedCategory(AppLocalizations l10n) {
    return switch (template) {
      ReferenceTemplate.frontView => l10n.referenceFrontViewCategory,
      ReferenceTemplate.backView => l10n.referenceBackViewCategory,
      ReferenceTemplate.armorDetail => l10n.referenceArmorDetailCategory,
      ReferenceTemplate.staff => l10n.referenceStaffCategory,
      ReferenceTemplate.colorPalette => l10n.referenceColorPaletteCategory,
      ReferenceTemplate.materials => l10n.referenceMaterialsCategory,
      null => category,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (template) {
      ReferenceTemplate.frontView => l10n.referenceFrontViewDescription,
      ReferenceTemplate.backView => l10n.referenceBackViewDescription,
      ReferenceTemplate.armorDetail => l10n.referenceArmorDetailDescription,
      ReferenceTemplate.staff => l10n.referenceStaffDescription,
      ReferenceTemplate.colorPalette => l10n.referenceColorPaletteDescription,
      ReferenceTemplate.materials => l10n.referenceMaterialsDescription,
      null => description,
    };
  }
}

enum ReferenceTemplate {
  frontView,
  backView,
  armorDetail,
  staff,
  colorPalette,
  materials,
}

List<CosplayMission> createMockMissions() {
  return [
    CosplayMission(
      title: '',
      type: MissionType.research,
      template: MissionTemplate.researchReferences,
    ),
    CosplayMission(
      title: '',
      type: MissionType.materials,
      template: MissionTemplate.buyEvaFoam,
    ),
    CosplayMission(
      title: '',
      type: MissionType.crafting,
      template: MissionTemplate.cutHelmetPieces,
    ),
    CosplayMission(
      title: '',
      type: MissionType.crafting,
      template: MissionTemplate.sealSurface,
    ),
    CosplayMission(
      title: '',
      type: MissionType.painting,
      template: MissionTemplate.paintGoldDetails,
    ),
    CosplayMission(
      title: '',
      type: MissionType.assembly,
      template: MissionTemplate.assembleStaff,
    ),
    CosplayMission(
      title: '',
      type: MissionType.finalTest,
      template: MissionTemplate.finalCosplayTest,
    ),
  ];
}

List<VisualReference> createMockReferences() {
  return const [
    VisualReference(
      title: 'Vista frontal',
      category: 'Silhouette',
      description:
          'Proporcion general del personaje, volumen de tunica, hombreras y presencia escenica.',
      icon: Icons.accessibility_new,
      colors: [Color(0xFF243044), Color(0xFF5B4A7E)],
      template: ReferenceTemplate.frontView,
    ),
    VisualReference(
      title: 'Vista trasera',
      category: 'Back view',
      description:
          'Referencia para capas, caida de tela y lectura del personaje desde atras.',
      icon: Icons.rotate_left,
      colors: [Color(0xFF1D2D3A), Color(0xFF3A4E68)],
      template: ReferenceTemplate.backView,
    ),
    VisualReference(
      title: 'Detalle de armadura',
      category: 'Armor',
      description:
          'Formas duras, bordes elevados y detalles dorados para construir piezas con foam.',
      icon: Icons.shield_moon,
      colors: [Color(0xFF2B2836), Color(0xFF8A6E35)],
      template: ReferenceTemplate.armorDetail,
    ),
    VisualReference(
      title: 'Bast\u00F3n / accesorio',
      category: 'Prop',
      description:
          'Longitud, ornamentos y centro focal del accesorio principal.',
      icon: Icons.auto_fix_high,
      colors: [Color(0xFF30233D), Color(0xFF6D5D9B)],
      template: ReferenceTemplate.staff,
    ),
    VisualReference(
      title: 'Paleta de colores',
      category: 'Color',
      description:
          'Negros suaves, dorado envejecido, morados apagados y acentos frios.',
      icon: Icons.palette,
      colors: [Color(0xFF11151E), Color(0xFFE7B84B)],
      template: ReferenceTemplate.colorPalette,
    ),
    VisualReference(
      title: 'Inspiraci\u00F3n de materiales',
      category: 'Materiales',
      description:
          'Texturas sugeridas: EVA foam sellado, tela pesada, pintura metalica y gemas falsas.',
      icon: Icons.texture,
      colors: [Color(0xFF18202C), Color(0xFF5C6C7E)],
      template: ReferenceTemplate.materials,
    ),
  ];
}

CosplayProject createMockProject() {
  final deadline = DateTime.now().add(const Duration(days: 85));
  final missions = createMockMissions();
  for (var index = 0; index < 3; index++) {
    missions[index].completed = true;
  }

  return CosplayProject(
    name: 'Ainz Ooal Gown',
    eventName: 'Connecturday CR',
    deadline: deadline,
    level: 'Avanzado',
    estimatedBudget: 180,
    franchise: 'Overlord',
    categories: [
      CosplayCategory(
        id: 'other',
        kind: CategoryKind.other,
        pieces: [
          CosplayPiece(
            id: 'mock-main',
            name: 'Ainz Ooal Gown',
            categoryId: 'other',
            acquisitionMethod: AcquisitionMethod.build,
            quests: missions,
          ),
        ],
      ),
    ],
  );
}
