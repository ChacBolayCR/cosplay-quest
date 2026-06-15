import 'package:flutter/material.dart';

import '../theme/cosplay_theme.dart';

class MissionCard extends StatelessWidget {
  const MissionCard({
    super.key,
    required this.title,
    required this.xp,
    required this.icon,
    required this.completed,
    required this.onComplete,
  });

  final String title;
  final int xp;
  final IconData icon;
  final bool completed;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: completed
            ? CosplayTheme.questGold.withValues(alpha: 0.10)
            : CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: completed
              ? CosplayTheme.questGold.withValues(alpha: 0.48)
              : CosplayTheme.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: completed
                  ? CosplayTheme.questGold.withValues(alpha: 0.16)
                  : CosplayTheme.cardPurple,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: CosplayTheme.border),
            ),
            child: Icon(
              completed ? Icons.done_rounded : icon,
              color: completed ? CosplayTheme.questGold : CosplayTheme.softBlue,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    decoration: completed ? TextDecoration.lineThrough : null,
                    decorationColor: CosplayTheme.questGold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '+$xp XP',
                  style: const TextStyle(
                    color: CosplayTheme.questGold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: completed,
            onChanged: completed ? null : (_) => onComplete(),
          ),
        ],
      ),
    );
  }
}
