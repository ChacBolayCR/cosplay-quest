import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../screens/references_screen.dart';
import '../theme/cosplay_theme.dart';
import '../widgets/avatar_progress_card.dart';
import '../widgets/build_journal_card.dart';
import '../widgets/hero_project_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/piece_breakdown.dart';
import '../widgets/piece_work_widgets.dart';
import 'piece_work_screen.dart';

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
  CosplayPiece? _lastActivePiece;

  CosplayProject get project => widget.project;

  BuildPieceEntry? get _active => activeBuildPiece(project, _lastActivePiece);

  void _completeQuest(CosplayMission mission) {
    if (mission.completed) return;

    setState(() {
      mission.completed = true;
      for (final entry in buildPieceEntries(project)) {
        if (entry.piece.quests.contains(mission)) {
          _lastActivePiece = entry.piece;
        }
      }
    });
    widget.onProjectChanged();
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.missionCompletedSnack(mission.xp))),
    );
  }

  Future<void> _showAddMissionSheet([CosplayPiece? piece]) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showModalBottomSheet<(CosplayMission, CosplayPiece?)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: CosplayTheme.cardInk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => _AddMissionSheet(
        pieces: project.pieces.expand((piece) => piece.descendants).toList(),
        piece: piece,
      ),
    );

    if (!mounted || result == null) return;
    setState(() {
      project.addCustomMission(result.$1, piece: result.$2);
      if (result.$2 != null) _lastActivePiece = result.$2;
    });
    widget.onProjectChanged();
    messenger.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).missionAddedSnack)),
    );
  }

  void _continueMission() {
    final active = _active;
    if (active != null) {
      _openPiece(active.piece);
    } else {
      setState(() => _selectedTab = 1);
    }
  }

  Future<void> _openPiece(CosplayPiece piece) async {
    final entry = buildPieceEntries(
      project,
    ).firstWhere((entry) => identical(entry.piece, piece));
    setState(() => _lastActivePiece = piece);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PieceWorkScreen(
          entry: entry,
          onComplete: _completeQuest,
          onAddFix: (piece) => _showAddMissionSheet(piece),
          onOpenPiece: _openPiece,
        ),
      ),
    );
    if (mounted) setState(() {});
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
              activeEntry: _active,
              onComplete: _completeQuest,
              onContinue: _continueMission,
              onAddMission: _showAddMissionSheet,
              onCreateProject: widget.onCreateProject,
              onOpenPiece: _openPiece,
            ),
            _MissionsTab(
              project: project,
              onComplete: _completeQuest,
              onAddMission: _showAddMissionSheet,
              onOpenPiece: _openPiece,
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
  const _AddMissionSheet({required this.pieces, this.piece});
  final List<CosplayPiece> pieces;
  final CosplayPiece? piece;

  @override
  State<_AddMissionSheet> createState() => _AddMissionSheetState();
}

class _AddMissionSheetState extends State<_AddMissionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late CosplayPiece? _piece =
      widget.piece ?? (widget.pieces.isEmpty ? null : widget.pieces.first);

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop((
      CosplayMission(
        title: _titleController.text.trim(),
        type: MissionType.custom,
      ),
      _piece,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
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
              Text(
                l10n.customQuestXpHelp,
                style: TextStyle(
                  color: CosplayTheme.mutedText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              if (widget.pieces.isNotEmpty) ...[
                DropdownButtonFormField<CosplayPiece>(
                  initialValue: _piece,
                  isExpanded: true,
                  decoration: InputDecoration(labelText: l10n.pieceLabel),
                  items: [
                    for (final piece in widget.pieces)
                      DropdownMenuItem(
                        value: piece,
                        child: Text(
                          piece.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: widget.piece == null
                      ? (value) => setState(() => _piece = value)
                      : null,
                ),
                const SizedBox(height: 14),
              ],
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
      ),
    );
  }
}

class _AdventureTab extends StatelessWidget {
  const _AdventureTab({
    required this.project,
    required this.activeEntry,
    required this.onComplete,
    required this.onContinue,
    required this.onAddMission,
    required this.onCreateProject,
    required this.onOpenPiece,
  });
  final CosplayProject project;
  final BuildPieceEntry? activeEntry;
  final ValueChanged<CosplayMission> onComplete;
  final VoidCallback onContinue;
  final VoidCallback onAddMission;
  final VoidCallback onCreateProject;
  final ValueChanged<CosplayPiece> onOpenPiece;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _QuestScrollView(
      children: [
        HeroProjectCard(
          projectName: project.name,
          eventName: project.eventName,
          progress: project.progress,
          daysRemaining: project.deadline == null
              ? null
              : project.daysRemaining,
          onContinue: onContinue,
          compact: true,
          currentXp: project.currentXp,
          rank: project.localizedRank(l),
        ),
        const SizedBox(height: 16),
        if (activeEntry != null)
          ContinuePieceCard(
            key: const ValueKey('continue-piece'),
            entry: activeEntry!,
            onOpen: onContinue,
            onComplete: onComplete,
          ),
        if (project.isComplete)
          _CompletedProjectCard(
            onAddMission: onAddMission,
            onCreateProject: onCreateProject,
          ),
        const SizedBox(height: 24),
        _SectionTitle(title: l.yourBuild, icon: Icons.handyman_outlined),
        const SizedBox(height: 12),
        PieceBreakdown(
          project: project,
          onComplete: onComplete,
          onOpenPiece: onOpenPiece,
        ),
        if (project.franchise.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            [
              project.franchise,
              if (project.variant != null) project.variant!,
            ].join(' · '),
          ),
        ],
        const SizedBox(height: 24),
        BuildJournalCard(entries: project.localizedJournalEntries(l)),
      ],
    );
  }
}

class _MissionsTab extends StatelessWidget {
  const _MissionsTab({
    required this.project,
    required this.onComplete,
    required this.onAddMission,
    required this.onOpenPiece,
  });
  final CosplayProject project;
  final ValueChanged<CosplayMission> onComplete;
  final VoidCallback onAddMission;
  final ValueChanged<CosplayPiece> onOpenPiece;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _QuestScrollView(
      children: [
        _PageHeader(
          title: l.quests,
          subtitle: project.isComplete
              ? l.allBaseQuestsComplete
              : l.gainXpSubtitle,
          icon: Icons.flag,
          trailing: IconButton.filled(
            tooltip: l.addExtraQuest,
            onPressed: onAddMission,
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        const SizedBox(height: 16),
        PieceBreakdown(
          project: project,
          onComplete: onComplete,
          onOpenPiece: onOpenPiece,
        ),
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
