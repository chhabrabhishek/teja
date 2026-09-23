import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../tokens/colors.dart';
import '../tokens/flavor.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'dabble_press.dart';

/// A header row that cannot self-overlap.
///
/// `CupertinoNavigationBar` positions its `middle` slot at the absolute centre of
/// the bar and hands `leading`/`trailing` loose constraints, so any combination
/// wide enough to meet in the middle silently draws — and takes taps — on top of
/// its neighbour. That is fine for Apple's own compact chevron-plus-title bars
/// and wrong for our text and pill actions.
///
/// Here the three regions are laid out in a Row: each side takes exactly its own
/// width and the title gets whatever is left, truncating instead of colliding.
class DabbleHeader extends StatelessWidget {
  const DabbleHeader({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.showBack = false,
    this.height = 52,
  });

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final bool showBack;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final start = leading ?? (showBack ? const _BackButton() : null);

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.gutter),
        child: Row(
          children: [
            if (start != null) start,
            Expanded(
              child: title == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Gap.sm),
                      child: Text(
                        title!,
                        style: DabbleText.headline.on(c.ink).copyWith(
                              fontFamily: context.style.roundedFamily,
                              fontWeight: context.style.headlineWeight,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DabblePress(
      onTap: () => context.pop(),
      semanticLabel: 'Back',
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.md, horizontal: Gap.xs),
        child: Icon(CupertinoIcons.chevron_left, size: 22, color: c.ember),
      ),
    );
  }
}

/// A text action sized to its label — the safe thing to put in [DabbleHeader].
class DabbleHeaderAction extends StatelessWidget {
  const DabbleHeaderAction(
    this.label, {
    super.key,
    this.onTap,
    this.emphasis = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DabblePress(
      onTap: onTap,
      semanticLabel: label,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Gap.md, horizontal: Gap.xs),
          child: Text(
            label,
            style: DabbleText.callout
                .on(emphasis ? c.ember : c.inkSecondary)
                .copyWith(fontWeight: emphasis ? FontWeight.w600 : FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
