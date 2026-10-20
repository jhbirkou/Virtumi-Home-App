import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'app_card.dart';
import 'neumorphic_container.dart';
import 'press_scale.dart';

/// Edit-mode action card with "Abbrechen" and "Speichern" buttons.
///
/// Placed at the end of editable content. Visually identical everywhere it is
/// used, per the design system.
class SaveCancelCard extends StatelessWidget {
  const SaveCancelCard({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.cancelLabel = 'Abbrechen',
    this.saveLabel = 'Speichern',
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String cancelLabel;
  final String saveLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              icon: Symbols.cancel,
              label: cancelLabel,
              iconColor: context.colors.error,
              textColor: context.colors.onSurfaceVariant,
              onTap: onCancel,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
          Expanded(
            child: _ActionButton(
              icon: Symbols.check_circle,
              label: saveLabel,
              filled: true,
              onTap: onSave,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.gutter,
        horizontal: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            fill: filled ? 1 : 0,
            color: filled ? context.colors.onPrimary : iconColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: filled ? context.colors.onPrimary : textColor,
              ),
            ),
          ),
        ],
      ),
    );

    return PressScale(
      onTap: onTap,
      semanticLabel: label,
      child: filled
          ? Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: AppRadius.mdAll,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: content,
            )
          : NeumorphicContainer(
              style: NeumorphicStyle.raisedSmall,
              borderRadius: AppRadius.mdAll,
              child: content,
            ),
    );
  }
}
