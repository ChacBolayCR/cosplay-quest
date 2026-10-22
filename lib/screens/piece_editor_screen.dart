import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';

class PieceEditorScreen extends StatefulWidget {
  const PieceEditorScreen({super.key, required this.category, this.piece});
  final CosplayCategory category;
  final CosplayPiece? piece;
  @override
  State<PieceEditorScreen> createState() => _PieceEditorScreenState();
}

class _PieceEditorScreenState extends State<PieceEditorScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.piece?.name);
  late final _technique = TextEditingController(text: widget.piece?.technique);
  late AcquisitionMethod _method =
      widget.piece?.acquisitionMethod ?? AcquisitionMethod.build;

  @override
  void dispose() {
    _name.dispose();
    _technique.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final previous = widget.piece;
    Navigator.of(context).pop(
      CosplayPiece(
        id: previous?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        name: _name.text.trim(),
        categoryId: widget.category.id,
        acquisitionMethod: _method,
        technique: _method.allowsTechnique && _technique.text.trim().isNotEmpty
            ? _technique.text.trim()
            : null,
        quests: previous?.acquisitionMethod == _method
            ? previous!.quests
            : createPieceQuests(_method),
        subpieces: previous?.subpieces,
        references: previous?.references,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final suggestions = [
      'EVA Foam',
      l.techniquePrinting,
      l.techniqueSewing,
      l.techniqueLeather,
      l.techniqueThermoplastic,
      l.techniqueResin,
      l.techniqueMixed,
      l.categoryOther,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.piece == null ? l.addPiece : l.editPiece),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.category.label(l),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    key: const ValueKey('pieceName'),
                    controller: _name,
                    decoration: InputDecoration(labelText: l.pieceName),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? l.requiredField : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<AcquisitionMethod>(
                    initialValue: _method,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l.acquisitionLabel),
                    items: [
                      for (final method in AcquisitionMethod.values)
                        DropdownMenuItem(
                          value: method,
                          child: Text(method.label(l)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _method = value);
                    },
                  ),
                  if (_method.allowsTechnique) ...[
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _technique,
                      decoration: InputDecoration(labelText: l.techniqueLabel),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final suggestion in suggestions)
                          ActionChip(
                            label: Text(suggestion),
                            onPressed: () => _technique.text = suggestion,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: Text(l.saveButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
