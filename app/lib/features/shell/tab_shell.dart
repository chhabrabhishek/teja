import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/typography.dart';

/// Three tabs. Never four. Never a centre FAB — that is the loudest Material tell
/// in mobile design, and creation here is a *mode*, not a destination.
class TabShell extends StatelessWidget {
  const TabShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: Stack(
        children: [
          Positioned.fill(child: shell),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _TabBar(
              index: shell.currentIndex,
              onTap: (i) {
                Feel.select();
                // Tapping the active tab returns it to its root.
                shell.goBranch(i, initialLocation: i == shell.currentIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  static const _items = [
    (icon: CupertinoIcons.sparkles, label: 'Today'),
    (icon: CupertinoIcons.square_stack_3d_up, label: 'Feed'),
    (icon: CupertinoIcons.person, label: 'You'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    final bar = Container(
      padding: EdgeInsets.only(top: 8, bottom: bottomInset > 0 ? bottomInset : 10),
      decoration: BoxDecoration(
        // Playful is flat and opaque; calm keeps the translucent iOS blur.
        color: s.isPlayful ? c.canvas : c.canvas.withValues(alpha: 0.86),
        border: Border(
          top: BorderSide(
            color: c.hairline,
            width: s.isPlayful ? s.borderWidth : 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(i),
                child: Semantics(
                  selected: i == index,
                  button: true,
                  label: _items[i].label,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: Motion.quick,
                        curve: Motion.easeOut,
                        padding: s.isPlayful
                            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 5)
                            : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: s.isPlayful && i == index
                              ? c.emberSoft
                              : const Color(0x00000000),
                          borderRadius: s.controlRadius,
                        ),
                        child: AnimatedScale(
                          duration: Motion.quick,
                          curve: Motion.easeOut,
                          scale: i == index ? 1.06 : 1,
                          child: Icon(
                            _items[i].icon,
                            size: 24,
                            color: i == index ? c.ember : c.inkTertiary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].label,
                        style: TejaText.footnote
                            .on(i == index ? c.ember : c.inkTertiary)
                            .copyWith(
                              fontSize: 11,
                              letterSpacing: 0.1,
                              fontFamily: s.roundedFamily,
                              fontWeight:
                                  s.isPlayful ? FontWeight.w800 : FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (s.isPlayful) return bar;
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: bar,
      ),
    );
  }
}
