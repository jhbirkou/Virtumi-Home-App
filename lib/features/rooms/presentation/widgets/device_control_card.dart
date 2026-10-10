import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../shared/models/models.dart';
import 'device_card_text_styles.dart';

/// Control card for a single device inside the room overview.
///
/// Shows a summary (icon, name, type), connectivity status, a power quick-action
/// toggle, and two affordances: settings (gear) and details (arrow).
class DeviceControlCard extends StatelessWidget {
  const DeviceControlCard({
    super.key,
    required this.device,
    required this.onOpenDetails,
    required this.onOpenSettings,
    required this.onTogglePower,
  });

  final Device device;
  final VoidCallback onOpenDetails;
  final VoidCallback onOpenSettings;
  final ValueChanged<bool> onTogglePower;

  @override
  Widget build(BuildContext context) {
    final online = device.connectivity == DeviceConnectivity.online;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBox(
                icon: device.type.icon,
                color: context.colors.primary,
                size: AppSizes.iconBoxMd,
                filled: true,
              ),
              const SizedBox(width: AppSpacing.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      device.name,
                      style: DeviceCardTextStyles.title(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.type.label,
                      style: DeviceCardTextStyles.subtitle(context),
                    ),
                  ],
                ),
              ),
              NeumorphicIconButton(
                icon: Symbols.settings,
                iconColor: context.colors.onSurface,
                size: 40,
                iconSize: 20,
                tooltip: 'Geräteeinstellungen',
                onPressed: onOpenSettings,
              ),
              const SizedBox(width: AppSpacing.sm),
              NeumorphicIconButton(
                icon: Symbols.arrow_forward,
                size: 40,
                iconSize: 20,
                tooltip: 'Gerätedetails',
                onPressed: onOpenDetails,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatusChip(online: online),
              const Spacer(),
              Text(
                device.statusLabel,
                style: DeviceCardTextStyles.caption(context),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppToggle(
                value: device.isOn,
                onChanged: onTogglePower,
                semanticLabel: '${device.name} Ein/Aus',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.online});
  final bool online;

  @override
  Widget build(BuildContext context) {
    final color =
        online ? context.palette.statusOnline : context.colors.outline;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            online ? 'Online' : 'Offline',
            style: DeviceCardTextStyles.caption(context).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
