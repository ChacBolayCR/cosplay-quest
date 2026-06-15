import 'package:flutter/material.dart';

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
  String _level = 'Principiante';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Crear proyecto')),
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
                              'Nueva aventura',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Define el cosplay, el evento y el nivel de desaf\u00EDo.',
                              style: TextStyle(
                                color: CosplayTheme.mutedText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del cosplay/proyecto',
                                prefixIcon: Icon(Icons.theater_comedy),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ingresa un nombre de proyecto';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _eventController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Evento objetivo',
                                prefixIcon: Icon(Icons.event),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ingresa el evento objetivo';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _deadlineController,
                              readOnly: true,
                              onTap: _pickDeadline,
                              decoration: const InputDecoration(
                                labelText: 'Fecha l\u00EDmite',
                                prefixIcon: Icon(Icons.calendar_month),
                              ),
                              validator: (_) {
                                if (_deadline == null) {
                                  return 'Selecciona una fecha l\u00EDmite';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>(
                              value: _level,
                              decoration: const InputDecoration(
                                labelText: 'Nivel',
                                prefixIcon: Icon(Icons.trending_up),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Principiante',
                                  child: Text('Principiante'),
                                ),
                                DropdownMenuItem(
                                  value: 'Intermedio',
                                  child: Text('Intermedio'),
                                ),
                                DropdownMenuItem(
                                  value: 'Avanzado',
                                  child: Text('Avanzado'),
                                ),
                              ],
                              onChanged: (value) =>
                                  setState(() => _level = value ?? _level),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Presupuesto estimado',
                                prefixIcon: Icon(Icons.savings),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ingresa un presupuesto estimado';
                                }
                                if (double.tryParse(value.trim()) == null) {
                                  return 'Usa un n\u00FAmero v\u00E1lido';
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
                        label: const Text('Crear aventura'),
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
