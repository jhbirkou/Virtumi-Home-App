import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/extensions/accent_resolver.dart';
import '../../../core/navigation/app_routes.dart';
import '../../../core/supabase/realtime_guard.dart';
import '../../../core/supabase/realtime_service.dart';
import '../../../core/supabase/supabase_client.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/data_providers.dart';
import '../application/room_devices_controller.dart';
import 'widgets/control_panel_device_card.dart';
import 'widgets/device_control_card.dart';
import 'widgets/smart_led_device_card.dart';
import 'widgets/room_summary_grid.dart';

/// Room overview ("Raum-Übersicht"): header + device control cards + a summary
/// stats grid. Each device exposes quick power control plus settings & details.
class RoomOverviewPage extends ConsumerStatefulWidget {
  const RoomOverviewPage({super.key, required this.roomId});

  final String roomId;

  @override
  ConsumerState<RoomOverviewPage> createState() => _RoomOverviewPageState();
}

class _RoomOverviewPageState extends ConsumerState<RoomOverviewPage> {
  RealtimeService? _realtime;
  final _livecomSubscribed = <String>{};

  @override
  void dispose() {
    _realtime?.unsubscribeAll();
    super.dispose();
  }

  void _ensureLivecomSubscriptions(List<Device> devices) {
    if (!useSupabaseRealtime(ref)) return;
    _realtime ??= RealtimeService(ref.read(supabaseClientProvider));
    for (final device in devices) {
      if (_livecomSubscribed.contains(device.id)) continue;
      _livecomSubscribed.add(device.id);
      _realtime!.subscribeToDeviceTable(
        deviceId: device.id,
        table: 'livecom',
        onChange: () =>
            ref.invalidate(roomDevicesControllerProvider(widget.roomId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomAsync = ref.watch(roomProvider(widget.roomId));
    final devicesAsync = ref.watch(roomDevicesControllerProvider(widget.roomId));
    final room = roomAsync.value;

    return AppScaffold(
      header: AppHeader(
        onRefresh: () =>
            ref.invalidate(roomDevicesControllerProvider(widget.roomId)),
      ),
      body: AppScrollView(
        children: [
          SectionHeaderCard(
            title: room?.name ?? 'Raum',
            icon: room?.icon ?? Symbols.meeting_room,
            accent: room == null ? null : context.accent(room.accentKey),
            filled: true,
          ),
          AsyncValueView<List<Device>>(
            value: devicesAsync,
            onRetry: () =>
                ref.invalidate(roomDevicesControllerProvider(widget.roomId)),
            data: (devices) {
              _ensureLivecomSubscriptions(devices);
              if (devices.isEmpty) {
                return const EmptyState(
                  icon: Symbols.devices,
                  message: 'Noch keine Geräte in diesem Raum',
                );
              }
              final controller =
                  ref.read(roomDevicesControllerProvider(widget.roomId).notifier);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final device in devices) ...[
                    if (device.type == DeviceType.controlPanel)
                      ControlPanelDeviceCard(
                        device: device,
                        onOpenDetails: () =>
                            context.push(Paths.deviceDetails(device.id)),
                        onOpenSettings: () =>
                            context.push(Paths.deviceSettings(device.id)),
                      )
                    else if (device.type == DeviceType.light)
                      SmartLedDeviceCard(
                        device: device,
                        showEffectPicker: false,
                        showOfflineStatus: false,
                        onOpenDetails: () =>
                            context.push(Paths.deviceDetails(device.id)),
                        onOpenSettings: () =>
                            context.push(Paths.deviceSettings(device.id)),
                      )
                    else
                      DeviceControlCard(
                        device: device,
                        onOpenDetails: () =>
                            context.push(Paths.deviceDetails(device.id)),
                        onOpenSettings: () =>
                            context.push(Paths.deviceSettings(device.id)),
                        onTogglePower: (value) =>
                            controller.togglePower(device.id, value),
                      ),
                    const SizedBox(height: AppSpacing.cardGap),
                  ],
                  RoomSummaryGrid(devices: devices),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
