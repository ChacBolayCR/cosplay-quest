import 'package:flutter/material.dart';

import '../models/cosplay_project.dart';
import '../theme/cosplay_theme.dart';
import '../widgets/avatar_progress_card.dart';
import '../widgets/build_journal_card.dart';
import '../widgets/hero_project_card.dart';
import '../widgets/mission_card.dart';
import '../widgets/progress_card.dart';

class ProjectDetailScreen extends StatefulWidget {
  const ProjectDetailScreen({
    super.key,
    required this.project,
    required this.onProjectChanged,
    required this.onCreateProject,
  });

  final CosplayProject project;
  final VoidCallback onProjectChanged;
  final VoidCallback onCreateProject;

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  int _selectedTab = 0;

  CosplayProject get project => widget.project;

  void _completeMission(int index) {
    final mission = project.missions[index];
    if (mission.completed) return;

    setState(() => mission.completed = true);
    widget.onProjectChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Misi\u00F3n completada +${mission.xp} XP')),
    );
  }

  Future<void> _showAddMissionSheet() async {
    final titleController = TextEditingController();
    final xpController = TextEditingController(text: '10');
    final formKey = GlobalKey<FormState>();

    final mission = await showModalBottomSheet<CosplayMission>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CosplayTheme.cardInk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            18,
            18,
            18,
            MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Agregar misi\u00F3n extra',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: titleController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'T\u00EDtulo de misi\u00F3n',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa el t\u00EDtulo de la misi\u00F3n';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: xpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'XP',
                    prefixIcon: Icon(Icons.bolt),
                  ),
                  validator: (value) {
                    final xp = int.tryParse(value?.trim() ?? '');
                    if (xp == null || xp <= 0) return 'Ingresa XP v\u00E1lido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.of(context).pop(
                      CosplayMission(
                        title: titleController.text.trim(),
                        xp: int.parse(xpController.text.trim()),
                        icon: Icons.add_task,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Agregar misi\u00F3n'),
                ),
              ],
            ),
          ),
        );
      },
    );

    titleController.dispose();
    xpController.dispose();

    if (mission == null) return;
    setState(() => project.missions.add(mission));
    widget.onProjectChanged();
  }

  void _continueMission() {
    setState(() => _selectedTab = 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _AdventureTab(
              project: project,
              onMissionComplete: _completeMission,
              onContinue: _continueMission,
              onAddMission: _showAddMissionSheet,
              onCreateProject: widget.onCreateProject,
            ),
            _MissionsTab(
              project: project,
              onMissionComplete: _completeMission,
              onAddMission: _showAddMissionSheet,
            ),
            _AvatarTab(project: project),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Aventura'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Misiones'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Avatar'),
        ],
      ),
    );
  }
}

class _AdventureTab extends StatelessWidget {
  const _AdventureTab({
    required this.project,
    required this.onMissionComplete,
    required this.onContinue,
    required this.onAddMission,
    required this.onCreateProject,
  });

  final CosplayProject project;
  final ValueChanged<int> onMissionComplete;
  final VoidCallback onContinue;
  final VoidCallback onAddMission;
  final VoidCallback onCreateProject;

  @override
  Widget build(BuildContext context) {
    return _QuestScrollView(
      children: [
        HeroProjectCard(
          projectName: project.name,
          eventName: project.eventName,
          progress: project.progress,
          daysRemaining: project.daysRemaining,
          onContinue: onContinue,
        ),
        const SizedBox(height: 18),
        ProgressCard(
          progress: project.progress,
          currentXp: project.currentXp,
          rank: project.rank,
          nextMission: project.nextMission,
        ),
        const SizedBox(height: 18),
        AvatarProgressCard(progress: project.progress, rank: project.rank),
        if (project.isComplete) ...[
          const SizedBox(height: 18),
          _CompletedProjectCard(
            onAddMission: onAddMission,
            onCreateProject: onCreateProject,
          ),
        ],
        const SizedBox(height: 22),
        _SectionTitle(title: 'Misiones', icon: Icons.flag_circle),
        const SizedBox(height: 12),
        for (var index = 0; index < project.missions.length; index++) ...[
          MissionCard(
            title: project.missions[index].title,
            xp: project.missions[index].xp,
            icon: project.missions[index].icon,
            completed: project.missions[index].completed,
            onComplete: () => onMissionComplete(index),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        BuildJournalCard(entries: project.journalEntries),
      ],
    );
  }
}

class _MissionsTab extends StatelessWidget {
  const _MissionsTab({
    required this.project,
    required this.onMissionComplete,
    required this.onAddMission,
  });

  final CosplayProject project;
  final ValueChanged<int> onMissionComplete;
  final VoidCallback onAddMission;

  @override
  Widget build(BuildContext context) {
    return _QuestScrollView(
      children: [
        _PageHeader(
          title: 'Misiones',
          subtitle: project.isComplete
              ? 'Todas las misiones base est\u00E1n completas.'
              : 'Gana XP completando pasos de tu build.',
          icon: Icons.flag,
          trailing: IconButton.filled(
            tooltip: 'Agregar misi\u00F3n extra',
            onPressed: onAddMission,
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < project.missions.length; index++) ...[
          MissionCard(
            title: project.missions[index].title,
            xp: project.missions[index].xp,
            icon: project.missions[index].icon,
            completed: project.missions[index].completed,
            onComplete: () => onMissionComplete(index),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AvatarTab extends StatelessWidget {
  const _AvatarTab({required this.project});

  final CosplayProject project;

  @override
  Widget build(BuildContext context) {
    return _QuestScrollView(
      children: [
        const _PageHeader(
          title: 'Avatar',
          subtitle: 'Tu rango crece con cada victoria de taller.',
          icon: Icons.face_retouching_natural,
        ),
        const SizedBox(height: 18),
        AvatarProgressCard(progress: project.progress, rank: project.rank),
        const SizedBox(height: 18),
        ProgressCard(
          progress: project.progress,
          currentXp: project.currentXp,
          rank: project.rank,
          nextMission: project.nextMission,
        ),
      ],
    );
  }
}

class _CompletedProjectCard extends StatelessWidget {
  const _CompletedProjectCard({
    required this.onAddMission,
    required this.onCreateProject,
  });

  final VoidCallback onAddMission;
  final VoidCallback onCreateProject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CosplayTheme.questGold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: CosplayTheme.questGold.withValues(alpha: 0.44),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\u{1F389} \u00A1Cosplay completado!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu aventura est\u00E1 lista para el evento.',
            style: TextStyle(
              color: CosplayTheme.mutedText,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: onAddMission,
                icon: const Icon(Icons.add_task),
                label: const Text('Agregar misi\u00F3n extra'),
              ),
              OutlinedButton.icon(
                onPressed: onCreateProject,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear nuevo proyecto'),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.emoji_events),
                label: const Text('Guardar en Sal\u00F3n de la Fama'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestScrollView extends StatelessWidget {
  const _QuestScrollView({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CosplayTheme.nightBlue, CosplayTheme.voidBlack],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: CosplayTheme.questGold),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: CosplayTheme.cardPurple,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: CosplayTheme.border),
            ),
            child: Icon(icon, color: CosplayTheme.softBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: CosplayTheme.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
