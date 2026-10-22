import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import 'mission_card.dart';
import 'piece_work_widgets.dart';

class PieceBreakdown extends StatefulWidget {
  const PieceBreakdown({
    super.key,
    required this.project,
    required this.onComplete,
    required this.onOpenPiece,
  });
  final CosplayProject project;
  final ValueChanged<CosplayMission> onComplete;
  final ValueChanged<CosplayPiece> onOpenPiece;

  @override
  State<PieceBreakdown> createState() => _PieceBreakdownState();
}

class _PieceBreakdownState extends State<PieceBreakdown> {
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = buildPieceEntries(widget.project);
    final categories = widget.project.categories
        .where((category) => category.pieces.isNotEmpty)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (categories.length > 1) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: Text(l.allCategories),
                selected: _categoryId == null,
                onSelected: (_) => setState(() => _categoryId = null),
              ),
              for (final category in categories)
                FilterChip(
                  key: ValueKey('filter-${category.id}'),
                  label: Text(category.label(l)),
                  selected: _categoryId == category.id,
                  onSelected: (selected) => setState(
                    () => _categoryId = selected ? category.id : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        for (final entry in entries)
          if (_categoryId == null || entry.category.id == _categoryId) ...[
            PieceSummaryRow(
              key: ValueKey('piece-row-${entry.piece.id}'),
              entry: entry,
              onTap: () => widget.onOpenPiece(entry.piece),
            ),
            const Divider(height: 1),
          ],
        if (widget.project.generalMissions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.generalQuests, style: Theme.of(context).textTheme.titleMedium),
          for (final quest in widget.project.generalMissions)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: MissionCard(
                title: quest.localizedTitle(l),
                category: quest.localizedCategoryLabel(l),
                xp: quest.xp,
                icon: quest.icon,
                completed: quest.completed,
                onComplete: () => widget.onComplete(quest),
              ),
            ),
        ],
      ],
    );
  }
}
