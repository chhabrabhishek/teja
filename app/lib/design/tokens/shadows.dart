import 'package:flutter/widgets.dart';

import 'colors.dart';

/// Two-layer, warm-tinted, very low alpha.
///
/// Dark mode has **no shadows**: depth comes from surface lightness plus a 1px
/// hairline border. This is how Journal, Linear and Notion handle dark, and grey
/// Material-style drop shadows on a dark canvas are the fastest way to look cheap.
abstract final class Shadows {
  static const _tint = Color(0xFF17130F);

  static List<BoxShadow> card(TejaColors c) => c.isDark
      ? const []
      : const [
          BoxShadow(color: Color(0x0A17130F), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: Color(0x0F17130F), blurRadius: 28, offset: Offset(0, 12)),
        ];

  static List<BoxShadow> hero(TejaColors c) => c.isDark
      ? const []
      : const [
          BoxShadow(color: Color(0x0A17130F), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: Color(0x1717130F), blurRadius: 48, offset: Offset(0, 20)),
        ];

  static List<BoxShadow> button(TejaColors c) => c.isDark
      ? const []
      : [BoxShadow(color: c.ember.withValues(alpha: 0.28), blurRadius: 20, offset: const Offset(0, 8))];

  /// In dark mode a hairline border replaces the shadow.
  static Border? border(TejaColors c) =>
      c.isDark ? Border.all(color: c.hairline, width: 1) : null;

  static const Color tint = _tint;
}
