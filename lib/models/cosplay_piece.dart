part of 'cosplay_project.dart';

enum CategoryKind {
  clothing,
  armor,
  props,
  head,
  accessories,
  footwear,
  makeup,
  other;

  String label(AppLocalizations l) => switch (this) {
    clothing => l.categoryClothing,
    armor => l.categoryArmor,
    props => l.categoryProps,
    head => l.categoryHead,
    accessories => l.categoryAccessories,
    footwear => l.categoryFootwear,
    makeup => l.categoryMakeup,
    other => l.categoryOther,
  };
}

class CosplayCategory {
  CosplayCategory({
    required this.id,
    this.kind,
    this.customName,
    List<CosplayPiece>? pieces,
  }) : pieces = pieces ?? [];

  final String id;
  final CategoryKind? kind;
  final String? customName;
  final List<CosplayPiece> pieces;

  String label(AppLocalizations l) =>
      customName ?? kind?.label(l) ?? l.categoryOther;
}

enum AcquisitionMethod {
  build,
  buy,
  modify,
  commission,
  alreadyHave;

  bool get allowsTechnique => this == build || this == modify;

  String label(AppLocalizations l) => switch (this) {
    build => l.acquisitionBuild,
    buy => l.acquisitionBuy,
    modify => l.acquisitionModify,
    commission => l.acquisitionCommission,
    alreadyHave => l.acquisitionAlreadyHave,
  };
}

class CosplayPiece {
  CosplayPiece({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.acquisitionMethod,
    this.technique,
    List<CosplayMission>? quests,
    List<CosplayPiece>? subpieces,
    List<VisualReference>? references,
  }) : quests = quests ?? [],
       subpieces = subpieces ?? [],
       references = references ?? [];

  final String id;
  final String name;
  final String categoryId;
  final AcquisitionMethod acquisitionMethod;
  final String? technique;
  final List<CosplayMission> quests;
  final List<CosplayPiece> subpieces;
  final List<VisualReference> references;

  Iterable<CosplayPiece> get descendants sync* {
    yield this;
    for (final child in subpieces) {
      yield* child.descendants;
    }
  }

  Iterable<CosplayMission> get allQuests sync* {
    yield* quests;
    for (final child in subpieces) {
      yield* child.allQuests;
    }
  }

  double get progress {
    final values = [
      ...quests.map((q) => q.completed ? 1.0 : 0.0),
      ...subpieces.map((p) => p.progress),
    ];
    if (values.isEmpty) {
      return acquisitionMethod == AcquisitionMethod.alreadyHave ? 1 : 0;
    }
    return values.reduce((a, b) => a + b) / values.length;
  }

  bool get isComplete => progress == 1;
}

enum QuestStage {
  references,
  pattern,
  build,
  shape,
  assembly,
  fit,
  finish,
  finalTest,
  select,
  order,
  receive;

  String label(AppLocalizations l) => switch (this) {
    references => l.stageReferences,
    pattern => l.stagePattern,
    build => l.acquisitionBuild,
    shape => l.stageShape,
    assembly => l.stageAssembly,
    fit => l.stageFit,
    finish => l.stageFinish,
    finalTest => l.missionTypeFinalTest,
    select => l.stageSelect,
    order => l.stageOrder,
    receive => l.stageReceive,
  };

  MissionType get type => switch (this) {
    references || select => MissionType.research,
    order || receive => MissionType.materials,
    pattern || build || shape => MissionType.crafting,
    assembly => MissionType.assembly,
    fit || finalTest => MissionType.finalTest,
    finish => MissionType.painting,
  };
}

List<CosplayMission> createPieceQuests(AcquisitionMethod method) {
  final stages = switch (method) {
    AcquisitionMethod.alreadyHave => <QuestStage>[],
    AcquisitionMethod.buy || AcquisitionMethod.commission => [
      QuestStage.references,
      QuestStage.select,
      QuestStage.order,
      QuestStage.receive,
      QuestStage.fit,
      QuestStage.finalTest,
    ],
    AcquisitionMethod.build || AcquisitionMethod.modify => [
      QuestStage.references,
      QuestStage.pattern,
      QuestStage.build,
      QuestStage.shape,
      QuestStage.assembly,
      QuestStage.fit,
      QuestStage.finish,
      QuestStage.finalTest,
    ],
  };
  return stages
      .map((stage) => CosplayMission(title: '', type: stage.type, stage: stage))
      .toList();
}
