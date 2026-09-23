import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design/tokens/colors.dart';
import '../design/tokens/flavor.dart';
import '../design/tokens/typography.dart';

final themeModeProvider =
    NotifierProvider<ThemeModeController, Brightness?>(ThemeModeController.new);

/// One visual language now. Kept as a provider so a second can be slotted in
/// without touching every call site.
final flavorProvider = Provider<DabbleFlavor>((ref) => DabbleFlavor.receipt);

/// null = follow the system. Dark mode is a first-class design, not a toggle we
/// bolted on, so this is persisted and applied before the first frame paints.
class ThemeModeController extends Notifier<Brightness?> {
  static const _key = 'dabble.theme';

  @override
  Brightness? build() {
    Future.microtask(_load);
    return null;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    state = switch (value) {
      'light' => Brightness.light,
      'dark' => Brightness.dark,
      _ => null,
    };
  }

  Future<void> set(Brightness? brightness) async {
    state = brightness;
    final prefs = await SharedPreferences.getInstance();
    if (brightness == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, brightness == Brightness.dark ? 'dark' : 'light');
    }
  }
}

/// Wraps the app in Dabble's palette and keeps the iOS status bar legible.
class DabbleTheme extends StatelessWidget {
  const DabbleTheme({
    super.key,
    required this.brightness,
    required this.child,
    this.flavor = DabbleFlavor.receipt,
  });

  final Brightness brightness;
  final DabbleFlavor flavor;
  final Widget child;

  static CupertinoThemeData cupertino(DabbleColors c) => CupertinoThemeData(
        brightness: c.isDark ? Brightness.dark : Brightness.light,
        primaryColor: c.ember,
        scaffoldBackgroundColor: c.canvas,
        barBackgroundColor: c.canvas.withValues(alpha: 0.82),
        applyThemeToAll: true,
        textTheme: CupertinoTextThemeData(
          primaryColor: c.ember,
          textStyle: DabbleText.body.on(c.ink),
          actionTextStyle: DabbleText.headline.on(c.ember),
          navTitleTextStyle: DabbleText.headline.on(c.ink),
          navLargeTitleTextStyle: DabbleText.title1.on(c.ink),
          tabLabelTextStyle: DabbleText.eyebrow.on(c.inkTertiary).copyWith(letterSpacing: 0.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = DabbleColors.resolve(flavor, brightness);
    final style = DabbleStyle.of(flavor);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: colors.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: DabbleColorScope(
        colors: colors,
        child: DabbleStyleScope(
          style: style,
          child: CupertinoTheme(data: cupertino(colors), child: child),
        ),
      ),
    );
  }
}
