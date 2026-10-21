import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../screens/references_screen.dart';
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
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.missionCompletedSnack(mission.xp))),
    );
  }

  Future<void> _showAddMissionSheet() async {
    final messenger = ScaffoldMessenger.of(context);
    final mission = await showModalBottomSheet<CosplayMission>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CosplayTheme.cardInk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => const _AddMissionSheet(),
    );

    if (!mounted || mission == null) return;
    setState(() => project.missions.add(mission));
    widget.onProjectChanged();
    messenger.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).missionAddedSnack)),
    );
  }

  void _continueMission() {
    setState(() => _selectedTab = 1);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
            ReferencesScreen(project: project),
            _AvatarTab(project: project),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: l10n.adventure,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flag),
            label: l10n.quests,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo_library),
            label: l10n.references,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.avatar,
          ),
        ],
      ),
    );
  }
}

class _AddMissionSheet extends StatefulWidget {
  const _AddMissionSheet();

  @override
  State<_AddMissionSheet> createState() => _AddMissionSheetState();
}

class _AddMissionSheetState extends State<_AddMissionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      CosplayMission(
        title: _titleController.text.trim(),
        type: MissionType.custom,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        18,
        18,
        18,
        MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.addExtraQuest,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.customQuestXpHelp,
              style: TextStyle(
                color: CosplayTheme.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.questTitleLabel,
                prefixIcon: const Icon(Icons.flag),
                suffixText: '+10 XP',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.questTitleError;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.addQuest),
            ),
          ],
        ),
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
    final l10n = AppLocalizations.of(context);

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
          rank: project.localizedRank(l10n),
          nextMission: project.localizedNextMission(l10n),
        ),
        const SizedBox(height: 18),
        AvatarProgressCard(
          progress: project.progress,
          rank: project.localizedRank(l10n),
        ),
        if (project.isComplete) ...[
          const SizedBox(height: 18),
          _CompletedProjectCard(
            onAddMission: onAddMission,
            onCreateProject: onCreateProject,
          ),
        ],
        const SizedBox(height: 22),
        _SectionTitle(title: l10n.quests, icon: Icons.flag_circle),
        const SizedBox(height: 12),
        for (var index = 0; index < project.missions.length; index++) ...[
          MissionCard(
            title: project.missions[index].localizedTitle(l10n),
            category: project.missions[index].localizedCategoryLabel(l10n),
            xp: project.missions[index].xp,
            icon: project.missions[index].icon,
            completed: project.missions[index].completed,
            onComplete: () => onMissionComplete(index),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 10),
        BuildJournalCard(entries: project.localizedJournalEntries(l10n)),
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
    final l10n = AppLocalizations.of(context);

    return _QuestScrollView(
      children: [
        _PageHeader(
          title: l10n.quests,
          subtitle: project.isComplete
              ? l10n.allBaseQuestsComplete
              : l10n.gainXpSubtitle,
          icon: Icons.flag,
          trailing: IconButton.filled(
            tooltip: l10n.addExtraQuest,
            onPressed: onAddMission,
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        const SizedBox(height: 18),
        for (var index = 0; index < project.missions.length; index++) ...[
          MissionCard(
            title: project.missions[index].localizedTitle(l10n),
            category: project.missions[index].localizedCategoryLabel(l10n),
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
    final l10n = AppLocalizations.of(context);

    return _QuestScrollView(
      children: [
        _PageHeader(
          title: l10n.avatar,
          subtitle: l10n.avatarRankSubtitle,
          icon: Icons.face_retouching_natural,
        ),
        const SizedBox(height: 18),
        AvatarProgressCard(
          progress: project.progress,
          rank: project.localizedRank(l10n),
        ),
        const SizedBox(height: 18),
        ProgressCard(
          progress: project.progress,
          currentXp: project.currentXp,
          rank: project.localizedRank(l10n),
          nextMission: project.localizedNextMission(l10n),
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
    final l10n = AppLocalizations.of(context);

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
          Text(
            l10n.cosplayCompletedTitle,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cosplayCompletedBody,
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
                label: Text(l10n.addExtraQuest),
              ),
              OutlinedButton.icon(
                onPressed: onCreateProject,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.createNewProject),
              ),
              OutlinedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.emoji_events),
                label: Text(l10n.saveHallOfFame),
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
