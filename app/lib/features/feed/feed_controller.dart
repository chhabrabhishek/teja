import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teja_repository.dart';
import '../../domain/models.dart';

@immutable
class FeedState {
  const FeedState({
    this.locked = true,
    this.creatorCount = 0,
    this.prompt,
    this.items = const [],
    this.cursor,
    this.loadingMore = false,
  });

  final bool locked;
  final int creatorCount;
  final Prompt? prompt;
  final List<Submission> items;
  final String? cursor;
  final bool loadingMore;

  bool get hasMore => cursor != null;

  FeedState copyWith({
    bool? locked,
    int? creatorCount,
    Prompt? prompt,
    List<Submission>? items,
    String? cursor,
    bool? loadingMore,
    bool clearCursor = false,
  }) =>
      FeedState(
        locked: locked ?? this.locked,
        creatorCount: creatorCount ?? this.creatorCount,
        prompt: prompt ?? this.prompt,
        items: items ?? this.items,
        cursor: clearCursor ? null : (cursor ?? this.cursor),
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

class FeedController extends AsyncNotifier<FeedState> {
  @override
  Future<FeedState> build() => _load();

  Future<FeedState> _load() async {
    final page = await ref.read(tejaRepositoryProvider).todayFeed();
    return FeedState(
      locked: page.locked,
      creatorCount: page.creatorCount,
      prompt: page.prompt,
      items: page.items,
      cursor: page.nextCursor,
    );
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  /// The feed is finite by design — one prompt, one day. Reaching the end is a
  /// feature, so there is no infinite scroll and no prefetch loop.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final page =
          await ref.read(tejaRepositoryProvider).todayFeed(cursor: current.cursor);
      state = AsyncData(current.copyWith(
        items: [...current.items, ...page.items],
        cursor: page.nextCursor,
        clearCursor: page.nextCursor == null,
        loadingMore: false,
      ));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }

  /// Optimistic: the emoji responds instantly and reverts silently on failure.
  /// A reaction is not worth an error dialog.
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

final feedControllerProvider =
    AsyncNotifierProvider<FeedController, FeedState>(FeedController.new);
