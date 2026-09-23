import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/typography.dart';

/// Tear geometry, shared by the standalone edge and the card.
const double kTearHeight = 7;
const double _kWavelength = 8;
const double _kAmplitude = 1.8;

/// A shallow wave across [width] at [y] — a perforation, not a scallop.
Path _wave(double width, double y, {bool startUp = true}) {
  final path = Path()..moveTo(0, y);
  var x = 0.0;
  var up = startUp;
  while (x < width) {
    final next = (x + _kWavelength).clamp(0.0, width);
    path.quadraticBezierTo(
      (x + next) / 2,
      up ? y - _kAmplitude * 2 : y + _kAmplitude * 2,
      next,
      y,
    );
    x = next;
    up = !up;
  }
  return path;
}

/// The torn perforation between sections.
///
/// This is the signature of the whole design — every piece of content reads as a
/// segment of one long receipt rather than a floating card. Painted rather than
/// an asset so it inherits colour, scales with width and costs nothing.
class TornEdge extends StatelessWidget {
  const TornEdge({
    super.key,
    this.height = kTearHeight,
    this.color,
    this.strokeWidth = 1,
  });

  final double height;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _TornPainter(
          color: color ?? context.colors.perforation,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _TornPainter extends CustomPainter {
  _TornPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _wave(size.width, size.height / 2),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(_TornPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

/// A full-bleed slip of receipt stock: lighter paper, torn top and bottom, and a
/// soft shadow that follows the tear rather than a rectangle.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CustomPaint(
      painter: _ReceiptPainter(
        fill: c.band,
        edge: c.perforation,
        shadow: c.cardShadow,
      ),
      child: Padding(
        padding: padding + const EdgeInsets.symmetric(vertical: kTearHeight),
        child: child,
      ),
    );
  }
}

class _ReceiptPainter extends CustomPainter {
  _ReceiptPainter({
    required this.fill,
    required this.edge,
    required this.shadow,
  });

  final Color fill;
  final Color edge;
  final Color shadow;

  @override
  void paint(Canvas canvas, Size size) {
    final top = _wave(size.width, kTearHeight);
    final bottom = _wave(size.width, size.height - kTearHeight, startUp: false);

    final body = Path.from(top)
      ..lineTo(size.width, size.height - kTearHeight)
      ..extendWithPath(_reversed(bottom), Offset.zero)
      ..close();

    canvas.drawPath(
      body.shift(const Offset(0, 2)),
      Paint()
        ..color = shadow
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(body, Paint()..color = fill);

    final stroke = Paint()
      ..color = edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(top, stroke);
    canvas.drawPath(bottom, stroke);
  }

  /// Path has no reverse, so re-walk the metric backwards to close the body.
  Path _reversed(Path path) {
    final out = Path();
    var started = false;
    for (final metric in path.computeMetrics()) {
      for (var d = metric.length; d >= 0; d -= 2) {
        final pos = metric.getTangentForOffset(d)?.position;
        if (pos == null) continue;
        started ? out.lineTo(pos.dx, pos.dy) : out.moveTo(pos.dx, pos.dy);
        started = true;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(_ReceiptPainter old) =>
      old.fill != fill || old.edge != edge || old.shadow != shadow;
}

/// A centred label on a hairline, used for `Today` / date separators in the feed.
class DateDivider extends StatelessWidget {
  const DateDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        Expanded(child: Container(height: 0.5, color: c.hairline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: DabbleText.footnote.on(c.inkTertiary),
          ),
        ),
        Expanded(child: Container(height: 0.5, color: c.hairline)),
      ],
    );
  }
}
