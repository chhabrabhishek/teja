import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/motion.dart';
import '../tokens/shadows.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'teja_press.dart';

enum TejaButtonVariant { primary, secondary, quiet, destructive }

enum TejaButtonSize { large, medium, small }

/// Remember rule #2 of the design system: exactly one Ember-filled button is
/// visible at a time. If you need two primaries on a screen, the screen is wrong.
class TejaButton extends StatelessWidget {
  const TejaButton(
    this.label, {
    super.key,
    this.onPressed,
    this.variant = TejaButtonVariant.primary,
    this.size = TejaButtonSize.large,
    this.icon,
    this.loading = false,
    this.expand = true,
  });

  const TejaButton.secondary(String label, {Key? key, VoidCallback? onPressed, bool loading = false})
      : this(label,
            key: key,
            onPressed: onPressed,
            variant: TejaButtonVariant.secondary,
            loading: loading);

  const TejaButton.quiet(String label, {Key? key, VoidCallback? onPressed})
      : this(label,
            key: key,
            onPressed: onPressed,
            variant: TejaButtonVariant.quiet,
            size: TejaButtonSize.medium,
            expand: false);

  final String label;
  final VoidCallback? onPressed;
  final TejaButtonVariant variant;
  final TejaButtonSize size;
  final IconData? icon;
  final bool loading;
  final bool expand;

  double get _height => switch (size) {
        TejaButtonSize.large => 54,
        TejaButtonSize.medium => 44,
        TejaButtonSize.small => 34,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final enabled = onPressed != null && !loading;

    final (Color background, Color foreground, Color edge) = switch (variant) {
      TejaButtonVariant.primary => (c.ember, c.onEmber, c.emberEdge),
      TejaButtonVariant.secondary => (c.surfaceAlt, c.ink, c.surfaceEdge),
      TejaButtonVariant.quiet => (const Color(0x00000000), c.ember, const Color(0x00000000)),
      TejaButtonVariant.destructive => (c.surfaceAlt, c.danger, c.surfaceEdge),
    };

    final height = size == TejaButtonSize.large ? s.buttonHeight : _height;
    final radius = s.isPlayful ? s.controlRadius : Radii.pill;

    final textStyle = (size == TejaButtonSize.small ? TejaText.footnote : TejaText.headline)
        .on(foreground)
        .copyWith(
          fontWeight: s.isPlayful ? FontWeight.w800 : FontWeight.w600,
          fontFamily: s.roundedFamily,
          letterSpacing: s.isPlayful ? 0.6 : null,
        );

    final label = s.isPlayful ? this.label.toUpperCase() : this.label;

    Widget content = loading
        ? CupertinoActivityIndicator(color: foreground, radius: 9)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 17, color: foreground),
                Gap.w8,
              ],
              Flexible(
                child: Text(
                  label,
                  style: textStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    final face = Container(
      height: height,
      width: expand ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: expand ? Gap.xl : Gap.lg),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        boxShadow: enabled && !s.isPlayful ? _softShadow(c) : const [],
      ),
      child: content,
    );

    return AnimatedOpacity(
      duration: Motion.quick,
      opacity: enabled ? 1 : 0.45,
      child: s.hasHardEdge && variant != TejaButtonVariant.quiet
          ? _PressableSlab(
              depth: enabled ? s.edgeDepth : 0,
              edge: edge,
              radius: radius,
              onTap: enabled ? onPressed : null,
              semanticLabel: label,
              child: face,
            )
          : TejaPress(
              onTap: enabled ? onPressed : null,
              scale: s.pressScale,
              semanticLabel: label,
              child: face,
            ),
    );
  }

  List<BoxShadow> _softShadow(TejaColors c) =>
      variant == TejaButtonVariant.primary ? Shadows.button(c) : const [];
}

/// The Duolingo press: the face drops onto its own shadow block instead of
/// scaling. It reads as a physical key rather than a rectangle that shrinks.
class _PressableSlab extends StatefulWidget {
  const _PressableSlab({
    required this.child,
    required this.depth,
    required this.edge,
    required this.radius,
    required this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final double depth;
  final Color edge;
  final BorderRadius radius;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<_PressableSlab> createState() => _PressableSlabState();
}

class _PressableSlabState extends State<_PressableSlab> {
  bool _down = false;

  void _set(bool value) {
    if (widget.onTap == null) return;
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final depth = widget.depth;
    final sunk = _down || widget.onTap == null;

    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: widget.onTap == null
            ? null
            : () {
                Feel.light();
                widget.onTap!();
              },
        child: Padding(
          padding: EdgeInsets.only(bottom: depth),
          child: Stack(
            children: [
              Positioned.fill(
                top: depth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.edge,
                    borderRadius: widget.radius,
                  ),
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 70),
                curve: Curves.easeOut,
                offset: sunk ? Offset(0, depth / 56) : Offset.zero,
                child: widget.child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
