import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/cosplay_theme.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.progress,
    required this.currentXp,
    required this.rank,
    required this.nextMission,
  });

  final double progress;
  final int currentXp;
  final String rank;
  final String nextMission;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt, color: CosplayTheme.questGold),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$currentXp XP',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: CosplayTheme.cardPurple,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: CosplayTheme.border),
                ),
                child: Text(
                  rank,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 14,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(CosplayTheme.questGold),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.flag, size: 18, color: CosplayTheme.softBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.nextQuest(nextMission),
                  style: const TextStyle(
                    color: CosplayTheme.mutedText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
