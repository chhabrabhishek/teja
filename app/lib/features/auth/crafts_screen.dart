import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design/components/chips.dart';
import '../../design/components/teja_button.dart';
import '../../design/components/teja_header.dart';
import '../../design/components/teja_press.dart';
import '../../design/components/teja_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/enums.dart';
import 'auth_controller.dart';

/// A tiny investment ritual: the app feels like it's about *you* before you've
/// made anything. Skippable — forcing it would betray the "no friction" promise.
class CraftsScreen extends ConsumerStatefulWidget {
  const CraftsScreen({super.key});

  @override
  ConsumerState<CraftsScreen> createState() => _CraftsScreenState();
}

class _CraftsScreenState extends ConsumerState<CraftsScreen> {
  final _selected = <Craft>{};
  bool _saving = false;

  Future<void> _continue() async {
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).updateProfile({
        'preferred_categories': _selected.map((c) => c.id).toList(),
      });
    } catch (_) {
      // A preference is not worth blocking onboarding over.
    }
    if (mounted) context.go('/today');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return TejaPage(
      scrollable: false,
      trailing: TejaHeaderAction('Skip', onTap: () => context.go('/today')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h24,
          Text('Which pull at you?', style: TejaText.title1.on(c.ink)),
          Gap.h8,
          Text(
            "You'll still get every prompt — this just shapes how we talk to you.",
            style: TejaText.callout.on(c.inkSecondary),
          ),
          Gap.h32,
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: Gap.md,
              mainAxisSpacing: Gap.md,
              childAspectRatio: 0.95,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final craft in Craft.values)
                  _CraftTile(
                    craft: craft,
                    selected: _selected.contains(craft),
                    onTap: () => setState(() {
                      _selected.contains(craft)
                          ? _selected.remove(craft)
                          : _selected.add(craft);
                    }),
                  ),
              ],
            ),
          ),
          Gap.h16,
          TejaButton('Continue', loading: _saving, onPressed: _continue),
          Gap.h24,
        ],
      ),
    );
  }
}

class _CraftTile extends StatelessWidget {
  const _CraftTile({required this.craft, required this.selected, required this.onTap});

  final Craft craft;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hue = TejaColors.forCategory(craft.id);

    return TejaPress(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.quick,
        curve: Motion.easeOut,
        padding: const EdgeInsets.all(Gap.xl),
        decoration: BoxDecoration(
          color: selected ? hue.withValues(alpha: c.categoryChipFill) : c.surface,
          borderRadius: Radii.card,
          border: Border.all(
            color: selected ? hue : c.hairline,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CategoryChip.glyphFor(craft.id), size: 20, color: hue),
                const Spacer(),
                AnimatedOpacity(
                  duration: Motion.quick,
                  opacity: selected ? 1 : 0,
                  child: Icon(CupertinoIcons.checkmark_circle_fill, size: 20, color: hue),
                ),
              ],
            ),
            const Spacer(),
            Text(craft.label, style: TejaText.headline.on(c.ink)),
            Gap.h4,
            Text(craft.blurb, style: TejaText.footnote.on(c.inkSecondary)),
          ],
        ),
      ),
    );
  }
}
