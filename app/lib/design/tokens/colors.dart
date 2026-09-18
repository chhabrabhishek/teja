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
    required this.isDark,
  });

  final Color canvas;
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
  final bool isDark;

  static const light = TejaColors(
    canvas: Color(0xFFFBF8F4),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF3EFE8),
    hairline: Color(0xFFE7E0D6),
    ink: Color(0xFF17130F),
    inkSecondary: Color(0xFF6A6157),
    inkTertiary: Color(0xFFA29889),
    ember: Color(0xFFDC5B34),
    emberSoft: Color(0xFFFBEAE2),
    emberEdge: Color(0xFFB8431F),
    onEmber: Color(0xFFFFFDFB),
    surfaceEdge: Color(0xFFE7E0D6),
    glow: Color(0xFFF0A63C),
    success: Color(0xFF3E7D5A),
    danger: Color(0xFFC0392B),
    scrim: Color(0x5217130F),
    isDark: false,
  );

  static const dark = TejaColors(
    canvas: Color(0xFF0D0C0B),
    surface: Color(0xFF161413),
    surfaceAlt: Color(0xFF201D1B),
    hairline: Color(0xFF2B2725),
    ink: Color(0xFFF6F2ED),
    inkSecondary: Color(0xFFA79F96),
    inkTertiary: Color(0xFF6C645B),
    ember: Color(0xFFFF7A4F),
    emberSoft: Color(0xFF2E1A12),
    emberEdge: Color(0xFFC4522F),
    onEmber: Color(0xFF14100E),
    surfaceEdge: Color(0xFF2B2725),
    glow: Color(0xFFFFB85C),
    success: Color(0xFF5AA37B),
    danger: Color(0xFFE05C4B),
    scrim: Color(0x8F000000),
    isDark: true,
  );

  /// Playful — saturated, high contrast, built for 2px outlines and 3D edges.
  /// Pure white canvas here on purpose: the calm rule about warm paper is a
  /// calm-flavor rule, and muddying these colours would kill the energy.
  static const playfulLight = TejaColors(
    canvas: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF7F7F7),
    hairline: Color(0xFFE5E5E5),
    ink: Color(0xFF3C3C3C),
    inkSecondary: Color(0xFF777777),
    inkTertiary: Color(0xFFAFAFAF),
    ember: Color(0xFFFF6B35),
    emberSoft: Color(0xFFFFEDE5),
    emberEdge: Color(0xFFD9501F),
    onEmber: Color(0xFFFFFFFF),
    surfaceEdge: Color(0xFFE5E5E5),
    glow: Color(0xFFFFC800),
    success: Color(0xFF58CC02),
    danger: Color(0xFFFF4B4B),
    scrim: Color(0x663C3C3C),
    isDark: false,
  );

  static const playfulDark = TejaColors(
    canvas: Color(0xFF131F24),
    surface: Color(0xFF1B2B32),
    surfaceAlt: Color(0xFF223640),
    hairline: Color(0xFF37464F),
    ink: Color(0xFFF1F7FB),
    inkSecondary: Color(0xFF8FA3AD),
    inkTertiary: Color(0xFF5F7682),
    ember: Color(0xFFFF7E4D),
    emberSoft: Color(0xFF3A2116),
    emberEdge: Color(0xFFC4522F),
    onEmber: Color(0xFF131F24),
    surfaceEdge: Color(0xFF37464F),
    glow: Color(0xFFFFC800),
    success: Color(0xFF58CC02),
    danger: Color(0xFFFF4B4B),
    scrim: Color(0x99000000),
    isDark: true,
  );

  static TejaColors resolve(TejaFlavor flavor, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return switch (flavor) {
      TejaFlavor.playful => isDark ? playfulDark : playfulLight,
      TejaFlavor.calm => isDark ? dark : light,
    };
  }

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
