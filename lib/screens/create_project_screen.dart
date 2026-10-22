import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import 'piece_editor_screen.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});
  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _form = GlobalKey<FormState>();
  final _character = TextEditingController();
  final _franchise = TextEditingController();
  final _variant = TextEditingController();
  final _categories = <CategoryKind, CosplayCategory>{};
  final _selected = <CategoryKind>{};
  int _step = 0;

  @override
  void dispose() {
    _character.dispose();
    _franchise.dispose();
    _variant.dispose();
    super.dispose();
  }

  Future<void> _edit(CosplayCategory category, [CosplayPiece? piece]) async {
    final result = await Navigator.of(context).push<CosplayPiece>(
      MaterialPageRoute(
        builder: (_) => PieceEditorScreen(category: category, piece: piece),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (piece == null) {
        category.pieces.add(result);
      } else {
        category.pieces[category.pieces.indexOf(piece)] = result;
      }
    });
  }

  void _next() {
    final l = AppLocalizations.of(context);
    if (_step == 0 && !_form.currentState!.validate()) return;
    if (_step == 1 && _selected.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.categoryRequired)));
      return;
    }
    if (_step < 2) {
      setState(() => _step++);
      return;
    }
    final categories = [
      for (final kind in CategoryKind.values)
        if (_selected.contains(kind)) _categories[kind]!,
    ];
    if (categories.any((category) => category.pieces.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.pieceRequired)));
      return;
    }
    Navigator.of(context).pop(
      CosplayProject(
        name: _character.text.trim(),
        characterName: _character.text.trim(),
        franchise: _franchise.text.trim(),
        variant: _variant.text.trim().isEmpty ? null : _variant.text.trim(),
        baseXp: 0,
        categories: categories,
        journalEntryKeys: const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.createProjectAppBar)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LinearProgressIndicator(value: (_step + 1) / 3),
                const SizedBox(height: 24),
                Text(
                  _step == 0
                      ? l.projectIdentity
                      : _step == 1
                      ? l.chooseCategories
                      : l.breakdownTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                if (_step == 0)
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          key: const ValueKey('character'),
                          controller: _character,
                          decoration: InputDecoration(
                            labelText: l.characterLabel,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l.requiredField
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey('franchise'),
                          controller: _franchise,
                          decoration: InputDecoration(
                            labelText: l.franchiseLabel,
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? l.requiredField
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _variant,
                          decoration: InputDecoration(
                            labelText: l.variantLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_step == 1) ...[
                  for (final kind in CategoryKind.values)
                    CheckboxListTile(
                      title: Text(kind.label(l)),
                      value: _selected.contains(kind),
                      onChanged: (value) => setState(() {
                        if (value == true) {
                          _selected.add(kind);
                          _categories.putIfAbsent(
                            kind,
                            () => CosplayCategory(id: kind.name, kind: kind),
                          );
                        } else {
                          _selected.remove(kind);
                        }
                      }),
                    ),
                ],
                if (_step == 2) ...[
                  Text(l.addPiecesHelp),
                  const SizedBox(height: 16),
                  for (final kind in CategoryKind.values)
                    if (_selected.contains(kind)) ...[
                      Text(
                        kind.label(l),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      for (final piece in _categories[kind]!.pieces)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(piece.name),
                          subtitle: Text(piece.acquisitionMethod.label(l)),
                          onTap: () => _edit(_categories[kind]!, piece),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: l.editPiece,
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () =>
                                    _edit(_categories[kind]!, piece),
                              ),
                              IconButton(
                                tooltip: l.removePiece,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => setState(
                                  () => _categories[kind]!.pieces.remove(piece),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: () => _edit(_categories[kind]!),
                          icon: const Icon(Icons.add),
                          label: Text(l.addPiece),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _next,
                  child: Text(
                    _step == 2 ? l.createAdventure : l.continueButton,
                  ),
                ),
                if (_step > 0)
                  TextButton(
                    onPressed: () => setState(() => _step--),
                    child: Text(l.backButton),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
