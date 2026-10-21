// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cosplay Quest';

  @override
  String get welcomeMessage => 'Every great cosplay begins with a quest.';

  @override
  String get welcomeSubtitle => 'Turn your cosplay into an adventure';

  @override
  String get enterButton => 'Enter';

  @override
  String get createProject => 'Create Project';

  @override
  String get createQuest => 'Create Quest';

  @override
  String get createAdventure => 'Create Quest';

  @override
  String get activeQuest => 'Active Quest';

  @override
  String get continueQuest => 'Continue Quest';

  @override
  String get quests => 'Quests';

  @override
  String get adventure => 'Adventure';

  @override
  String get adventures => 'Adventures';

  @override
  String get references => 'References';

  @override
  String get visualReferences => 'Visual References';

  @override
  String get avatar => 'Avatar';

  @override
  String get newProject => 'New Project';

  @override
  String get yourCosplayProjects => 'Your cosplay projects';

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String daysShort(int days) {
    return '$days days';
  }

  @override
  String get emptyProjectsTitle => 'You have no active quests yet';

  @override
  String get emptyProjectsBody =>
      'Create your first cosplay and begin the quest';

  @override
  String get createProjectAppBar => 'Create Project';

  @override
  String get newAdventure => 'New Quest';

  @override
  String get createProjectIntro =>
      'Define the cosplay, event, and challenge level.';

  @override
  String get projectNameLabel => 'Cosplay/project name';

  @override
  String get projectNameError => 'Enter a project name';

  @override
  String get targetEventLabel => 'Target event';

  @override
  String get targetEventError => 'Enter the target event';

  @override
  String get deadlineLabel => 'Deadline';

  @override
  String get deadlineError => 'Select a deadline';

  @override
  String get levelLabel => 'Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get estimatedBudgetLabel => 'Estimated budget';

  @override
  String get estimatedBudgetError => 'Enter an estimated budget';

  @override
  String get validNumberError => 'Use a valid number';

  @override
  String missionCompletedSnack(int xp) {
    return 'Quest completed +$xp XP';
  }

  @override
  String get missionAddedSnack => 'Quest added +10 XP';

  @override
  String get addExtraQuest => 'Add extra quest';

  @override
  String get customQuestXpHelp => 'Custom quests grant +10 XP.';

  @override
  String get questTitleLabel => 'Quest title';

  @override
  String get questTitleError => 'Enter the quest title';

  @override
  String get addQuest => 'Add quest';

  @override
  String get allBaseQuestsComplete => 'All base quests are complete.';

  @override
  String get gainXpSubtitle => 'Gain XP by completing steps in your build.';

  @override
  String get avatarRankSubtitle =>
      'Your rank grows with every workshop victory.';

  @override
  String get cosplayCompletedTitle => '🎉 Cosplay Complete!';

  @override
  String get cosplayCompletedBody => 'Your quest is ready for the event.';

  @override
  String get createNewProject => 'Create new project';

  @override
  String get saveHallOfFame => 'Save to Hall of Fame';

  @override
  String get buildJournal => 'Build Journal';

  @override
  String get viewJournal => 'View journal';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String nextQuest(String quest) {
    return 'Next quest: $quest';
  }

  @override
  String get avatarEvolves => 'Your avatar evolves with every quest';

  @override
  String avatarPowerState(int percent) {
    return 'Status: $percent% power unlocked';
  }

  @override
  String get close => 'Close';

  @override
  String get closeReference => 'Close reference';

  @override
  String get createQuestFromReference => 'Create quest from reference';

  @override
  String referencesMoodboard(String projectName) {
    return '$projectName moodboard for shapes, colors, and materials.';
  }

  @override
  String get mockReferenceLabel => 'MOCK REF';

  @override
  String get props => 'Props';

  @override
  String get armor => 'Armor';

  @override
  String get rankWorkshopLegend => 'Workshop Legend';

  @override
  String get rankPropsMaster => 'Props Master';

  @override
  String get rankFoamForger => 'Foam Forger';

  @override
  String get rankWorkshopApprentice => 'Workshop Apprentice';

  @override
  String get adventureComplete => 'Quest complete';

  @override
  String get missionResearchReferences => 'Research references';

  @override
  String get missionBuyEvaFoam => 'Buy EVA Foam';

  @override
  String get missionCutHelmetPieces => 'Cut helmet pieces';

  @override
  String get missionSealSurface => 'Seal surface';

  @override
  String get missionPaintGoldDetails => 'Paint gold details';

  @override
  String get missionAssembleStaff => 'Assemble staff';

  @override
  String get missionFinalCosplayTest => 'Final cosplay test';

  @override
  String get missionTypeResearch => 'Research';

  @override
  String get missionTypeMaterials => 'Materials';

  @override
  String get missionTypeCrafting => 'Construction';

  @override
  String get missionTypePainting => 'Painting';

  @override
  String get missionTypeAssembly => 'Assembly';

  @override
  String get missionTypeFinalTest => 'Final test';

  @override
  String get missionTypeCustom => 'Custom';

  @override
  String get journalFirstSketch => 'First sketch';

  @override
  String get journalMaterialsBought => 'Materials bought';

  @override
  String get journalFirstPieceDone => 'First finished piece';

  @override
  String get referenceFrontViewTitle => 'Front view';

  @override
  String get referenceFrontViewCategory => 'Silhouette';

  @override
  String get referenceFrontViewDescription =>
      'Overall character proportions, robe volume, shoulder armor, and stage presence.';

  @override
  String get referenceBackViewTitle => 'Back view';

  @override
  String get referenceBackViewCategory => 'Back view';

  @override
  String get referenceBackViewDescription =>
      'Reference for capes, fabric fall, and character readability from behind.';

  @override
  String get referenceArmorDetailTitle => 'Armor detail';

  @override
  String get referenceArmorDetailCategory => 'Armor';

  @override
  String get referenceArmorDetailDescription =>
      'Hard shapes, raised edges, and gold details for building foam pieces.';

  @override
  String get referenceStaffTitle => 'Staff / accessory';

  @override
  String get referenceStaffCategory => 'Prop';

  @override
  String get referenceStaffDescription =>
      'Length, ornaments, and focal center of the main accessory.';

  @override
  String get referenceColorPaletteTitle => 'Color palette';

  @override
  String get referenceColorPaletteCategory => 'Color';

  @override
  String get referenceColorPaletteDescription =>
      'Soft blacks, aged gold, muted purples, and cool accents.';

  @override
  String get referenceMaterialsTitle => 'Material inspiration';

  @override
  String get referenceMaterialsCategory => 'Materials';

  @override
  String get referenceMaterialsDescription =>
      'Suggested textures: sealed EVA foam, heavy fabric, metallic paint, and faux gems.';
}
