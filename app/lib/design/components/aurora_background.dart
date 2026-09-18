import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/motion.dart';

/// Two very soft radial blobs drifting on a slow loop.
///
/// This is the *only* decorative element in the app. It gives Today and The Spark
/// a sense of warmth and depth without a single hard-edged gradient. It is
/// disabled entirely under reduce-motion (rendered static) so it never becomes a
/// battery or vestibular problem.
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({
    super.key,
    this.intensity = 1,
    this.tint,
    this.child,
  });

  final double intensity;
  final Color? tint;
  final Widget? child;

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final reduce = Motion.reduced(context);

    // Playful is flat by design: soft radial blobs over a saturated palette read
    // as a smudge, and they bleed behind the status bar.
    if (context.style.isPlayful) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: c.canvas),
          if (widget.child != null) widget.child!,
        ],
      );
    }

    if (reduce) _controller.stop();

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: c.canvas),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: _AuroraPainter(
              t: reduce ? 0.25 : _controller.value,
              ember: widget.tint ?? c.ember,
              glow: c.glow,
              intensity: widget.intensity * (c.isDark ? 0.55 : 1),
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

class _AuroraPainter extends CustomPainter {
  _AuroraPainter({
    required this.t,
    required this.ember,
    required this.glow,
    required this.intensity,
  });

  final double t;
  final Color ember;
  final Color glow;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final angle = t * 2 * math.pi;
    _blob(
      canvas,
      size,
      center: Offset(
        size.width * (0.18 + 0.10 * math.sin(angle)),
        size.height * (0.12 + 0.05 * math.cos(angle * 0.7)),
      ),
      radius: size.width * 0.72,
      color: ember.withValues(alpha: 0.07 * intensity),
    );
    _blob(
      canvas,
      size,
      center: Offset(
        size.width * (0.86 + 0.08 * math.cos(angle * 0.6)),
        size.height * (0.26 + 0.06 * math.sin(angle)),
      ),
      radius: size.width * 0.60,
      color: glow.withValues(alpha: 0.05 * intensity),
    );
  }

  void _blob(Canvas canvas, Size size,
      {required Offset center, required double radius, required Color color}) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0)],
        stops: const [0, 1],
      ).createShader(rect);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(_AuroraPainter old) =>
      old.t != t || old.intensity != intensity || old.ember != ember;
}
