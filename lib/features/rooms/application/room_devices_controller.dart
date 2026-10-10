import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/models.dart';
import '../../../shared/providers/repository_providers.dart';

/// Loads and manages the devices of a room, with optimistic power toggling.
class RoomDevicesController extends AsyncNotifier<List<Device>> {
  RoomDevicesController(this.roomId);

  final String roomId;

  @override
  Future<List<Device>> build() async {
    final devices =
        await ref.watch(smartHomeRepositoryProvider).getDevices(roomId);
    final resolver = ref.read(deviceEndpointResolverProvider);
    for (final device in devices) {
      resolver.cacheFromDevice(device);
    }
    return devices;
  }

  /// Optimistically toggle a device's power, then persist.
  Future<void> togglePower(String deviceId, bool isOn) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData([
      for (final d in current)
        if (d.id == deviceId) d.copyWith(isOn: isOn) else d,
    ]);

    await ref.read(smartHomeRepositoryProvider).setDevicePower(deviceId, isOn);
  }
}

final roomDevicesControllerProvider = AsyncNotifierProvider.family<
    RoomDevicesController, List<Device>, String>(RoomDevicesController.new);
