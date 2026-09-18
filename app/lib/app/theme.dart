import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../design/tokens/colors.dart';
import '../design/tokens/flavor.dart';
import '../design/tokens/typography.dart';

final themeModeProvider =
    NotifierProvider<ThemeModeController, Brightness?>(ThemeModeController.new);

/// Which visual personality the app wears. Persisted so a design review survives
/// a restart.
final flavorProvider =
    NotifierProvider<FlavorController, TejaFlavor>(FlavorController.new);

class FlavorController extends Notifier<TejaFlavor> {
  static const _key = 'teja.flavor';

  @override
  TejaFlavor build() {
    Future.microtask(_load);
    return TejaFlavor.calm;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_key) == TejaFlavor.playful.name
        ? TejaFlavor.playful
        : TejaFlavor.calm;
  }

  Future<void> set(TejaFlavor flavor) async {
    state = flavor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, flavor.name);
  }

  Future<void> toggle() => set(
        state == TejaFlavor.calm ? TejaFlavor.playful : TejaFlavor.calm,
      );
}

/// null = follow the system. Dark mode is a first-class design, not a toggle we
/// bolted on, so this is persisted and applied before the first frame paints.
class ThemeModeController extends Notifier<Brightness?> {
  static const _key = 'teja.theme';

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

/// Wraps the app in Teja's palette and keeps the iOS status bar legible.
class TejaTheme extends StatelessWidget {
  const TejaTheme({
    super.key,
    required this.brightness,
    required this.child,
    this.flavor = TejaFlavor.calm,
  });

  final Brightness brightness;
  final TejaFlavor flavor;
  final Widget child;

  static CupertinoThemeData cupertino(TejaColors c) => CupertinoThemeData(
        brightness: c.isDark ? Brightness.dark : Brightness.light,
        primaryColor: c.ember,
        scaffoldBackgroundColor: c.canvas,
        barBackgroundColor: c.canvas.withValues(alpha: 0.82),
        applyThemeToAll: true,
        textTheme: CupertinoTextThemeData(
          primaryColor: c.ember,
          textStyle: TejaText.body.on(c.ink),
          actionTextStyle: TejaText.headline.on(c.ember),
          navTitleTextStyle: TejaText.headline.on(c.ink),
          navLargeTitleTextStyle: TejaText.title1.on(c.ink),
          tabLabelTextStyle: TejaText.eyebrow.on(c.inkTertiary).copyWith(letterSpacing: 0.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = TejaColors.resolve(flavor, brightness);
    final style = TejaStyle.of(flavor);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: colors.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: TejaColorScope(
        colors: colors,
        child: TejaStyleScope(
          style: style,
          child: CupertinoTheme(data: cupertino(colors), child: child),
        ),
      ),
    );
  }
}
