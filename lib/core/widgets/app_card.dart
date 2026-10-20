import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'neumorphic_container.dart';
import 'press_scale.dart';

/// Global card component used across all screens.
///
/// Renders a raised neumorphic surface and, when [onTap] is provided, adds the
/// tactile `scale 0.97` press feedback specified in the design system.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.borderRadius,
    this.style = NeumorphicStyle.raised,
    this.color,
    this.width,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;
  final NeumorphicStyle style;
  final Color? color;
  final double? width;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppRadius.cardAll;

    final card = NeumorphicContainer(
      style: style,
      borderRadius: radius,
      padding: padding,
      width: width,
      color: color,
      child: child,
    );

    return PressScale(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: card,
    );
  }
}
