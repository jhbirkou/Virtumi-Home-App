import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';
import 'location_name_input.dart';
import 'location_preset_row.dart';

/// Name input + horizontal preset picker for house, floor, or room.
class LocationFieldCard extends StatelessWidget {
  const LocationFieldCard({
    super.key,
    required this.label,
    required this.nameController,
    required this.selectedIconKey,
    required this.presets,
    required this.iconColor,
    required this.enabled,
    required this.onIconKeyChanged,
    this.hint,
  });

  final String label;
  final TextEditingController nameController;
  final String selectedIconKey;
  final List<LocationPreset> presets;
  final Color iconColor;
  final bool enabled;
  final ValueChanged<String> onIconKeyChanged;
  final String? hint;

  void _selectPreset(LocationPreset preset) {
    nameController.text = preset.name;
    onIconKeyChanged(preset.key);
  }

  IconData get _selectedIcon =>
      LocationPresets.iconForKey(selectedIconKey, presets);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionLabel(label),
        GroupedListCard(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: LocationNameInput(
                icon: _selectedIcon,
                iconColor: iconColor,
                controller: nameController,
                enabled: enabled,
                hint: hint,
              ),
            ),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vorauswahl & Symbol',
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                LocationPresetRow(
                  presets: presets,
                  selectedKey: selectedIconKey,
                  onSelected: _selectPreset,
                  enabled: enabled,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
