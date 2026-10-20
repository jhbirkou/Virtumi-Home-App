import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'press_scale.dart';

/// Neumorphic toggle switch: a sunken track with a raised pill thumb that turns
/// primary-blue (with a soft glow) when active, per the design system.
class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  static const double _width = 56;
  static const double _height = 32;
  static const double _thumb = 24;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final primary = context.colors.primary;
    final trackOff = palette.flatElevation
        ? context.colors.surfaceContainerHighest
        : Color.alphaBlend(
            palette.shadowDark.withValues(alpha: 0.5),
            palette.neuSurface,
          );
    final glowAlpha = palette.flatElevation ? 0.0 : 0.4;

    final track = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: value ? primary : trackOff,
        borderRadius: AppRadius.full,
        boxShadow: value && glowAlpha > 0
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: glowAlpha),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: _thumb,
            height: _thumb,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: palette.flatElevation
                  ? null
                  : [
                      BoxShadow(
                        color: palette.shadowDark.withValues(alpha: 0.6),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
          ),
        ),
      ),
    );

    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: PressScale(
        scalePressed: 0.96,
        enabled: onChanged != null,
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: track,
      ),
    );
  }
}
