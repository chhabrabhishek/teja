import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/dabble_button.dart';
import '../../design/components/dabble_field.dart';
import '../../design/components/dabble_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import 'auth_controller.dart';

/// A wrong code shakes the boxes once and clears them. Never a modal — a modal
/// makes a typo feel like a failure.
class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key});

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  Timer? _timer;
  int _secondsLeft = 45;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _verify(String code) async {
    final ok = await ref.read(authControllerProvider.notifier).verifyEmailCode(code);
    if (ok && mounted) {
      final isNew = ref.read(authControllerProvider).isNewUser;
      context.go(isNew ? '/auth/crafts' : '/today');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final auth = ref.watch(authControllerProvider);

    return DabblePage(
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h32,
          Text('Check your email', style: DabbleText.title1.on(c.ink)),
          Gap.h8,
          Row(
            children: [
              Flexible(
                child: Text(
                  'Code sent to ${auth.pendingEmail ?? ''}',
                  style: DabbleText.callout.on(c.inkSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap.w8,
              DabbleButton.quiet('Change', onPressed: () => context.pop()),
            ],
          ),
          Gap.h32,
          CodeField(
            enabled: !auth.busy,
            errorSignal: auth.codeErrorSignal,
            onCompleted: _verify,
          ),
          Gap.h20,
          if (auth.busy)
            const CupertinoActivityIndicator()
          else if (_secondsLeft > 0)
            Text(
              'Resend in 0:${_secondsLeft.toString().padLeft(2, '0')}',
              style: DabbleText.footnote.on(c.inkTertiary).tabular,
            )
          else
            DabbleButton.quiet('Send a new code', onPressed: () {
              ref
                  .read(authControllerProvider.notifier)
                  .requestEmailCode(auth.pendingEmail ?? '');
              _startCountdown();
            }),
          if (auth.error != null) ...[
            Gap.h12,
            Text(auth.error!, style: DabbleText.footnote.on(c.danger)),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
