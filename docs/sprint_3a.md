# Sprint 3A: decomposition v1

The project retains the existing localized RPG presentation and in-memory state.
No dependencies were added. Project references, zoom, journal, custom quests,
ranks and the XP table remain available.

## Domain

- CosplayProject: characterName, franchise, optional variant, categories and
  project references. name remains for compatibility with current project cards.
- CosplayCategory: stable string id, optional built-in kind, optional customName,
  mutable list of pieces. Built-in kinds do not close the category schema.
- CosplayPiece: id, name, categoryId, acquisitionMethod, optional free-text
  technique, quests, recursive optional subpieces and a separate references list.
- AcquisitionMethod: build, buy, modify, commission, alreadyHave.
- QuestStage: high-level process labels mapped to existing MissionType values.
  There are no character conditions or tutorial instructions.
- CosplayMission retains its custom title, type, completion and existing templates.
  An optional stage supplies a localized label for piece process quests.

Build/modify receive reference, pattern, build, shape, assembly, fit, finish and
final-test stages. Buy/commission receive reference, selection, order, reception,
fit and final-test stages. Already-have pieces start complete without quests.
Fixes are ordinary pending custom quests (+10 XP) assigned to the selected piece,
including nested pieces. Adding one reopens that piece's completion.

## Progress and compatibility

Piece progress is the mean of its own quest completion values and its immediate
subpiece progress values. A piece with neither is complete only for alreadyHave.
Project progress is the mean of top-level piece progress, plus any legacy general
quest completion values. A project with no pieces keeps its earlier flat quest
calculation. XP counts completed quests once, recursively, plus existing base XP.
An already-have piece awards no automatic XP.

project.missions is now an aggregated view, not the storage list. Mutations use
piece.quests or project.addCustomMission. The old constructor's missions argument
is still supported as general project quests. The existing mock's seven quests
are grouped into one piece so its quest identities, completion and XP survive.

New creation collects identity, selected categories, and editable/removable pieces.
Piece configuration opens on its own screen. Technique suggestions are optional
and arbitrary technique text is accepted. Each selected category needs one piece.
Legacy event/date/level/budget fields remain readable in the model; new projects
do not collect budgets/events or invent a deadline. Existing dated projects still
show their date indicators.

## Before Sprint 3B

- State is in memory and resets when the app restarts.
- Subpieces and custom categories are supported by the model; the creation UI
  currently authors top-level pieces and the eight built-in categories.
- Piece references have their own list; uploads and their editing UI are deferred.
- Editing pieces is available during creation. Changing acquisition in a draft
  regenerates its suggested quests. No post-creation piece editor is introduced.
- Review stable persisted identifiers, serialization/migration of legacy quests,
  the legacy base XP field, and weighting of subpieces before persistence.
- Review whether suggested process stages should become individually configurable.
  Current stages remain high-level and use the unchanged XP type table.

## New localization keys (ES and EN)

projectIdentity, characterLabel, franchiseLabel, variantLabel, requiredField,
continueButton, backButton, breakdownTitle, chooseCategories,
categoryClothing, categoryArmor, categoryProps, categoryHead, categoryAccessories,
categoryFootwear, categoryMakeup, categoryOther,
addPiece, editPiece, removePiece, pieceName, acquisitionLabel,
acquisitionBuild, acquisitionBuy, acquisitionModify, acquisitionCommission,
acquisitionAlreadyHave, techniqueLabel, techniquePrinting, techniqueSewing,
techniqueLeather, techniqueThermoplastic, techniqueResin, techniqueMixed,
saveButton, addPiecesHelp, categoryRequired, pieceRequired,
addFixQuest, pieceLabel, generalQuests,
stageReferences, stagePattern, stageShape, stageAssembly, stageFit, stageFinish,
stageSelect, stageOrder, stageReceive, readyPiece.

Localization classes are generated from the two ARB files with Flutter gen-l10n.

## Coverage

- Scorpion, Dante and Deathmask use the same generic domain types (test fixtures).
- Recursive progress/XP, already-have pieces, fixes, legacy general quests,
  reference separation, custom categories and the unchanged XP table.
- Mobile creation in ES/EN: identity, category selection, adding/editing/removing
  pieces, free-text technique and optional variant.
- Nested-piece fix quest modal: close, pending custom state, +10 XP on completion,
  project completion, and existing reference/localization smoke tests.
