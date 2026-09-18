import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../tokens/colors.dart';
import '../tokens/motion.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// A single underlined field. Boxes feel like forms; a rule feels like writing.
class TejaField extends StatelessWidget {
  const TejaField({
    super.key,
    required this.controller,
    this.placeholder,
    this.keyboardType,
    this.autofocus = false,
    this.autofillHints,
    this.maxLines = 1,
    this.maxLength,
    this.onSubmitted,
    this.onChanged,
    this.textStyle,
  });

  final TextEditingController controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool autofocus;
  final List<String>? autofillHints;
  final int? maxLines;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      placeholderStyle: (textStyle ?? TejaText.body).on(c.inkTertiary),
      style: (textStyle ?? TejaText.body).on(c.ink),
      cursorColor: c.ember,
      keyboardType: keyboardType,
      autofocus: autofocus,
      autofillHints: autofillHints,
      maxLines: maxLines,
      maxLength: maxLength,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      padding: const EdgeInsets.symmetric(vertical: Gap.md),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.hairline, width: 1)),
      ),
    );
  }
}

/// Six boxes, auto-advance, paste-aware, auto-submit on the last digit.
/// A wrong code shakes once — never a modal.
class CodeField extends StatefulWidget {
  const CodeField({
    super.key,
    required this.onCompleted,
    this.length = 6,
    this.enabled = true,
    this.errorSignal = 0,
  });

  final ValueChanged<String> onCompleted;
  final int length;
  final bool enabled;

  /// Increment to trigger the shake-and-clear.
  final int errorSignal;

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  late final AnimationController _shake =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 240));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focus.requestFocus());
  }

  @override
  void didUpdateWidget(CodeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorSignal != oldWidget.errorSignal) {
      Feel.error();
      _controller.clear();
      setState(() {});
      if (!Motion.reduced(context)) _shake.forward(from: 0);
      _focus.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _shake.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    if (value.length == widget.length) {
      _focus.unfocus();
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = _controller.text;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final t = _shake.value;
        final dx = t == 0 ? 0.0 : 6 * (1 - t) * ((t * 8).floor().isEven ? 1 : -1);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.length; i++)
                AnimatedContainer(
                  duration: Motion.quick,
                  width: 48,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: c.surfaceAlt,
                    borderRadius: Radii.control,
                    border: Border.all(
                      color: i == value.length && _focus.hasFocus ? c.ember : const Color(0x00000000),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    i < value.length ? value[i] : '',
                    style: TejaText.title2.on(c.ink).tabular,
                  ),
                ),
            ],
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: CupertinoTextField(
                controller: _controller,
                focusNode: _focus,
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.oneTimeCode],
                maxLength: widget.length,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: _onChanged,
                showCursor: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
