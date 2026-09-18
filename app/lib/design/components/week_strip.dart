import 'package:flutter/widgets.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/motion.dart';
import '../tokens/spacing.dart';

enum _DotState { filled, today, empty, future }

/// Ambient proof of practice. Seven dots, no numbers, no percentages.
///
/// Filled = created · ring = today, still open · empty = missed · faint = future.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    super.key,
    required this.streak,
    required this.createdToday,
    this.size = 9,
    this.alignment = MainAxisAlignment.center,
  });

  final int streak;
  final bool createdToday;
  final double size;
  final MainAxisAlignment alignment;

  List<_DotState> _states() {
    final todayIndex = DateTime.now().weekday - 1; // Mon = 0
    // If today isn't done yet, the streak's last day was yesterday.
    final reach = createdToday ? streak - 1 : streak;
    return List.generate(7, (i) {
      final offset = i - todayIndex;
      if (offset > 0) return _DotState.future;
      if (offset == 0) return createdToday ? _DotState.filled : _DotState.today;
      return -offset <= reach ? _DotState.filled : _DotState.empty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: 'This week: $streak day streak',
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          for (final state in _states())
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.44),
              child: _Dot(state: state, size: size, colors: c),
            ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.state, required this.size, required this.colors});

  final _DotState state;
  final double size;
  final TejaColors colors;

  @override
  Widget build(BuildContext context) {
    final s = context.style;
    final size = this.size * (s.isPlayful ? 1.3 : 1);
    return AnimatedContainer(
      duration: Motion.standard,
      curve: Motion.easeOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: switch (state) {
          _DotState.filled => colors.ember,
          _DotState.today => const Color(0x00000000),
          _DotState.empty => colors.hairline,
          _DotState.future => colors.hairline.withValues(alpha: 0.45),
        },
        border: state == _DotState.today
            ? Border.all(color: colors.ember, width: s.isPlayful ? 2.5 : 1.6)
            : (s.isPlayful && state == _DotState.filled
                ? Border.all(color: colors.emberEdge, width: 1.5)
                : null),
      ),
    );
  }
}

/// The profile variant: five rows of dots covering roughly a month.
class MonthDots extends StatelessWidget {
  const MonthDots({super.key, required this.streak, required this.createdToday});

  final int streak;
  final bool createdToday;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final reach = createdToday ? streak - 1 : streak;
    return Column(
      children: [
        for (var row = 4; row >= 0; row--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var col = 0; col < 7; col++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Builder(builder: (_) {
                      final daysAgo = row * 7 + (6 - col);
                      final filled = daysAgo == 0 ? createdToday : daysAgo <= reach;
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? c.ember.withValues(alpha: 1 - (row * 0.12))
                              : c.hairline,
                        ),
                      );
                    }),
                  ),
              ],
            ),
          ),
        Gap.h8,
      ],
    );
  }
}
