import 'dart:ui' show FontFeature;

import 'package:flutter/widgets.dart';

/// Dabble's type scale.
///
/// Serif throughout. **Iowan Old Style** ships with iOS — it is the Apple Books
/// reading face — so there is no font to download, bundle or licence, and no
/// runtime fetch to fail behind a corporate proxy. Every fallback is also a
/// system face, so the app can never render in a font we didn't choose.
abstract final class DabbleText {
  static const String _serif = 'Iowan Old Style';
  static const List<String> _fallback = ['Charter', 'Georgia', 'Times New Roman'];

  static TextStyle _s(double size, double lineHeight, FontWeight weight,
          [double spacing = 0]) =>
      TextStyle(
        fontFamily: _serif,
        fontFamilyFallback: _fallback,
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: spacing,
      );

  static final displayXL = _s(34, 44, FontWeight.w700, -0.2);
  static final display = _s(28, 38, FontWeight.w700, -0.2);
  static final title1 = _s(24, 31, FontWeight.w700);
  static final title2 = _s(19, 26, FontWeight.w700);
  static final headline = _s(16, 22, FontWeight.w600);
  static final body = _s(16, 26, FontWeight.w400);
  static final bodyEmphasis = _s(16, 26, FontWeight.w700);
  static final callout = _s(15, 22, FontWeight.w400);
  static final subhead = _s(14, 19, FontWeight.w600);
  static final footnote = _s(12.5, 17, FontWeight.w400);

  /// The only uppercase style in the app.
  static final eyebrow = _s(11, 15, FontWeight.w700, 0.8);

  /// Counters and streaks: digits must not jitter while animating.
  static const tabular = [FontFeature.tabularFigures()];

  /// Long-form reading is capped at ~68 characters per line.
  static const double readingMeasure = 640;
}

extension DabbleTextStyleX on TextStyle {
  TextStyle on(Color color) => copyWith(color: color);
  TextStyle get tabular => copyWith(fontFeatures: DabbleText.tabular);
  TextStyle size(double value) => copyWith(fontSize: value, height: null);
}
