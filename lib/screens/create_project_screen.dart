import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../theme/cosplay_theme.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _eventController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _budgetController = TextEditingController();

  DateTime? _deadline;
  String _level = 'beginner';

  @override
  void dispose() {
    _nameController.dispose();
    _eventController.dispose();
    _deadlineController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? now.add(const Duration(days: 60)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: CosplayTheme.questGold,
              onPrimary: CosplayTheme.voidBlack,
              surface: CosplayTheme.cardInk,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    setState(() {
      _deadline = picked;
      _deadlineController.text = '${picked.day}/${picked.month}/${picked.year}';
    });
  }

  void _createProject() {
    if (!_formKey.currentState!.validate()) return;

    final budget = double.tryParse(_budgetController.text.trim()) ?? 0;
    final project = CosplayProject(
      name: _nameController.text.trim(),
      eventName: _eventController.text.trim(),
      deadline: _deadline ?? DateTime.now().add(const Duration(days: 60)),
      level: _level,
      estimatedBudget: budget,
      baseXp: 0,
      missions: createMockMissions(),
    );

    Navigator.of(context).pop(project);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createProjectAppBar)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CosplayTheme.nightBlue, CosplayTheme.voidBlack],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: CosplayTheme.cardInk,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: CosplayTheme.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.newAdventure,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.createProjectIntro,
                              style: TextStyle(
                                color: CosplayTheme.mutedText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: l10n.projectNameLabel,
                                prefixIcon: const Icon(Icons.theater_comedy),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.projectNameError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _eventController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: l10n.targetEventLabel,
                                prefixIcon: const Icon(Icons.event),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.targetEventError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _deadlineController,
                              readOnly: true,
                              onTap: _pickDeadline,
                              decoration: InputDecoration(
                                labelText: l10n.deadlineLabel,
                                prefixIcon: const Icon(Icons.calendar_month),
                              ),
                              validator: (_) {
                                if (_deadline == null) {
                                  return l10n.deadlineError;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              initialValue: _level,
                              decoration: InputDecoration(
                                labelText: l10n.levelLabel,
                                prefixIcon: const Icon(Icons.trending_up),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'beginner',
                                  child: Text(l10n.beginner),
                                ),
                                DropdownMenuItem(
                                  value: 'intermediate',
                                  child: Text(l10n.intermediate),
                                ),
                                DropdownMenuItem(
                                  value: 'advanced',
                                  child: Text(l10n.advanced),
                                ),
                              ],
                              onChanged: (value) =>
                                  setState(() => _level = value ?? _level),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: l10n.estimatedBudgetLabel,
                                prefixIcon: const Icon(Icons.savings),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.estimatedBudgetError;
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return l10n.validNumberError;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: _createProject,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(l10n.createAdventure),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
