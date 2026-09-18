import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/motion.dart';

/// A one-shot confetti burst for The Spark.
///
/// Deliberately hand-painted rather than a package: ~48 rectangles on a single
/// ticker costs nothing, and a dependency for two seconds of joy is a bad trade.
/// Renders nothing under reduce-motion.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    this.pieces = 48,
    this.duration = const Duration(milliseconds: 2200),
  });

  final int pieces;
  final Duration duration;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration)..forward();
  late final List<_Piece> _pieces;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _pieces = List.generate(widget.pieces, (i) {
      final angle = -math.pi / 2 + (_random.nextDouble() - 0.5) * 2.4;
      final speed = 0.55 + _random.nextDouble() * 0.75;
      return _Piece(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
        spin: (_random.nextDouble() - 0.5) * 12,
        size: 6 + _random.nextDouble() * 7,
        delay: _random.nextDouble() * 0.18,
        colorIndex: i % 5,
        wobble: _random.nextDouble() * math.pi * 2,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Motion.reduced(context)) return const SizedBox.shrink();
    final c = context.colors;
    final palette = [c.ember, c.glow, c.success, TejaColors.joke, TejaColors.writing];

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ConfettiPainter(
            t: _controller.value,
            pieces: _pieces,
            palette: palette,
          ),
        ),
      ),
    );
  }
}

class _Piece {
  _Piece({
    required this.velocity,
    required this.spin,
    required this.size,
    required this.delay,
    required this.colorIndex,
    required this.wobble,
  });

  final Offset velocity;
  final double spin;
  final double size;
  final double delay;
  final int colorIndex;
  final double wobble;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.t, required this.pieces, required this.palette});

  final double t;
  final List<_Piece> pieces;
  final List<Color> palette;

  static const _gravity = 1.6;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.42);
    final paint = Paint();

    for (final piece in pieces) {
      final local = ((t - piece.delay) / (1 - piece.delay)).clamp(0.0, 1.0);
      if (local <= 0) continue;

      final travel = size.height * 0.85;
      final dx = piece.velocity.dx * travel * local +
          math.sin(local * 6 + piece.wobble) * 14;
      final dy = piece.velocity.dy * travel * local +
          _gravity * travel * local * local;

      // Fade only in the last third so the burst reads as solid colour first.
      final opacity = local < 0.65 ? 1.0 : (1 - (local - 0.65) / 0.35);
      paint.color = palette[piece.colorIndex].withValues(alpha: opacity.clamp(0, 1));

      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(piece.spin * local);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: piece.size,
            height: piece.size * 0.6,
          ),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
