import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/env.dart';
import '../../core/utils/date_x.dart';
import '../../design/components/aurora_background.dart';
import '../../design/components/avatar.dart';
import '../../design/components/chips.dart';
import '../../design/components/markdown_preview.dart';
import '../../design/components/prompt_hero_card.dart';
import '../../design/components/states.dart';
import '../../design/components/teja_button.dart';
import '../../design/components/teja_card.dart';
import '../../design/components/week_strip.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';
import 'today_controller.dart';

/// The hero screen.
///
/// Someone should be able to glance at this in a notification-shade preview and
/// know exactly what to make today. The prompt owns the optical centre; the
/// streak is present but small (proof, not pressure); the community is visible
/// but locked, which converts curiosity into creation.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final today = ref.watch(todayControllerProvider);

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: today.when(
            loading: () => const _TodaySkeleton(),
            // Today must never show an error card — it is the screen the habit
            // lives on. A retry affordance, warmly worded, and nothing else.
            error: (e, _) => EmptyState(
              icon: CupertinoIcons.cloud,
              title: "Can't reach today's prompt",
              message: 'Check your connection and pull to try again.',
              actionLabel: 'Try again',
              onAction: () => ref.read(todayControllerProvider.notifier).refresh(),
            ),
            data: (data) => _TodayBody(data: data),
          ),
        ),
      ),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.data});

  final Today data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final submission = data.mySubmission;
    final published = submission?.isPublished ?? false;
    final hasDraft = submission != null && !published;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            'Today',
            style: TejaText.title1.on(c.ink).copyWith(
                  fontFamily: context.style.roundedFamily,
                  fontWeight: context.style.displayWeight,
                ),
          ),
          backgroundColor:
              context.style.isPlayful ? c.canvas : const Color(0x00000000),
          border: null,
          automaticallyImplyLeading: false,
          trailing: StreakPill(
            days: data.streak.current,
            onTap: () => context.go('/you'),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () => ref.read(todayControllerProvider.notifier).refresh(),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(Gap.gutter, 0, Gap.gutter, 120),
          sliver: SliverList.list(children: [
            FadeRise(
              child: Text(
                DateTime.now().eyebrowLabel,
                style: TejaText.eyebrow.on(c.inkTertiary),
              ),
            ),
            Gap.h16,
            FadeRise(
              delay: const Duration(milliseconds: 60),
              child: PromptHeroCard(
                category: data.prompt.category,
                categoryLabel: data.prompt.categoryLabel,
                text: data.prompt.text,
                nudge: nudgeFor(
                  secondsRemaining: data.secondsRemaining,
                  streak: data.streak.current,
                  createdToday: published,
                  promptNudge: data.prompt.nudge,
                ),
                timeRemaining: published
                    ? null
                    : timeRemainingLabel(data.secondsRemaining, createdToday: false),
                onTap: published ? null : () => context.push('/compose'),
                // A free growth loop: share the prompt, not your work.
                onLongPress: () => Share.share(
                  '"${data.prompt.text}"\n\nToday on Teja — ${Env.appStoreUrl}',
                ),
              ),
            ),
            Gap.h24,
            if (published) ...[
              _PublishedCard(submission: submission!),
              Gap.h12,
              TejaButton.secondary(
                'See what others made',
                onPressed: () => context.go('/feed'),
              ),
            ] else ...[
              FadeRise(
                delay: const Duration(milliseconds: 120),
                child: TejaButton(
                  hasDraft ? 'Continue draft' : 'Start creating',
                  onPressed: () => context.push('/compose'),
                ),
              ),
              if (hasDraft) ...[
                Gap.h8,
                Center(
                  child: Text(
                    'Draft saved',
                    style: TejaText.footnote.on(c.inkTertiary),
                  ),
                ),
              ],
            ],
            Gap.h32,
            WeekStrip(streak: data.streak.current, createdToday: published),
            Gap.h32,
            _CommunityTeaser(
              count: data.creatorCount,
              unlocked: published,
              onTap: () => context.go(published ? '/feed' : '/compose'),
            ),
          ]),
        ),
      ],
    );
  }
}

/// Once you've created, the CTA stops shouting. The only Ember on the screen
/// disappears — you're done, and the app should feel done too.
class _PublishedCard extends StatelessWidget {
  const _PublishedCard({required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TejaCard(
      onTap: () => context.push('/s/${submission.id}'),
      child: Row(
        children: [
          if (submission.hasImage)
            SizedBox(
              width: 48,
              height: 48,
              child: TejaImage(url: submission.imageUrl!, borderRadius: Radii.control),
            )
          else
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.surfaceAlt, borderRadius: Radii.control),
              child: Icon(CupertinoIcons.textformat, size: 18, color: c.inkSecondary),
            ),
          Gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(CupertinoIcons.checkmark_seal_fill, size: 14, color: c.success),
                    Gap.w4,
                    Text('You created today', style: TejaText.footnote.on(c.success)),
                  ],
                ),
                Gap.h4,
                Text(
                  submission.body.isEmpty
                      ? 'Your photo'
                      : MarkdownPreview.plainText(submission.body),
                  style: TejaText.subhead.on(c.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(CupertinoIcons.chevron_right, size: 15, color: c.inkTertiary),
        ],
      ),
    );
  }
}

/// Locked, but never hostile: it shows the number of people already inside.
/// Curiosity is the strongest CTA we have.
class _CommunityTeaser extends StatelessWidget {
  const _CommunityTeaser({
    required this.count,
    required this.unlocked,
    required this.onTap,
  });

  final int count;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (count == 0) {
      return Center(
        child: Text(
          unlocked
              ? "You're first today. Others will appear through the day."
              : 'Be the first to create today.',
          style: TejaText.footnote.on(c.inkTertiary),
          textAlign: TextAlign.center,
        ),
      );
    }

    return TejaCard(
      onTap: onTap,
      elevated: false,
      color: c.surfaceAlt,
      child: Row(
        children: [
          SizedBox(
            width: 62,
            height: 28,
            child: Stack(
              children: [
                for (var i = 0; i < 3; i++)
                  Positioned(
                    left: i * 17.0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.hairline,
                        border: Border.all(color: c.surfaceAlt, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${count == 1 ? 'person' : 'people'} created today',
                  style: TejaText.subhead.on(c.ink),
                ),
                Gap.h4,
                Text(
                  unlocked ? 'See the feed' : 'Publish yours to unlock the feed',
                  style: TejaText.footnote.on(c.inkTertiary),
                ),
              ],
            ),
          ),
          Icon(
            unlocked ? CupertinoIcons.chevron_right : CupertinoIcons.lock_fill,
            size: 14,
            color: c.inkTertiary,
          ),
        ],
      ),
    );
  }
}

/// The skeleton mirrors the real layout exactly, so nothing jumps when data lands.
class _TodaySkeleton extends StatelessWidget {
  const _TodaySkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(Gap.gutter, Gap.huge, Gap.gutter, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton.text(width: 180),
          Gap.h24,
          Skeleton(height: 260, borderRadius: Radii.hero),
          Gap.h24,
          Skeleton(height: 54, borderRadius: Radii.pill),
        ],
      ),
    );
  }
}
