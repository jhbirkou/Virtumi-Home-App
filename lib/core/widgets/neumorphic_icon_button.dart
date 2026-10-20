import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'neumorphic_container.dart';
import 'press_scale.dart';

/// Circular raised neumorphic icon button (header buttons, quick actions).
///
/// Provides the standard `active:scale-95` press feedback.
class NeumorphicIconButton extends StatelessWidget {
  const NeumorphicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = AppSizes.headerButton,
    this.iconColor,
    this.iconSize = 24,
    this.filled = false,
    this.tooltip,
    this.style = NeumorphicStyle.raisedSmall,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final double iconSize;
  final bool filled;
  final String? tooltip;
  final NeumorphicStyle style;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? context.colors.primary;

    Widget button = PressScale(
      style: PressScaleStyle.compact,
      onTap: onPressed,
      semanticLabel: tooltip,
      child: NeumorphicContainer(
        style: style,
        color: context.palette.controlSurface,
        width: size,
        height: size,
        borderRadius: AppRadius.full,
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: color,
          size: iconSize,
          fill: filled ? 1 : 0,
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }

    return button;
  }
}
