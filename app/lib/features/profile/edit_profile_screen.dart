import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/dabble_field.dart';
import '../../design/components/dabble_header.dart';
import '../../design/components/dabble_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../auth/auth_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _username;
  late final TextEditingController _bio;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _name = TextEditingController(text: user?.displayName ?? '');
    _username = TextEditingController(text: user?.username ?? '');
    _bio = TextEditingController(text: user?.bio ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).updateProfile({
        'display_name': _name.text.trim(),
        'username': _username.text.trim().toLowerCase(),
        'bio': _bio.text.trim(),
      });
      if (mounted) context.pop();
    } catch (e) {
      setState(() => _error = 'That handle may be taken. Try another.');
    }
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DabblePage(
      title: 'Edit profile',
      showBack: false,
      leading: DabbleHeaderAction('Cancel', onTap: () => context.pop()),
      trailing: _saving
          ? const Padding(
              padding: EdgeInsets.symmetric(horizontal: Gap.sm),
              child: CupertinoActivityIndicator(),
            )
          : DabbleHeaderAction('Save', emphasis: true, onTap: _save),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h24,
          Text('NAME', style: DabbleText.eyebrow),
          DabbleField(controller: _name, placeholder: 'Your name'),
          Gap.h24,
          Text('HANDLE', style: DabbleText.eyebrow),
          DabbleField(
            controller: _username,
            placeholder: 'handle',
            keyboardType: TextInputType.text,
          ),
          Gap.h8,
          Text(
            'Lowercase letters, numbers and underscores.',
            style: DabbleText.footnote.on(c.inkTertiary),
          ),
          Gap.h24,
          Text('BIO', style: DabbleText.eyebrow),
          DabbleField(
            controller: _bio,
            placeholder: 'One line about your practice',
            maxLines: 3,
            maxLength: 160,
          ),
          if (_error != null) ...[
            Gap.h16,
            Text(_error!, style: DabbleText.footnote.on(c.danger)),
          ],
        ],
      ),
    );
  }
}
