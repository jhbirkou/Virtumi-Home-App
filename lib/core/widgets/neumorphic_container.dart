import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Visual style for a [NeumorphicContainer].
enum NeumorphicStyle {
  /// Extruded element that rises out of the background (dual outer shadow).
  raised,

  /// Smaller raised variant used for compact buttons.
  raisedSmall,

  /// Pressed-in element (simulated inset look) for tracks / input wells.
  sunken,

  /// No shadow, just the neumorphic surface color.
  flat,
}

/// The foundational neumorphic surface used by every card/button in the app.
///
/// Centralizes the surface color + dual-shadow recipe so the soft UI look stays
/// 100% consistent. Prefer [AppCard] for tappable cards.
class NeumorphicContainer extends StatelessWidget {
  const NeumorphicContainer({
    super.key,
    this.child,
    this.style = NeumorphicStyle.raised,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.color,
    this.alignment,
  });

  final Widget? child;
  final NeumorphicStyle style;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;
    final radius = borderRadius ?? AppRadius.cardAll;
    final surface = color ?? palette.neuSurface;
    final flatBorder = palette.flatElevation
        ? Border.all(color: palette.cardBorder)
        : null;

    final decoration = switch (style) {
      NeumorphicStyle.raised => BoxDecoration(
          color: surface,
          borderRadius: radius,
          border: flatBorder,
          boxShadow: palette.flatElevation ? null : palette.raised,
        ),
      NeumorphicStyle.raisedSmall => BoxDecoration(
          color: surface,
          borderRadius: radius,
          border: flatBorder,
          boxShadow: palette.flatElevation ? null : palette.raisedSmall,
        ),
      NeumorphicStyle.sunken => BoxDecoration(
          color: palette.flatElevation
              ? colors.surfaceContainerHigh
              : Color.alphaBlend(
                  palette.shadowDark.withValues(alpha: 0.35),
                  surface,
                ),
          borderRadius: radius,
          border: flatBorder ??
              Border.all(
                color: palette.shadowLight.withValues(alpha: 0.6),
                width: 1,
              ),
        ),
      NeumorphicStyle.flat => BoxDecoration(
          color: surface,
          borderRadius: radius,
          border: flatBorder,
        ),
    };

    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      child: child,
    );
  }
}
