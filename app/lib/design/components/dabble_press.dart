import 'package:flutter/widgets.dart';

import '../tokens/motion.dart';

/// The press feedback for everything tappable in Dabble: a 0.97 scale and a small
/// opacity drop. No ripple, ever — an expanding circle is the loudest Material
/// tell there is.
class DabblePress extends StatefulWidget {
  const DabblePress({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.97,
    this.opacity = 0.85,
    this.haptic = true,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final double opacity;
  final bool haptic;
  final String? semanticLabel;

  @override
  State<DabblePress> createState() => _DabblePressState();
}

class _DabblePressState extends State<DabblePress> {
  bool _down = false;

  void _set(bool value) {
    if (widget.onTap == null && widget.onLongPress == null) return;
    if (_down != value) setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null || widget.onLongPress != null;
    return Semantics(
      button: enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _set(true),
        onTapUp: (_) => _set(false),
        onTapCancel: () => _set(false),
        onTap: enabled
            ? () {
                if (widget.haptic) Feel.select();
                widget.onTap?.call();
              }
            : null,
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                Feel.medium();
                widget.onLongPress!();
              },
        child: AnimatedScale(
          scale: _down ? widget.scale : 1,
          duration: Motion.instant,
          curve: Motion.easeOut,
          child: AnimatedOpacity(
            opacity: _down ? widget.opacity : 1,
            duration: Motion.instant,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
