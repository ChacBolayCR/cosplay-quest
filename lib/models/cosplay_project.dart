import 'package:flutter/material.dart';

class CosplayProject {
  CosplayProject({
    required this.name,
    required this.eventName,
    required this.deadline,
    required this.level,
    required this.estimatedBudget,
    required this.missions,
    List<VisualReference>? references,
    this.baseXp = 1250,
    this.journalEntries = const [
      'Primer boceto',
      'Materiales comprados',
      'Primera pieza terminada',
    ],
  }) : references = references ?? createMockReferences();

  final String name;
  final String eventName;
  final DateTime deadline;
  final String level;
  final double estimatedBudget;
  final int baseXp;
  final List<CosplayMission> missions;
  final List<VisualReference> references;
  final List<String> journalEntries;

  int get completedCount =>
      missions.where((mission) => mission.completed).length;

  bool get isComplete =>
      missions.isNotEmpty && completedCount == missions.length;

  double get progress {
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
    final today = DateTime.now();
    final current = DateTime(today.year, today.month, today.day);
    final target = DateTime(deadline.year, deadline.month, deadline.day);
    return target.difference(current).inDays.clamp(0, 9999);
  }

  String get rank {
    if (progress >= 1) return 'Leyenda del Taller';
    if (progress >= 0.65) return 'Maestro de Props';
    if (progress >= 0.35) return 'Forjador de Foam';
    return 'Aprendiz de Taller';
  }

  String get nextMission {
    final pending = missions.where((mission) => !mission.completed);
    if (pending.isEmpty) return 'Aventura completada';
    return pending.first.title;
  }
}

enum MissionType {
  research(5, 'Investigacion', Icons.travel_explore),
  materials(10, 'Materiales', Icons.shopping_bag),
  crafting(20, 'Construccion', Icons.construction),
  painting(20, 'Pintura', Icons.brush),
  assembly(30, 'Ensamble', Icons.handyman),
  finalTest(40, 'Prueba final', Icons.verified),
  custom(10, 'Personalizada', Icons.add_task);

  const MissionType(this.xp, this.label, this.icon);

  final int xp;
  final String label;
  final IconData icon;
}

class CosplayMission {
  CosplayMission({
    required this.title,
    required this.type,
    IconData? icon,
    this.completed = false,
  }) : icon = icon ?? type.icon;

  final String title;
  final MissionType type;
  final IconData icon;
  bool completed;

  int get xp => type.xp;
  String get categoryLabel => type.label;
}

class VisualReference {
  const VisualReference({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<Color> colors;
}

List<CosplayMission> createMockMissions() {
  return [
    CosplayMission(title: 'Investigar referencias', type: MissionType.research),
    CosplayMission(title: 'Comprar EVA Foam', type: MissionType.materials),
    CosplayMission(
      title: 'Cortar piezas del casco',
      type: MissionType.crafting,
    ),
    CosplayMission(title: 'Sellar superficie', type: MissionType.crafting),
    CosplayMission(
      title: 'Pintar detalles dorados',
      type: MissionType.painting,
    ),
    CosplayMission(title: 'Ensamblar bast\u00F3n', type: MissionType.assembly),
    CosplayMission(
      title: 'Prueba final del cosplay',
      type: MissionType.finalTest,
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
    ),
    VisualReference(
      title: 'Vista trasera',
      category: 'Back view',
      description:
          'Referencia para capas, caida de tela y lectura del personaje desde atras.',
      icon: Icons.rotate_left,
      colors: [Color(0xFF1D2D3A), Color(0xFF3A4E68)],
    ),
    VisualReference(
      title: 'Detalle de armadura',
      category: 'Armor',
      description:
          'Formas duras, bordes elevados y detalles dorados para construir piezas con foam.',
      icon: Icons.shield_moon,
      colors: [Color(0xFF2B2836), Color(0xFF8A6E35)],
    ),
    VisualReference(
      title: 'Bast\u00F3n / accesorio',
      category: 'Prop',
      description:
          'Longitud, ornamentos y centro focal del accesorio principal.',
      icon: Icons.auto_fix_high,
      colors: [Color(0xFF30233D), Color(0xFF6D5D9B)],
    ),
    VisualReference(
      title: 'Paleta de colores',
      category: 'Color',
      description:
          'Negros suaves, dorado envejecido, morados apagados y acentos frios.',
      icon: Icons.palette,
      colors: [Color(0xFF11151E), Color(0xFFE7B84B)],
    ),
    VisualReference(
      title: 'Inspiraci\u00F3n de materiales',
      category: 'Materiales',
      description:
          'Texturas sugeridas: EVA foam sellado, tela pesada, pintura metalica y gemas falsas.',
      icon: Icons.texture,
      colors: [Color(0xFF18202C), Color(0xFF5C6C7E)],
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
    missions: missions,
  );
}
