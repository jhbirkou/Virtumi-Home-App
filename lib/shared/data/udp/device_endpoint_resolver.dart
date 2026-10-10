import '../../domain/smart_home_repository.dart';
import '../../models/device.dart';
import 'device_endpoint.dart';
import 'udp_helpers.dart';

/// Resolves [DeviceEndpoint] from the Supabase device registry.
///
/// Endpoints are cached so UDP commands (e.g. LED toggle) do not wait on a
/// Supabase round-trip before the datagram is sent. Seed the cache with
/// [cacheFromDevice] when a [Device] is already loaded in the UI.
class DeviceEndpointResolver {
  DeviceEndpointResolver(this._smartHome);

  final SmartHomeRepository _smartHome;
  final Map<String, DeviceEndpoint> _cache = {};

  /// Prefer this when [device] is already in memory (no network).
  void cacheFromDevice(Device device, {int? port}) {
    try {
      _cache[device.id] =
          DeviceEndpoint.fromDevice(device, port: port ?? defaultUdpPort);
    } catch (_) {
      // Incomplete device row (missing IP/code) — leave cache unchanged.
    }
  }

  void invalidate([String? deviceId]) {
    if (deviceId == null) {
      _cache.clear();
    } else {
      _cache.remove(deviceId);
    }
  }

  Future<DeviceEndpoint> resolve(String deviceId, {int? port}) async {
    final cached = _cache[deviceId];
    if (cached != null) {
      if (port == null || port == cached.port) return cached;
      return DeviceEndpoint(
        deviceId: cached.deviceId,
        ipAddress: cached.ipAddress,
        port: port,
        deviceCode: cached.deviceCode,
        kind: cached.kind,
        deviceName: cached.deviceName,
      );
    }

    final device = await _smartHome.getDevice(
      deviceId,
      includeConnectivity: false,
    );
    if (device == null) {
      throw StateError('Gerät nicht gefunden: $deviceId');
    }
    final endpoint =
        DeviceEndpoint.fromDevice(device, port: port ?? defaultUdpPort);
    _cache[deviceId] = endpoint;
    return endpoint;
  }

  Future<Device?> getDevice(String deviceId) => _smartHome.getDevice(deviceId);
}
