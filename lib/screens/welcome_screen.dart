import 'package:flutter/material.dart';

import '../theme/cosplay_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onEnter,
    required this.onCreateProject,
  });

  final VoidCallback onEnter;
  final VoidCallback onCreateProject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [CosplayTheme.nightBlue, CosplayTheme.voidBlack],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      height: 310,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: CosplayTheme.border),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2B2540),
                            Color(0xFF132237),
                            Color(0xFF141821),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66070A10),
                            blurRadius: 26,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 38,
                            child: Container(
                              width: 168,
                              height: 168,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: CosplayTheme.softPurple.withValues(
                                  alpha: 0.18,
                                ),
                                border: Border.all(
                                  color: CosplayTheme.softPurple.withValues(
                                    alpha: 0.28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 74,
                            child: Icon(
                              Icons.face_retouching_natural,
                              size: 108,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            right: 34,
                            top: 42,
                            child: Icon(
                              Icons.auto_awesome,
                              size: 50,
                              color: CosplayTheme.questGold.withValues(
                                alpha: 0.72,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 36,
                            bottom: 46,
                            child: _HeroChip(icon: Icons.brush, label: 'Props'),
                          ),
                          Positioned(
                            right: 36,
                            bottom: 42,
                            child: _HeroChip(
                              icon: Icons.shield_moon,
                              label: 'Armor',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Cosplay Quest',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Convierte tu cosplay en una aventura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CosplayTheme.mutedText,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 34),
                    FilledButton.icon(
                      onPressed: onEnter,
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('Entrar'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: onCreateProject,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Crear proyecto'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: CosplayTheme.questGold),
          const SizedBox(width: 7),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
