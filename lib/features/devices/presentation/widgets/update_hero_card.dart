import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Hero card communicating the update availability status, with a primary
/// action to start a manual update.
class UpdateHeroCard extends StatelessWidget {
  const UpdateHeroCard({
    super.key,
    required this.config,
    required this.onStartUpdate,
  });

  final UpdateConfig config;
  final VoidCallback onStartUpdate;

  @override
  Widget build(BuildContext context) {
    final available = config.updateAvailable;
    final accent =
        available ? context.palette.accentGreen : context.colors.primary;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        children: [
          Container(
            width: AppSizes.avatar,
            height: AppSizes.avatar,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: AppRadius.mdAll,
            ),
            alignment: Alignment.center,
            child: Icon(
              available ? Symbols.system_update_alt : Symbols.check_circle,
              size: 32,
              fill: 1,
              color: accent,
              shadows: [Shadow(color: accent.withValues(alpha: 0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(
            available ? 'Update verfügbar' : 'System aktuell',
            style: context.text.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          _VersionBadge(
            version: available ? config.availableVersion : config.currentVersion,
            accent: accent,
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(
            available
                ? config.description
                : 'Dein System ist auf dem neuesten Stand.',
            textAlign: TextAlign.center,
            style: context.text.bodyMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          if (available) ...[
            const SizedBox(height: AppSpacing.containerPadding),
            _PrimaryButton(
              icon: Symbols.download,
              label: 'Manuelles Update starten',
              onTap: onStartUpdate,
            ),
          ],
        ],
      ),
    );
  }
}

class _VersionBadge extends StatelessWidget {
  const _VersionBadge({required this.version, required this.accent});
  final String version;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainer,
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            version,
            style: context.text.labelSmall
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    return PressScale(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.gutter),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: context.colors.onPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: context.text.bodyLarge?.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
