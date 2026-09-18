import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../design/components/stat_row.dart';
import '../../design/components/teja_press.dart';
import '../../design/components/teja_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../auth/auth_controller.dart';

/// Settings is four groups and nothing more. Every extra toggle here is a
/// decision we've pushed onto someone who just wanted to draw something.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final user = ref.watch(authControllerProvider).user;
    final theme = ref.watch(themeModeProvider);

    return TejaPage(
      title: 'Settings',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h24,
          const Eyebrow('Practice'),
          Gap.h12,
          _Group(children: [
            _Row(
              label: 'Daily reminder',
              value: user?.reminderHour == null
                  ? 'Off'
                  : _hourLabel(user!.reminderHour!),
              onTap: () => _pickHour(context, ref, user?.reminderHour ?? 9),
            ),
          ]),
          Gap.h32,
          const Eyebrow('Appearance'),
          Gap.h12,
          _Group(children: [
            _Row(
              label: 'Design',
              value: ref.watch(flavorProvider).label,
              onTap: () => _pickFlavor(context, ref),
            ),
            _Row(
              label: 'Theme',
              value: switch (theme) {
                Brightness.light => 'Light',
                Brightness.dark => 'Dark',
                _ => 'System',
              },
              onTap: () => _pickTheme(context, ref),
            ),
          ]),
          Gap.h32,
          const Eyebrow('Account'),
          Gap.h12,
          _Group(children: [
            _Row(
              label: 'Edit profile',
              onTap: () => context.push('/you/edit'),
            ),
            _Row(label: 'Email', value: user?.email ?? '', muted: true),
          ]),
          Gap.h32,
          const Eyebrow('About'),
          Gap.h12,
          const _Group(children: [
            _Row(label: 'Privacy Policy'),
            _Row(label: 'Terms of Service'),
            _Row(label: 'Version', value: '1.0.0 (1)', muted: true),
          ]),
          Gap.h40,
          Center(
            child: TejaPress(
              onTap: () => ref.read(authControllerProvider.notifier).signOut(),
              child: Padding(
                padding: const EdgeInsets.all(Gap.md),
                child: Text('Sign out', style: TejaText.headline.on(c.ember)),
              ),
            ),
          ),
          Center(
            child: TejaPress(
              onTap: () => _confirmDelete(context, ref),
              child: Padding(
                padding: const EdgeInsets.all(Gap.md),
                child: Text('Delete account', style: TejaText.footnote.on(c.danger)),
              ),
            ),
          ),
          Gap.h40,
        ],
      ),
    );
  }

  static String _hourLabel(int hour) {
    final suffix = hour < 12 ? 'AM' : 'PM';
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display:00 $suffix';
  }

  void _pickHour(BuildContext context, WidgetRef ref, int current) {
    var selected = current;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => Container(
        height: 280,
        color: sheetContext.colors.surface,
        child: Column(
          children: [
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(initialItem: current),
                onSelectedItemChanged: (i) => selected = i,
                children: [
                  for (var h = 0; h < 24; h++)
                    Center(child: Text(_hourLabel(h), style: TejaText.body)),
                ],
              ),
            ),
            CupertinoButton(
              onPressed: () {
                ref
                    .read(authControllerProvider.notifier)
                    .updateProfile({'reminder_hour': selected});
                sheetContext.pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickFlavor(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: const Text('Design'),
        message: const Text('Switch the whole app between two personalities.'),
        actions: [
          for (final flavor in TejaFlavor.values)
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(flavorProvider.notifier).set(flavor);
                sheetContext.pop();
              },
              child: Text('${flavor.label} — ${flavor.blurb}'),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _pickTheme(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          for (final option in [
            ('System', null),
            ('Light', Brightness.light),
            ('Dark', Brightness.dark),
          ])
            CupertinoActionSheetAction(
              onPressed: () {
                ref.read(themeModeProvider.notifier).set(option.$2);
                sheetContext.pop();
              },
              child: Text(option.$1),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'Your creations, streak and comments are permanently removed. '
          'This cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => dialogContext.pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              dialogContext.pop();
              ref.read(authControllerProvider.notifier).deleteAccount();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: Radii.card,
        border: c.isDark ? Border.all(color: c.hairline) : null,
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const Hairline(indent: Gap.lg),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, this.value, this.onTap, this.muted = false});

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TejaPress(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.lg),
        child: Row(
          children: [
            Text(label, style: TejaText.callout.on(c.ink)),
            const Spacer(),
            if (value != null)
              Flexible(
                child: Text(
                  value!,
                  style: TejaText.callout.on(c.inkTertiary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (!muted) ...[
              Gap.w8,
              Icon(CupertinoIcons.chevron_right, size: 14, color: c.inkTertiary),
            ],
          ],
        ),
      ),
    );
  }
}
