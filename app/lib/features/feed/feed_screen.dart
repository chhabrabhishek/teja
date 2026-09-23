import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/date_x.dart';
import '../../design/components/avatar.dart';
import '../../design/components/markdown_preview.dart';
import '../../design/components/paper.dart';
import '../../design/components/dabble_press.dart';
import '../../design/components/torn_edge.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';
import '../auth/auth_controller.dart';
import '../home/home_controller.dart';

/// Everything everyone has made, newest first, filtered by topic. Reached from
/// the Feed button on Home — never a tab, so it stays a place you choose to go.
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 600) {
        ref.read(homeControllerProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final home = ref.watch(homeControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final name = user?.displayName.isNotEmpty == true
        ? user!.displayName
        : (user?.username ?? 'there');

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: SafeArea(
        bottom: false,
        child: home.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Gap.large),
              child: PaperButton(
                label: 'Try again',
                primary: false,
                onTap: () => ref.read(homeControllerProvider.notifier).refresh(),
              ),
            ),
          ),
          data: (state) => CustomScrollView(
            controller: _scroll,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: FeedGreeting(
                  name: name,
                  streak: state.today?.streak.current ?? 0,
                  avatarUrl: user?.avatarUrl,
                  showBack: true,
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () =>
                    ref.read(homeControllerProvider.notifier).refresh(),
              ),
              if (state.topics.isNotEmpty)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _ChipsHeader(
                    topics: state.topics,
                    activeId: state.activeTopicId,
                    canvas: c.canvas,
                    onSelect: (id) =>
                        ref.read(homeControllerProvider.notifier).selectTopic(id),
                  ),
                ),
              if (state.feedLocked)
                SliverToBoxAdapter(
                  child: _FeedLocked(onCreate: () => context.push('/compose')),
                )
              else
                _FeedSlivers(items: state.items),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Gap.section),
                  child: Center(
                    child: state.loadingMore
                        ? const CupertinoActivityIndicator()
                        : Text(
                            state.items.isEmpty && !state.feedLocked
                                ? 'Nothing here yet.'
                                : "You've reached the beginning.",
                            style: DabbleText.footnote.on(c.inkTertiary),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The same greeting row on Home and Feed, so the two screens read as one place.
class FeedGreeting extends StatelessWidget {
  const FeedGreeting({
    super.key,
    required this.name,
    required this.streak,
    this.avatarUrl,
    this.showBack = false,
  });

  final String name;
  final int streak;
  final String? avatarUrl;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.fromLTRB(showBack ? Gap.md : Gap.xxl, Gap.lg, Gap.xl, Gap.sm),
      child: Row(
        children: [
          if (showBack)
            DabblePress(
              onTap: () => context.pop(),
              semanticLabel: 'Back',
              child: Padding(
                padding: const EdgeInsets.all(Gap.sm),
                child: Icon(CupertinoIcons.chevron_left, size: 22, color: c.ink),
              ),
            ),
          Expanded(
            child: Text(
              'Hi,\n$name',
              style: DabbleText.title2.on(c.inkSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          StreakPill(streak: streak),
          Gap.w12,
          Avatar(
            name: name,
            url: avatarUrl,
            size: 40,
            onTap: () => context.push('/you'),
          ),
        ],
      ),
    );
  }
}

class _ChipsHeader extends SliverPersistentHeaderDelegate {
  _ChipsHeader({
    required this.topics,
    required this.activeId,
    required this.onSelect,
    required this.canvas,
  });

  final List<Topic> topics;
  final String? activeId;
  final ValueChanged<String?> onSelect;

  /// Captured at build time: a persistent header won't repaint on a theme
  /// change unless something it compares in [shouldRebuild] actually differs.
  final Color canvas;

  /// Roots plus their children, flattened — the chip row is a filter, not a tree.
  List<Topic> get _leaves => [
        for (final root in topics) ...root.children,
      ];

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final c = context.colors;
    return Container(
      color: c.canvas,
      alignment: Alignment.centerLeft,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Gap.xl, vertical: Gap.sm),
        children: [
          _Chip(label: 'All', selected: activeId == null, onTap: () => onSelect(null)),
          for (final topic in _leaves)
            _Chip(
              label: topic.name,
              selected: activeId == topic.id,
              onTap: () => onSelect(topic.id),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_ChipsHeader old) =>
      old.activeId != activeId || old.topics != topics || old.canvas != canvas;
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(right: Gap.sm),
      child: DabblePress(
        onTap: onTap,
        semanticLabel: label,
        child: AnimatedContainer(
          duration: Motion.quick,
          curve: Motion.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? c.ink : c.surfaceAlt,
            borderRadius: const BorderRadius.all(Radius.circular(999)),
          ),
          child: Text(
            label,
            style: DabbleText.subhead.on(selected ? c.canvas : c.ink),
          ),
        ),
      ),
    );
  }
}

/// Feed entries, each a receipt segment with a torn edge above and below.
class _FeedSlivers extends ConsumerWidget {
  const _FeedSlivers({required this.items});

  final List<Submission> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? lastLabel;
    final children = <Widget>[];

    for (final item in items) {
      final label = _dayLabel(item.publishedAt);
      if (label != lastLabel) {
        children.add(Padding(
          padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.lg, Gap.xxl, Gap.sm),
          child: DateDivider(label: label),
        ));
        lastLabel = label;
      }
      children.add(_FeedEntry(submission: item));
    }

    return SliverList(delegate: SliverChildListDelegate(children));
  }

  static String _dayLabel(DateTime? when) {
    if (when == null) return 'Earlier';
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day)
        .difference(DateTime(when.year, when.month, when.day))
        .inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return when.eyebrowLabel.split(' · ').last;
  }
}

class _FeedEntry extends ConsumerWidget {
  const _FeedEntry({required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final author = submission.author;
    final name = author.displayName.isEmpty ? author.username : author.displayName;

    return DabblePress(
      onTap: () => context.push('/s/${submission.id}'),
      child: Padding(
        padding: const EdgeInsets.only(bottom: Gap.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.xxl, 0, Gap.xxl, Gap.md),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: c.glow, shape: BoxShape.circle),
                  ),
                  Gap.w8,
                  Expanded(
                    child: Text(
                      name,
                      style: DabbleText.subhead.on(c.ember),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (submission.publishedAt != null)
                    Text(
                      submission.publishedAt!.shortAgo,
                      style: DabbleText.footnote.on(c.inkTertiary),
                    ),
                ],
              ),
            ),
            ReceiptCard(
              padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.lg, Gap.xxl, Gap.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (submission.hasImage) ...[
                    DabbleImage(
                      url: submission.imageUrl!,
                      aspectRatio: submission.aspectRatio,
                    ),
                    if (submission.body.isNotEmpty) Gap.h12,
                  ],
                  if (submission.body.isNotEmpty)
                    MarkdownPreview(
                      submission.body,
                      style: DabbleText.body.on(c.ink),
                      maxLines: 4,
                    ),
                ],
              ),
            ),
            if (submission.commentCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.md, Gap.xxl, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${submission.commentCount} '
                    '${submission.commentCount == 1 ? "Comment" : "Comments"}',
                    style: DabbleText.footnote.on(c.inkTertiary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeedLocked extends StatelessWidget {
  const _FeedLocked({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.large, Gap.xxl, Gap.large),
      child: Column(
        children: [
          Icon(CupertinoIcons.lock, size: 20, color: c.inkTertiary),
          Gap.h16,
          Text('Make one thing first', style: DabbleText.title2.on(c.ink)),
          Gap.h8,
          Text(
            'The feed opens once you have made something yourself. '
            'Just once — not every day.',
            style: DabbleText.callout.on(c.inkSecondary),
            textAlign: TextAlign.center,
          ),
          Gap.h24,
          PaperButton(label: "Let's Go", onTap: onCreate),
        ],
      ),
    );
  }
}
