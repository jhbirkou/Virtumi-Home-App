import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual press style for [PressScale].
enum PressScaleStyle {
  /// Standard buttons and cards (scale 0.97).
  standard,

  /// Compact icon buttons (scale 0.92).
  compact,
}

/// Wraps [child] with scale-down press feedback and optional haptic click.
///
/// Matches the Stitch micro-interaction pattern (`active:scale-[0.97]`).
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.semanticLabel,
    this.style = PressScaleStyle.standard,
    this.scalePressed,
    this.duration = const Duration(milliseconds: 120),
    this.haptic = true,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final String? semanticLabel;
  final PressScaleStyle style;
  final double? scalePressed;
  final Duration duration;
  final bool haptic;
  final HitTestBehavior behavior;

  double get _resolvedScalePressed => scalePressed ??
      switch (style) {
        PressScaleStyle.standard => 0.97,
        PressScaleStyle.compact => 0.92,
      };

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale> {
  bool _pressed = false;

  bool get _interactive => widget.enabled && widget.onTap != null;

  void _setPressed(bool value) {
    if (!_interactive) return;
    setState(() => _pressed = value);
  }

  void _onTapDown(TapDownDetails _) {
    if (!_interactive) return;
    if (widget.haptic) {
      HapticFeedback.selectionClick();
    }
    _setPressed(true);
  }

  @override
  Widget build(BuildContext context) {
    final scale = _interactive && _pressed ? widget._resolvedScalePressed : 1.0;

    Widget content = AnimatedScale(
      scale: scale,
      duration: widget.duration,
      curve: Curves.easeOut,
      child: widget.child,
    );

    if (widget.semanticLabel != null || _interactive) {
      content = Semantics(
        button: _interactive,
        enabled: widget.enabled,
        label: widget.semanticLabel,
        child: content,
      );
    }

    if (!_interactive) return content;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      behavior: widget.behavior,
      child: content,
    );
  }
}
