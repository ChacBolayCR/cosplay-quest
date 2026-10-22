import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../theme/cosplay_theme.dart';

// Presentation entries flatten the hierarchy without changing its ownership.
class BuildPieceEntry {
  const BuildPieceEntry(this.category, this.piece, {this.parentName});
  final CosplayCategory category;
  final CosplayPiece piece;
  final String? parentName;

  CosplayMission? get nextQuest {
    for (final quest in piece.quests) {
      if (!quest.completed) return quest;
    }
    return null;
  }

  String metadata(AppLocalizations l) => [
    category.label(l),
    if (piece.technique?.isNotEmpty ?? false) piece.technique!,
    if (parentName != null) parentName!,
  ].join(' · ');
}

List<BuildPieceEntry> buildPieceEntries(CosplayProject project) {
  Iterable<BuildPieceEntry> visit(
    CosplayCategory category,
    CosplayPiece piece, [
    String? parent,
  ]) sync* {
    yield BuildPieceEntry(category, piece, parentName: parent);
    for (final child in piece.subpieces) {
      yield* visit(category, child, piece.name);
    }
  }

  return [
    for (final category in project.categories)
      for (final piece in category.pieces) ...visit(category, piece),
  ];
}

BuildPieceEntry? activeBuildPiece(
  CosplayProject project,
  CosplayPiece? lastActive,
) {
  final incomplete = buildPieceEntries(
    project,
  ).where((entry) => !entry.piece.isComplete).toList();
  for (final entry in incomplete) {
    if (identical(entry.piece, lastActive) && entry.nextQuest != null) {
      return entry;
    }
  }
  for (final entry in incomplete) {
    if (entry.nextQuest != null) return entry;
  }
  return incomplete.isEmpty ? null : incomplete.first;
}

class PieceSummaryRow extends StatelessWidget {
  const PieceSummaryRow({super.key, required this.entry, required this.onTap});
  final BuildPieceEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final piece = entry.piece;
    final next = entry.nextQuest;
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      piece.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(piece.progress * 100).round()}%',
                    style: const TextStyle(
                      color: CosplayTheme.questGold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 20),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                entry.metadata(l),
                style: const TextStyle(
                  color: CosplayTheme.mutedText,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: piece.progress,
                minHeight: 3,
                color: CosplayTheme.questGold,
              ),
              const SizedBox(height: 8),
              Text(
                piece.isComplete
                    ? l.completed
                    : next == null
                    ? l.noPendingQuests
                    : l.nextQuest(next.localizedTitle(l)),
                style: const TextStyle(fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PieceNextQuest extends StatelessWidget {
  const PieceNextQuest({
    super.key,
    required this.quest,
    required this.onComplete,
  });
  final CosplayMission quest;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quest.localizedTitle(l),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '+${quest.xp} XP',
                style: const TextStyle(
                  color: CosplayTheme.questGold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Tooltip(
          message: l.completeQuest,
          child: Checkbox(
            value: quest.completed,
            onChanged: quest.completed ? null : (_) => onComplete(),
          ),
        ),
      ],
    );
  }
}

class ContinuePieceCard extends StatelessWidget {
  const ContinuePieceCard({
    super.key,
    required this.entry,
    required this.onOpen,
    required this.onComplete,
  });
  final BuildPieceEntry entry;
  final VoidCallback onOpen;
  final ValueChanged<CosplayMission> onComplete;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final next = entry.nextQuest;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CosplayTheme.softBlue.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.resumeAdventure,
            style: const TextStyle(
              color: CosplayTheme.softBlue,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  entry.piece.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: l.openPiece,
                onPressed: onOpen,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          Text(
            entry.metadata(l),
            style: const TextStyle(color: CosplayTheme.mutedText, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: entry.piece.progress,
                  minHeight: 5,
                  color: CosplayTheme.questGold,
                ),
              ),
              const SizedBox(width: 12),
              Text('${(entry.piece.progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 12),
          if (next != null)
            PieceNextQuest(quest: next, onComplete: () => onComplete(next))
          else
            Text(l.noPendingQuests),
        ],
      ),
    );
  }
}
