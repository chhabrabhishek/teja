import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/motion.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Five reactions, chosen for warmth rather than judgement. There is no thumbs
/// down, no "meh", and no total score — nothing that could make a person feel
/// graded on the thing they just made.
const kReactions = ['💛', '🔥', '😂', '🤯', '🫶'];

class ReactionBar extends StatelessWidget {
  const ReactionBar({
    super.key,
    required this.counts,
    required this.mine,
    required this.onToggle,
    this.commentCount,
    this.onComments,
    this.large = false,
  });

  final Map<String, int> counts;
  final List<String> mine;
  final void Function(String emoji, bool selected) onToggle;
  final int? commentCount;
  final VoidCallback? onComments;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        // Five pills plus counts can exceed a narrow card once borders are on.
        // scaleDown only engages when it has to, so nothing shrinks in the
        // common case and it can never overflow in the uncommon one.
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final emoji in kReactions)
                  Padding(
                    padding: const EdgeInsets.only(right: Gap.sm),
                    child: _ReactionButton(
                      emoji: emoji,
                      count: counts[emoji] ?? 0,
                      selected: mine.contains(emoji),
                      large: large,
                      onTap: () => onToggle(emoji, !mine.contains(emoji)),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (commentCount != null)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onComments,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.xs, vertical: Gap.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.bubble_left, size: 15, color: c.inkTertiary),
                  Gap.w4,
                  Text(
                    commentCount == 0 ? '' : '$commentCount',
                    style: DabbleText.footnote.on(c.inkTertiary).tabular,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ReactionButton extends StatefulWidget {
  const _ReactionButton({
    required this.emoji,
    required this.count,
    required this.selected,
    required this.onTap,
    required this.large,
  });

  final String emoji;
  final int count;
  final bool selected;
  final VoidCallback onTap;
  final bool large;

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: Motion.quick,
    lowerBound: 1,
    upperBound: 1.25,
  );

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    Feel.select();
    widget.onTap();
    if (!Motion.reduced(context)) {
      await _pop.forward();
      await _pop.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final hasCount = widget.count > 0;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: 'Reaction ${widget.emoji}, ${widget.count}',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _tap,
        child: AnimatedContainer(
          duration: Motion.quick,
          curve: Motion.easeOut,
          height: widget.large || s.isPlayful ? 44 : 34,
          padding: EdgeInsets.symmetric(horizontal: hasCount ? Gap.md : Gap.sm + 2),
          decoration: BoxDecoration(
            color: widget.selected ? c.emberSoft : c.surfaceAlt,
            borderRadius: s.isPlayful ? s.controlRadius : Radii.pill,
            border: s.isPlayful
                ? Border.all(
                    color: widget.selected ? c.ember : c.hairline,
                    width: s.borderWidth,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _pop,
                child: Text(
                  widget.emoji,
                  style: TextStyle(fontSize: widget.large || s.isPlayful ? 18 : 15),
                ),
              ),
              // Counts are hidden at zero: no zero-shaming.
              if (hasCount) ...[
                Gap.w4,
                Text(
                  '${widget.count}',
                  style: DabbleText.footnote
                      .on(widget.selected ? c.ember : c.inkSecondary)
                      .tabular
                      .copyWith(
                        fontFamily: s.roundedFamily,
                        fontWeight: widget.selected || s.isPlayful
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
