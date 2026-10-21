import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme/cosplay_theme.dart';

class AvatarProgressCard extends StatelessWidget {
  const AvatarProgressCard({
    super.key,
    required this.progress,
    required this.rank,
  });

  final double progress;
  final String rank;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auraSize = 86 + (progress * 34);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 116,
            height: 116,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: auraSize,
                  height: auraSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CosplayTheme.softBlue.withValues(alpha: 0.10),
                    border: Border.all(
                      color: CosplayTheme.softBlue.withValues(alpha: 0.32),
                      width: 2,
                    ),
                  ),
                ),
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [CosplayTheme.softPurple, Color(0xFF2F3545)],
                    ),
                  ),
                  child: const Icon(
                    Icons.face_retouching_natural,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: CosplayTheme.questGold,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 18,
                      color: CosplayTheme.voidBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.avatarEvolves,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.avatarPowerState((progress * 100).round()),
                  style: const TextStyle(
                    color: CosplayTheme.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: CosplayTheme.questGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: CosplayTheme.questGold.withValues(alpha: 0.32),
                    ),
                  ),
                  child: Text(
                    rank,
                    style: const TextStyle(
                      color: CosplayTheme.questGold,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
