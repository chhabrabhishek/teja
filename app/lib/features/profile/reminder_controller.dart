import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications.dart';
import '../../data/auth_repository.dart';
import '../../data/push_repository.dart';
import '../auth/auth_controller.dart';

@immutable
class ReminderState {
  const ReminderState({
    this.hour,
    this.granted = false,
    this.scheduled = false,
    this.asked = false,
  });

  final int? hour;
  final bool granted;
  final bool scheduled;

  /// Whether we've already asked for permission this install.
  final bool asked;

  bool get isOn => hour != null && granted && scheduled;

  ReminderState copyWith({int? hour, bool? granted, bool? scheduled, bool? asked, bool clearHour = false}) =>
      ReminderState(
        hour: clearHour ? null : (hour ?? this.hour),
        granted: granted ?? this.granted,
        scheduled: scheduled ?? this.scheduled,
        asked: asked ?? this.asked,
      );
}

/// Keeps the single daily local notification in sync with the user's saved hour.
class ReminderController extends Notifier<ReminderState> {
  @override
  ReminderState build() {
    // The server is the source of truth for the hour; the device owns the schedule.
    ref.listen(
      authControllerProvider.select((s) => s.user?.reminderHour),
      (previous, next) {
        if (previous != next) _sync(next);
      },
    );
    Future.microtask(() => _sync(ref.read(authControllerProvider).user?.reminderHour));
    return const ReminderState();
  }

  NotificationService get _service => ref.read(notificationServiceProvider);

  Future<void> _sync(int? hour) async {
    final granted = await _service.hasPermission();
    if (hour == null || !granted) {
      await _service.cancel();
      state = state.copyWith(hour: hour, granted: granted, scheduled: false, clearHour: hour == null);
      return;
    }
    await _service.scheduleDaily(hour: hour, timezoneName: await localTimezone());
    state = state.copyWith(
      hour: hour,
      granted: true,
      scheduled: await _service.isScheduled(),
    );
    // Cheap and idempotent: catches tokens that rotate between launches.
    unawaited(ref.read(pushRepositoryProvider).syncToken());
  }

  /// Asked once, after the first publish — never on cold launch.
  Future<bool> askPermission() async {
    state = state.copyWith(asked: true);
    final granted = await _service.requestPermission();
    state = state.copyWith(granted: granted);
    if (granted) {
      final hour = ref.read(authControllerProvider).user?.reminderHour ?? 9;
      if (ref.read(authControllerProvider).user?.reminderHour == null) {
        await ref.read(authControllerProvider.notifier).updateProfile({'reminder_hour': hour});
      }
      await _sync(hour);
      // The same grant covers push; the token only exists once authorised.
      await ref.read(pushRepositoryProvider).syncToken();
    }
    return granted;
  }

  Future<void> setHour(int? hour) async {
    await ref.read(authControllerProvider.notifier).updateProfile({'reminder_hour': hour});
    if (hour != null && !state.granted) {
      await askPermission();
      return;
    }
    await _sync(hour);
  }
}

final reminderControllerProvider =
    NotifierProvider<ReminderController, ReminderState>(ReminderController.new);
