import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/teja_repository.dart';
import '../../design/components/teja_button.dart';
import '../../design/components/teja_header.dart';
import '../../design/components/teja_scaffold.dart';
import '../../design/tokens/colors.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../today/today_controller.dart';
import 'topic_picker.dart';

/// A tiny investment ritual, and the only thing that decides what you're asked
/// to make each day. Skippable — forcing it would betray the "no friction"
/// promise, and an empty selection simply widens the prompt pool.
class InterestsScreen extends ConsumerStatefulWidget {
  const InterestsScreen({super.key, this.isOnboarding = true});

  final bool isOnboarding;

  @override
  ConsumerState<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends ConsumerState<InterestsScreen> {
  Set<String>? _selected;
  bool _saving = false;

  Set<String> _initial(List topics) {
    final out = <String>{};
    for (final root in topics) {
      for (final child in root.children) {
        if (child.isSelected) out.add(child.id as String);
      }
      if (root.isSelected) out.add(root.id as String);
    }
    return out;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(tejaRepositoryProvider).setTopics((_selected ?? {}).toList());
      // The daily challenge is drawn from these, so it must be re-resolved.
      ref.invalidate(todayControllerProvider);
    } catch (_) {
      // An interest is never worth blocking onboarding over.
    }
    if (!mounted) return;
    widget.isOnboarding ? context.go('/today') : context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final topics = ref.watch(topicsProvider);
    final selected = _selected ?? (topics.valueOrNull == null ? <String>{} : _initial(topics.value!));
    final count = selected.length;

    return TejaPage(
      showBack: !widget.isOnboarding,
      trailing: widget.isOnboarding
          ? TejaHeaderAction('Skip', onTap: () => context.go('/today'))
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap.h16,
          Text('Which pull at you?', style: TejaText.title1.on(c.ink)),
          Gap.h8,
          Text(
            'Your daily challenge comes from these. Pick as many as you like — '
            'you can change them any time.',
            style: TejaText.callout.on(c.inkSecondary),
          ),
          Gap.h32,
          TopicPicker(
            selected: selected,
            onChanged: (next) => setState(() => _selected = next),
          ),
          Gap.h16,
          TejaButton(
            count == 0 ? 'Continue' : 'Continue with $count',
            loading: _saving,
            onPressed: _save,
          ),
          Gap.h8,
          Center(
            child: Text(
              count == 0
                  ? "Pick none and we'll draw from everything."
                  : 'One challenge a day, drawn from these.',
              style: TejaText.footnote.on(c.inkTertiary),
            ),
          ),
          Gap.h40,
        ],
      ),
    );
  }
}
