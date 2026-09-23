import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../tokens/colors.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import 'dabble_press.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.name,
    this.url,
    this.size = 32,
    this.onTap,
  });

  final String name;
  final String? url;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final initial = _initialOf(name);

    Widget avatar = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.surfaceAlt,
        shape: BoxShape.circle,
        border: c.isDark ? Border.all(color: c.hairline) : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url!.isEmpty
          ? Text(
              initial,
              style: DabbleText.headline
                  .on(c.inkSecondary)
                  .copyWith(fontSize: size * 0.4, height: 1),
            )
          : CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              width: size,
              height: size,
              fadeInDuration: const Duration(milliseconds: 180),
              errorWidget: (_, __, ___) =>
                  Text(initial, style: DabbleText.headline.on(c.inkSecondary)),
            ),
    );

    if (onTap != null) avatar = DabblePress(onTap: onTap, child: avatar);
    return Semantics(label: name, image: true, child: avatar);
  }

  /// Skips leading punctuation so an '@handle' shows its first letter, not '@'.
  static String _initialOf(String name) {
    for (final char in name.trim().split('')) {
      if (RegExp(r'[a-zA-Z0-9]').hasMatch(char)) return char.toUpperCase();
    }
    return '·';
  }
}

/// A network image that never flashes: skeleton → cross-fade, warm placeholder.
class DabbleImage extends StatelessWidget {
  const DabbleImage({
    super.key,
    required this.url,
    this.aspectRatio,
    this.borderRadius = Radii.image,
  });

  final String url;
  final double? aspectRatio;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget image = ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceAlt,
          // A 1px inner hairline keeps white photos from bleeding into the canvas.
          border: Border.all(color: c.hairline, width: 0.5),
          borderRadius: borderRadius,
        ),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 240),
          placeholder: (_, __) => ColoredBox(color: c.surfaceAlt),
          errorWidget: (_, __, ___) => Center(
            child: Icon(CupertinoIcons.photo, color: c.inkTertiary, size: 22),
          ),
        ),
      ),
    );

    if (aspectRatio != null) {
      image = AspectRatio(aspectRatio: aspectRatio!, child: image);
    }
    return image;
  }
}
