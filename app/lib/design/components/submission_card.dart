import 'package:flutter/cupertino.dart';

import '../../core/utils/date_x.dart';
import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../../domain/models.dart';
import 'avatar.dart';
import 'markdown_preview.dart';
import 'reaction_bar.dart';
import 'teja_card.dart';

/// A feed card shows enough to feel something and not enough to replace opening
/// it. Text clamps to six lines behind a fade; images keep their aspect ratio
/// within a 4:5 envelope so the feed keeps a steady rhythm.
class SubmissionCard extends StatelessWidget {
  const SubmissionCard({
    super.key,
    required this.submission,
    required this.onTap,
    required this.onReact,
    this.onAuthorTap,
    this.showMineTag = true,
  });

  final Submission submission;
  final VoidCallback onTap;
  final void Function(String emoji, bool selected) onReact;
  final VoidCallback? onAuthorTap;
  final bool showMineTag;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final author = submission.author;

    return TejaCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                name: author.displayName.isEmpty ? author.username : author.displayName,
                url: author.avatarUrl,
                onTap: onAuthorTap,
              ),
              Gap.w12,
              Expanded(
                child: Text(
                  author.displayName.isEmpty ? '@${author.username}' : author.displayName,
                  style: TejaText.headline.on(c.ink),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (submission.publishedAt != null)
                Text(
                  submission.publishedAt!.shortAgo,
                  style: TejaText.footnote.on(c.inkTertiary),
                ),
              if (submission.isMine && showMineTag) ...[
                Gap.w8,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: c.emberSoft, borderRadius: Radii.pill),
                  child: Text('You', style: TejaText.footnote.on(c.ember)),
                ),
              ],
            ],
          ),
          Gap.h16,
          if (submission.hasImage) ...[
            TejaImage(url: submission.imageUrl!, aspectRatio: submission.aspectRatio),
            if (submission.body.isNotEmpty) ...[
              Gap.h12,
              Text(
                submission.body,
                style: TejaText.callout.on(c.inkSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ] else
            _ClampedText(text: submission.body),
          Gap.h12,
          ReactionBar(
            counts: submission.reactionCounts,
            mine: submission.myReactions,
            onToggle: onReact,
            commentCount: submission.commentCount,
            onComments: onTap,
          ),
        ],
      ),
    );
  }
}

/// A hard ellipsis on someone's writing feels like a judgement. A fade feels like
/// an invitation.
class _ClampedText extends StatelessWidget {
  const _ClampedText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ShaderMask(
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [c.ink, c.ink, c.ink.withValues(alpha: 0)],
        stops: const [0, 0.78, 1],
      ).createShader(rect),
      blendMode: BlendMode.dstIn,
      child: MarkdownPreview(
        text,
        style: TejaText.body.on(c.ink),
        maxLines: 6,
        // The fade mask is the truncation cue; an ellipsis on top would be noise.
        overflow: TextOverflow.clip,
      ),
    );
  }
}
