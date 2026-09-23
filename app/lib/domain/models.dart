import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Run `dart run build_runner build --delete-conflicting-outputs` after editing.

@freezed
abstract class Streak with _$Streak {
  const factory Streak({
    @Default(0) int current,
    @Default(0) int longest,
    @Default(0) int total,
    @JsonKey(name: 'last_date') DateTime? lastDate,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}

@freezed
abstract class DabbleUser with _$DabbleUser {
  const factory DabbleUser({
    required String id,
    required String username,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @Default('') String bio,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? email,
    @Default('UTC') String timezone,
    @JsonKey(name: 'reminder_hour') int? reminderHour,
    @JsonKey(name: 'preferred_categories') @Default(<String>[]) List<String> preferredCategories,
    @Default(Streak()) Streak streak,
  }) = _DabbleUser;

  factory DabbleUser.fromJson(Map<String, dynamic> json) => _$DabbleUserFromJson(json);
}

@freezed
abstract class Topic with _$Topic {
  const Topic._();

  const factory Topic({
    required String id,
    required String slug,
    required String name,
    @Default('') String blurb,
    @Default('writing') String craft,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'accepts_prompts') @Default(true) bool acceptsPrompts,
    @JsonKey(name: 'subscriber_count') @Default(0) int subscriberCount,
    @JsonKey(name: 'is_selected') @Default(false) bool isSelected,
    @Default(<Topic>[]) List<Topic> children,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  bool get isRoot => parentId == null;

  /// A root counts as chosen when it, or any child, is selected.
  bool get hasSelection =>
      isSelected || children.any((c) => c.isSelected || c.hasSelection);
}

@freezed
abstract class Prompt with _$Prompt {
  const factory Prompt({
    required String id,
    required DateTime date,
    required String category,
    @JsonKey(name: 'category_label') required String categoryLabel,
    @Default('text') String kind,
    required String text,
    @Default('Five minutes is enough.') String nudge,
    @JsonKey(name: 'topic_id') String? topicId,
    @JsonKey(name: 'topic_name') String? topicName,
    @JsonKey(name: 'topic_path') String? topicPath,
  }) = _Prompt;

  factory Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);
}

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String id,
    required String username,
    @JsonKey(name: 'display_name') @Default('') String displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(0) int streak,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

@freezed
abstract class Submission with _$Submission {
  const Submission._();

  const factory Submission({
    required String id,
    @Default('text') String kind,
    @Default('') String body,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'image_width') int? imageWidth,
    @JsonKey(name: 'image_height') int? imageHeight,
    @Default('draft') String status,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'reaction_count') @Default(0) int reactionCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'is_mine') @Default(false) bool isMine,
    required Author author,
    @JsonKey(name: 'prompt_id') @Default('') String promptId,
    @JsonKey(name: 'prompt_text') @Default('') String promptText,
    @JsonKey(name: 'prompt_category') @Default('writing') String promptCategory,
    @JsonKey(name: 'prompt_nudge') @Default('') String promptNudge,
    @JsonKey(name: 'prompt_date') DateTime? promptDate,
    @JsonKey(name: 'topic_name') String? topicName,
    @JsonKey(name: 'topic_path') String? topicPath,
    @JsonKey(name: 'my_reactions') @Default(<String>[]) List<String> myReactions,
    @JsonKey(name: 'reaction_counts') @Default(<String, int>{}) Map<String, int> reactionCounts,
  }) = _Submission;

  factory Submission.fromJson(Map<String, dynamic> json) => _$SubmissionFromJson(json);

  bool get isPublished => status == 'published';
  bool get hasImage => (imageUrl ?? '').isNotEmpty;
  double get aspectRatio =>
      (imageWidth != null && imageHeight != null && imageHeight! > 0)
          ? (imageWidth! / imageHeight!).clamp(0.6, 1.6)
          : 0.8;
}

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String body,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'is_mine') @Default(false) bool isMine,
    @JsonKey(name: 'author_username') @Default('') String authorUsername,
    @JsonKey(name: 'author_name') @Default('') String authorName,
    @JsonKey(name: 'author_avatar_url') String? authorAvatarUrl,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'reply_count') @Default(0) int replyCount,
    @Default(<Comment>[]) List<Comment> replies,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}

/// Everything the Today screen needs, in one round trip.
@freezed
abstract class Today with _$Today {
  const factory Today({
    required Prompt prompt,
    @JsonKey(name: 'seconds_remaining') @Default(0) int secondsRemaining,
    @JsonKey(name: 'creator_count') @Default(0) int creatorCount,
    @JsonKey(name: 'my_submission') Submission? mySubmission,
    @Default(Streak()) Streak streak,
    @JsonKey(name: 'other_prompts') @Default(<Prompt>[]) List<Prompt> otherPrompts,
  }) = _Today;

  factory Today.fromJson(Map<String, dynamic> json) => _$TodayFromJson(json);
}

@freezed
abstract class FeedPage with _$FeedPage {
  const factory FeedPage({
    @Default(true) bool locked,
    @JsonKey(name: 'creator_count') @Default(0) int creatorCount,
    Prompt? prompt,
    @Default(<Submission>[]) List<Submission> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _FeedPage;

  factory FeedPage.fromJson(Map<String, dynamic> json) => _$FeedPageFromJson(json);
}

@freezed
abstract class SubmissionPage with _$SubmissionPage {
  const factory SubmissionPage({
    @Default(<Submission>[]) List<Submission> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _SubmissionPage;

  factory SubmissionPage.fromJson(Map<String, dynamic> json) =>
      _$SubmissionPageFromJson(json);
}

@freezed
abstract class CommentPage with _$CommentPage {
  const factory CommentPage({
    @Default(<Comment>[]) List<Comment> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
  }) = _CommentPage;

  factory CommentPage.fromJson(Map<String, dynamic> json) => _$CommentPageFromJson(json);
}

@freezed
abstract class UploadTarget with _$UploadTarget {
  const factory UploadTarget({
    required String key,
    @JsonKey(name: 'upload_url') required String uploadUrl,
    @Default(<String, String>{}) Map<String, String> headers,
    @JsonKey(name: 'public_url') required String publicUrl,
  }) = _UploadTarget;

  factory UploadTarget.fromJson(Map<String, dynamic> json) => _$UploadTargetFromJson(json);
}

@freezed
abstract class Session with _$Session {
  const factory Session({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') @Default(1800) int expiresIn,
    @JsonKey(name: 'is_new_user') @Default(false) bool isNewUser,
    required DabbleUser user,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);
}

@freezed
abstract class PublishResult with _$PublishResult {
  const factory PublishResult({
    required Submission submission,
    required Streak streak,
  }) = _PublishResult;

  factory PublishResult.fromJson(Map<String, dynamic> json) =>
      _$PublishResultFromJson(json);
}
