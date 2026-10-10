import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../theme/theme.dart';
import 'app_card.dart';

/// Tappable list card with a round tinted icon, a title + subtitle, and a small
/// circular chevron affordance. Used for drill-down lists (Etagen, Räume).
class NavTileCard extends StatelessWidget {
  const NavTileCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.detail,
    this.onTap,
    this.heroTag,
    this.showIconEditHint = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final String? detail;
  final VoidCallback? onTap;
  final Object? heroTag;
  final bool showIconEditHint;

  @override
  Widget build(BuildContext context) {
    Widget iconCircle = Container(
      width: AppSizes.iconBoxLg,
      height: AppSizes.iconBoxLg,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
        child: Icon(icon, color: accent, size: 28, fill: 1),
    );

    if (heroTag != null) {
      iconCircle = Hero(tag: heroTag!, child: iconCircle);
    }

    if (showIconEditHint) {
      iconCircle = Stack(
        clipBehavior: Clip.none,
        children: [
          iconCircle,
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: context.colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.surface, width: 2),
                boxShadow: context.palette.flatElevation
                    ? null
                    : context.palette.raisedSmall,
              ),
              alignment: Alignment.center,
              child: Icon(
                Symbols.edit,
                size: 12,
                color: context.colors.onPrimary,
              ),
            ),
          ),
        ],
      );
    }

    return AppCard(
      onTap: onTap,
      semanticLabel: title,
      child: Row(
        children: [
          iconCircle,
          const SizedBox(width: AppSpacing.containerPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: context.text.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (detail != null && detail!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    detail!,
                    style: _detailStyle(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: _detailStyle(context),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              showIconEditHint ? Symbols.edit : Symbols.chevron_right,
              size: 20,
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle? _detailStyle(BuildContext context) {
    return context.text.labelSmall?.copyWith(
      letterSpacing: 0,
      fontWeight: FontWeight.w400,
      color: context.colors.onSurfaceVariant,
    );
  }
}
