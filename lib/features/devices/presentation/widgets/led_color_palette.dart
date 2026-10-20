import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Predefined LED color swatch palette. The active color is highlighted; tapping
/// a swatch selects it (only while [enabled]).
class LedColorPalette extends StatelessWidget {
  const LedColorPalette({
    super.key,
    required this.selectedValue,
    required this.onSelected,
    this.onCustomTap,
    this.enabled = true,
    this.compact = false,
  });

  final int selectedValue;
  final ValueChanged<int> onSelected;

  /// Called when the "custom color" circle is tapped (opens a free color picker).
  final VoidCallback? onCustomTap;
  final bool enabled;
  final bool compact;

  /// Curated palette of LED colors (warm/cool whites + vivid hues).
  static const List<int> palette = [
    0xFFFFF1D6, // Warmweiß
    0xFFFFFFFF, // Kaltweiß
    0xFF0070EA, // Blau
    0xFF3DC2FD, // Cyan
    0xFF14B8A6, // Türkis
    0xFF22C55E, // Grün
    0xFFEAB308, // Gelb
    0xFFEA580C, // Orange
    0xFFDC2626, // Rot
    0xFFEC4899, // Pink
    0xFF9333EA, // Violett
    0xFF4F46E5, // Indigo
  ];

  @override
  Widget build(BuildContext context) {
    final isCustomSelected = !palette.contains(selectedValue);
    final swatchSize = compact ? 36.0 : 48.0;
    final spacing = compact ? AppSpacing.sm : AppSpacing.gutter;

    final content = Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (final value in palette)
          _Swatch(
            color: Color(value),
            selected: value == selectedValue,
            size: swatchSize,
            flat: compact,
            onTap: enabled ? () => onSelected(value) : null,
          ),
        _CustomSwatch(
          selectedColor: isCustomSelected ? Color(selectedValue) : null,
          size: swatchSize,
          flat: compact,
          onTap: enabled ? onCustomTap : null,
        ),
      ],
    );

    if (compact) {
      return ClipRect(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: content,
        ),
      );
    }

    return AppCard(child: content);
  }
}

/// Special swatch that opens a free color picker. Shows the active custom color
/// when one is selected, otherwise a rainbow ring with a palette icon.
class _CustomSwatch extends StatelessWidget {
  const _CustomSwatch({
    required this.selectedColor,
    required this.onTap,
    this.size = 48,
    this.flat = false,
  });

  final Color? selectedColor;
  final VoidCallback? onTap;
  final double size;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final selected = selectedColor != null;

    final shadows = flat
        ? null
        : [
            BoxShadow(
              color: context.palette.shadowDark.withValues(alpha: 0.5),
              offset: const Offset(2, 2),
              blurRadius: 5,
            ),
            BoxShadow(
              color: context.palette.shadowLight.withValues(alpha: 0.7),
              offset: const Offset(-2, -2),
              blurRadius: 5,
            ),
          ];

    return PressScale(
      enabled: onTap != null,
      onTap: onTap,
      semanticLabel: 'Eigene Farbe',
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: selected ? selectedColor : null,
            gradient: selected
                ? null
                : const SweepGradient(
                    colors: [
                      Color(0xFFFF0000),
                      Color(0xFFFFFF00),
                      Color(0xFF00FF00),
                      Color(0xFF00FFFF),
                      Color(0xFF0000FF),
                      Color(0xFFFF00FF),
                      Color(0xFFFF0000),
                    ],
                  ),
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? primary : context.colors.outlineVariant,
              width: selected ? 3 : 1,
            ),
            boxShadow: shadows,
          ),
          child: Icon(
            selected ? Symbols.check : Symbols.colorize,
            size: flat ? 18 : 22,
            fill: 1,
            color: Colors.white,
          ),
        ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
    this.size = 48,
    this.flat = false,
  });

  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final double size;
  final bool flat;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final isLight = color.computeLuminance() > 0.7;
    final checkColor = isLight ? context.colors.onSurface : Colors.white;

    return PressScale(
      enabled: onTap != null,
      onTap: onTap,
      child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? primary : context.colors.outlineVariant,
              width: selected ? 3 : 1,
            ),
            boxShadow: flat
                ? null
                : [
                    BoxShadow(
                      color: context.palette.shadowDark.withValues(alpha: 0.5),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: context.palette.shadowLight.withValues(alpha: 0.7),
                      offset: const Offset(-2, -2),
                      blurRadius: 5,
                    ),
                  ],
          ),
          child: selected
              ? Icon(Symbols.check, size: flat ? 18 : 22, color: checkColor, fill: 1)
              : null,
        ),
    );
  }
}
