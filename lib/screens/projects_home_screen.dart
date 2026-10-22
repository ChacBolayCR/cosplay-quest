import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../theme/cosplay_theme.dart';

class ProjectsHomeScreen extends StatelessWidget {
  const ProjectsHomeScreen({
    super.key,
    required this.projects,
    required this.onCreateProject,
    required this.onOpenProject,
  });

  final List<CosplayProject> projects;
  final VoidCallback onCreateProject;
  final ValueChanged<CosplayProject> onOpenProject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adventures),
        actions: [
          IconButton(
            tooltip: l10n.newProject,
            onPressed: onCreateProject,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: _QuestBackground(
        child: projects.isEmpty
            ? _EmptyProjectsState(onCreateProject: onCreateProject)
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
                itemCount: projects.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.yourCosplayProjects,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: onCreateProject,
                          icon: const Icon(Icons.add_rounded),
                          label: Text(l10n.newProject),
                        ),
                      ],
                    );
                  }

                  final project = projects[index - 1];
                  return _ProjectCard(
                    project: project,
                    onTap: () => onOpenProject(project),
                  );
                },
              ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final CosplayProject project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: CosplayTheme.cardInk,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: CosplayTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: CosplayTheme.cardPurple,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: CosplayTheme.border),
                  ),
                  child: const Icon(
                    Icons.shield_moon,
                    color: CosplayTheme.softBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        project.franchise.isNotEmpty
                            ? project.franchise
                            : project.eventName,
                        style: const TextStyle(
                          color: CosplayTheme.mutedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: CosplayTheme.mutedText,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: project.progress,
                minHeight: 10,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(
                  CosplayTheme.questGold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${(project.progress * 100).round()}%',
                  style: const TextStyle(
                    color: CosplayTheme.questGold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                if (project.deadline != null)
                  Text(
                    l10n.daysRemaining(project.daysRemaining),
                    style: const TextStyle(
                      color: CosplayTheme.mutedText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProjectsState extends StatelessWidget {
  const _EmptyProjectsState({required this.onCreateProject});

  final VoidCallback onCreateProject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: CosplayTheme.cardInk,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: CosplayTheme.border),
              ),
              child: const Icon(
                Icons.explore,
                size: 46,
                color: CosplayTheme.questGold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.emptyProjectsTitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyProjectsBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CosplayTheme.mutedText,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onCreateProject,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.createQuest),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestBackground extends StatelessWidget {
  const _QuestBackground({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}
