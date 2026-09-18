import 'package:flutter/widgets.dart';

/// Inline-only Markdown, for previews.
///
/// Renders `**bold**`, `_italic_` and `` `code` ``, but *strips* block syntax —
/// headings, quotes, bullets, fences. A card is a preview: a `# Heading` at true
/// heading size would wreck the feed's vertical rhythm, and the whole point of
/// the feed is that every card reads at the same weight. Full Markdown renders
/// on the detail screen, where it has room to breathe.
///
/// Also avoids `flutter_markdown` here because that package can't do `maxLines`,
/// and the 6-line clamp with a fade mask is core to the card design.
class MarkdownPreview extends StatelessWidget {
  const MarkdownPreview(
    this.source, {
    super.key,
    required this.style,
    this.maxLines,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
  });

  final String source;
  final TextStyle style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow overflow;

  static final _fence = RegExp(r'^\s*```.*$', multiLine: true);
  static final _blockPrefix =
      RegExp(r'^[ \t]*(#{1,6}\s+|>\s+|[-*+]\s+|\d+\.\s+)', multiLine: true);
  static final _extraBlankLines = RegExp(r'\n{3,}');
  static final _inline = RegExp(
    r'\*\*(.+?)\*\*|__(.+?)__|\*(.+?)\*|_(.+?)_|`(.+?)`|\[(.+?)\]\([^)]*\)',
    dotAll: true,
  );

  static String plainText(String source) => _strip(source)
      .replaceAllMapped(
        _inline,
        (m) => m.group(1) ?? m.group(2) ?? m.group(3) ?? m.group(4) ?? m.group(5) ?? m.group(6) ?? '',
      )
      .trim();

  static String _strip(String source) => source
      .replaceAll(_fence, '')
      .replaceAll(_blockPrefix, '')
      .replaceAll(_extraBlankLines, '\n\n')
      .trim();

  List<InlineSpan> _spans() {
    final text = _strip(source);
    final spans = <InlineSpan>[];
    var index = 0;

    for (final match in _inline.allMatches(text)) {
      if (match.start > index) {
        spans.add(TextSpan(text: text.substring(index, match.start)));
      }
      final bold = match.group(1) ?? match.group(2);
      final italic = match.group(3) ?? match.group(4);
      final code = match.group(5);
      final link = match.group(6);

      if (bold != null) {
        spans.add(TextSpan(
          text: bold,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ));
      } else if (italic != null) {
        spans.add(TextSpan(
          text: italic,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      } else if (code != null) {
        spans.add(TextSpan(
          text: code,
          style: const TextStyle(fontFamily: 'Menlo', fontSize: 15),
        ));
      } else if (link != null) {
        spans.add(TextSpan(text: link));
      }
      index = match.end;
    }

    if (index < text.length) spans.add(TextSpan(text: text.substring(index)));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(style: style, children: _spans()),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
