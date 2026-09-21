// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Streak _$StreakFromJson(Map<String, dynamic> json) => _Streak(
  current: (json['current'] as num?)?.toInt() ?? 0,
  longest: (json['longest'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
  lastDate: json['last_date'] == null
      ? null
      : DateTime.parse(json['last_date'] as String),
);

Map<String, dynamic> _$StreakToJson(_Streak instance) => <String, dynamic>{
  'current': instance.current,
  'longest': instance.longest,
  'total': instance.total,
  'last_date': instance.lastDate?.toIso8601String(),
};

_TejaUser _$TejaUserFromJson(Map<String, dynamic> json) => _TejaUser(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String?,
  email: json['email'] as String?,
  timezone: json['timezone'] as String? ?? 'UTC',
  reminderHour: (json['reminder_hour'] as num?)?.toInt(),
  preferredCategories:
      (json['preferred_categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  streak: json['streak'] == null
      ? const Streak()
      : Streak.fromJson(json['streak'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TejaUserToJson(_TejaUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'display_name': instance.displayName,
  'bio': instance.bio,
  'avatar_url': instance.avatarUrl,
  'email': instance.email,
  'timezone': instance.timezone,
  'reminder_hour': instance.reminderHour,
  'preferred_categories': instance.preferredCategories,
  'streak': instance.streak,
};

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
  id: json['id'] as String,
  slug: json['slug'] as String,
  name: json['name'] as String,
  blurb: json['blurb'] as String? ?? '',
  craft: json['craft'] as String? ?? 'writing',
  parentId: json['parent_id'] as String?,
  acceptsPrompts: json['accepts_prompts'] as bool? ?? true,
  subscriberCount: (json['subscriber_count'] as num?)?.toInt() ?? 0,
  isSelected: json['is_selected'] as bool? ?? false,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Topic>[],
);

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'name': instance.name,
  'blurb': instance.blurb,
  'craft': instance.craft,
  'parent_id': instance.parentId,
  'accepts_prompts': instance.acceptsPrompts,
  'subscriber_count': instance.subscriberCount,
  'is_selected': instance.isSelected,
  'children': instance.children,
};

_Prompt _$PromptFromJson(Map<String, dynamic> json) => _Prompt(
  id: json['id'] as String,
  date: DateTime.parse(json['date'] as String),
  category: json['category'] as String,
  categoryLabel: json['category_label'] as String,
  kind: json['kind'] as String? ?? 'text',
  text: json['text'] as String,
  nudge: json['nudge'] as String? ?? 'Five minutes is enough.',
  topicId: json['topic_id'] as String?,
  topicName: json['topic_name'] as String?,
  topicPath: json['topic_path'] as String?,
);

Map<String, dynamic> _$PromptToJson(_Prompt instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'category': instance.category,
  'category_label': instance.categoryLabel,
  'kind': instance.kind,
  'text': instance.text,
  'nudge': instance.nudge,
  'topic_id': instance.topicId,
  'topic_name': instance.topicName,
  'topic_path': instance.topicPath,
};

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  id: json['id'] as String,
  username: json['username'] as String,
  displayName: json['display_name'] as String? ?? '',
  avatarUrl: json['avatar_url'] as String?,
  streak: (json['streak'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'display_name': instance.displayName,
  'avatar_url': instance.avatarUrl,
  'streak': instance.streak,
};

_Submission _$SubmissionFromJson(Map<String, dynamic> json) => _Submission(
  id: json['id'] as String,
  kind: json['kind'] as String? ?? 'text',
  body: json['body'] as String? ?? '',
  imageUrl: json['image_url'] as String?,
  imageWidth: (json['image_width'] as num?)?.toInt(),
  imageHeight: (json['image_height'] as num?)?.toInt(),
  status: json['status'] as String? ?? 'draft',
  publishedAt: json['published_at'] == null
      ? null
      : DateTime.parse(json['published_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  reactionCount: (json['reaction_count'] as num?)?.toInt() ?? 0,
  commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
  isMine: json['is_mine'] as bool? ?? false,
  author: Author.fromJson(json['author'] as Map<String, dynamic>),
  promptId: json['prompt_id'] as String? ?? '',
  promptText: json['prompt_text'] as String? ?? '',
  promptCategory: json['prompt_category'] as String? ?? 'writing',
  promptNudge: json['prompt_nudge'] as String? ?? '',
  promptDate: json['prompt_date'] == null
      ? null
      : DateTime.parse(json['prompt_date'] as String),
  topicName: json['topic_name'] as String?,
  topicPath: json['topic_path'] as String?,
  myReactions:
      (json['my_reactions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  reactionCounts:
      (json['reaction_counts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
);

Map<String, dynamic> _$SubmissionToJson(_Submission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'body': instance.body,
      'image_url': instance.imageUrl,
      'image_width': instance.imageWidth,
      'image_height': instance.imageHeight,
      'status': instance.status,
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'reaction_count': instance.reactionCount,
      'comment_count': instance.commentCount,
      'is_mine': instance.isMine,
      'author': instance.author,
      'prompt_id': instance.promptId,
      'prompt_text': instance.promptText,
      'prompt_category': instance.promptCategory,
      'prompt_nudge': instance.promptNudge,
      'prompt_date': instance.promptDate?.toIso8601String(),
      'topic_name': instance.topicName,
      'topic_path': instance.topicPath,
      'my_reactions': instance.myReactions,
      'reaction_counts': instance.reactionCounts,
    };

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  body: json['body'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  isMine: json['is_mine'] as bool? ?? false,
  authorUsername: json['author_username'] as String? ?? '',
  authorName: json['author_name'] as String? ?? '',
  authorAvatarUrl: json['author_avatar_url'] as String?,
  parentId: json['parent_id'] as String?,
  replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
  replies:
      (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Comment>[],
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'body': instance.body,
  'created_at': instance.createdAt.toIso8601String(),
  'is_mine': instance.isMine,
  'author_username': instance.authorUsername,
  'author_name': instance.authorName,
  'author_avatar_url': instance.authorAvatarUrl,
  'parent_id': instance.parentId,
  'reply_count': instance.replyCount,
  'replies': instance.replies,
};

_Today _$TodayFromJson(Map<String, dynamic> json) => _Today(
  prompt: Prompt.fromJson(json['prompt'] as Map<String, dynamic>),
  secondsRemaining: (json['seconds_remaining'] as num?)?.toInt() ?? 0,
  creatorCount: (json['creator_count'] as num?)?.toInt() ?? 0,
  mySubmission: json['my_submission'] == null
      ? null
      : Submission.fromJson(json['my_submission'] as Map<String, dynamic>),
  streak: json['streak'] == null
      ? const Streak()
      : Streak.fromJson(json['streak'] as Map<String, dynamic>),
  otherPrompts:
      (json['other_prompts'] as List<dynamic>?)
          ?.map((e) => Prompt.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Prompt>[],
);

Map<String, dynamic> _$TodayToJson(_Today instance) => <String, dynamic>{
  'prompt': instance.prompt,
  'seconds_remaining': instance.secondsRemaining,
  'creator_count': instance.creatorCount,
  'my_submission': instance.mySubmission,
  'streak': instance.streak,
  'other_prompts': instance.otherPrompts,
};

_FeedPage _$FeedPageFromJson(Map<String, dynamic> json) => _FeedPage(
  locked: json['locked'] as bool? ?? true,
  creatorCount: (json['creator_count'] as num?)?.toInt() ?? 0,
  prompt: json['prompt'] == null
      ? null
      : Prompt.fromJson(json['prompt'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Submission.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Submission>[],
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$FeedPageToJson(_FeedPage instance) => <String, dynamic>{
  'locked': instance.locked,
  'creator_count': instance.creatorCount,
  'prompt': instance.prompt,
  'items': instance.items,
  'next_cursor': instance.nextCursor,
};

_SubmissionPage _$SubmissionPageFromJson(Map<String, dynamic> json) =>
    _SubmissionPage(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Submission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Submission>[],
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$SubmissionPageToJson(_SubmissionPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'next_cursor': instance.nextCursor,
    };

_CommentPage _$CommentPageFromJson(Map<String, dynamic> json) => _CommentPage(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Comment>[],
  nextCursor: json['next_cursor'] as String?,
);

Map<String, dynamic> _$CommentPageToJson(_CommentPage instance) =>
    <String, dynamic>{
      'items': instance.items,
      'next_cursor': instance.nextCursor,
    };

_UploadTarget _$UploadTargetFromJson(Map<String, dynamic> json) =>
    _UploadTarget(
      key: json['key'] as String,
      uploadUrl: json['upload_url'] as String,
      headers:
          (json['headers'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      publicUrl: json['public_url'] as String,
    );

Map<String, dynamic> _$UploadTargetToJson(_UploadTarget instance) =>
    <String, dynamic>{
      'key': instance.key,
      'upload_url': instance.uploadUrl,
      'headers': instance.headers,
      'public_url': instance.publicUrl,
    };

_Session _$SessionFromJson(Map<String, dynamic> json) => _Session(
  accessToken: json['access_token'] as String,
  refreshToken: json['refresh_token'] as String,
  expiresIn: (json['expires_in'] as num?)?.toInt() ?? 1800,
  isNewUser: json['is_new_user'] as bool? ?? false,
  user: TejaUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SessionToJson(_Session instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'refresh_token': instance.refreshToken,
  'expires_in': instance.expiresIn,
  'is_new_user': instance.isNewUser,
  'user': instance.user,
};

_PublishResult _$PublishResultFromJson(Map<String, dynamic> json) =>
    _PublishResult(
      submission: Submission.fromJson(
        json['submission'] as Map<String, dynamic>,
      ),
      streak: Streak.fromJson(json['streak'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PublishResultToJson(_PublishResult instance) =>
    <String, dynamic>{
      'submission': instance.submission,
      'streak': instance.streak,
    };
