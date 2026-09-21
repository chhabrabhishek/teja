import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teja_repository.dart';
import '../../domain/models.dart';

enum FeedScope { today, all }

@immutable
class FeedState {
  const FeedState({
    this.scope = FeedScope.today,
    this.locked = true,
    this.creatorCount = 0,
    this.prompt,
    this.items = const [],
    this.cursor,
    this.loadingMore = false,
  });

  final FeedScope scope;
  final bool locked;
  final int creatorCount;
  final Prompt? prompt;
  final List<Submission> items;
  final String? cursor;
  final bool loadingMore;

  bool get hasMore => cursor != null;

  FeedState copyWith({
    FeedScope? scope,
    bool? locked,
    int? creatorCount,
    Prompt? prompt,
    List<Submission>? items,
    String? cursor,
    bool? loadingMore,
    bool clearCursor = false,
  }) =>
      FeedState(
        scope: scope ?? this.scope,
        locked: locked ?? this.locked,
        creatorCount: creatorCount ?? this.creatorCount,
        prompt: prompt ?? this.prompt,
        items: items ?? this.items,
        cursor: clearCursor ? null : (cursor ?? this.cursor),
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

class FeedController extends AsyncNotifier<FeedState> {
  FeedScope _scope = FeedScope.today;

  @override
  Future<FeedState> build() => _load(_scope);

  Future<FeedState> _load(FeedScope scope) async {
    final repo = ref.read(tejaRepositoryProvider);
    final page =
        scope == FeedScope.today ? await repo.todayFeed() : await repo.allFeed();
    return FeedState(
      scope: scope,
      locked: page.locked,
      creatorCount: page.creatorCount,
      prompt: page.prompt,
      items: page.items,
      cursor: page.nextCursor,
    );
  }

  Future<void> setScope(FeedScope scope) async {
    if (_scope == scope) return;
    _scope = scope;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(scope));
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _load(_scope));
  }

  /// Today's feed is finite by design — one prompt, one day — so reaching the
  /// end is a feature. All-time pages properly.
  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || current.loadingMore || !current.hasMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final repo = ref.read(tejaRepositoryProvider);
      final page = current.scope == FeedScope.today
          ? await repo.todayFeed(cursor: current.cursor)
          : await repo.allFeed(cursor: current.cursor);
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
