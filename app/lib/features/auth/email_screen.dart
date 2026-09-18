import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/teja_button.dart';
import '../../design/components/teja_field.dart';
import '../../design/components/teja_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import 'auth_controller.dart';

/// One screen, one field, zero decisions. The keyboard is up on arrival.
class EmailScreen extends ConsumerStatefulWidget {
  const EmailScreen({super.key});

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final _controller = TextEditingController();
  bool _valid = false;

  static final _re = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final sent = await ref
        .read(authControllerProvider.notifier)
        .requestEmailCode(_controller.text);
    if (sent && mounted) context.push('/auth/code');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final auth = ref.watch(authControllerProvider);

    return TejaPage(
      scrollable: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h32,
          Text("What's your email?", style: TejaText.title1.on(c.ink)),
          Gap.h32,
          TejaField(
            controller: _controller,
            placeholder: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            autofillHints: const [AutofillHints.email],
            onChanged: (v) => setState(() => _valid = _re.hasMatch(v.trim())),
            onSubmitted: (_) => _valid ? _continue() : null,
          ),
          Gap.h16,
          Text(
            "We'll send a 6-digit code. No password to remember.",
            style: TejaText.footnote.on(c.inkTertiary),
          ),
          if (auth.error != null) ...[
            Gap.h12,
            Text(auth.error!, style: TejaText.footnote.on(c.danger)),
          ],
          const Spacer(),
          TejaButton(
            'Continue',
            loading: auth.busy,
            onPressed: _valid ? _continue : null,
          ),
          Gap.h24,
        ],
      ),
    );
  }
}
