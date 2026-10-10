import '../../models/device.dart';
import '../../models/device_kind.dart';
import 'udp_helpers.dart';

/// UDP target resolved from the Supabase device registry.
class DeviceEndpoint {
  const DeviceEndpoint({
    required this.deviceId,
    required this.ipAddress,
    required this.port,
    required this.deviceCode,
    required this.kind,
    this.deviceName = '',
  });

  final String deviceId;
  final String ipAddress;
  final int port;
  final String deviceCode;
  final DeviceKind kind;
  final String deviceName;

  factory DeviceEndpoint.fromDevice(Device device, {int port = defaultUdpPort}) {
    return DeviceEndpoint(
      deviceId: device.id,
      ipAddress: requireIpv4(device.ipAddress),
      port: port,
      deviceCode: requireDeviceCode(device.serialNumber),
      kind: resolveDeviceKind(device.model),
      deviceName: device.name,
    );
  }
}
