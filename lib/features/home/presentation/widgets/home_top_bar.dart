import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Home screen top bar: avatar + greeting + connection status, with a
/// notifications action button. (Home is a tab root, so no back button.)
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.user,
    this.connection = 'Cloud',
    this.onNotifications,
  });

  final User user;
  final String connection;
  final VoidCallback? onNotifications;

  String get _greetingName {
    if (user.firstName.trim().isNotEmpty) return user.firstName.trim();
    if (user.name.trim().isNotEmpty) return user.name.trim();
    return 'du';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerPadding,
        AppSpacing.gutter,
        AppSpacing.containerPadding,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          NeumorphicContainer(
            width: 44,
            height: 44,
            borderRadius: AppRadius.full,
            padding: const EdgeInsets.all(2),
            child: UserAvatar(
              initials: user.initials,
              imageUrl: user.avatarUrl,
              size: 40,
              borderRadius: AppRadius.full,
            ),
          ),
          const SizedBox(width: AppSpacing.gutter),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Hi, $_greetingName!', style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Willkommen in ${AppConstants.appName}',
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        connection,
                        style: context.text.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: context.colors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.colors.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          NeumorphicIconButton(
            icon: Symbols.notifications,
            iconColor: context.colors.onSurfaceVariant,
            size: 44,
            onPressed: onNotifications,
            tooltip: 'Benachrichtigungen',
          ),
        ],
      ),
    );
  }
}
