import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/teja_repository.dart';
import '../../design/components/avatar.dart';
import '../../design/components/markdown_preview.dart';
import '../../design/components/stat_row.dart';
import '../../design/components/states.dart';
import '../../design/components/teja_card.dart';
import '../../design/components/week_strip.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';
import '../auth/auth_controller.dart';

final _profileProvider =
    FutureProvider.autoDispose.family<TejaUser, String>((ref, username) {
  return ref.read(tejaRepositoryProvider).profile(username);
});

final _creationsProvider =
    FutureProvider.autoDispose.family<List<Submission>, String>((ref, username) async {
  final page = await ref.read(tejaRepositoryProvider).profileSubmissions(username);
  return page.items;
});

/// The proof screen. Two numbers and a wall of evidence that you are, in fact, a
/// person who makes things.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, this.username});

  /// null = the signed-in user's own profile (the "You" tab).
  final String? username;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final isMe = username == null;
    final me = ref.watch(authControllerProvider).user;
    final handle = username ?? me?.username;

    if (handle == null) {
      return CupertinoPageScaffold(
        backgroundColor: c.canvas,
        child: const Center(child: CupertinoActivityIndicator()),
      );
    }

    final profile = isMe && me != null
        ? AsyncData(me)
        : ref.watch(_profileProvider(handle));
    final creations = ref.watch(_creationsProvider(handle));

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(isMe ? 'You' : 'Profile', style: TejaText.title1.on(c.ink)),
            backgroundColor: c.canvas.withValues(alpha: 0.82),
            border: null,
            automaticallyImplyLeading: !isMe,
            trailing: isMe
                ? GestureDetector(
                    onTap: () => context.push('/you/settings'),
                    child: Icon(CupertinoIcons.gear, size: 22, color: c.inkSecondary),
                  )
                : null,
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              ref.invalidate(_profileProvider(handle));
              ref.invalidate(_creationsProvider(handle));
              if (isMe) await ref.read(authControllerProvider.notifier).restore();
            },
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.sm, Gap.gutter, 120),
            sliver: SliverList.list(children: [
              profile.when(
                loading: () => const _ProfileSkeleton(),
                error: (_, __) => const EmptyState(
                  icon: CupertinoIcons.person,
                  title: 'Profile not found',
                  message: 'This person may have deleted their account.',
                ),
                data: (user) => _ProfileHeader(user: user, isMe: isMe),
              ),
              Gap.h32,
              const Eyebrow('Your creations'),
              Gap.h16,
              creations.when(
                loading: () => const _GridSkeleton(),
                error: (_, __) => const SizedBox.shrink(),
                data: (items) => items.isEmpty
                    ? EmptyState(
                        icon: CupertinoIcons.sparkles,
                        title: 'Nothing here yet',
                        message: "Today's prompt is waiting.",
                        actionLabel: 'Go to today',
                        onAction: () => context.go('/today'),
                      )
                    : _CreationsGrid(items: items),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.isMe});

  final TejaUser user;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = user.displayName.isEmpty ? '@${user.username}' : user.displayName;

    return Column(
      children: [
        Avatar(name: name, url: user.avatarUrl, size: 80),
        Gap.h16,
        Text(name, style: TejaText.title1.on(c.ink)),
        Gap.h4,
        Text('@${user.username}', style: TejaText.subhead.on(c.inkTertiary)),
        if (user.bio.isNotEmpty) ...[
          Gap.h12,
          Text(
            user.bio,
            style: TejaText.callout.on(c.inkSecondary),
            textAlign: TextAlign.center,
            maxLines: 3,
          ),
        ],
        if (isMe) ...[
          Gap.h16,
          GestureDetector(
            onTap: () => context.push('/you/edit'),
            child: Text('Edit profile', style: TejaText.footnote.on(c.ember)),
          ),
        ],
        Gap.h32,
        StatRow(stats: [
          (value: '${user.streak.current}', label: 'Current'),
          (value: '${user.streak.longest}', label: 'Longest'),
          (value: '${user.streak.total}', label: 'Made'),
        ]),
        Gap.h32,
        MonthDots(
          streak: user.streak.current,
          createdToday: user.streak.lastDate != null &&
              DateUtilsX.isToday(user.streak.lastDate!),
        ),
      ],
    );
  }
}

abstract final class DateUtilsX {
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}

/// A two-column masonry: images as thumbnails, text as small cards showing the
/// first lines. Seeing your own words tiled up is the whole emotional payoff.
class _CreationsGrid extends StatelessWidget {
  const _CreationsGrid({required this.items});

  final List<Submission> items;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final left = <Submission>[];
    final right = <Submission>[];
    for (var i = 0; i < items.length; i++) {
      (i.isEven ? left : right).add(items[i]);
    }

    Widget column(List<Submission> column) => Expanded(
          child: Column(
            children: [
              for (final item in column)
                Padding(
                  padding: const EdgeInsets.only(bottom: Gap.md),
                  child: TejaCard(
                    onTap: () => context.push('/s/${item.id}'),
                    padding: item.hasImage ? EdgeInsets.zero : const EdgeInsets.all(Gap.lg),
                    child: item.hasImage
                        ? TejaImage(
                            url: item.imageUrl!,
                            aspectRatio: item.aspectRatio,
                            borderRadius: Radii.card,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MarkdownPreview(
                                item.body,
                                style: TejaText.subhead.on(c.ink),
                                maxLines: 5,
                              ),
                              Gap.h12,
                              Text(
                                item.publishedAt == null
                                    ? ''
                                    : '${item.publishedAt!.day}/${item.publishedAt!.month}',
                                style: TejaText.footnote.on(c.inkTertiary),
                              ),
                            ],
                          ),
                  ),
                ),
            ],
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [column(left), Gap.w12, column(right)],
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          Skeleton(width: 80, height: 80, borderRadius: Radii.pill),
          Gap.h16,
          Skeleton.text(width: 140),
          Gap.h12,
          Skeleton.text(width: 90),
          Gap.h32,
          Skeleton(height: 56),
        ],
      );
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) => const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Skeleton(height: 160, borderRadius: Radii.card)),
          Gap.w12,
          Expanded(child: Skeleton(height: 120, borderRadius: Radii.card)),
        ],
      );
}
