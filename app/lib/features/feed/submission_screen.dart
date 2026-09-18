import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/date_x.dart';
import '../../data/teja_repository.dart';
import '../../design/components/avatar.dart';
import '../../design/components/reaction_bar.dart';
import '../../design/components/stat_row.dart';
import '../../design/components/states.dart';
import '../../design/tokens/colors.dart';
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
      await ref.read(tejaRepositoryProvider).addComment(widget.submissionId, body);
      _comment.clear();
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
                                for (final comment in items) _CommentRow(comment: comment),
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
              ),
            ],
          ),
        ),
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
  const _CommentRow({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: Gap.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(name: comment.authorName, url: comment.authorAvatarUrl, size: 28),
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
              ],
            ),
          ),
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
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.md, Gap.md, Gap.md),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        border: Border(top: BorderSide(color: c.hairline, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              // Setting the norm in the placeholder measurably reduces hostility.
              placeholder: 'Say something kind…',
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
    );
  }
}
