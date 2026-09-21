import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/chips.dart';
import '../../design/components/states.dart';
import '../../design/components/submission_card.dart';
import '../../design/components/teja_button.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import 'feed_controller.dart';

/// A campfire, not a timeline.
///
/// It is finite — only today's prompt — and that finiteness is the point. You can
/// reach the end, and when you do we say so. No infinite scroll, no algorithm, no
/// "suggested for you".
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
        ref.read(feedControllerProvider.notifier).loadMore();
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
    final feed = ref.watch(feedControllerProvider);

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: feed.when(
        loading: () => const _FeedSkeleton(),
        error: (e, _) => EmptyState(
          icon: CupertinoIcons.cloud,
          title: 'Feed is out of reach',
          message: 'Check your connection and try again.',
          actionLabel: 'Try again',
          onAction: () => ref.read(feedControllerProvider.notifier).refresh(),
        ),
        data: (state) => state.locked
            ? (state.scope == FeedScope.today
                ? _LockedFeed(count: state.creatorCount)
                : const _LockedAllTime())
            : _UnlockedFeed(state: state, controller: _scroll),
      ),
    );
  }
}

/// Two modes, deliberately different: Today is the campfire and is re-earned
/// daily; All time is the archive and is earned once.
class _ScopeSwitcher extends ConsumerWidget {
  const _ScopeSwitcher({required this.scope});

  final FeedScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.sm, Gap.gutter, Gap.md),
      child: CupertinoSlidingSegmentedControl<FeedScope>(
        groupValue: scope,
        backgroundColor: c.surfaceAlt,
        thumbColor: c.surface,
        onValueChanged: (value) {
          if (value != null) {
            Feel.select();
            ref.read(feedControllerProvider.notifier).setScope(value);
          }
        },
        children: {
          FeedScope.today: Padding(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Text('Today', style: TejaText.subhead.on(c.ink)),
          ),
          FeedScope.all: Padding(
            padding: const EdgeInsets.symmetric(vertical: Gap.sm),
            child: Text('All time', style: TejaText.subhead.on(c.ink)),
          ),
        },
      ),
    );
  }
}

class _LockedAllTime extends StatelessWidget {
  const _LockedAllTime();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        const _ScopeSwitcher(scope: FeedScope.all),
        Expanded(
          child: EmptyState(
            icon: CupertinoIcons.lock_fill,
            title: 'Make one thing first',
            message:
                'The archive opens once you have created something yourself. '
                'Just once — not every day.',
            actionLabel: 'Go to today',
            onAction: () => context.go('/today'),
          ),
        ),
      ],
    );
  }
}

class _UnlockedFeed extends ConsumerWidget {
  const _UnlockedFeed({required this.state, required this.controller});

  final FeedState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final notifier = ref.read(feedControllerProvider.notifier);

    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            state.scope == FeedScope.today ? "Today's Feed" : 'All time',
            style: TejaText.title1.on(c.ink).copyWith(
                  fontFamily: context.style.roundedFamily,
                  fontWeight: context.style.displayWeight,
                ),
          ),
          backgroundColor: c.canvas.withValues(alpha: 0.82),
          border: null,
          automaticallyImplyLeading: false,
        ),
        CupertinoSliverRefreshControl(onRefresh: notifier.refresh),
        SliverToBoxAdapter(child: _ScopeSwitcher(scope: state.scope)),
        if (state.prompt != null && state.scope == FeedScope.today)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.sm, Gap.gutter, Gap.lg),
              child: Row(
                children: [
                  CategoryChip(
                    category: state.prompt!.category,
                    label: state.prompt!.categoryLabel,
                  ),
                  Gap.w12,
                  Expanded(
                    child: Text(
                      state.prompt!.text,
                      style: TejaText.footnote.on(c.inkSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (state.items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: CupertinoIcons.sparkles,
              title: state.scope == FeedScope.today
                  ? "You're first today"
                  : 'Nothing here yet',
              message: state.scope == FeedScope.today
                  ? 'Others will appear through the day. Come back tonight.'
                  : 'Creations in your topics will collect here.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(Gap.gutter, 0, Gap.gutter, Gap.section),
            sliver: SliverList.separated(
              itemCount: state.items.length,
              separatorBuilder: (_, __) => Gap.h16,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return SubmissionCard(
                  submission: item,
                  onTap: () => context.push('/s/${item.id}'),
                  onAuthorTap: () => context.push('/u/${item.author.username}'),
                  onReact: (emoji, selected) => notifier.react(item.id, emoji, selected),
                );
              },
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 110),
            child: Center(
              child: state.loadingMore
                  ? const CupertinoActivityIndicator()
                  : state.items.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          state.scope == FeedScope.today
                              ? "That's everyone so far."
                              : "You've reached the beginning.",
                          style: TejaText.footnote.on(c.inkTertiary),
                        ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The lock is not an error and must never look like one. It shows real cards,
/// blurred, plus the number of people already inside — curiosity is the strongest
/// call to action we have.
class _LockedFeed extends StatelessWidget {
  const _LockedFeed({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Opacity(
                opacity: 0.55,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.gutter, 120, Gap.gutter, 0),
                  child: Column(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        Container(
                          height: 180 - i * 20,
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: Radii.card,
                          ),
                        ),
                        Gap.h16,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: FadeRise(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.section),
              child: Container(
                padding: const EdgeInsets.all(Gap.xxl),
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: Radii.hero,
                  border: Border.all(color: c.hairline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.lock_fill, size: 22, color: c.inkTertiary),
                    Gap.h16,
                    Text('Create to unlock', style: TejaText.title2.on(c.ink)),
                    Gap.h8,
                    Text(
                      count == 0
                          ? 'Nobody has created yet today. Go first.'
                          : 'See what $count ${count == 1 ? 'person' : 'people'} made from today\'s prompt.',
                      style: TejaText.callout.on(c.inkSecondary),
                      textAlign: TextAlign.center,
                    ),
                    Gap.h24,
                    TejaButton(
                      'Start creating',
                      onPressed: () => context.push('/compose'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeedSkeleton extends StatelessWidget {
  const _FeedSkeleton();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(Gap.gutter, 120, Gap.gutter, 0),
        child: Column(
          children: [
            Skeleton(height: 200, borderRadius: Radii.card),
            Gap.h16,
            Skeleton(height: 240, borderRadius: Radii.card),
            Gap.h16,
            Skeleton(height: 180, borderRadius: Radii.card),
          ],
        ),
      );
}
