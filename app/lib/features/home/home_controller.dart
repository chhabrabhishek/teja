import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teja_repository.dart';
import '../../domain/models.dart';
import '../auth/auth_controller.dart';
import '../auth/topic_picker.dart';

/// Everything the one-page home needs: the hero prompt and the scrolling feed
/// beneath it, kept in one controller so the page never shows two spinners.
class HomeState {
  const HomeState({
    this.today,
    this.topics = const [],
    this.items = const [],
    this.cursor,
    this.feedLocked = false,
    this.loadingMore = false,
    this.activeTopicId,
  });

  final Today? today;
  final List<Topic> topics;
  final List<Submission> items;
  final String? cursor;
  final bool feedLocked;
  final bool loadingMore;
  final String? activeTopicId;

  bool get hasMore => cursor != null;
  bool get createdToday => today?.mySubmission?.isPublished ?? false;

  HomeState copyWith({
    Today? today,
    List<Topic>? topics,
    List<Submission>? items,
    String? cursor,
    bool? feedLocked,
    bool? loadingMore,
    String? activeTopicId,
    bool clearCursor = false,
    bool clearTopic = false,
  }) =>
      HomeState(
        today: today ?? this.today,
        topics: topics ?? this.topics,
        items: items ?? this.items,
        cursor: clearCursor ? null : (cursor ?? this.cursor),
        feedLocked: feedLocked ?? this.feedLocked,
        loadingMore: loadingMore ?? this.loadingMore,
        activeTopicId: clearTopic ? null : (activeTopicId ?? this.activeTopicId),
      );
}

class HomeController extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() => _load();

  Future<HomeState> _load({String? topicId}) async {
    final repo = ref.read(tejaRepositoryProvider);
    // Fired together rather than chained: the hero and the feed are one screen.
    final results = await Future.wait([
      repo.today(),
      repo.allFeed(topicId: topicId),
      repo.topics(),
    ]);
    final today = results[0] as Today;
    final feed = results[1] as FeedPage;
    final topics = results[2] as List<Topic>;

    return HomeState(
      today: today,
      topics: topics,
      items: feed.items,
      cursor: feed.nextCursor,
      feedLocked: feed.locked,
      activeTopicId: topicId,
    );
  }

  Future<void> refresh() async {
    final topicId = state.valueOrNull?.activeTopicId;
    state = await AsyncValue.guard(() => _load(topicId: topicId));
  }

  Future<void> selectTopic(String? topicId) async {
    final current = state.valueOrNull;
    if (current == null || current.activeTopicId == topicId) return;
    state = AsyncData(current.copyWith(
      items: const [],
      loadingMore: true,
      activeTopicId: topicId,
      clearTopic: topicId == null,
      clearCursor: true,
    ));
    try {
      final feed = await ref.read(tejaRepositoryProvider).allFeed(topicId: topicId);
      state = AsyncData(current.copyWith(
        items: feed.items,
        cursor: feed.nextCursor,
        clearCursor: feed.nextCursor == null,
        feedLocked: feed.locked,
        loadingMore: false,
        activeTopicId: topicId,
        clearTopic: topicId == null,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final feed = await ref.read(tejaRepositoryProvider).allFeed(
            cursor: current.cursor,
            topicId: current.activeTopicId,
          );
      state = AsyncData(current.copyWith(
        items: [...current.items, ...feed.items],
        cursor: feed.nextCursor,
        clearCursor: feed.nextCursor == null,
        loadingMore: false,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  /// Applied the moment a publish succeeds, so returning from The Spark shows
  /// the published state with no spinner and no flicker.
  void applyPublish(PublishResult result) {
    final current = state.valueOrNull;
    final today = current?.today;
    if (current == null || today == null) return;
    state = AsyncData(current.copyWith(
      today: today.copyWith(
        mySubmission: result.submission,
        streak: result.streak,
        creatorCount: today.creatorCount + 1,
      ),
    ));
    ref.read(authControllerProvider.notifier).applyStreak(result.streak);
    // Publishing is what unlocks the feed, so it has to be re-fetched.
    refresh();
  }

  void applyDraft(Submission draft) {
    final current = state.valueOrNull;
    final today = current?.today;
    if (current == null || today == null) return;
    state = AsyncData(current.copyWith(today: today.copyWith(mySubmission: draft)));
  }

  /// Optimistic; reverts silently. A reaction is not worth an error dialog.
  Future<void> react(String submissionId, String emoji, bool on) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final previous = current.items;
    state = AsyncData(current.copyWith(
      items: [
        for (final item in previous)
          if (item.id == submissionId) _applyReaction(item, emoji, on) else item,
      ],
    ));
    try {
      await ref.read(tejaRepositoryProvider).react(submissionId, emoji, on: on);
    } catch (_) {
      state = AsyncData((state.valueOrNull ?? current).copyWith(items: previous));
    }
  }

  static Submission _applyReaction(Submission s, String emoji, bool on) {
    final counts = Map<String, int>.from(s.reactionCounts);
    counts[emoji] = ((counts[emoji] ?? 0) + (on ? 1 : -1)).clamp(0, 1 << 30);
    if (counts[emoji] == 0) counts.remove(emoji);
    return s.copyWith(
      reactionCounts: counts,
      myReactions: on
          ? [...s.myReactions, emoji]
          : s.myReactions.where((e) => e != emoji).toList(),
      reactionCount: (s.reactionCount + (on ? 1 : -1)).clamp(0, 1 << 30),
    );
  }
}

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomeState>(HomeController.new);

/// Re-exported so screens don't import the picker just for the topic list.
final homeTopicsProvider = topicsProvider;
