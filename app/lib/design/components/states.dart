import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/motion.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'dabble_button.dart';

/// Empty states in Dabble are never sad. No frowning illustrations, no "nothing to
/// see here". Each one names the feeling and offers exactly one way forward.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.large, vertical: Gap.section),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: c.inkTertiary),
            Gap.h20,
            Text(title, style: DabbleText.title2.on(c.ink), textAlign: TextAlign.center),
            Gap.h8,
            Text(
              message,
              style: DabbleText.callout.on(c.inkSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              Gap.h24,
              DabbleButton.quiet(actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// A warm sweep over `surfaceAlt`. Skeletons mirror the real layout exactly so
/// nothing jumps when content lands.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = Radii.control,
  });

  const Skeleton.text({Key? key, double? width})
      : this(key: key, width: width, height: 14, borderRadius: Radii.pill);

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (Motion.reduced(context)) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: widget.borderRadius),
      );
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = _c.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: c.surfaceAlt,
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1 - 2 * (1 - t), 0),
              end: Alignment(1 - 2 * (1 - t), 0),
              colors: [
                c.surfaceAlt,
                c.ink.withValues(alpha: 0.06),
                c.surfaceAlt,
              ],
            ),
          ),
        );
      },
    );
  }
}
