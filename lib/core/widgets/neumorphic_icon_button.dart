import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'neumorphic_container.dart';

/// Circular raised neumorphic icon button (header buttons, quick actions).
///
/// Provides the standard `active:scale-95` press feedback.
class NeumorphicIconButton extends StatefulWidget {
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
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.iconColor ?? context.colors.primary;

    Widget button = AnimatedScale(
      scale: _pressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: NeumorphicContainer(
        style: widget.style,
        color: context.palette.controlSurface,
        width: widget.size,
        height: widget.size,
        borderRadius: AppRadius.full,
        alignment: Alignment.center,
        child: Icon(
          widget.icon,
          color: color,
          size: widget.iconSize,
          fill: widget.filled ? 1 : 0,
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return Semantics(
      button: true,
      label: widget.tooltip,
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        behavior: HitTestBehavior.opaque,
        child: button,
      ),
    );
  }
}
