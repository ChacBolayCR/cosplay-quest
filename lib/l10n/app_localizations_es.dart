// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Cosplay Quest';

  @override
  String get welcomeMessage => 'Todo gran cosplay comienza con una misión.';

  @override
  String get welcomeSubtitle => 'Convierte tu cosplay en una aventura';

  @override
  String get enterButton => 'Entrar';

  @override
  String get createProject => 'Crear proyecto';

  @override
  String get createQuest => 'Crear aventura';

  @override
  String get createAdventure => 'Crear aventura';

  @override
  String get activeQuest => 'Aventura activa';

  @override
  String get continueQuest => 'Continuar misión';

  @override
  String get quests => 'Misiones';

  @override
  String get adventure => 'Aventura';

  @override
  String get adventures => 'Aventuras';

  @override
  String get references => 'Referencias';

  @override
  String get visualReferences => 'Referencias Visuales';

  @override
  String get avatar => 'Avatar';

  @override
  String get newProject => 'Nuevo proyecto';

  @override
  String get yourCosplayProjects => 'Tus proyectos cosplay';

  @override
  String daysRemaining(int days) {
    return '$days días restantes';
  }

  @override
  String daysShort(int days) {
    return '$days días';
  }

  @override
  String get emptyProjectsTitle => 'Aún no tienes aventuras activas';

  @override
  String get emptyProjectsBody => 'Crea tu primer cosplay y empieza la misión';

  @override
  String get createProjectAppBar => 'Crear proyecto';

  @override
  String get newAdventure => 'Nueva aventura';

  @override
  String get createProjectIntro =>
      'Define el cosplay, el evento y el nivel de desafío.';

  @override
  String get projectNameLabel => 'Nombre del cosplay/proyecto';

  @override
  String get projectNameError => 'Ingresa un nombre de proyecto';

  @override
  String get targetEventLabel => 'Evento objetivo';

  @override
  String get targetEventError => 'Ingresa el evento objetivo';

  @override
  String get deadlineLabel => 'Fecha límite';

  @override
  String get deadlineError => 'Selecciona una fecha límite';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get beginner => 'Principiante';

  @override
  String get intermediate => 'Intermedio';

  @override
  String get advanced => 'Avanzado';

  @override
  String get estimatedBudgetLabel => 'Presupuesto estimado';

  @override
  String get estimatedBudgetError => 'Ingresa un presupuesto estimado';

  @override
  String get validNumberError => 'Usa un número válido';

  @override
  String missionCompletedSnack(int xp) {
    return 'Misión completada +$xp XP';
  }

  @override
  String get missionAddedSnack => 'Misión agregada +10 XP';

  @override
  String get addExtraQuest => 'Agregar misión extra';

  @override
  String get customQuestXpHelp => 'Las misiones personalizadas otorgan +10 XP.';

  @override
  String get questTitleLabel => 'Título de misión';

  @override
  String get questTitleError => 'Ingresa el título de la misión';

  @override
  String get addQuest => 'Agregar misión';

  @override
  String get allBaseQuestsComplete =>
      'Todas las misiones base están completas.';

  @override
  String get gainXpSubtitle => 'Gana XP completando pasos de tu build.';

  @override
  String get avatarRankSubtitle =>
      'Tu rango crece con cada victoria de taller.';

  @override
  String get cosplayCompletedTitle => '🎉 ¡Cosplay completado!';

  @override
  String get cosplayCompletedBody => 'Tu aventura está lista para el evento.';

  @override
  String get createNewProject => 'Crear nuevo proyecto';

  @override
  String get saveHallOfFame => 'Guardar en Salón de la Fama';

  @override
  String get buildJournal => 'Build Journal';

  @override
  String get viewJournal => 'Ver diario';

  @override
  String get completed => 'Completado';

  @override
  String get pending => 'Pendiente';

  @override
  String nextQuest(String quest) {
    return 'Próxima misión: $quest';
  }

  @override
  String get avatarEvolves => 'Tu avatar evoluciona con cada misión';

  @override
  String avatarPowerState(int percent) {
    return 'Estado: $percent% de poder desbloqueado';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get closeReference => 'Cerrar referencia';

  @override
  String get createQuestFromReference => 'Crear misión desde referencia';

  @override
  String referencesMoodboard(String projectName) {
    return 'Moodboard de $projectName para formas, colores y materiales.';
  }

  @override
  String get mockReferenceLabel => 'MOCK REF';

  @override
  String get props => 'Props';

  @override
  String get armor => 'Armor';

  @override
  String get rankWorkshopLegend => 'Leyenda del Taller';

  @override
  String get rankPropsMaster => 'Maestro de Props';

  @override
  String get rankFoamForger => 'Forjador de Foam';

  @override
  String get rankWorkshopApprentice => 'Aprendiz de Taller';

  @override
  String get adventureComplete => 'Aventura completada';

  @override
  String get missionResearchReferences => 'Investigar referencias';

  @override
  String get missionBuyEvaFoam => 'Comprar EVA Foam';

  @override
  String get missionCutHelmetPieces => 'Cortar piezas del casco';

  @override
  String get missionSealSurface => 'Sellar superficie';

  @override
  String get missionPaintGoldDetails => 'Pintar detalles dorados';

  @override
  String get missionAssembleStaff => 'Ensamblar bastón';

  @override
  String get missionFinalCosplayTest => 'Prueba final del cosplay';

  @override
  String get missionTypeResearch => 'Investigación';

  @override
  String get missionTypeMaterials => 'Materiales';

  @override
  String get missionTypeCrafting => 'Construcción';

  @override
  String get missionTypePainting => 'Pintura';

  @override
  String get missionTypeAssembly => 'Ensamble';

  @override
  String get missionTypeFinalTest => 'Prueba final';

  @override
  String get missionTypeCustom => 'Personalizada';

  @override
  String get journalFirstSketch => 'Primer boceto';

  @override
  String get journalMaterialsBought => 'Materiales comprados';

  @override
  String get journalFirstPieceDone => 'Primera pieza terminada';

  @override
  String get referenceFrontViewTitle => 'Vista frontal';

  @override
  String get referenceFrontViewCategory => 'Silhouette';

  @override
  String get referenceFrontViewDescription =>
      'Proporción general del personaje, volumen de túnica, hombreras y presencia escénica.';

  @override
  String get referenceBackViewTitle => 'Vista trasera';

  @override
  String get referenceBackViewCategory => 'Back view';

  @override
  String get referenceBackViewDescription =>
      'Referencia para capas, caída de tela y lectura del personaje desde atrás.';

  @override
  String get referenceArmorDetailTitle => 'Detalle de armadura';

  @override
  String get referenceArmorDetailCategory => 'Armor';

  @override
  String get referenceArmorDetailDescription =>
      'Formas duras, bordes elevados y detalles dorados para construir piezas con foam.';

  @override
  String get referenceStaffTitle => 'Bastón / accesorio';

  @override
  String get referenceStaffCategory => 'Prop';

  @override
  String get referenceStaffDescription =>
      'Longitud, ornamentos y centro focal del accesorio principal.';

  @override
  String get referenceColorPaletteTitle => 'Paleta de colores';

  @override
  String get referenceColorPaletteCategory => 'Color';

  @override
  String get referenceColorPaletteDescription =>
      'Negros suaves, dorado envejecido, morados apagados y acentos fríos.';

  @override
  String get referenceMaterialsTitle => 'Inspiración de materiales';

  @override
  String get referenceMaterialsCategory => 'Materiales';

  @override
  String get referenceMaterialsDescription =>
      'Texturas sugeridas: EVA foam sellado, tela pesada, pintura metálica y gemas falsas.';
}
