import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';

/// Horizontal row of circular location presets for house, floor, or room.
class LocationPresetRow extends StatelessWidget {
  const LocationPresetRow({
    super.key,
    required this.presets,
    required this.selectedKey,
    required this.onSelected,
    this.enabled = true,
  });

  final List<LocationPreset> presets;
  final String selectedKey;
  final ValueChanged<LocationPreset> onSelected;
  final bool enabled;

  static const double _itemWidth = 92;
  static const double _iconSize = 56;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentGreen;
    final labelStyle = context.text.labelSmall?.copyWith(
      fontSize: 10,
      height: 1.15,
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );

    return SizedBox(
      height: _iconSize + AppSpacing.xs + 16,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.gutter),
        itemBuilder: (context, index) {
          final preset = presets[index];
          final selected = preset.key == selectedKey;

          return Semantics(
            button: true,
            selected: selected,
            label: preset.name,
            child: InkWell(
              onTap: enabled ? () => onSelected(preset) : null,
              borderRadius: AppRadius.full,
              splashColor: Colors.transparent,
              highlightColor: accent.withValues(alpha: 0.08),
              child: SizedBox(
                width: _itemWidth,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: _iconSize,
                      height: _iconSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? context.colors.primary
                            : context.colors.surfaceContainer,
                        border: selected
                            ? Border.all(color: accent, width: 2.5)
                            : null,
                        boxShadow: selected
                            ? AppShadows.raisedSmall(
                                context.palette.shadowLight,
                                context.palette.shadowDark,
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        preset.icon,
                        color: selected
                            ? context.colors.onPrimary
                            : context.colors.onSurfaceVariant,
                        size: 26,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SizedBox(
                      width: _itemWidth,
                      height: 14,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Text(
                          preset.name,
                          style: labelStyle?.copyWith(
                            color: selected
                                ? context.colors.onSurface
                                : context.colors.onSurfaceVariant,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
