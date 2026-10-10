import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';

/// Compact square house card used in the "Meine Häuser" grid.
class HouseGridCard extends StatelessWidget {
  const HouseGridCard({
    super.key,
    required this.house,
    this.onTap,
    this.onIconEdit,
  });

  final House house;
  final VoidCallback? onTap;
  final VoidCallback? onIconEdit;

  @override
  Widget build(BuildContext context) {
    final iconBox = IconBox(
      icon: house.icon,
      color: context.colors.primary,
      filled: true,
      glow: true,
    );

    return AppCard(
      onTap: onTap,
      semanticLabel: house.name,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              iconBox,
              if (onIconEdit != null)
                Positioned(
                  right: -12,
                  bottom: 4,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onIconEdit,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: context.colors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.surface,
                            width: 2,
                          ),
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
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                house.name,
                style:
                    context.text.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${house.deviceCount} Geräte \u00b7 ${house.roomCount} Räume',
                style: context.text.labelSmall?.copyWith(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w400,
                  color: context.colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
