import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @resumeAdventure.
  ///
  /// In en, this message translates to:
  /// **'Continue Quest'**
  String get resumeAdventure;

  /// No description provided for @yourBuild.
  ///
  /// In en, this message translates to:
  /// **'Your Build'**
  String get yourBuild;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @nextQuestHeading.
  ///
  /// In en, this message translates to:
  /// **'Next quest'**
  String get nextQuestHeading;

  /// No description provided for @openPiece.
  ///
  /// In en, this message translates to:
  /// **'Open piece'**
  String get openPiece;

  /// No description provided for @completeQuest.
  ///
  /// In en, this message translates to:
  /// **'Complete quest'**
  String get completeQuest;

  /// No description provided for @noPendingQuests.
  ///
  /// In en, this message translates to:
  /// **'No pending quests'**
  String get noPendingQuests;

  /// No description provided for @subpiecesLabel.
  ///
  /// In en, this message translates to:
  /// **'Subpieces'**
  String get subpiecesLabel;

  /// No description provided for @projectIdentity.
  ///
  /// In en, this message translates to:
  /// **'Project identity'**
  String get projectIdentity;

  /// No description provided for @characterLabel.
  ///
  /// In en, this message translates to:
  /// **'Character'**
  String get characterLabel;

  /// No description provided for @franchiseLabel.
  ///
  /// In en, this message translates to:
  /// **'Franchise'**
  String get franchiseLabel;

  /// No description provided for @variantLabel.
  ///
  /// In en, this message translates to:
  /// **'Version / variant (optional)'**
  String get variantLabel;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @breakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Break down your cosplay'**
  String get breakdownTitle;

  /// No description provided for @chooseCategories.
  ///
  /// In en, this message translates to:
  /// **'Choose your categories'**
  String get chooseCategories;

  /// No description provided for @categoryClothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get categoryClothing;

  /// No description provided for @categoryArmor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get categoryArmor;

  /// No description provided for @categoryProps.
  ///
  /// In en, this message translates to:
  /// **'Props'**
  String get categoryProps;

  /// No description provided for @categoryHead.
  ///
  /// In en, this message translates to:
  /// **'Wig / Head'**
  String get categoryHead;

  /// No description provided for @categoryAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessories;

  /// No description provided for @categoryFootwear.
  ///
  /// In en, this message translates to:
  /// **'Footwear'**
  String get categoryFootwear;

  /// No description provided for @categoryMakeup.
  ///
  /// In en, this message translates to:
  /// **'Makeup'**
  String get categoryMakeup;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @addPiece.
  ///
  /// In en, this message translates to:
  /// **'Add piece'**
  String get addPiece;

  /// No description provided for @editPiece.
  ///
  /// In en, this message translates to:
  /// **'Edit piece'**
  String get editPiece;

  /// No description provided for @removePiece.
  ///
  /// In en, this message translates to:
  /// **'Remove piece'**
  String get removePiece;

  /// No description provided for @pieceName.
  ///
  /// In en, this message translates to:
  /// **'Piece name'**
  String get pieceName;

  /// No description provided for @acquisitionLabel.
  ///
  /// In en, this message translates to:
  /// **'How will you get it?'**
  String get acquisitionLabel;

  /// No description provided for @acquisitionBuild.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get acquisitionBuild;

  /// No description provided for @acquisitionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get acquisitionBuy;

  /// No description provided for @acquisitionModify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get acquisitionModify;

  /// No description provided for @acquisitionCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get acquisitionCommission;

  /// No description provided for @acquisitionAlreadyHave.
  ///
  /// In en, this message translates to:
  /// **'Already Have'**
  String get acquisitionAlreadyHave;

  /// No description provided for @techniqueLabel.
  ///
  /// In en, this message translates to:
  /// **'Technique / material (optional)'**
  String get techniqueLabel;

  /// No description provided for @techniquePrinting.
  ///
  /// In en, this message translates to:
  /// **'3D Printing'**
  String get techniquePrinting;

  /// No description provided for @techniqueSewing.
  ///
  /// In en, this message translates to:
  /// **'Sewing'**
  String get techniqueSewing;

  /// No description provided for @techniqueLeather.
  ///
  /// In en, this message translates to:
  /// **'Leather'**
  String get techniqueLeather;

  /// No description provided for @techniqueThermoplastic.
  ///
  /// In en, this message translates to:
  /// **'Thermoplastic'**
  String get techniqueThermoplastic;

  /// No description provided for @techniqueResin.
  ///
  /// In en, this message translates to:
  /// **'Resin'**
  String get techniqueResin;

  /// No description provided for @techniqueMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed Technique'**
  String get techniqueMixed;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @addPiecesHelp.
  ///
  /// In en, this message translates to:
  /// **'Add at least one piece in each selected category.'**
  String get addPiecesHelp;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Select at least one category'**
  String get categoryRequired;

  /// No description provided for @pieceRequired.
  ///
  /// In en, this message translates to:
  /// **'Add a piece in each category to continue'**
  String get pieceRequired;

  /// No description provided for @addFixQuest.
  ///
  /// In en, this message translates to:
  /// **'Add fix quest'**
  String get addFixQuest;

  /// No description provided for @pieceLabel.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get pieceLabel;

  /// No description provided for @generalQuests.
  ///
  /// In en, this message translates to:
  /// **'Project quests'**
  String get generalQuests;

  /// No description provided for @stageReferences.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get stageReferences;

  /// No description provided for @stagePattern.
  ///
  /// In en, this message translates to:
  /// **'Pattern / Measurements'**
  String get stagePattern;

  /// No description provided for @stageShape.
  ///
  /// In en, this message translates to:
  /// **'Shape / Form'**
  String get stageShape;

  /// No description provided for @stageAssembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly / Fastening'**
  String get stageAssembly;

  /// No description provided for @stageFit.
  ///
  /// In en, this message translates to:
  /// **'Fit Test'**
  String get stageFit;

  /// No description provided for @stageFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish / Paint'**
  String get stageFinish;

  /// No description provided for @stageSelect.
  ///
  /// In en, this message translates to:
  /// **'Select / Agree specifications'**
  String get stageSelect;

  /// No description provided for @stageOrder.
  ///
  /// In en, this message translates to:
  /// **'Order / Commission'**
  String get stageOrder;

  /// No description provided for @stageReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive / Inspect'**
  String get stageReceive;

  /// No description provided for @readyPiece.
  ///
  /// In en, this message translates to:
  /// **'Ready for the adventure'**
  String get readyPiece;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Cosplay Quest'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Every great cosplay begins with a quest.'**
  String get welcomeMessage;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn your cosplay into an adventure'**
  String get welcomeSubtitle;

  /// No description provided for @enterButton.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enterButton;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @createQuest.
  ///
  /// In en, this message translates to:
  /// **'Create Quest'**
  String get createQuest;

  /// No description provided for @createAdventure.
  ///
  /// In en, this message translates to:
  /// **'Create Quest'**
  String get createAdventure;

  /// No description provided for @activeQuest.
  ///
  /// In en, this message translates to:
  /// **'Active Quest'**
  String get activeQuest;

  /// No description provided for @continueQuest.
  ///
  /// In en, this message translates to:
  /// **'Continue Quest'**
  String get continueQuest;

  /// No description provided for @quests.
  ///
  /// In en, this message translates to:
  /// **'Quests'**
  String get quests;

  /// No description provided for @adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// No description provided for @adventures.
  ///
  /// In en, this message translates to:
  /// **'Adventures'**
  String get adventures;

  /// No description provided for @references.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get references;

  /// No description provided for @visualReferences.
  ///
  /// In en, this message translates to:
  /// **'Visual References'**
  String get visualReferences;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @yourCosplayProjects.
  ///
  /// In en, this message translates to:
  /// **'Your cosplay projects'**
  String get yourCosplayProjects;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String daysRemaining(int days);

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String daysShort(int days);

  /// No description provided for @emptyProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'You have no active quests yet'**
  String get emptyProjectsTitle;

  /// No description provided for @emptyProjectsBody.
  ///
  /// In en, this message translates to:
  /// **'Create your first cosplay and begin the quest'**
  String get emptyProjectsBody;

  /// No description provided for @createProjectAppBar.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProjectAppBar;

  /// No description provided for @newAdventure.
  ///
  /// In en, this message translates to:
  /// **'New Quest'**
  String get newAdventure;

  /// No description provided for @createProjectIntro.
  ///
  /// In en, this message translates to:
  /// **'Define the cosplay, event, and challenge level.'**
  String get createProjectIntro;

  /// No description provided for @projectNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Cosplay/project name'**
  String get projectNameLabel;

  /// No description provided for @projectNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter a project name'**
  String get projectNameError;

  /// No description provided for @targetEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Target event'**
  String get targetEventLabel;

  /// No description provided for @targetEventError.
  ///
  /// In en, this message translates to:
  /// **'Enter the target event'**
  String get targetEventError;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineLabel;

  /// No description provided for @deadlineError.
  ///
  /// In en, this message translates to:
  /// **'Select a deadline'**
  String get deadlineError;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @estimatedBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated budget'**
  String get estimatedBudgetLabel;

  /// No description provided for @estimatedBudgetError.
  ///
  /// In en, this message translates to:
  /// **'Enter an estimated budget'**
  String get estimatedBudgetError;

  /// No description provided for @validNumberError.
  ///
  /// In en, this message translates to:
  /// **'Use a valid number'**
  String get validNumberError;

  /// No description provided for @missionCompletedSnack.
  ///
  /// In en, this message translates to:
  /// **'Quest completed +{xp} XP'**
  String missionCompletedSnack(int xp);

  /// No description provided for @missionAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Quest added +10 XP'**
  String get missionAddedSnack;

  /// No description provided for @addExtraQuest.
  ///
  /// In en, this message translates to:
  /// **'Add extra quest'**
  String get addExtraQuest;

  /// No description provided for @customQuestXpHelp.
  ///
  /// In en, this message translates to:
  /// **'Custom quests grant +10 XP.'**
  String get customQuestXpHelp;

  /// No description provided for @questTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Quest title'**
  String get questTitleLabel;

  /// No description provided for @questTitleError.
  ///
  /// In en, this message translates to:
  /// **'Enter the quest title'**
  String get questTitleError;

  /// No description provided for @addQuest.
  ///
  /// In en, this message translates to:
  /// **'Add quest'**
  String get addQuest;

  /// No description provided for @allBaseQuestsComplete.
  ///
  /// In en, this message translates to:
  /// **'All base quests are complete.'**
  String get allBaseQuestsComplete;

  /// No description provided for @gainXpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Gain XP by completing steps in your build.'**
  String get gainXpSubtitle;

  /// No description provided for @avatarRankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your rank grows with every workshop victory.'**
  String get avatarRankSubtitle;

  /// No description provided for @cosplayCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 Cosplay Complete!'**
  String get cosplayCompletedTitle;

  /// No description provided for @cosplayCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Your quest is ready for the event.'**
  String get cosplayCompletedBody;

  /// No description provided for @createNewProject.
  ///
  /// In en, this message translates to:
  /// **'Create new project'**
  String get createNewProject;

  /// No description provided for @saveHallOfFame.
  ///
  /// In en, this message translates to:
  /// **'Save to Hall of Fame'**
  String get saveHallOfFame;

  /// No description provided for @buildJournal.
  ///
  /// In en, this message translates to:
  /// **'Build Journal'**
  String get buildJournal;

  /// No description provided for @viewJournal.
  ///
  /// In en, this message translates to:
  /// **'View journal'**
  String get viewJournal;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @nextQuest.
  ///
  /// In en, this message translates to:
  /// **'Next quest: {quest}'**
  String nextQuest(String quest);

  /// No description provided for @avatarEvolves.
  ///
  /// In en, this message translates to:
  /// **'Your avatar evolves with every quest'**
  String get avatarEvolves;

  /// No description provided for @avatarPowerState.
  ///
  /// In en, this message translates to:
  /// **'Status: {percent}% power unlocked'**
  String avatarPowerState(int percent);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @closeReference.
  ///
  /// In en, this message translates to:
  /// **'Close reference'**
  String get closeReference;

  /// No description provided for @createQuestFromReference.
  ///
  /// In en, this message translates to:
  /// **'Create quest from reference'**
  String get createQuestFromReference;

  /// No description provided for @referencesMoodboard.
  ///
  /// In en, this message translates to:
  /// **'{projectName} moodboard for shapes, colors, and materials.'**
  String referencesMoodboard(String projectName);

  /// No description provided for @mockReferenceLabel.
  ///
  /// In en, this message translates to:
  /// **'MOCK REF'**
  String get mockReferenceLabel;

  /// No description provided for @props.
  ///
  /// In en, this message translates to:
  /// **'Props'**
  String get props;

  /// No description provided for @armor.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get armor;

  /// No description provided for @rankWorkshopLegend.
  ///
  /// In en, this message translates to:
  /// **'Workshop Legend'**
  String get rankWorkshopLegend;

  /// No description provided for @rankPropsMaster.
  ///
  /// In en, this message translates to:
  /// **'Props Master'**
  String get rankPropsMaster;

  /// No description provided for @rankFoamForger.
  ///
  /// In en, this message translates to:
  /// **'Foam Forger'**
  String get rankFoamForger;

  /// No description provided for @rankWorkshopApprentice.
  ///
  /// In en, this message translates to:
  /// **'Workshop Apprentice'**
  String get rankWorkshopApprentice;

  /// No description provided for @adventureComplete.
  ///
  /// In en, this message translates to:
  /// **'Quest complete'**
  String get adventureComplete;

  /// No description provided for @missionResearchReferences.
  ///
  /// In en, this message translates to:
  /// **'Research references'**
  String get missionResearchReferences;

  /// No description provided for @missionBuyEvaFoam.
  ///
  /// In en, this message translates to:
  /// **'Buy EVA Foam'**
  String get missionBuyEvaFoam;

  /// No description provided for @missionCutHelmetPieces.
  ///
  /// In en, this message translates to:
  /// **'Cut helmet pieces'**
  String get missionCutHelmetPieces;

  /// No description provided for @missionSealSurface.
  ///
  /// In en, this message translates to:
  /// **'Seal surface'**
  String get missionSealSurface;

  /// No description provided for @missionPaintGoldDetails.
  ///
  /// In en, this message translates to:
  /// **'Paint gold details'**
  String get missionPaintGoldDetails;

  /// No description provided for @missionAssembleStaff.
  ///
  /// In en, this message translates to:
  /// **'Assemble staff'**
  String get missionAssembleStaff;

  /// No description provided for @missionFinalCosplayTest.
  ///
  /// In en, this message translates to:
  /// **'Final cosplay test'**
  String get missionFinalCosplayTest;

  /// No description provided for @missionTypeResearch.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get missionTypeResearch;

  /// No description provided for @missionTypeMaterials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get missionTypeMaterials;

  /// No description provided for @missionTypeCrafting.
  ///
  /// In en, this message translates to:
  /// **'Construction'**
  String get missionTypeCrafting;

  /// No description provided for @missionTypePainting.
  ///
  /// In en, this message translates to:
  /// **'Painting'**
  String get missionTypePainting;

  /// No description provided for @missionTypeAssembly.
  ///
  /// In en, this message translates to:
  /// **'Assembly'**
  String get missionTypeAssembly;

  /// No description provided for @missionTypeFinalTest.
  ///
  /// In en, this message translates to:
  /// **'Final test'**
  String get missionTypeFinalTest;

  /// No description provided for @missionTypeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get missionTypeCustom;

  /// No description provided for @journalFirstSketch.
  ///
  /// In en, this message translates to:
  /// **'First sketch'**
  String get journalFirstSketch;

  /// No description provided for @journalMaterialsBought.
  ///
  /// In en, this message translates to:
  /// **'Materials bought'**
  String get journalMaterialsBought;

  /// No description provided for @journalFirstPieceDone.
  ///
  /// In en, this message translates to:
  /// **'First finished piece'**
  String get journalFirstPieceDone;

  /// No description provided for @referenceFrontViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Front view'**
  String get referenceFrontViewTitle;

  /// No description provided for @referenceFrontViewCategory.
  ///
  /// In en, this message translates to:
  /// **'Silhouette'**
  String get referenceFrontViewCategory;

  /// No description provided for @referenceFrontViewDescription.
  ///
  /// In en, this message translates to:
  /// **'Overall character proportions, robe volume, shoulder armor, and stage presence.'**
  String get referenceFrontViewDescription;

  /// No description provided for @referenceBackViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Back view'**
  String get referenceBackViewTitle;

  /// No description provided for @referenceBackViewCategory.
  ///
  /// In en, this message translates to:
  /// **'Back view'**
  String get referenceBackViewCategory;

  /// No description provided for @referenceBackViewDescription.
  ///
  /// In en, this message translates to:
  /// **'Reference for capes, fabric fall, and character readability from behind.'**
  String get referenceBackViewDescription;

  /// No description provided for @referenceArmorDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Armor detail'**
  String get referenceArmorDetailTitle;

  /// No description provided for @referenceArmorDetailCategory.
  ///
  /// In en, this message translates to:
  /// **'Armor'**
  String get referenceArmorDetailCategory;

  /// No description provided for @referenceArmorDetailDescription.
  ///
  /// In en, this message translates to:
  /// **'Hard shapes, raised edges, and gold details for building foam pieces.'**
  String get referenceArmorDetailDescription;

  /// No description provided for @referenceStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff / accessory'**
  String get referenceStaffTitle;

  /// No description provided for @referenceStaffCategory.
  ///
  /// In en, this message translates to:
  /// **'Prop'**
  String get referenceStaffCategory;

  /// No description provided for @referenceStaffDescription.
  ///
  /// In en, this message translates to:
  /// **'Length, ornaments, and focal center of the main accessory.'**
  String get referenceStaffDescription;

  /// No description provided for @referenceColorPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Color palette'**
  String get referenceColorPaletteTitle;

  /// No description provided for @referenceColorPaletteCategory.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get referenceColorPaletteCategory;

  /// No description provided for @referenceColorPaletteDescription.
  ///
  /// In en, this message translates to:
  /// **'Soft blacks, aged gold, muted purples, and cool accents.'**
  String get referenceColorPaletteDescription;

  /// No description provided for @referenceMaterialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Material inspiration'**
  String get referenceMaterialsTitle;

  /// No description provided for @referenceMaterialsCategory.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get referenceMaterialsCategory;

  /// No description provided for @referenceMaterialsDescription.
  ///
  /// In en, this message translates to:
  /// **'Suggested textures: sealed EVA foam, heavy fabric, metallic paint, and faux gems.'**
  String get referenceMaterialsDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
