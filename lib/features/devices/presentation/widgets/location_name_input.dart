import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Bordered name text field used for device and location assignment forms.
class LocationNameInput extends StatelessWidget {
  const LocationNameInput({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.controller,
    required this.enabled,
    this.hint,
    this.labelText = 'Name',
  });

  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;
  final bool enabled;
  final String? hint;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconBox(icon: icon, color: iconColor),
        const SizedBox(width: AppSpacing.gutter),
        Expanded(
          child: enabled
              ? TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  enableSuggestions: true,
                  style: context.text.bodyLarge,
                  decoration: InputDecoration(
                    labelText: labelText,
                    hintText: hint ?? 'Individuellen Namen eingeben',
                    filled: true,
                    fillColor: context.colors.surfaceContainerHighest
                        .withValues(alpha: 0.35),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.gutter,
                      vertical: AppSpacing.sm,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                      borderSide: BorderSide(
                        color: context.colors.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                      borderSide: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                )
              : Text(
                  controller.text.isEmpty ? '—' : controller.text,
                  style: context.text.bodyLarge,
                ),
        ),
      ],
    );
  }
}
