import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/extensions/accent_resolver.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Profile summary card: avatar (with online dot), name, email and role badges.
/// Tapping opens the full profile.
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.user,
    this.onTap,
    this.avatarHeroTag,
    this.connectionLabel,
  });

  final User user;
  final VoidCallback? onTap;
  final Object? avatarHeroTag;
  final String? connectionLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      semanticLabel: 'Profil von ${user.displayName}',
      child: Row(
        children: [
          UserAvatar(
            initials: user.initials,
            imageUrl: user.avatarUrl,
            showStatus: true,
            isOnline: user.isOnline,
            heroTag: avatarHeroTag,
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.displayName,
                  style: context.text.headlineMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user.email,
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (connectionLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    connectionLabel!,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (user.badges.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final badge in user.badges)
                        _Badge(label: badge.label, color: context.accent(badge.accentKey)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null)
            Icon(Symbols.chevron_right, color: context.colors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.full,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: color,
          letterSpacing: 0.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
