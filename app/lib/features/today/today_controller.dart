import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teja_repository.dart';
import '../../domain/models.dart';
import '../auth/auth_controller.dart';

/// One provider, one round trip. The Today screen never waterfalls requests.
class TodayController extends AsyncNotifier<Today> {
  @override
  Future<Today> build() => ref.read(tejaRepositoryProvider).today();

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => ref.read(tejaRepositoryProvider).today());
  }

  /// Applied the moment a publish succeeds, so returning to Today from The Spark
  /// shows the published state with no spinner and no flicker.
  void applyPublish(PublishResult result) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      mySubmission: result.submission,
      streak: result.streak,
      creatorCount: current.creatorCount + 1,
    ));
    ref.read(authControllerProvider.notifier).applyStreak(result.streak);
  }

  void applyDraft(Submission draft) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(mySubmission: draft));
  }
}

final todayControllerProvider =
    AsyncNotifierProvider<TodayController, Today>(TodayController.new);
