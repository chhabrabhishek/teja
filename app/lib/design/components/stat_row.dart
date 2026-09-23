import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// The proof row on Profile. Three numbers, hairline dividers, tabular figures.
/// No progress bars, no badges, no levels.
class StatRow extends StatelessWidget {
  const StatRow({super.key, required this.stats});

  final List<({String value, String label})> stats;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < stats.length; i++) ...[
            if (i > 0)
              VerticalDivider(color: c.hairline),
            Expanded(
              child: Semantics(
                label: '${stats[i].label}: ${stats[i].value}',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stats[i].value,
                      style: DabbleText.display.on(c.ink).tabular.size(30),
                    ),
                    Gap.h4,
                    Text(
                      stats[i].label.toUpperCase(),
                      style: DabbleText.eyebrow.on(c.inkTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 0.5, color: color, margin: const EdgeInsets.symmetric(vertical: Gap.xs));
}

class Hairline extends StatelessWidget {
  const Hairline({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) => Container(
        height: 0.5,
        margin: EdgeInsets.only(left: indent),
        color: context.colors.hairline,
      );
}

/// The uppercase section label — the only uppercase style in the app.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: DabbleText.eyebrow.on(color ?? context.colors.inkTertiary),
      );
}
