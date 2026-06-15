import 'package:flutter/material.dart';

import '../theme/cosplay_theme.dart';

class BuildJournalCard extends StatelessWidget {
  const BuildJournalCard({super.key, required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              const Icon(Icons.menu_book, color: CosplayTheme.softBlue),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Diario de creaci\u00F3n',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final entry in entries) ...[
            Row(
              children: [
                const Icon(
                  Icons.stars_rounded,
                  size: 18,
                  color: CosplayTheme.questGold,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    entry,
                    style: const TextStyle(
                      color: CosplayTheme.mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Ver diario'),
            ),
          ),
        ],
      ),
    );
  }
}
