import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../design/components/avatar.dart';
import '../../design/components/teja_header.dart';
import '../../design/components/teja_button.dart';
import '../../design/components/teja_press.dart';import '../../design/components/torn_edge.dart';import '../../design/tokens/colors.dart';
import '../../design/tokens/motion.dart';
import '../../design/tokens/spacing.dart';
import '../../design/tokens/typography.dart';
import '../../domain/enums.dart';
import '../home/home_controller.dart';
import 'compose_controller.dart';

/// A writing room, not a form.
///
/// The prompt stays pinned at the top in small type so the thread is never lost,
/// but it recedes. Chrome is three things: Cancel, the save state, Publish. The
/// keyboard is the interface.
class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  late final TextEditingController _text;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController(text: ref.read(composeControllerProvider).body);
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _confirmDismiss() async {
    final state = ref.read(composeControllerProvider);
    if (!state.hasContent) {
      context.pop();
      return;
    }
    await ref.read(composeControllerProvider.notifier).save();
    if (!mounted) return;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        message: const Text('Your draft is saved. You can finish it any time today.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              sheetContext.pop();
              context.pop();
            },
            child: const Text('Keep draft'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              sheetContext.pop();
              context.pop();
            },
            child: const Text('Discard'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _confirmPublish() async {
    final confirmed = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: const Text('Publish to today\'s feed?'),
        message: const Text('Everyone who created today will see it.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => sheetContext.pop(true),
            child: const Text('Publish'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(false),
          child: const Text('Keep editing'),
        ),
      ),
    );
    if (confirmed != true || !mounted) return;

    final result = await ref.read(composeControllerProvider.notifier).publish();
    if (result == null || !mounted) return;
    Feel.celebrate();
    context.pushReplacement('/spark?day=${result.streak.current}');
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final state = ref.watch(composeControllerProvider);
    final prompt = ref.watch(homeControllerProvider).valueOrNull?.today?.prompt;
    final craft = Craft.from(prompt?.category);

    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      // A plain Row instead of CupertinoNavigationBar: that widget centres its
      // middle slot absolutely and hands leading/trailing loose constraints, so
      // the two tap targets overlap. Here each side owns exactly its own width.
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TejaHeader(
              leading: TejaHeaderAction('Cancel', onTap: _confirmDismiss),
              trailing: state.publishing
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Gap.sm),
                      child: CupertinoActivityIndicator(),
                    )
                  : TejaButton(
                      'Publish',
                      size: TejaButtonSize.small,
                      expand: false,
                      onPressed: state.hasContent ? _confirmPublish : null,
                    ),
            ),
            if (state.uploadProgress != null)
              _ProgressLine(progress: state.uploadProgress!),
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.sm, Gap.gutter, Gap.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      prompt?.text ?? '',
                      style: TejaText.subhead.on(c.inkSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gap.w12,
                  _SaveIndicator(state: state.save),
                ],
              ),
            ),
            const TornEdge(),
            Expanded(
              child: craft.isImage
                  ? _ImageComposer(craft: craft, text: _text)
                  : _TextComposer(craft: craft, controller: _text),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Gap.gutter, vertical: Gap.sm),
                child: Text(state.error!, style: TejaText.footnote.on(c.danger)),
              ),
            if (!craft.isImage) _EditorToolbar(craft: craft, controller: _text),
          ],
        ),
      ),
    );
  }
}

class _TextComposer extends ConsumerWidget {
  const _TextComposer({required this.craft, required this.controller});

  final Craft craft;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(composeControllerProvider);

    // Preview is a cross-fade on the same surface, never a second screen.
    return AnimatedSwitcher(
      duration: Motion.quick,
      child: state.preview
          ? Markdown(
              key: const ValueKey('preview'),
              data: state.body,
              padding: const EdgeInsets.all(Gap.gutter),
              styleSheet: MarkdownStyleSheet(
                p: TejaText.body.on(c.ink),
                h1: TejaText.title2.on(c.ink),
                h2: TejaText.headline.on(c.ink),
                blockquote: TejaText.body.on(c.inkSecondary),
                listBullet: TejaText.body.on(c.ink),
              ),
            )
          : CupertinoTextField(
              key: const ValueKey('editor'),
              controller: controller,
              autofocus: true,
              maxLines: null,
              expands: true,
              maxLength: craft.characterLimit,
              textAlignVertical: TextAlignVertical.top,
              placeholder: craft.placeholder,
              placeholderStyle: TejaText.body.on(c.inkTertiary),
              style: TejaText.body.on(c.ink),
              cursorColor: c.ember,
              decoration: const BoxDecoration(),
              padding: const EdgeInsets.fromLTRB(Gap.gutter, Gap.lg, Gap.gutter, Gap.lg),
              onChanged: ref.read(composeControllerProvider.notifier).setBody,
            ),
    );
  }
}

class _ImageComposer extends ConsumerWidget {
  const _ImageComposer({required this.craft, required this.text});

  final Craft craft;
  final TextEditingController text;

  void _pick(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              sheetContext.pop();
              ref.read(composeControllerProvider.notifier).pickImage(ImageSource.camera);
            },
            child: const Text('Camera'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sheetContext.pop();
              ref.read(composeControllerProvider.notifier).pickImage(ImageSource.gallery);
            },
            child: const Text('Photo Library'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => sheetContext.pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(composeControllerProvider);
    final hasImage = (state.imageUrl ?? '').isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Gap.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TejaPress(
            onTap: () => _pick(context, ref),
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: hasImage
                  ? TejaImage(url: state.imageUrl!)
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        color: c.surfaceAlt,
                        borderRadius: Radii.image,
                        border: Border.all(color: c.hairline),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.add, size: 26, color: c.inkSecondary),
                          Gap.h12,
                          Text(
                            craft == Craft.sketch ? 'Add your sketch' : 'Add a photo',
                            style: TejaText.headline.on(c.ink),
                          ),
                          Gap.h4,
                          Text(
                            'Camera or Library',
                            style: TejaText.footnote.on(c.inkTertiary),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          if (hasImage) ...[
            Gap.h12,
            TejaButton.quiet('Replace', onPressed: () => _pick(context, ref)),
          ],
          Gap.h16,
          CupertinoTextField(
            controller: text,
            maxLines: 3,
            minLines: 1,
            placeholder: craft.placeholder,
            placeholderStyle: TejaText.body.on(c.inkTertiary),
            style: TejaText.body.on(c.ink),
            cursorColor: c.ember,
            decoration: const BoxDecoration(),
            padding: EdgeInsets.zero,
            onChanged: ref.read(composeControllerProvider.notifier).setBody,
          ),
        ],
      ),
    );
  }
}

/// Markdown shortcuts, a preview toggle, and a count. No font pickers, no colour
/// swatches, no alignment buttons — this is not a word processor.
class _EditorToolbar extends ConsumerWidget {
  const _EditorToolbar({required this.craft, required this.controller});

  final Craft craft;
  final TextEditingController controller;

  void _wrap(WidgetRef ref, String token) {
    final selection = controller.selection;
    final text = controller.text;
    if (!selection.isValid) return;
    final selected = selection.textInside(text);
    final replacement = '$token$selected$token';
    controller.value = controller.value.copyWith(
      text: selection.textBefore(text) + replacement + selection.textAfter(text),
      selection: TextSelection.collapsed(
        offset: selection.start + replacement.length - (selected.isEmpty ? token.length : 0),
      ),
    );
    ref.read(composeControllerProvider.notifier).setBody(controller.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final state = ref.watch(composeControllerProvider);
    final limit = craft.characterLimit;
    final count = state.body.length;
    final nearLimit = limit != null && count > limit - 20;

    final keyboardUp = MediaQuery.viewInsetsOf(context).bottom > 0;

    return Container(
      padding: EdgeInsets.only(
        left: Gap.gutter,
        right: Gap.gutter,
        top: Gap.sm,
        bottom: keyboardUp ? Gap.sm : Gap.xl,
      ),
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        border: Border(top: BorderSide(color: c.hairline, width: 0.5)),
      ),
      child: Row(
        children: [
          if (craft != Craft.joke) ...[
            _ToolButton(label: 'B', bold: true, onTap: () => _wrap(ref, '**')),
            _ToolButton(label: 'i', italic: true, onTap: () => _wrap(ref, '_')),
            _ToolButton(label: '“', onTap: () => _wrap(ref, '"')),
            Gap.w12,
            TejaButton.quiet(
              state.preview ? 'Edit' : 'Preview',
              onPressed: ref.read(composeControllerProvider.notifier).togglePreview,
            ),
          ],
          const Spacer(),
          Text(
            limit == null
                ? '${state.body.trim().isEmpty ? 0 : state.body.trim().split(RegExp(r'\s+')).length} words'
                : '${limit - count}',
            style: TejaText.footnote
                .on(nearLimit ? c.ember : c.inkTertiary)
                .tabular,
          ),
        ],
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.label,
    required this.onTap,
    this.bold = false,
    this.italic = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool bold;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TejaPress(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 34,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TejaText.headline.on(c.ink).copyWith(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
              ),
        ),
      ),
    );
  }
}

class _SaveIndicator extends StatelessWidget {
  const _SaveIndicator({required this.state});

  final ComposeSaveState state;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (text, color) = switch (state) {
      ComposeSaveState.saving => ('Saving…', c.inkTertiary),
      ComposeSaveState.saved => ('Draft · saved', c.inkTertiary),
      ComposeSaveState.failed => ('Not saved', c.danger),
      ComposeSaveState.idle => ('', c.inkTertiary),
    };
    return AnimatedSwitcher(
      duration: Motion.quick,
      child: Text(text, key: ValueKey(text), style: TejaText.footnote.on(color)),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 2,
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: progress.clamp(0.02, 1),
          child: ColoredBox(color: c.ember, child: const SizedBox(height: 2)),
        ),
      ),
    );
  }
}
