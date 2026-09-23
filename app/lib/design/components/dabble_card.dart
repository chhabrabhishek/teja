import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';
import 'dabble_press.dart';

class DabbleCard extends StatelessWidget {
  const DabbleCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Gap.xl),
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.elevated = true,
    this.color,
    this.wash,
    this.edgeColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final bool elevated;
  final Color? color;

  /// A tint laid over the surface — used for the category wash on the prompt hero.
  final Color? wash;

  /// Colour of the solid bottom edge in the playful flavor.
  final Color? edgeColor;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final radius = borderRadius ?? s.cardRadius;

    // Playful gets a visible outline and a solid bottom edge; calm gets a soft
    // shadow in light mode and a hairline in dark.
    final surface = Container(
      decoration: BoxDecoration(
        color: color ?? c.surface,
        borderRadius: radius,
        border: s.isPlayful
            ? Border.all(color: c.hairline, width: s.borderWidth)
            : Shadows.border(c),
        boxShadow: s.isPlayful
            ? (elevated
                ? [
                    BoxShadow(
                      color: edgeColor ?? c.surfaceEdge,
                      offset: Offset(0, s.edgeDepth),
                      blurRadius: 0,
                    ),
                  ]
                : const [])
            : (elevated ? Shadows.card(c) : const []),
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(color: wash),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );

    if (onTap == null && onLongPress == null) return surface;
    return DabblePress(
      onTap: onTap,
      onLongPress: onLongPress,
      scale: s.pressScale,
      child: surface,
    );
  }
}
