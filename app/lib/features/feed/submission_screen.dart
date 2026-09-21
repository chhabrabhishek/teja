import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/date_x.dart';
import '../../data/teja_repository.dart';
import '../../design/components/avatar.dart';
import '../../design/components/chips.dart';
import '../../design/components/reaction_bar.dart';
import '../../design/components/stat_row.dart';
import '../../design/components/states.dart';
import '../../design/components/teja_card.dart';
import '../../design/components/teja_press.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';
import 'feed_controller.dart';

final _submissionProvider =
    FutureProvider.autoDispose.family<Submission, String>((ref, id) {
  return ref.read(tejaRepositoryProvider).submission(id);
});

final _commentsProvider =
    FutureProvider.autoDispose.family<List<Comment>, String>((ref, id) async {
  final page = await ref.read(tejaRepositoryProvider).comments(id);
  return page.items;
});

/// A reading room. Full content, generous measure, then reactions, then comments.
/// The author is one tap away but never the focus.
class SubmissionScreen extends ConsumerStatefulWidget {
  const SubmissionScreen({super.key, required this.submissionId});

  final String submissionId;

  @override
  ConsumerState<SubmissionScreen> createState() => _SubmissionScreenState();
}

class _SubmissionScreenState extends ConsumerState<SubmissionScreen> {
  final _comment = TextEditingController();
  bool _sending = false;
  Comment? _replyingTo;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final body = _comment.text.trim();
    if (body.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(tejaRepositoryProvider).addComment(
            widget.submissionId,
            body,
            parentId: _replyingTo?.id,
          );
      _comment.clear();
      _replyingTo = null;
      ref.invalidate(_commentsProvider(widget.submissionId));
      ref.invalidate(_submissionProvider(widget.submissionId));
    } catch (_) {
      Feel.error();
    }
    if (mounted) setState(() => _sending = false);
  }

  void _moreActions(Submission submission) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          if (submission.isMine)
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                sheetContext.pop();
                await ref
                    .read(tejaRepositoryProvider)
                    .deleteSubmission(submission.id);
                if (mounted) context.pop();
              },
              child: const Text('Delete'),
            )
          else ...[
            CupertinoActionSheetAction(
              onPressed: () {
                sheetContext.pop();
                ref.read(tejaRepositoryProvider).report(
                      submissionId: submission.id,
                      reason: 'other',
                    );
              },
              child: const Text('Report'),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () async {
                sheetContext.pop();
                await ref
                    .read(tejaRepositoryProvider)
                    .block(submission.author.username);
                ref.read(feedControllerProvider.notifier).refresh();
                if (mounted) context.pop();
              },
              child: Text('Block @${submission.author.username}'),
            ),
          ],
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final submission = ref.watch(_submissionProvider(widget.submissionId));
    final comments = ref.watch(_commentsProvider(widget.submissionId));

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: c.canvas.withValues(alpha: 0.82),
        border: null,
        middle: Text(
          submission.valueOrNull?.author.displayName ?? '',
          style: TejaText.headline.on(c.ink),
        ),
        trailing: submission.hasValue
            ? GestureDetector(
                onTap: () => _moreActions(submission.value!),
                child: Icon(CupertinoIcons.ellipsis, size: 20, color: c.inkSecondary),
              )
            : null,
      ),
      child: submission.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => const EmptyState(
          icon: CupertinoIcons.doc,
          title: 'This creation is gone',
          message: 'It may have been deleted.',
        ),
        data: (data) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.lg, Gap.gutter, Gap.section),
                  children: [
                    _PromptContext(submission: data),
                    Gap.h20,
                    _AuthorRow(submission: data),
                    Gap.h20,
                    if (data.hasImage) ...[
                      TejaImage(url: data.imageUrl!, aspectRatio: data.aspectRatio),
                      if (data.body.isNotEmpty) ...[
                        Gap.h16,
                        Text(data.body, style: TejaText.body.on(c.ink)),
                      ],
                    ] else
                      MarkdownBody(
                        data: data.body,
                        styleSheet: MarkdownStyleSheet(
                          p: TejaText.body.on(c.ink),
                          h1: TejaText.title2.on(c.ink),
                          h2: TejaText.headline.on(c.ink),
                          blockquote: TejaText.body.on(c.inkSecondary),
                          listBullet: TejaText.body.on(c.ink),
                        ),
                      ),
                    Gap.h24,
                    ReactionBar(
                      large: true,
                      counts: data.reactionCounts,
                      mine: data.myReactions,
                      onToggle: (emoji, selected) async {
                        await ref
                            .read(feedControllerProvider.notifier)
                            .react(data.id, emoji, selected);
                        ref.invalidate(_submissionProvider(widget.submissionId));
                      },
                    ),
                    Gap.h24,
                    const Hairline(),
                    Gap.h20,
                    Eyebrow('Comments${data.commentCount > 0 ? ' · ${data.commentCount}' : ''}'),
                    Gap.h16,
                    comments.when(
                      loading: () => const Skeleton.text(width: 200),
                      error: (_, __) => const SizedBox.shrink(),
                      data: (items) => items.isEmpty
                          ? Text(
                              'No comments yet. Be the first kind word.',
                              style: TejaText.callout.on(c.inkTertiary),
                            )
                          : Column(
                              children: [
                                for (final comment in items)
                                  _CommentRow(
                                    comment: comment,
                                    onReply: (target) =>
                                        setState(() => _replyingTo = target),
                                  ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              _CommentComposer(
                controller: _comment,
                sending: _sending,
                onSend: _send,
                replyingTo: _replyingTo,
                onCancelReply: () => setState(() => _replyingTo = null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The question being answered.
///
/// Without this, a post is a stranger's sentence with no context — the prompt is
/// half the work and half the meaning, so it leads rather than hides in a footer.
class _PromptContext extends StatelessWidget {
  const _PromptContext({required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;
    final hue = TejaColors.forCategory(submission.promptCategory);

    return TejaCard(
      elevated: false,
      color: c.surfaceAlt,
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CategoryChip.glyphFor(submission.promptCategory), size: 13, color: hue),
              Gap.w8,
              Expanded(
                child: Text(
                  (submission.topicPath ?? submission.promptCategory).toUpperCase(),
                  style: TejaText.eyebrow.on(hue),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (submission.promptDate != null)
                Text(
                  submission.promptDate!.eyebrowLabel.split(' · ').last,
                  style: TejaText.footnote.on(c.inkTertiary),
                ),
            ],
          ),
          Gap.h12,
          Text(
            submission.promptText,
            style: TejaText.title2.on(c.ink).copyWith(
                  fontFamily: s.roundedFamily,
                  fontWeight: s.headlineWeight,
                ),
          ),
        ],
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  const _AuthorRow({required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final author = submission.author;
    final name = author.displayName.isEmpty ? '@${author.username}' : author.displayName;

    return Row(
      children: [
        Avatar(
          name: name,
          url: author.avatarUrl,
          size: 44,
          onTap: () => context.push('/u/${author.username}'),
        ),
        Gap.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TejaText.headline.on(c.ink)),
              Gap.h4,
              Text(
                [
                  if (submission.publishedAt != null) submission.publishedAt!.shortAgo,
                  if (author.streak > 0) 'Day ${author.streak}',
                ].join(' · '),
                style: TejaText.footnote.on(c.inkTertiary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.comment,
    required this.onReply,
    this.isReply = false,
  });

  final Comment comment;
  final ValueChanged<Comment> onReply;
  final bool isReply;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: EdgeInsets.only(bottom: Gap.lg, left: isReply ? Gap.section : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(
                name: comment.authorName,
                url: comment.authorAvatarUrl,
                size: isReply ? 24 : 28,
                onTap: () => context.push('/u/${comment.authorUsername}'),
              ),
              Gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(comment.authorName, style: TejaText.subhead.on(c.ink)),
                        Gap.w8,
                        Text(comment.createdAt.shortAgo,
                            style: TejaText.footnote.on(c.inkTertiary)),
                      ],
                    ),
                    Gap.h4,
                    Text(comment.body, style: TejaText.callout.on(c.inkSecondary)),
                    Gap.h4,
                    TejaPress(
                      onTap: () => onReply(comment),
                      semanticLabel: 'Reply to ${comment.authorName}',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                        child: Text('Reply', style: TejaText.footnote.on(c.ember)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          for (final reply in comment.replies)
            _CommentRow(comment: reply, onReply: onReply, isReply: true),
        ],
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({
    required this.controller,
    required this.sending,
    required this.onSend,
    this.replyingTo,
    this.onCancelReply,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;
  final Comment? replyingTo;
  final VoidCallback? onCancelReply;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.md, Gap.md, Gap.md),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        border: Border(top: BorderSide(color: c.hairline, width: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyingTo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to ${replyingTo!.authorName}',
                      style: TejaText.footnote.on(c.ember),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TejaPress(
                    onTap: onCancelReply,
                    semanticLabel: 'Cancel reply',
                    child: Icon(CupertinoIcons.xmark, size: 14, color: c.inkTertiary),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  // Setting the norm in the placeholder measurably reduces hostility.
                  placeholder: replyingTo == null
                      ? 'Say something kind…'
                      : 'Reply to ${replyingTo!.authorName}…',
                  placeholderStyle: TejaText.callout.on(c.inkTertiary),
                  style: TejaText.callout.on(c.ink),
                  cursorColor: c.ember,
                  maxLines: 4,
                  minLines: 1,
                  maxLength: 500,
                  decoration: const BoxDecoration(),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              Gap.w8,
              GestureDetector(
                onTap: onSend,
                child: sending
                    ? const CupertinoActivityIndicator()
                    : Icon(CupertinoIcons.arrow_up_circle_fill, size: 30, color: c.ember),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
