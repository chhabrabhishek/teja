import 'package:flutter/widgets.dart';

/// 4pt base scale. If a value isn't here, it's wrong.
abstract final class Gap {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 32;
  static const double large = 40;
  static const double huge = 56;
  static const double massive = 72;

  /// Screen horizontal gutter.
  static const double gutter = 20;

  static const Widget h4 = SizedBox(height: xs);
  static const Widget h8 = SizedBox(height: sm);
  static const Widget h12 = SizedBox(height: md);
  static const Widget h16 = SizedBox(height: lg);
  static const Widget h20 = SizedBox(height: xl);
  static const Widget h24 = SizedBox(height: xxl);
  static const Widget h32 = SizedBox(height: section);
  static const Widget h40 = SizedBox(height: large);
  static const Widget h56 = SizedBox(height: huge);

  static const Widget w4 = SizedBox(width: xs);
  static const Widget w8 = SizedBox(width: sm);
  static const Widget w12 = SizedBox(width: md);
  static const Widget w16 = SizedBox(width: lg);
}

/// Continuous (squircle) corners — the single biggest "feels like iOS" cue.
abstract final class Radii {
  static const BorderRadius control = BorderRadius.all(Radius.circular(14));
  static const BorderRadius card = BorderRadius.all(Radius.circular(20));
  static const BorderRadius hero = BorderRadius.all(Radius.circular(28));
  static const BorderRadius image = BorderRadius.all(Radius.circular(18));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
