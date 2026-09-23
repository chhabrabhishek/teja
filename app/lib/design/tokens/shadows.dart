import 'package:flutter/widgets.dart';

import 'colors.dart';

/// Printed paper has no elevation.
///
/// Depth comes from the torn perforations and hairline rules instead, so every
/// shadow here is empty by design rather than by omission — keeping the API
/// means components don't need to know.
abstract final class Shadows {
  static List<BoxShadow> card(DabbleColors c) => const [];

  static List<BoxShadow> hero(DabbleColors c) => const [];

  static List<BoxShadow> button(DabbleColors c) => const [];

  static Border? border(DabbleColors c) => Border.all(color: c.hairline, width: 0.5);

  static const Color tint = Color(0xFF1C1B19);
}
