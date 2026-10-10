import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../shared/models/models.dart';
import 'location_preset_row.dart';

/// Bottom sheet for choosing a location preset icon (floor or room).
Future<LocationPreset?> showLocationIconPickerSheet({
  required BuildContext context,
  required String title,
  required List<LocationPreset> presets,
  required String selectedKey,
}) {
  return showModalBottomSheet<LocationPreset>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => _LocationIconPickerSheet(
      title: title,
      presets: presets,
      selectedKey: selectedKey,
    ),
  );
}

class _LocationIconPickerSheet extends StatelessWidget {
  const _LocationIconPickerSheet({
    required this.title,
    required this.presets,
    required this.selectedKey,
  });

  final String title;
  final List<LocationPreset> presets;
  final String selectedKey;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.gutter),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.cardLgAll,
          boxShadow: context.palette.raised,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.gutter),
                decoration: BoxDecoration(
                  color: context.colors.outlineVariant,
                  borderRadius: AppRadius.full,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Text(title, style: context.text.titleMedium),
            ),
            Text(
              'Vorauswahl & Symbol',
              style: context.text.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            LocationPresetRow(
              presets: presets,
              selectedKey: selectedKey,
              onSelected: (preset) => Navigator.of(context).pop(preset),
            ),
          ],
        ),
      ),
    );
  }
}
