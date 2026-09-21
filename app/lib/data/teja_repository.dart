import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../domain/models.dart';
import 'auth_repository.dart';

class TejaRepository {
  TejaRepository(this._api);

  final ApiClient _api;

  // --- today ---------------------------------------------------------------

  Future<Today> today() async =>
      Today.fromJson(await _api.get<Map<String, dynamic>>('/prompts/today'));

  // --- compose -------------------------------------------------------------

  Future<Submission> saveDraft({
    required String promptId,
    required String kind,
    required String body,
    String? imageKey,
    int? imageWidth,
    int? imageHeight,
  }) async =>
      Submission.fromJson(await _api.post<Map<String, dynamic>>(
        '/submissions',
        body: {
          'prompt_id': promptId,
          'kind': kind,
          'body': body,
          if (imageKey != null) 'image_key': imageKey,
          if (imageWidth != null) 'image_width': imageWidth,
          if (imageHeight != null) 'image_height': imageHeight,
        },
      ));

  Future<PublishResult> publish(String submissionId) async =>
      PublishResult.fromJson(
        await _api.post<Map<String, dynamic>>('/submissions/$submissionId/publish'),
      );

  Future<UploadTarget> uploadTarget(String contentType, {String purpose = 'submission'}) async =>
      UploadTarget.fromJson(await _api.post<Map<String, dynamic>>(
        '/media/upload-url',
        body: {'content_type': contentType, 'purpose': purpose},
      ));

  Future<void> upload(UploadTarget target, List<int> bytes,
          {void Function(double)? onProgress}) =>
      _api.uploadBytes(
        url: target.uploadUrl,
        bytes: bytes,
        headers: target.headers,
        onProgress: onProgress,
      );

  // --- topics --------------------------------------------------------------

  Future<List<Topic>> topics() async {
    final raw = await _api.get<List<dynamic>>('/topics');
    return raw.map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Topic>> setTopics(List<String> topicIds) async {
    final raw = await _api.put<List<dynamic>>('/topics/me', body: {'topic_ids': topicIds});
    return raw.map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList();
  }

  // --- feed ----------------------------------------------------------------

  Future<FeedPage> todayFeed({String? cursor}) async => FeedPage.fromJson(
        await _api.get<Map<String, dynamic>>(
          '/feed/today',
          query: {if (cursor != null) 'cursor': cursor},
        ),
      );

  Future<FeedPage> allFeed({String? cursor, String? topicId}) async =>
      FeedPage.fromJson(
        await _api.get<Map<String, dynamic>>(
          '/feed/all',
          query: {
            if (cursor != null) 'cursor': cursor,
            if (topicId != null) 'topic_id': topicId,
          },
        ),
      );

  Future<Submission> submission(String id) async =>
      Submission.fromJson(await _api.get<Map<String, dynamic>>('/submissions/$id'));

  Future<void> deleteSubmission(String id) => _api.delete('/submissions/$id');

  // --- reactions + comments -------------------------------------------------

  Future<void> react(String submissionId, String emoji, {required bool on}) async {
    final path = '/submissions/$submissionId/reactions/${Uri.encodeComponent(emoji)}';
    if (on) {
      await _api.put<Map<String, dynamic>>(path);
    } else {
      await _api.delete(path);
    }
  }

  Future<CommentPage> comments(String submissionId, {String? cursor}) async =>
      CommentPage.fromJson(await _api.get<Map<String, dynamic>>(
        '/submissions/$submissionId/comments',
        query: {if (cursor != null) 'cursor': cursor},
      ));

  Future<Comment> addComment(String submissionId, String body, {String? parentId}) async =>
      Comment.fromJson(await _api.post<Map<String, dynamic>>(
        '/submissions/$submissionId/comments',
        body: {'body': body, if (parentId != null) 'parent_id': parentId},
      ));

  Future<void> report({String? submissionId, String? commentId, required String reason}) =>
      _api.post<Map<String, dynamic>>('/reports', body: {
        'submission_id': submissionId,
        'comment_id': commentId,
        'reason': reason,
      });

  Future<void> block(String username) =>
      _api.post<void>('/users/$username/block');

  // --- profiles ------------------------------------------------------------

  Future<TejaUser> profile(String username) async =>
      TejaUser.fromJson(await _api.get<Map<String, dynamic>>('/users/$username'));

  Future<SubmissionPage> profileSubmissions(String username, {String? cursor}) async =>
      SubmissionPage.fromJson(await _api.get<Map<String, dynamic>>(
        '/users/$username/submissions',
        query: {if (cursor != null) 'cursor': cursor},
      ));
}

final tejaRepositoryProvider = Provider<TejaRepository>(
  (ref) => TejaRepository(ref.watch(apiClientProvider)),
);
