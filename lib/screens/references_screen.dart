import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/cosplay_project.dart';
import '../theme/cosplay_theme.dart';

class ReferencesScreen extends StatelessWidget {
  const ReferencesScreen({super.key, required this.project});

  final CosplayProject project;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CosplayTheme.nightBlue, CosplayTheme.voidBlack],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ReferencesHeader(projectName: project.name),
                  const SizedBox(height: 18),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth < 520
                          ? 1
                          : constraints.maxWidth < 820
                          ? 2
                          : 3;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: project.references.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: columns == 1 ? 1.18 : 0.72,
                        ),
                        itemBuilder: (context, index) {
                          final reference = project.references[index];
                          return _ReferenceTile(
                            reference: reference,
                            onTap: () => _openReference(context, reference),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openReference(BuildContext context, VisualReference reference) {
    final l10n = AppLocalizations.of(context);

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.closeReference,
      barrierColor: Colors.black.withValues(alpha: 0.84),
      pageBuilder: (context, _, __) {
        return Scaffold(
          backgroundColor: CosplayTheme.voidBlack,
          appBar: AppBar(
            title: Text(reference.localizedTitle(l10n)),
            actions: [
              IconButton(
                tooltip: l10n.close,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: CosplayTheme.border),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: InteractiveViewer(
                          minScale: 0.8,
                          maxScale: 4,
                          child: SizedBox.expand(
                            child: _ReferenceArtwork(
                              reference: reference,
                              expanded: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CosplayTheme.cardInk,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: CosplayTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reference.localizedTitle(l10n),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          reference.localizedCategory(l10n),
                          style: const TextStyle(
                            color: CosplayTheme.questGold,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          reference.localizedDescription(l10n),
                          style: const TextStyle(
                            color: CosplayTheme.mutedText,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: null,
                            icon: const Icon(Icons.add_task),
                            label: Text(l10n.createQuestFromReference),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReferencesHeader extends StatelessWidget {
  const _ReferencesHeader({required this.projectName});

  final String projectName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CosplayTheme.cardInk,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: CosplayTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: CosplayTheme.cardPurple,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: CosplayTheme.border),
            ),
            child: const Icon(
              Icons.photo_library,
              color: CosplayTheme.softBlue,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.visualReferences,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.referencesMoodboard(projectName),
                  style: const TextStyle(
                    color: CosplayTheme.mutedText,
                    fontWeight: FontWeight.w600,
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

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({required this.reference, required this.onTap});

  final VisualReference reference;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: CosplayTheme.cardInk,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: CosplayTheme.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4405070C),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 6, child: _ReferenceArtwork(reference: reference)),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 11, 13, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reference.localizedTitle(l10n),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        reference.localizedCategory(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CosplayTheme.questGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          reference.localizedDescription(l10n),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CosplayTheme.mutedText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReferenceArtwork extends StatelessWidget {
  const _ReferenceArtwork({required this.reference, this.expanded = false});

  final VisualReference reference;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lineColor = Colors.white.withValues(alpha: expanded ? 0.15 : 0.11);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: reference.colors,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _ReferencePatternPainter(color: lineColor)),
          Positioned(
            right: expanded ? 42 : 14,
            top: expanded ? 36 : 14,
            child: Icon(
              Icons.auto_awesome,
              size: expanded ? 96 : 38,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            left: expanded ? 34 : 14,
            top: expanded ? 34 : 14,
            child: _ArtworkPill(
              label: l10n.mockReferenceLabel,
              expanded: expanded,
              icon: Icons.image,
            ),
          ),
          Center(
            child: Container(
              width: expanded ? 220 : 96,
              height: expanded ? 220 : 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: expanded ? 3 : 2,
                ),
              ),
              child: Icon(
                reference.icon,
                size: expanded ? 112 : 50,
                color: Colors.white.withValues(alpha: 0.94),
              ),
            ),
          ),
          Positioned(
            left: expanded ? 34 : 14,
            right: expanded ? 34 : 14,
            bottom: expanded ? 34 : 14,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: expanded ? 18 : 12,
                vertical: expanded ? 14 : 9,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(expanded ? 22 : 16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Row(
                children: [
                  Icon(
                    reference.icon,
                    color: CosplayTheme.questGold,
                    size: expanded ? 24 : 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          reference.localizedTitle(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: expanded ? 20 : 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (expanded) ...[
                          const SizedBox(height: 4),
                          Text(
                            reference.localizedCategory(l10n),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: CosplayTheme.questGold,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArtworkPill extends StatelessWidget {
  const _ArtworkPill({
    required this.label,
    required this.expanded,
    required this.icon,
  });

  final String label;
  final bool expanded;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: expanded ? 14 : 9,
        vertical: expanded ? 9 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: expanded ? 18 : 13, color: CosplayTheme.questGold),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: expanded ? 12 : 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferencePatternPainter extends CustomPainter {
  const _ReferencePatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const spacing = 34.0;
    for (double x = -size.height; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }

    final framePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final rect = Rect.fromLTWH(18, 18, size.width - 36, size.height - 36);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(24)),
      framePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ReferencePatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
