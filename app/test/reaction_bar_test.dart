import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teja/app/theme.dart';
import 'package:teja/design/components/reaction_bar.dart';
import 'package:teja/design/tokens/flavor.dart';

/// Five pills, borders and multi-digit counts have to survive the narrowest
/// card we render. Overflow here is invisible in release builds, which is
/// exactly why it needs a test rather than an eyeball.
void main() {
  Future<void> pumpBar(
    WidgetTester tester, {
    required TejaFlavor flavor,
    required Map<String, int> counts,
    double width = 280, // a 320pt phone minus gutters and card padding
  }) async {
    await tester.pumpWidget(
      TejaTheme(
        brightness: Brightness.light,
        flavor: flavor,
        child: CupertinoApp(
          home: Center(
            child: SizedBox(
              width: width,
              child: ReactionBar(
                counts: counts,
                mine: const ['💛'],
                onToggle: (_, __) {},
                commentCount: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  for (final flavor in TejaFlavor.values) {
    testWidgets('${flavor.name}: no overflow with every count populated',
        (tester) async {
      await pumpBar(
        tester,
        flavor: flavor,
        counts: {for (final e in kReactions) e: 999},
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('${flavor.name}: no overflow at zero counts', (tester) async {
      await pumpBar(tester, flavor: flavor, counts: const {});
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('survives an absurdly narrow card', (tester) async {
    await pumpBar(
      tester,
      flavor: TejaFlavor.receipt,
      counts: {for (final e in kReactions) e: 12345},
      width: 180,
    );
    expect(tester.takeException(), isNull);
  });
}
