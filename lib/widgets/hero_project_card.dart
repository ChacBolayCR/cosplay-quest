import 'package:flutter/material.dart';

import '../theme/cosplay_theme.dart';

class HeroProjectCard extends StatelessWidget {
  const HeroProjectCard({
    super.key,
    required this.projectName,
    required this.eventName,
    required this.progress,
    required this.daysRemaining,
    required this.onContinue,
  });

  final String projectName;
  final String eventName;
  final double progress;
  final int daysRemaining;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF262A3A), Color(0xFF17243A), Color(0xFF11151E)],
        ),
        border: Border.all(color: CosplayTheme.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66070A10),
            blurRadius: 26,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -16,
            child: Icon(
              Icons.auto_awesome,
              size: 120,
              color: CosplayTheme.questGold.withValues(alpha: 0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: CosplayTheme.softPurple.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: CosplayTheme.border),
                ),
                child: const Text(
                  'Aventura activa',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                projectName,
                style: const TextStyle(
                  fontSize: 32,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Convierte tu cosplay en una aventura',
                style: TextStyle(
                  color: CosplayTheme.mutedText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuestPill(icon: Icons.shield_moon, label: projectName),
                  _QuestPill(icon: Icons.event, label: eventName),
                  _QuestPill(
                    icon: Icons.hourglass_top,
                    label: '$daysRemaining d\u00EDas',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 12,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation(
                          CosplayTheme.questGold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: CosplayTheme.questGold,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Continuar misi\u00F3n'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestPill extends StatelessWidget {
  const _QuestPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: CosplayTheme.softBlue),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
