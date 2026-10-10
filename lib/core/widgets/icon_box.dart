import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Tinted, rounded icon container used throughout the app (settings rows, cards,
/// headers). Matches the "24px icon centered in a 40px rounded-xl tinted box"
/// pattern from the design system, with an optional soft accent glow.
class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = AppSizes.iconBoxSm,
    this.iconSize = AppSizes.iconSize,
    this.borderRadius,
    this.filled = false,
    this.glow = false,
    this.tintOpacity = 0.1,
    this.heroTag,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final BorderRadius? borderRadius;

  /// Whether the icon uses the filled (FILL 1) symbol weight.
  final bool filled;

  /// Adds a soft colored drop-shadow behind the icon.
  final bool glow;
  final double tintOpacity;

  /// Optional Hero tag to animate this icon between screens.
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final glowAlpha = palette.flatElevation ? 0.3 : 0.5;

    final box = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: tintOpacity),
        borderRadius: borderRadius ?? AppRadius.smAll,
        border: palette.flatElevation
            ? Border.all(color: color.withValues(alpha: 0.12))
            : null,
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: color,
        fill: filled ? 1 : 0,
        shadows: glow
            ? [Shadow(color: color.withValues(alpha: glowAlpha), blurRadius: 8)]
            : null,
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: box);
    }
    return box;
  }
}
