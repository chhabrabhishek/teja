import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'chips.dart';
import 'teja_press.dart';

/// The signature component. The prompt is physically the largest thing on the
/// display — nothing on Today is allowed to compete with it.
///
/// The whole card is a tap target: if someone reaches for the words, they mean
/// "let me write".
class PromptHeroCard extends StatelessWidget {
  const PromptHeroCard({
    super.key,
    required this.category,
    required this.categoryLabel,
    required this.text,
    required this.nudge,
    this.timeRemaining,
    this.onTap,
    this.onLongPress,
  });

  final String category;
  final String categoryLabel;
  final String text;
  final String nudge;
  final String? timeRemaining;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final hue = TejaColors.forCategory(category);

    // Long prompts step down a size rather than wrapping into a wall of text.
    final base = text.length > 90 ? TejaText.display : TejaText.displayXL;
    final style = base.copyWith(
      fontFamily: s.roundedFamily,
      fontWeight: s.displayWeight,
      fontSize: base.fontSize! * s.displayScale,
      height: s.isPlayful ? 1.15 : base.height,
    );

    return TejaPress(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: s.pressScale,
      semanticLabel: "Today's prompt. $text",
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: s.heroRadius,
          border: s.isPlayful
              ? Border.all(color: c.hairline, width: s.borderWidth)
              : Shadows.border(c),
          boxShadow: s.isPlayful
              ? [
                  BoxShadow(
                    color: c.surfaceEdge,
                    offset: Offset(0, s.edgeDepth),
                    blurRadius: 0,
                  ),
                ]
              : Shadows.hero(c),
        ),
        child: ClipRRect(
          borderRadius: s.heroRadius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: s.heroWash ? hue.withValues(alpha: c.categoryWash) : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(Gap.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryChip(category: category, label: categoryLabel),
                  Gap.h20,
                  Text(
                    text,
                    style: style.on(c.ink),
                    // The hero caps its Dynamic Type scale so the CTA never falls
                    // off-screen at accessibility sizes.
                    textScaler: TextScaler.linear(
                      MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.3).toDouble(),
                    ),
                  ),
                  Gap.h16,
                  Text(nudge, style: TejaText.callout.on(c.inkSecondary)),
                  if (timeRemaining != null) ...[
                    Gap.h8,
                    Text(timeRemaining!, style: TejaText.footnote.on(c.inkTertiary)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
