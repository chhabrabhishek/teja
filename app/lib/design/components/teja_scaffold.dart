import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'aurora_background.dart';
import 'teja_header.dart';

/// Every screen in Teja is built on this.
///
/// Warm canvas, a large iOS title that collapses on scroll, an optional aurora
/// backdrop, and a translucent nav bar with a hairline — never an elevated
/// Material AppBar.
class TejaScaffold extends StatelessWidget {
  const TejaScaffold({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.leading,
    this.aurora = false,
    this.largeTitle = true,
    this.slivers,
    this.onRefresh,
    this.padding = const EdgeInsets.symmetric(horizontal: Gap.gutter),
  });

  final Widget child;
  final String? title;
  final Widget? trailing;
  final Widget? leading;
  final bool aurora;
  final bool largeTitle;
  final List<Widget>? slivers;
  final Future<void> Function()? onRefresh;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final content = CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        if (title != null)
          CupertinoSliverNavigationBar(
            largeTitle: Text(title!, style: TejaText.title1.on(c.ink)),
            backgroundColor: c.canvas.withValues(alpha: 0.82),
            border: Border(bottom: BorderSide(color: c.hairline, width: 0.0)),
            trailing: trailing,
            leading: leading,
            automaticallyImplyLeading: leading == null,
            stretch: true,
          ),
        if (onRefresh != null) CupertinoSliverRefreshControl(onRefresh: onRefresh),
        ...?slivers,
        SliverPadding(
          padding: padding,
          sliver: SliverToBoxAdapter(child: child),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: Gap.large)),
      ],
    );

    return CupertinoPageScaffold(
      backgroundColor: aurora ? const Color(0x00000000) : c.canvas,
      child: aurora
          ? AuroraBackground(child: SafeArea(top: false, bottom: false, child: content))
          : content,
    );
  }
}

/// Pushed (non-tab) pages: plain header, back swipe intact.
class TejaPage extends StatelessWidget {
  const TejaPage({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.leading,
    this.padding = const EdgeInsets.symmetric(horizontal: Gap.gutter),
    this.scrollable = true,
    this.showBack = true,
  });

  final Widget child;
  final String? title;
  final Widget? trailing;
  final Widget? leading;
  final EdgeInsets padding;
  final bool scrollable;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final body = Padding(padding: padding, child: child);
    // Back-swipe comes from CupertinoPage, not from a navigation bar, so using a
    // plain header here costs nothing.
    return CupertinoPageScaffold(
      backgroundColor: c.canvas,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TejaHeader(
              title: title,
              leading: leading,
              trailing: trailing,
              showBack: showBack && Navigator.of(context).canPop(),
            ),
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: body,
                    )
                  : body,
            ),
          ],
        ),
      ),
    );
  }
}
