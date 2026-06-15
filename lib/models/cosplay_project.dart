import 'package:flutter/material.dart';

class CosplayProject {
  CosplayProject({
    required this.name,
    required this.eventName,
    required this.deadline,
    required this.level,
    required this.estimatedBudget,
    required this.missions,
    this.baseXp = 1250,
    this.journalEntries = const [
      'Primer boceto',
      'Materiales comprados',
      'Primera pieza terminada',
    ],
  });

  final String name;
  final String eventName;
  final DateTime deadline;
  final String level;
  final double estimatedBudget;
  final int baseXp;
  final List<CosplayMission> missions;
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

class CosplayMission {
  CosplayMission({
    required this.title,
    required this.xp,
    required this.icon,
    this.completed = false,
  });

  final String title;
  final int xp;
  final IconData icon;
  bool completed;
}

List<CosplayMission> createMockMissions() {
  return [
    CosplayMission(title: 'Comprar EVA Foam', xp: 10, icon: Icons.shopping_bag),
    CosplayMission(
      title: 'Cortar piezas del casco',
      xp: 20,
      icon: Icons.content_cut,
    ),
    CosplayMission(title: 'Sellar superficie', xp: 15, icon: Icons.water_drop),
    CosplayMission(title: 'Pintar detalles dorados', xp: 25, icon: Icons.brush),
    CosplayMission(
      title: 'Terminar bast\u00F3n',
      xp: 50,
      icon: Icons.auto_fix_high,
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
