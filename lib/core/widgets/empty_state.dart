import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_card.dart';

/// Centered empty-state placeholder inside a card: a soft icon circle plus a
/// message. Used for "no activities", "no people linked", etc.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
  });

  final IconData icon;
  final String message;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSizes.avatar,
            height: AppSizes.avatar,
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest
                  .withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 30, color: context.colors.outline),
          ),
          const SizedBox(height: AppSpacing.gutter),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
