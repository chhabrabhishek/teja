import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/teja_repository.dart';
import '../../design/components/chips.dart';
import '../../design/components/teja_press.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/flavor.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/models.dart';

final topicsProvider = FutureProvider.autoDispose<List<Topic>>(
  (ref) => ref.read(tejaRepositoryProvider).topics(),
);

/// The interest tree.
///
/// Crafts are headers, not choices — picking the craft would tell us nothing we
/// can act on, since the daily challenge is drawn from a *leaf*. Selecting a
/// craft therefore selects all of its topics rather than acting as its own node.
class TopicPicker extends ConsumerWidget {
  const TopicPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final topics = ref.watch(topicsProvider);

    return topics.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: Gap.large),
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Gap.xl),
        child: Text(
          "Couldn't load topics. Pull to try again.",
          style: TejaText.callout.on(c.inkSecondary),
        ),
      ),
      data: (roots) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final root in roots) ...[
            _RootSection(
              root: root,
              selected: selected,
              onToggleChild: (id) {
                final next = Set<String>.from(selected);
                next.contains(id) ? next.remove(id) : next.add(id);
                onChanged(next);
              },
              onToggleAll: () {
                final childIds = root.children.map((t) => t.id).toSet();
                final next = Set<String>.from(selected);
                childIds.every(next.contains)
                    ? next.removeAll(childIds)
                    : next.addAll(childIds);
                onChanged(next);
              },
            ),
            Gap.h24,
          ],
        ],
      ),
    );
  }
}

class _RootSection extends StatelessWidget {
  const _RootSection({
    required this.root,
    required this.selected,
    required this.onToggleChild,
    required this.onToggleAll,
  });

  final Topic root;
  final Set<String> selected;
  final ValueChanged<String> onToggleChild;
  final VoidCallback onToggleAll;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hue = TejaColors.forCategory(root.craft);
    final childIds = root.children.map((t) => t.id).toSet();
    final allOn = childIds.isNotEmpty && childIds.every(selected.contains);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(CategoryChip.glyphFor(root.craft), size: 16, color: hue),
            Gap.w8,
            Expanded(
              child: Text(root.name.toUpperCase(), style: TejaText.eyebrow.on(hue)),
            ),
            TejaPress(
              onTap: onToggleAll,
              semanticLabel: allOn ? 'Deselect all ${root.name}' : 'Select all ${root.name}',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Gap.xs, vertical: Gap.sm),
                child: Text(
                  allOn ? 'None' : 'All',
                  style: TejaText.footnote.on(c.inkTertiary),
                ),
              ),
            ),
          ],
        ),
        if (root.blurb.isNotEmpty) ...[
          Gap.h4,
          Text(root.blurb, style: TejaText.footnote.on(c.inkTertiary)),
        ],
        Gap.h12,
        for (final child in root.children)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.sm),
            child: _TopicRow(
              topic: child,
              hue: hue,
              isSelected: selected.contains(child.id),
              onTap: () => onToggleChild(child.id),
            ),
          ),
      ],
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({
    required this.topic,
    required this.hue,
    required this.isSelected,
    required this.onTap,
  });

  final Topic topic;
  final Color hue;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.style;

    return TejaPress(
      onTap: onTap,
      scale: s.pressScale,
      semanticLabel: '${topic.name}. ${isSelected ? 'Selected' : 'Not selected'}',
      child: AnimatedContainer(
        duration: Motion.quick,
        curve: Motion.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: Gap.lg, vertical: Gap.md),
        decoration: BoxDecoration(
          color: isSelected ? hue.withValues(alpha: c.categoryChipFill) : c.surface,
          borderRadius: s.cardRadius,
          border: Border.all(
            color: isSelected ? hue : c.hairline,
            width: isSelected ? 1.5 : s.borderWidth,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.name,
                    style: TejaText.headline.on(c.ink).copyWith(
                          fontFamily: s.roundedFamily,
                          fontWeight: s.headlineWeight,
                        ),
                  ),
                  if (topic.blurb.isNotEmpty) ...[
                    Gap.h4,
                    Text(topic.blurb, style: TejaText.footnote.on(c.inkSecondary)),
                  ],
                ],
              ),
            ),
            Gap.w12,
            AnimatedOpacity(
              duration: Motion.quick,
              opacity: isSelected ? 1 : 0,
              child: Icon(CupertinoIcons.checkmark_circle_fill, size: 22, color: hue),
            ),
          ],
        ),
      ),
    );
  }
}
