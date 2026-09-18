import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Motion is breath, not bounce. Everything eases out. Nothing overshoots except
/// The Spark, which is allowed exactly one moment of joy.
abstract final class Motion {
  static const instant = Duration(milliseconds: 120);
  static const quick = Duration(milliseconds: 200);
  static const standard = Duration(milliseconds: 320);
  static const deliberate = Duration(milliseconds: 520);
  static const spark = Duration(milliseconds: 900);

  static const Curve easeOut = Cubic(0.22, 1, 0.36, 1);
  static const Curve enter = Cubic(0.16, 1, 0.3, 1);
  static const Curve exit = Cubic(0.4, 0, 1, 1);

  /// Respect the system reduce-motion setting: transforms collapse to cross-fades.
  static bool reduced(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
}

/// Haptics are part of the design, not an afterthought.
abstract final class Feel {
  static void select() => HapticFeedback.selectionClick();
  static void light() => HapticFeedback.lightImpact();
  static void medium() => HapticFeedback.mediumImpact();

  /// Publishing and streak increments — the two moments that earn a heavy tap.
  static void celebrate() => HapticFeedback.heavyImpact();
  static void error() => HapticFeedback.vibrate();
}

/// Fade + rise, staggered. The signature entrance for content on Today.
class FadeRise extends StatelessWidget {
  const FadeRise({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 16,
    this.duration = Motion.deliberate,
  });

  final Widget child;
  final Duration delay;
  final double offset;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final reduce = Motion.reduced(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + delay,
      curve: Interval(
        delay.inMilliseconds / (duration + delay).inMilliseconds.clamp(1, 1 << 30),
        1,
        curve: Motion.enter,
      ),
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: reduce
            ? child
            : Transform.translate(offset: Offset(0, (1 - t) * offset), child: child),
      ),
      child: child,
    );
  }
}
