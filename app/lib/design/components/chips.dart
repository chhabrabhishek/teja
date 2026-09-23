import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'dabble_press.dart';

/// Category hue appears only here, in the small glyph, and as a 4–10% wash behind
/// the prompt. Never as a full-bleed fill.
class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.category, required this.label});

  final String category;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hue = DabbleColors.forCategory(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: 7),
      decoration: BoxDecoration(
        color: hue.withValues(alpha: c.categoryChipFill),
        borderRadius: Radii.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(glyphFor(category), size: 13, color: c.isDark ? hue.withValues(alpha: 0.95) : hue),
          Gap.w8,
          Text(
            label.toUpperCase(),
            style: DabbleText.eyebrow.on(c.isDark ? hue.withValues(alpha: 0.95) : hue),
          ),
        ],
      ),
    );
  }

  static IconData glyphFor(String category) => switch (category) {
        'photo' => CupertinoIcons.camera,
        'sketch' => CupertinoIcons.pencil_outline,
        'joke' => CupertinoIcons.smiley,
        _ => CupertinoIcons.textformat_alt,
      };
}

/// Proof, not pressure. No flame glyph — the flame is the gamified cliché we're
/// deliberately avoiding. A small filled dot and a number reads calmer and, oddly,
/// more serious.
class StreakPill extends StatelessWidget {
  const StreakPill({super.key, required this.days, this.onTap, this.compact = false});

  final int days;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final active = days > 0;
    final tint = active ? c.ember : c.inkTertiary;
    return DabblePress(
      onTap: onTap,
      semanticLabel: active ? 'Current streak, $days days' : 'No streak yet',
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? Gap.sm : Gap.md, vertical: 6),
        decoration: BoxDecoration(
          color: active ? c.emberSoft : c.surfaceAlt,
          borderRadius: Radii.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: tint, shape: BoxShape.circle),
            ),
            Gap.w8,
            Text('$days', style: DabbleText.footnote.on(tint).tabular.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
