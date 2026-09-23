import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/date_x.dart';
import '../../data/dabble_repository.dart';
import '../../design/components/avatar.dart';
import '../../design/components/paper.dart';
import '../../design/components/reaction_bar.dart';
import '../../design/components/stat_row.dart';
import '../../design/components/states.dart';
import '../../design/components/dabble_press.dart';
import '../../design/components/torn_edge.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';
import 'feed_controller.dart';

final _submissionProvider =
    FutureProvider.autoDispose.family<Submission, String>((ref, id) {
  return ref.read(dabbleRepositoryProvider).submission(id);
});

final _commentsProvider =
    FutureProvider.autoDispose.family<List<Comment>, String>((ref, id) async {
  final page = await ref.read(dabbleRepositoryProvider).comments(id);
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
      await ref.read(dabbleRepositoryProvider).addComment(
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
                    .read(dabbleRepositoryProvider)
                    .deleteSubmission(submission.id);
                if (mounted) context.pop();
              },
              child: const Text('Delete'),
            )
          else ...[
            CupertinoActionSheetAction(
              onPressed: () {
                sheetContext.pop();
                ref.read(dabbleRepositoryProvider).report(
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
                    .read(dabbleRepositoryProvider)
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
              PaperHeader(
                trailing: DabblePress(
                  onTap: () => _moreActions(data),
                  semanticLabel: 'More',
                  child: Padding(
                    padding: const EdgeInsets.all(Gap.sm),
                    child: Icon(CupertinoIcons.ellipsis, size: 18, color: c.inkSecondary),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: Gap.section),
                  children: [
                    _PostHead(submission: data),
                    ReceiptCard(
                      padding: const EdgeInsets.fromLTRB(
                          Gap.xxl, Gap.xl, Gap.xxl, Gap.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.promptText.isNotEmpty) ...[
                            Eyebrow(data.topicName ?? 'The challenge'),
                            Gap.h8,
                            Text(
                              data.promptText,
                              style: DabbleText.title2.on(c.ember),
                            ),
                            Gap.h20,
                          ],
                          if (data.hasImage) ...[
                            DabbleImage(url: data.imageUrl!, aspectRatio: data.aspectRatio),
                            if (data.body.isNotEmpty) Gap.h16,
                          ],
                          if (data.body.isNotEmpty)
                            MarkdownBody(
                              data: data.body,
                              styleSheet: MarkdownStyleSheet(
                                p: DabbleText.body.on(c.ink),
                                h1: DabbleText.title2.on(c.ink),
                                h2: DabbleText.headline.on(c.ink),
                                blockquote: DabbleText.body.on(c.inkSecondary),
                                listBullet: DabbleText.body.on(c.ink),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Gap.xxl, Gap.lg, Gap.xxl, 0),
                      child: ReactionBar(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          Gap.xxl, Gap.xl, Gap.xxl, Gap.sm),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(
                            'Comments${data.commentCount > 0 ? ' · ${data.commentCount}' : ''}',
                          ),
                          Gap.h16,
                          comments.when(
                            loading: () => const Skeleton.text(width: 200),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (items) => items.isEmpty
                                ? Text(
                                    'No comments yet. Be the first kind word.',
                                    style: DabbleText.callout.on(c.inkTertiary),
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

/// The receipt head: who made it, when, then a torn edge into the work itself.
class _PostHead extends StatelessWidget {
  const _PostHead({required this.submission});

  final Submission submission;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final author = submission.author;
    final name = author.displayName.isEmpty ? author.username : author.displayName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.sm, Gap.xxl, Gap.md),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: c.glow, shape: BoxShape.circle),
              ),
              Gap.w8,
              Expanded(
                child: DabblePress(
                  onTap: () => context.push('/u/${author.username}'),
                  child: Text(name, style: DabbleText.subhead.on(c.ember)),
                ),
              ),
              if (submission.publishedAt != null)
                Text(
                  submission.publishedAt!.shortAgo,
                  style: DabbleText.footnote.on(c.inkTertiary),
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
      padding: EdgeInsets.only(bottom: Gap.xl, left: isReply ? Gap.xl : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // A hairline rule instead of an avatar for replies: it shows the
              // thread without repeating a face that's already above.
              if (isReply)
                Container(
                  width: 1,
                  height: 44,
                  margin: const EdgeInsets.only(right: Gap.lg, top: Gap.xs),
                  color: c.hairline,
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DabblePress(
                            onTap: () => context.push('/u/${comment.authorUsername}'),
                            child: Text(
                              comment.authorName,
                              style: DabbleText.subhead.on(c.ink),
                            ),
                          ),
                        ),
                        Text(
                          comment.createdAt.shortAgo,
                          style: DabbleText.footnote.on(c.inkTertiary),
                        ),
                      ],
                    ),
                    Gap.h4,
                    Text(comment.body, style: DabbleText.callout.on(c.inkSecondary)),
                    Gap.h4,
                    Align(
                      alignment: Alignment.centerRight,
                      child: DabblePress(
                        onTap: () => onReply(comment),
                        semanticLabel: 'Reply to ${comment.authorName}',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                          child: Text('Reply', style: DabbleText.footnote.on(c.ember)),
                        ),
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
      padding: const EdgeInsets.fromLTRB(Gap.xxl, Gap.md, Gap.xxl, Gap.lg),
      color: c.canvas,
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
                      style: DabbleText.footnote.on(c.ember),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DabblePress(
                    onTap: onCancelReply,
                    semanticLabel: 'Cancel reply',
                    child: Icon(CupertinoIcons.xmark, size: 14, color: c.inkTertiary),
                  ),
                ],
              ),
            ),
          // One flat pill, as in the design — the send arrow only appears once
          // there is something to send, so at rest it reads as a single control.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Gap.xl, vertical: Gap.xs),
            decoration: BoxDecoration(
              color: c.surfaceAlt,
              borderRadius: const BorderRadius.all(Radius.circular(999)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoTextField(
                    controller: controller,
                    // Setting the norm in the placeholder measurably reduces hostility.
                    placeholder: replyingTo == null
                        ? 'Reply'
                        : 'Reply to ${replyingTo!.authorName}',
                    placeholderStyle: DabbleText.callout.on(c.inkTertiary),
                    style: DabbleText.callout.on(c.ink),
                    cursorColor: c.ember,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: 500,
                    padding: const EdgeInsets.symmetric(vertical: Gap.md),
                    decoration: const BoxDecoration(),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
                if (sending)
                  const CupertinoActivityIndicator()
                else
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (context, value, _) => value.text.trim().isEmpty
                        ? const SizedBox.shrink()
                        : DabblePress(
                            onTap: onSend,
                            semanticLabel: 'Send',
                            child: Icon(CupertinoIcons.arrow_up_circle_fill,
                                size: 28, color: c.ember),
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
