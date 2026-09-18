import 'dart:ui' show FontFeature;

import 'package:flutter/widgets.dart';

/// Teja's type scale.
///
/// Family: San Francisco. On iOS, a null `fontFamily` resolves the system face —
/// SF Pro Display above 20pt, SF Pro Text below. We ship no custom font in v1:
/// SF with correct optical tracking already reads more premium than a bundled
/// webfont, and it gets Dynamic Type for free.
///
/// To move to a serif display face later (Fraunces gives the prompt an
/// Apple-Journal feel), change [_displayFamily] — nothing else.
abstract final class TejaText {
  static const String? _displayFamily = null;
  static const String? _uiFamily = null;

  static const displayXL = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 40,
    height: 46 / 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.1,
  );

  static const display = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
  );

  static const title1 = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );

  static const title2 = TextStyle(
    fontFamily: _displayFamily,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.4,
  );

  static const headline = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 17,
    height: 22 / 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const body = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 17,
    height: 27 / 17,
    fontWeight: FontWeight.w400,
  );

  static const bodyEmphasis = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 17,
    height: 27 / 17,
    fontWeight: FontWeight.w600,
  );

  static const callout = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const subhead = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 15,
    height: 20 / 15,
    fontWeight: FontWeight.w500,
  );

  static const footnote = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
  );

  /// The only uppercase style in the app.
  static const eyebrow = TextStyle(
    fontFamily: _uiFamily,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  /// Counters and streaks: digits must not jitter while animating.
  static const tabular = [FontFeature.tabularFigures()];

  /// Long-form reading is capped at ~68 characters per line.
  static const double readingMeasure = 640;
}

extension TejaTextStyleX on TextStyle {
  TextStyle on(Color color) => copyWith(color: color);
  TextStyle get tabular => copyWith(fontFeatures: TejaText.tabular);
  TextStyle size(double value) => copyWith(fontSize: value, height: null);
}
