import '../../../domain/device_request_repository.dart';
import '../device_endpoint_resolver.dart';
import '../udp_device_service.dart';

class UdpDeviceRequestRepository implements DeviceRequestRepository {
  UdpDeviceRequestRepository(this._udp, this._endpoints);

  final UdpDeviceService _udp;
  final DeviceEndpointResolver _endpoints;

  @override
  Future<void> sendButtonPress(String deviceId, int command) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.sendButtonPress(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
      command: command,
    );
  }

  @override
  Future<void> sendMatterPairingRequest(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeMatterCommand(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
      pairingMode: 1,
      factoryReset: 0,
    );
  }

  @override
  Future<void> sendUpdateRequest(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.startManualUpdate(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
  }

  @override
  Future<void> requestPasswordChange({
    required String deviceId,
    required String currentCode,
    required String newCode,
  }) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.changeDevicePassword(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: currentCode,
      newPassword: newCode,
    );
    await _udp.readDeviceInfo(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: newCode,
    );
  }

  @override
  Future<String?> pollRequestStatus({
    required String table,
    required String deviceId,
    Duration timeout = const Duration(seconds: 30),
    Duration interval = const Duration(seconds: 2),
  }) async {
    return null;
  }
}
