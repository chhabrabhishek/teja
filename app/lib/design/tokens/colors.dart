import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'flavor.dart';

/// Teja's palette.
///
/// One warm accent (Ember), a warm neutral ramp, four desaturated category hues.
/// Dark mode is a different material, not an inversion: no shadows, depth comes
/// from surface lightness and hairlines.
///
/// Pure #FFFFFF and pure #000000 are banned as canvas colours.
@immutable
class TejaColors {
  const TejaColors({
    required this.canvas,
    required this.band,
    required this.surface,
    required this.surfaceAlt,
    required this.hairline,
    required this.ink,
    required this.inkSecondary,
    required this.inkTertiary,
    required this.ember,
    required this.emberSoft,
    required this.emberEdge,
    required this.onEmber,
    required this.surfaceEdge,
    required this.glow,
    required this.success,
    required this.danger,
    required this.scrim,
    required this.perforation,
    required this.cardShadow,
    required this.isDark,
  });

  final Color canvas;

  /// The lighter stock between two torn edges — the printed part of the receipt.
  final Color band;
  final Color surface;
  final Color surfaceAlt;
  final Color hairline;
  final Color ink;
  final Color inkSecondary;
  final Color inkTertiary;
  final Color ember;
  final Color emberSoft;

  /// The darker block under a 3D button; unused in the calm flavor.
  final Color emberEdge;
  final Color onEmber;
  final Color surfaceEdge;
  final Color glow;
  final Color success;
  final Color danger;
  final Color scrim;

  /// The torn perforation line between receipt segments.
  final Color perforation;

  /// The soft drop under a receipt card; follows the torn edge, not a rectangle.
  final Color cardShadow;
  final bool isDark;

  /// Receipt — warm printed paper, vermillion ink, no shadows anywhere.
  static const receiptLight = TejaColors(
    canvas: Color(0xFFF7F6F2),
    band: Color(0xFFFCFBF9),
    surface: Color(0xFFFBFAF8),
    surfaceAlt: Color(0xFFE6E4E0),
    hairline: Color(0xFFDDD9D3),
    ink: Color(0xFF1C1B19),
    inkSecondary: Color(0xFF6E6A64),
    inkTertiary: Color(0xFF9C978F),
    ember: Color(0xFFF96B38),
    emberSoft: Color(0xFFFDEAE3),
    emberEdge: Color(0xFFD04A26),
    onEmber: Color(0xFFFFFFFF),
    surfaceEdge: Color(0xFFDDD9D3),
    glow: Color(0xFFE8452B),
    success: Color(0xFF4F7A52),
    danger: Color(0xFFC0392B),
    scrim: Color(0x521C1B19),
    perforation: Color(0xFFCDC9C2),
    cardShadow: Color(0x14000000),
    isDark: false,
  );

  static const receiptDark = TejaColors(
    canvas: Color(0xFF15140F),
    band: Color(0xFF1B1A15),
    surface: Color(0xFF1C1A16),
    surfaceAlt: Color(0xFF272420),
    hairline: Color(0xFF34302A),
    ink: Color(0xFFF4F1EA),
    inkSecondary: Color(0xFFA8A29A),
    inkTertiary: Color(0xFF6F6A62),
    ember: Color(0xFFFF7A52),
    emberSoft: Color(0xFF34201A),
    emberEdge: Color(0xFFD04A26),
    onEmber: Color(0xFF15140F),
    surfaceEdge: Color(0xFF34302A),
    glow: Color(0xFFFF6A4D),
    success: Color(0xFF6FA372),
    danger: Color(0xFFE05C4B),
    scrim: Color(0x99000000),
    perforation: Color(0xFF38342E),
    cardShadow: Color(0x40000000),
    isDark: true,
  );

  static TejaColors resolve(TejaFlavor flavor, Brightness brightness) =>
      brightness == Brightness.dark ? receiptDark : receiptLight;

  /// Category hues are identical in both themes; only their alpha changes.
  static const writing = Color(0xFF5A6A9E);
  static const photo = Color(0xFF5E7D68);
  static const sketch = Color(0xFFB2684A);
  static const joke = Color(0xFF84557A);

  static Color forCategory(String category) => switch (category) {
        'photo' => photo,
        'sketch' => sketch,
        'joke' => joke,
        _ => writing,
      };

  /// Tint strength for category washes — dark mode needs more to stay visible.
  double get categoryWash => isDark ? 0.10 : 0.05;
  double get categoryChipFill => isDark ? 0.20 : 0.12;
}

/// Ambient access: `context.colors.ember`.
class TejaColorScope extends InheritedWidget {
  const TejaColorScope({super.key, required this.colors, required super.child});

  final TejaColors colors;

  static TejaColors of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TejaColorScope>();
    assert(scope != null, 'TejaColorScope is missing. Wrap the app in TejaTheme.');
    return scope!.colors;
  }

  @override
  bool updateShouldNotify(TejaColorScope oldWidget) => colors != oldWidget.colors;
}

extension TejaColorContext on BuildContext {
  TejaColors get colors => TejaColorScope.of(this);
}
