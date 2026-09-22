import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_controller.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'avatar.dart';
import 'teja_press.dart';

/// A pill. Flattening one side lets two buttons sit together as a single pill
/// cut in half, which is how the pair on Home reads.
class PaperButton extends StatelessWidget {
  const PaperButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = true,
    this.expand = false,
    this.loading = false,
    this.flatLeft = false,
    this.flatRight = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool primary;
  final bool expand;
  final bool loading;
  final bool flatLeft;
  final bool flatRight;

  static const double _height = 58;
  static const Radius _cut = Radius.circular(14);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final background = primary ? c.ember : c.surfaceAlt;
    final foreground = primary ? c.onEmber : c.ink;
    final enabled = onTap != null && !loading;
    const round = Radius.circular(_height / 2);

    return TejaPress(
      onTap: enabled ? onTap : null,
      semanticLabel: label,
      child: Opacity(
        opacity: enabled ? 1 : 0.45,
        child: Container(
          height: _height,
          width: expand ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: Gap.xxl),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.horizontal(
              left: flatLeft ? _cut : round,
              right: flatRight ? _cut : round,
            ),
          ),
          child: loading
              ? CupertinoActivityIndicator(color: foreground, radius: 9)
              : Text(label, style: TejaText.headline.on(foreground)),
        ),
      ),
    );
  }
}

/// The persistent top row: an optional back chevron on the left, streak and
/// avatar on the right. Replaces the navigation bar everywhere, so the same
/// controls sit in the same place on every screen.
class PaperHeader extends ConsumerWidget {
  const PaperHeader({
    super.key,
    this.showBack = true,
    this.title,
    this.trailing,
  });

  final bool showBack;
  final String? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = ref.watch(authControllerProvider).user;
    final name = (user?.displayName.isNotEmpty ?? false)
        ? user!.displayName
        : (user?.username ?? '?');
    final streak = user?.streak.current ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.sm, Gap.xl, Gap.sm),
      child: Row(
        children: [
          if (showBack && Navigator.of(context).canPop())
            TejaPress(
              onTap: () => context.pop(),
              semanticLabel: 'Back',
              child: Padding(
                padding: const EdgeInsets.all(Gap.sm),
                child: Icon(CupertinoIcons.chevron_left, size: 22, color: c.ink),
              ),
            ),
          if (title != null) ...[
            Gap.w8,
            Expanded(
              child: Text(
                title!,
                style: TejaText.headline.on(c.ink),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          if (trailing != null) trailing!,
          StreakPill(streak: streak),
          Gap.w12,
          Avatar(
            name: name,
            url: user?.avatarUrl,
            size: 40,
            onTap: () => context.push('/you'),
          ),
        ],
      ),
    );
  }
}

class StreakPill extends StatelessWidget {
  const StreakPill({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 28,
      constraints: const BoxConstraints(minWidth: 44),
      padding: const EdgeInsets.symmetric(horizontal: Gap.md),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Text(
        streak > 0 ? '$streak' : '—',
        style: TejaText.footnote.on(c.inkSecondary).tabular,
      ),
    );
  }
}
