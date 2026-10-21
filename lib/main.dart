import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'models/cosplay_project.dart';
import 'screens/create_project_screen.dart';
import 'screens/project_detail_screen.dart';
import 'screens/projects_home_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/cosplay_theme.dart';

void main() {
  runApp(const CosplayQuestApp());
}

class CosplayQuestApp extends StatefulWidget {
  const CosplayQuestApp({super.key});

  @override
  State<CosplayQuestApp> createState() => _CosplayQuestAppState();
}

class _CosplayQuestAppState extends State<CosplayQuestApp> {
  final List<CosplayProject> _projects = [createMockProject()];

  void _addProject(CosplayProject project) {
    setState(() => _projects.add(project));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: CosplayTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          return WelcomeScreen(
            onEnter: () => _openProjectsHome(context),
            onCreateProject: () => _openCreateProject(context),
          );
        },
      ),
    );
  }

  void _openProjectsHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectsHomeScreen(
          projects: _projects,
          onCreateProject: () => _openCreateProject(context),
          onOpenProject: (project) => _openProjectDetail(context, project),
        ),
      ),
    );
  }

  Future<void> _openCreateProject(BuildContext context) async {
    final project = await Navigator.of(context).push<CosplayProject>(
      MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
    );

    if (project == null || !context.mounted) return;
    _addProject(project);
    _openProjectDetail(context, project);
  }

  Future<void> _openProjectDetail(
    BuildContext context,
    CosplayProject project,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(
          project: project,
          onProjectChanged: () => setState(() {}),
          onCreateProject: () => _openCreateProject(context),
        ),
      ),
    );
  }
}
