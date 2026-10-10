import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';
import '../../../shared/providers/repository_providers.dart';
import '../../rooms/presentation/widgets/control_panel_device_card.dart';
import '../../rooms/presentation/widgets/device_control_card.dart';
import '../../rooms/presentation/widgets/smart_led_device_card.dart';

/// Device details ("Gerätedetails"): same interactive card as room overview.
class DeviceDetailsPage extends ConsumerWidget {
  const DeviceDetailsPage({super.key, required this.deviceId});

  final String deviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceAsync = ref.watch(deviceProvider(deviceId));
    final device = deviceAsync.value;
    final showEdit = device != null &&
        device.type != DeviceType.controlPanel &&
        device.type != DeviceType.light;

    return AppScaffold(
      header: AppHeader(
        onEdit: showEdit
            ? () => context.push(Paths.deviceSettings(deviceId))
            : null,
        onRefresh: () => ref.invalidate(deviceProvider(deviceId)),
      ),
      body: AsyncValueView<Device?>(
        value: deviceAsync,
        onRetry: () => ref.invalidate(deviceProvider(deviceId)),
        data: (device) {
          if (device == null) {
            return const EmptyState(
              icon: Symbols.error,
              message: 'Gerät nicht gefunden',
            );
          }
          return AppScrollView(
            children: [
              SectionHeaderCard(
                title: device.name,
                subtitle: device.type.label,
                icon: device.type.icon,
                filled: true,
              ),
              _DeviceControlCard(device: device),
            ],
          );
        },
      ),
    );
  }
}

class _DeviceControlCard extends ConsumerWidget {
  const _DeviceControlCard({required this.device});

  final Device device;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (device.type == DeviceType.controlPanel) {
      return ControlPanelDeviceCard(
        device: device,
        showDetailsButton: false,
        onOpenDetails: () {},
        onOpenSettings: () => context.push(Paths.deviceSettings(device.id)),
      );
    }

    if (device.type == DeviceType.light) {
      return SmartLedDeviceCard(
        device: device,
        showDetailsButton: false,
        showExtendedEffectControls: true,
        showOfflineStatus: false,
        onOpenDetails: () {},
        onOpenSettings: () => context.push(Paths.deviceSettings(device.id)),
      );
    }

    return DeviceControlCard(
      device: device,
      onOpenDetails: () {},
      onOpenSettings: () => context.push(Paths.deviceSettings(device.id)),
      onTogglePower: (value) async {
        await ref
            .read(smartHomeRepositoryProvider)
            .setDevicePower(device.id, value);
        ref.invalidate(deviceProvider(device.id));
      },
    );
  }
}
