import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// Action card with pairing mode and factory reset buttons for Matter.
class MatterActionCard extends StatelessWidget {
  const MatterActionCard({
    super.key,
    required this.onActivatePairing,
    required this.onFactoryReset,
  });

  final VoidCallback onActivatePairing;
  final VoidCallback onFactoryReset;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          _MatterActionButton(
            label: 'Kopplungsmodus aktivieren',
            icon: Symbols.bolt,
            accent: AppColors.accentGreen,
            onTap: onActivatePairing,
          ),
          const SizedBox(height: AppSpacing.gutter),
          _MatterActionButton(
            label: 'Matter auf Werkseinstellungen zurücksetzen',
            icon: Symbols.restart_alt,
            accent: AppColors.accentRed,
            onTap: onFactoryReset,
          ),
        ],
      ),
    );
  }
}

class _MatterActionButton extends StatelessWidget {
  const _MatterActionButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      semanticLabel: label,
      child: NeumorphicContainer(
        style: NeumorphicStyle.raised,
        borderRadius: AppRadius.mdAll,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.gutter,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(width: AppSpacing.gutter),
            Expanded(
              child: Text(
                label,
                style: context.text.bodyLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
