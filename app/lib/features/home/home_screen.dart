import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/paper.dart';
import '../../design/components/torn_edge.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../auth/auth_controller.dart';
import '../feed/feed_screen.dart';
import 'home_controller.dart';

/// One screenful: who you are, what today asks of you, and the two ways out —
/// make something, or go and read what everyone else made.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final home = ref.watch(homeControllerProvider);
    final user = ref.watch(authControllerProvider).user;

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: SafeArea(
        bottom: false,
        child: home.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => _HomeError(
            onRetry: () => ref.read(homeControllerProvider.notifier).refresh(),
          ),
          data: (state) => CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: FeedGreeting(
                  name: user?.displayName.isNotEmpty == true
                      ? user!.displayName
                      : (user?.username ?? 'there'),
                  streak: state.today?.streak.current ?? 0,
                  avatarUrl: user?.avatarUrl,
                ),
              ),
              CupertinoSliverRefreshControl(
                onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
              ),
              SliverFillRemaining(
                child: _Hero(
                  state: state,
                  onCreate: () => context.push('/compose'),
                  onFeed: () => context.push('/feed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The first screenful: what today is about, the prompt, and the two actions.
class _Hero extends StatelessWidget {
  const _Hero({required this.state, required this.onCreate, required this.onFeed});

  final HomeState state;
  final VoidCallback onCreate;
  final VoidCallback onFeed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final prompt = state.today?.prompt;
    if (prompt == null) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Today we are going to',
                  style: DabbleText.callout.on(c.inkSecondary),
                ),
                Gap.h4,
                Text(
                  prompt.topicName ?? prompt.categoryLabel,
                  style: DabbleText.title2.on(c.ink),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ReceiptCard(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.xxl,
              vertical: Gap.lg,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  prompt.text,
                  style: DabbleText.displayXL.on(c.ember),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.lg),
            child: Row(
              children: [
                SizedBox(
                  width: 132,
                  child: PaperButton(
                    label: 'Feed',
                    onTap: onFeed,
                    primary: false,
                    expand: true,
                    flatRight: true,
                  ),
                ),
                Gap.w8,
                Expanded(
                  child: PaperButton(
                    label: state.createdToday ? 'Done today' : "Let's Go",
                    onTap: state.createdToday ? null : onCreate,
                    expand: true,
                    flatLeft: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HomeError extends StatelessWidget {
  const _HomeError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Can't reach today's prompt", style: DabbleText.title2.on(c.ink)),
            Gap.h8,
            Text(
              'Check your connection.',
              style: DabbleText.callout.on(c.inkSecondary),
            ),
            Gap.h24,
            PaperButton(label: 'Try again', onTap: onRetry, primary: false),
          ],
        ),
      ),
    );
  }
}
