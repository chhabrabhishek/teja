import 'package:flutter/widgets.dart';

import 'motion.dart';

/// Two complete visual personalities, switchable at runtime.
///
/// [calm] — Apple Journal / Linear. Warm paper, soft shadows, huge quiet type.
/// [playful] — Duolingo. Saturated colour, 2px borders, chunky 3D buttons that
/// physically depress, rounded type, bouncy motion.
///
/// Every geometry and motion decision that differs between them lives here, so a
/// component reads `context.style` and never branches on the flavor itself.
enum TejaFlavor {
  receipt('Receipt', 'Printed paper, torn edges, vermillion ink');

  const TejaFlavor(this.label, this.blurb);

  final String label;
  final String blurb;
}

@immutable
class TejaStyle {
  const TejaStyle({
    required this.flavor,
    required this.controlRadius,
    required this.cardRadius,
    required this.heroRadius,
    required this.imageRadius,
    required this.borderWidth,
    required this.edgeDepth,
    required this.buttonHeight,
    required this.displayWeight,
    required this.headlineWeight,
    required this.displayScale,
    required this.heroWash,
    required this.roundedFamily,
    required this.pressScale,
    required this.pressCurve,
    required this.enterCurve,
  });

  final TejaFlavor flavor;

  final BorderRadius controlRadius;
  final BorderRadius cardRadius;
  final BorderRadius heroRadius;
  final BorderRadius imageRadius;

  /// Hairline in calm, a deliberate outline in playful.
  final double borderWidth;

  /// Height of the solid colour block under a button. 0 disables the 3D edge.
  final double edgeDepth;

  final double buttonHeight;
  final FontWeight displayWeight;
  final FontWeight headlineWeight;

  /// Heavy rounded type reads larger at the same point size, so playful scales
  /// down to keep the prompt and its CTA on one screen.
  final double displayScale;

  /// A category tint behind the prompt. Warms the paper in calm; over a pure
  /// white playful card it just looks dirty.
  final bool heroWash;

  /// SF Pro Rounded on iOS; falls back to the system face elsewhere.
  final String? roundedFamily;

  final double pressScale;
  final Curve pressCurve;
  final Curve enterCurve;

  bool get isPlayful => false;

  /// Buttons and cards sit on a solid colour edge instead of a soft shadow.
  bool get hasHardEdge => edgeDepth > 0;

  /// Printed paper: flat, hairline-ruled, no elevation anywhere.
  static const receipt = TejaStyle(
    flavor: TejaFlavor.receipt,
    controlRadius: BorderRadius.all(Radius.circular(24)),
    cardRadius: BorderRadius.all(Radius.circular(16)),
    heroRadius: BorderRadius.all(Radius.circular(20)),
    imageRadius: BorderRadius.all(Radius.circular(12)),
    borderWidth: 0.5,
    edgeDepth: 0,
    buttonHeight: 54,
    displayWeight: FontWeight.w700,
    headlineWeight: FontWeight.w600,
    displayScale: 1,
    heroWash: false,
    roundedFamily: null,
    pressScale: 0.97,
    pressCurve: Motion.easeOut,
    enterCurve: Motion.enter,
  );

  static TejaStyle of(TejaFlavor flavor) => receipt;
}

class TejaStyleScope extends InheritedWidget {
  const TejaStyleScope({super.key, required this.style, required super.child});

  final TejaStyle style;

  static TejaStyle of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TejaStyleScope>()?.style ??
      TejaStyle.receipt;

  @override
  bool updateShouldNotify(TejaStyleScope oldWidget) => style != oldWidget.style;
}

extension TejaStyleContext on BuildContext {
  TejaStyle get style => TejaStyleScope.of(this);
}
