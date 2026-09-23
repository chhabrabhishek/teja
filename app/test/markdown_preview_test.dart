import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dabble/design/components/markdown_preview.dart';

void main() {
  group('MarkdownPreview.plainText', () {
    test('unwraps inline emphasis', () {
      expect(MarkdownPreview.plainText('**Hello**'), 'Hello');
      expect(MarkdownPreview.plainText('_soft_ and __loud__'), 'soft and loud');
      expect(MarkdownPreview.plainText('a `code` b'), 'a code b');
    });

    test('strips block syntax that would break card rhythm', () {
      expect(MarkdownPreview.plainText('# Heading'), 'Heading');
      expect(MarkdownPreview.plainText('> quoted'), 'quoted');
      expect(MarkdownPreview.plainText('- one\n- two'), 'one\ntwo');
      expect(MarkdownPreview.plainText('1. first'), 'first');
    });

    test('keeps link text, drops the url', () {
      expect(MarkdownPreview.plainText('see [the docs](https://x.dev)'), 'see the docs');
    });

    test('collapses runs of blank lines', () {
      expect(MarkdownPreview.plainText('a\n\n\n\nb'), 'a\n\nb');
    });

    test('leaves plain prose untouched', () {
      const prose = 'The sky went the colour of an old photograph.';
      expect(MarkdownPreview.plainText(prose), prose);
    });
  });

  testWidgets('renders bold as a weighted span, not literal asterisks',
      (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: MarkdownPreview(
          'she said **stop** quietly',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );

    final richText = tester.widget<RichText>(find.byType(RichText));
    final styles = <String, FontWeight?>{};
    richText.text.visitChildren((span) {
      if (span is TextSpan && span.text != null) {
        styles[span.text!] = span.style?.fontWeight;
      }
      return true;
    });

    expect(styles.keys.join(), isNot(contains('*')));
    expect(styles['stop'], FontWeight.w700);
    expect(styles['she said '], isNot(FontWeight.w700));
  });
}
