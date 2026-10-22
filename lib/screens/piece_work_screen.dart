import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../widgets/mission_card.dart';
import '../widgets/piece_work_widgets.dart';

class PieceWorkScreen extends StatefulWidget {
  const PieceWorkScreen({
    super.key,
    required this.entry,
    required this.onComplete,
    required this.onAddFix,
    required this.onOpenPiece,
  });
  final BuildPieceEntry entry;
  final ValueChanged<CosplayMission> onComplete;
  final Future<void> Function(CosplayPiece) onAddFix;
  final Future<void> Function(CosplayPiece) onOpenPiece;

  @override
  State<PieceWorkScreen> createState() => _PieceWorkScreenState();
}

class _PieceWorkScreenState extends State<PieceWorkScreen> {
  void _complete(CosplayMission quest) {
    widget.onComplete(quest);
    setState(() {});
  }

  Future<void> _addFix() async {
    await widget.onAddFix(widget.entry.piece);
    if (mounted) setState(() {});
  }

  Future<void> _openChild(CosplayPiece piece) async {
    await widget.onOpenPiece(piece);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entry = widget.entry;
    final piece = entry.piece;
    final next = entry.nextQuest;
    return Scaffold(
      appBar: AppBar(title: Text(piece.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(entry.metadata(l)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        key: const ValueKey('work-piece-progress'),
                        value: piece.progress,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${(piece.progress * 100).round()}%'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  l.nextQuestHeading,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (next != null)
                  PieceNextQuest(
                    key: const ValueKey('work-next-quest'),
                    quest: next,
                    onComplete: () => _complete(next),
                  )
                else
                  Text(piece.isComplete ? l.completed : l.noPendingQuests),
                const SizedBox(height: 24),
                Text(l.quests, style: Theme.of(context).textTheme.titleLarge),
                for (final quest in piece.quests)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: MissionCard(
                      title: quest.localizedTitle(l),
                      category: quest.localizedCategoryLabel(l),
                      xp: quest.xp,
                      icon: quest.icon,
                      completed: quest.completed,
                      onComplete: () => _complete(quest),
                    ),
                  ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addFix,
                    icon: const Icon(Icons.add),
                    label: Text(l.addFixQuest),
                  ),
                ),
                if (piece.subpieces.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    l.subpiecesLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  for (final child in piece.subpieces)
                    PieceSummaryRow(
                      key: ValueKey('child-row-${child.id}'),
                      entry: BuildPieceEntry(
                        entry.category,
                        child,
                        parentName: piece.name,
                      ),
                      onTap: () => _openChild(child),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
