import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../design/components/aurora_background.dart';
import '../../design/components/teja_button.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import 'auth_controller.dart';

/// A single held breath.
///
/// No carousel, no feature grid, no "Skip". One promise, two ways in. Carousels
/// are where trust goes to die — people swipe past them and learn nothing.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final auth = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider.select((s) => s.status), (_, status) {
      if (status == AuthStatus.signedIn) {
        context.go(ref.read(authControllerProvider).isNewUser ? '/auth/crafts' : '/today');
      }
    });

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: AuroraBackground(
        intensity: 0.85,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 3),
                FadeRise(
                  child: Text('Teja', style: TejaText.title1.on(c.ember)),
                ),
                Gap.h24,
                FadeRise(
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    'One prompt a day.\nMake something small.',
                    style: TejaText.displayXL.on(c.ink),
                  ),
                ),
                Gap.h16,
                FadeRise(
                  delay: const Duration(milliseconds: 160),
                  child: Text(
                    'Then see what the world made from the same spark.',
                    style: TejaText.callout.on(c.inkSecondary),
                  ),
                ),
                const Spacer(flex: 4),
                if (auth.error != null) ...[
                  Text(
                    auth.error!,
                    style: TejaText.footnote.on(c.danger),
                    textAlign: TextAlign.center,
                  ),
                  Gap.h12,
                ],
                FadeRise(
                  delay: const Duration(milliseconds: 240),
                  child: SignInWithAppleButton(
                    height: 54,
                    borderRadius: BorderRadius.circular(999),
                    style: c.isDark
                        ? SignInWithAppleButtonStyle.white
                        : SignInWithAppleButtonStyle.black,
                    onPressed: () =>
                        ref.read(authControllerProvider.notifier).signInWithApple(),
                  ),
                ),
                Gap.h12,
                FadeRise(
                  delay: const Duration(milliseconds: 300),
                  child: TejaButton.secondary(
                    'Continue with email',
                    onPressed: () => context.push('/auth/email'),
                  ),
                ),
                Gap.h20,
                Center(
                  child: Text(
                    'By continuing you agree to our Terms & Privacy Policy.',
                    style: TejaText.footnote.on(c.inkTertiary),
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap.h24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
