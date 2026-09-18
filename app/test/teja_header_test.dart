import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teja/app/theme.dart';
import 'package:teja/design/components/teja_header.dart';

/// Guards the bug that shipped three times: `CupertinoNavigationBar` centres its
/// middle slot absolutely and gives leading/trailing loose constraints, so wide
/// actions silently overlap and steal each other's taps.
void main() {
  Future<void> pumpHeader(
    WidgetTester tester, {
    required String title,
    required String leading,
    required String trailing,
    Size size = const Size(320, 700), // narrowest phone we support
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      TejaTheme(
        brightness: Brightness.light,
        child: CupertinoApp(
          home: TejaHeader(
            title: title,
            leading: TejaHeaderAction(leading, onTap: () {}),
            trailing: TejaHeaderAction(trailing, onTap: () {}),
          ),
        ),
      ),
    );
  }

  void expectNoOverlap(WidgetTester tester, String a, String b) {
    final rectA = tester.getRect(find.text(a));
    final rectB = tester.getRect(find.text(b));
    expect(
      rectA.overlaps(rectB),
      isFalse,
      reason: '"$a" $rectA overlaps "$b" $rectB',
    );
  }

  testWidgets('header actions never overlap each other', (tester) async {
    await pumpHeader(
      tester,
      title: 'Edit profile',
      leading: 'Cancel',
      trailing: 'Save',
    );
    expectNoOverlap(tester, 'Cancel', 'Save');
    expectNoOverlap(tester, 'Cancel', 'Edit profile');
    expectNoOverlap(tester, 'Edit profile', 'Save');
  });

  testWidgets('a long title truncates instead of colliding', (tester) async {
    await pumpHeader(
      tester,
      title: 'A title far too long to ever fit in this bar',
      leading: 'Cancel',
      trailing: 'Publish',
    );
    expectNoOverlap(tester, 'Cancel', 'Publish');
    expect(tester.takeException(), isNull);
  });

  testWidgets('both actions stay tappable', (tester) async {
    var leadingTaps = 0;
    var trailingTaps = 0;

    await tester.pumpWidget(
      TejaTheme(
        brightness: Brightness.light,
        child: CupertinoApp(
          home: TejaHeader(
            title: 'Edit profile',
            leading: TejaHeaderAction('Cancel', onTap: () => leadingTaps++),
            trailing: TejaHeaderAction('Save', onTap: () => trailingTaps++),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(leadingTaps, 1, reason: 'Cancel did not receive its tap');
    expect(trailingTaps, 0, reason: 'Save stole the tap meant for Cancel');

    await tester.tap(find.text('Save'));
    await tester.pump();
    expect(trailingTaps, 1);
    expect(leadingTaps, 1);
  });
}
