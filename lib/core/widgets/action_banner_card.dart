import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'app_card.dart';
import 'icon_box.dart';

/// Horizontal banner card: leading tinted icon, title + subtitle, and a
/// trailing affordance (a round add button or a chevron).
///
/// Used for "Neues Gerät hinzufügen" and "Verknüpfte Personen".
class ActionBannerCard extends StatelessWidget {
  const ActionBannerCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.onTap,
    this.trailingIcon = Symbols.chevron_right,
    this.trailingFilledButton = false,
    this.filledIcon = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback? onTap;
  final IconData trailingIcon;

  /// When true, the trailing icon is shown inside a round raised button.
  final bool trailingFilledButton;
  final bool filledIcon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.gutter),
      semanticLabel: title,
      child: Row(
        children: [
          IconBox(
            icon: icon,
            color: accent,
            size: AppSizes.iconBoxMd,
            filled: filledIcon,
            glow: true,
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.text.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (trailingFilledButton)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.palette.neuSurface,
                shape: BoxShape.circle,
                boxShadow: context.palette.raisedSmall,
              ),
              alignment: Alignment.center,
              child: Icon(trailingIcon, color: accent, size: 22),
            )
          else
            Icon(trailingIcon,
                color: context.colors.onSurfaceVariant, size: 24),
        ],
      ),
    );
  }
}
