import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/api/api_exception.dart';
import '../../data/dabble_repository.dart';
import '../../domain/enums.dart';
import '../../domain/models.dart';
import '../home/home_controller.dart';

@immutable
class ComposeState {
  const ComposeState({
    this.submissionId,
    this.body = '',
    this.imageKey,
    this.imageUrl,
    this.imageWidth,
    this.imageHeight,
    this.save = ComposeSaveState.idle,
    this.uploadProgress,
    this.publishing = false,
    this.error,
    this.preview = false,
  });

  final String? submissionId;
  final String body;
  final String? imageKey;
  final String? imageUrl;
  final int? imageWidth;
  final int? imageHeight;
  final ComposeSaveState save;
  final double? uploadProgress;
  final bool publishing;
  final String? error;
  final bool preview;

  bool get hasContent => body.trim().isNotEmpty || (imageKey?.isNotEmpty ?? false);

  ComposeState copyWith({
    String? submissionId,
    String? body,
    String? imageKey,
    String? imageUrl,
    int? imageWidth,
    int? imageHeight,
    ComposeSaveState? save,
    double? uploadProgress,
    bool? publishing,
    String? error,
    bool? preview,
    bool clearError = false,
    bool clearProgress = false,
  }) =>
      ComposeState(
        submissionId: submissionId ?? this.submissionId,
        body: body ?? this.body,
        imageKey: imageKey ?? this.imageKey,
        imageUrl: imageUrl ?? this.imageUrl,
        imageWidth: imageWidth ?? this.imageWidth,
        imageHeight: imageHeight ?? this.imageHeight,
        save: save ?? this.save,
        uploadProgress: clearProgress ? null : (uploadProgress ?? this.uploadProgress),
        publishing: publishing ?? this.publishing,
        error: clearError ? null : (error ?? this.error),
        preview: preview ?? this.preview,
      );
}

/// Autosaves so a draft is never lost — not to a crash, not to a phone call, not
/// to an accidental swipe-down.
class ComposeController extends AutoDisposeNotifier<ComposeState> {
  Timer? _debounce;

  @override
  ComposeState build() {
    ref.onDispose(() => _debounce?.cancel());
    final existing = ref.read(homeControllerProvider).valueOrNull?.today?.mySubmission;
    if (existing != null && !existing.isPublished) {
      return ComposeState(
        submissionId: existing.id,
        body: existing.body,
        imageKey: existing.hasImage ? '' : null,
        imageUrl: existing.imageUrl,
        imageWidth: existing.imageWidth,
        imageHeight: existing.imageHeight,
        save: ComposeSaveState.saved,
      );
    }
    return const ComposeState();
  }

  Prompt? get _prompt => ref.read(homeControllerProvider).valueOrNull?.today?.prompt;

  void setBody(String value) {
    state = state.copyWith(body: value, save: ComposeSaveState.saving, clearError: true);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), save);
  }

  void togglePreview() => state = state.copyWith(preview: !state.preview);

  Future<void> save() async {
    final prompt = _prompt;
    if (prompt == null || !state.hasContent) return;
    try {
      final draft = await ref.read(dabbleRepositoryProvider).saveDraft(
            promptId: prompt.id,
            kind: Craft.from(prompt.category).isImage ? 'image' : 'text',
            body: state.body,
            imageKey: state.imageKey,
            imageWidth: state.imageWidth,
            imageHeight: state.imageHeight,
          );
      state = state.copyWith(submissionId: draft.id, save: ComposeSaveState.saved);
      ref.read(homeControllerProvider.notifier).applyDraft(draft);
    } on ApiException catch (e) {
      state = state.copyWith(save: ComposeSaveState.failed, error: e.message);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      maxWidth: 2000,
      imageQuality: 88,
    );
    if (file == null) return;

    state = state.copyWith(uploadProgress: 0, clearError: true);
    try {
      final bytes = await file.readAsBytes();
      final repo = ref.read(dabbleRepositoryProvider);
      final target = await repo.uploadTarget(_contentType(file.path));
      await repo.upload(target, bytes,
          onProgress: (p) => state = state.copyWith(uploadProgress: p));
      state = state.copyWith(
        imageKey: target.key,
        imageUrl: target.publicUrl,
        save: ComposeSaveState.saving,
        clearProgress: true,
      );
      await save();
    } on ApiException catch (e) {
      // The draft text is never touched by an upload failure.
      state = state.copyWith(error: e.message, clearProgress: true);
    }
  }

  Future<PublishResult?> publish() async {
    if (!state.hasContent) return null;
    state = state.copyWith(publishing: true, clearError: true);
    try {
      await save();
      final id = state.submissionId;
      if (id == null) throw ApiException('Nothing to publish yet.');
      final result = await ref.read(dabbleRepositoryProvider).publish(id);
      ref.read(homeControllerProvider.notifier).applyPublish(result);
      state = state.copyWith(publishing: false);
      return result;
    } on ApiException catch (e) {
      state = state.copyWith(publishing: false, error: e.message);
      return null;
    }
  }

  static String _contentType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.heic')) return 'image/heic';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}

final composeControllerProvider =
    AutoDisposeNotifierProvider<ComposeController, ComposeState>(ComposeController.new);
