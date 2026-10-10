import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

/// A single tappable tile in the device settings grid: a tinted icon box above
/// a centered label.
class SettingsGridTile extends StatelessWidget {
  const SettingsGridTile({
    super.key,
    this.icon,
    this.imageAsset,
    required this.label,
    required this.accent,
    required this.onTap,
    this.danger = false,
  }) : assert(icon != null || imageAsset != null);

  final IconData? icon;
  final String? imageAsset;
  final String label;
  final Color accent;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.xs,
      ),
      borderRadius: AppRadius.cardLgAll,
      semanticLabel: label.replaceAll('\n', ' '),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageAsset != null)
            Container(
              width: AppSizes.iconBoxMd,
              height: AppSizes.iconBoxMd,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: AppRadius.smAll,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                imageAsset!,
                width: AppSizes.iconSize,
                height: AppSizes.iconSize,
                fit: BoxFit.contain,
                color: accent,
                colorBlendMode: BlendMode.srcIn,
              ),
            )
          else
            IconBox(
              icon: icon!,
              color: accent,
              size: AppSizes.iconBoxMd,
              glow: true,
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.text.bodySmall?.copyWith(
              color: danger
                  ? context.colors.error
                  : context.colors.onSurfaceVariant,
              fontWeight: danger ? FontWeight.w700 : FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
