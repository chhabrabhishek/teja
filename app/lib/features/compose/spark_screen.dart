import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/aurora_background.dart';
import '../../design/components/confetti.dart';
import '../../design/components/teja_button.dart';
import '../../design/components/week_strip.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../feed/feed_controller.dart';
import '../profile/reminder_controller.dart';

/// The dopamine.
///
/// It lasts about two and a half seconds and then gets out of the way. This
/// screen is the reason people come back tomorrow, which makes it a feature — not
/// a toast, not a snackbar, not a checkmark in a corner.
class SparkScreen extends ConsumerStatefulWidget {
  const SparkScreen({super.key, required this.streakDays});

  final int streakDays;

  @override
  ConsumerState<SparkScreen> createState() => _SparkScreenState();
}

class _SparkScreenState extends ConsumerState<SparkScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Motion.spark);
  Timer? _autoAdvance;
  bool _left = false;

  @override
  void initState() {
    super.initState();
    // The feed is already unlocked by the time this screen finishes animating.
    ref.read(feedControllerProvider.notifier).refresh();
    _controller.forward();
    _autoAdvance = Timer(const Duration(milliseconds: 2400), _toFeed);
    _maybeAskForReminder();
  }

  /// Asked here, never on cold launch: permission requested right after someone
  /// has actually made something converts far better, and finally makes sense.
  Future<void> _maybeAskForReminder() async {
    final reminder = ref.read(reminderControllerProvider);
    if (reminder.asked || reminder.granted) return;
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    _autoAdvance?.cancel();
    await ref.read(reminderControllerProvider.notifier).askPermission();
    if (mounted && !_left) {
      _autoAdvance = Timer(const Duration(milliseconds: 1200), _toFeed);
    }
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toFeed() {
    if (_left || !mounted) return;
    _left = true;
    context.go('/feed');
  }

  void _toToday() {
    if (_left || !mounted) return;
    _left = true;
    context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final reduce = Motion.reduced(context);

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: GestureDetector(
        onTap: () => _autoAdvance?.cancel(),
        child: Stack(
          children: [
            Positioned.fill(
              child: AuroraBackground(
                intensity: 2.4,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Gap.gutter),
                    child: Column(
                      children: [
                        const Spacer(flex: 3),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, _) {
                            final curve =
                                s.isPlayful ? Curves.elasticOut : Curves.easeOutCubic;
                            final t = reduce ? 1.0 : curve.transform(_controller.value);
                            final count = widget.streakDays - 1 + t.clamp(0.0, 1.0);
                            return Column(
                              children: [
                                Text(
                                  'DAY',
                                  style: TejaText.eyebrow.on(c.inkSecondary).copyWith(
                                        fontFamily: s.roundedFamily,
                                      ),
                                ),
                                Gap.h12,
                                Transform.scale(
                                  scale: reduce ? 1 : 0.9 + 0.1 * t,
                                  child: Text(
                                    '${count.round().clamp(1, 99999)}',
                                    style: TejaText.display
                                        .on(c.ember)
                                        .tabular
                                        .copyWith(
                                          fontSize: 72,
                                          height: 1.05,
                                          fontFamily: s.roundedFamily,
                                          fontWeight: s.displayWeight,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Gap.h24,
                        Text(
                          'You made something today.',
                          style: TejaText.title2.on(c.ink).copyWith(
                                fontFamily: s.roundedFamily,
                                fontWeight: s.headlineWeight,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        Gap.h32,
                        WeekStrip(
                          streak: widget.streakDays,
                          createdToday: true,
                          size: 11,
                        ),
                        const Spacer(flex: 4),
                        TejaButton('See what others made', onPressed: _toFeed),
                        Gap.h12,
                        TejaButton.quiet('Back to Today', onPressed: _toToday),
                        Gap.h24,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Playful earns its keep here: this is the payoff screen.
            if (s.isPlayful) const Positioned.fill(child: ConfettiBurst()),
          ],
        ),
      ),
    );
  }
}
