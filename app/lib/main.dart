import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'design/tokens/colors.dart';

void main() {
  runApp(const ProviderScope(child: TejaApp()));
}

class TejaApp extends ConsumerWidget {
  const TejaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final override = ref.watch(themeModeProvider);
    final flavor = ref.watch(flavorProvider);
    final router = ref.watch(routerProvider);
    final brightness = override ?? MediaQuery.platformBrightnessOf(context);
    final colors = TejaColors.resolve(flavor, brightness);

    // TejaTheme sits above CupertinoApp, so every routed page resolves
    // `context.colors` and `context.style` without re-wrapping.
    return TejaTheme(
      brightness: brightness,
      flavor: flavor,
      child: CupertinoApp.router(
        title: 'Teja',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: TejaTheme.cupertino(colors),
      ),
    );
  }
}
