import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_helpers.dart';
import '../../../domain/device_config_repository.dart';
import '../../../models/device_kind.dart';
import '../../../models/models.dart';
import '../../supabase/mappers/config_mappers.dart';
import '../device_endpoint.dart';
import '../device_endpoint_resolver.dart';
import '../udp_device_service.dart';
import '../udp_mappers.dart';

class UdpDeviceConfigRepository implements DeviceConfigRepository {
  UdpDeviceConfigRepository(this._udp, this._endpoints, this._client);

  final UdpDeviceService _udp;
  final DeviceEndpointResolver _endpoints;
  final SupabaseClient _client;

  @override
  Future<NetworkConfig> getNetworkConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final results = await Future.wait([
      for (final command in [1, 2, 3, 4, 5])
        _udp.readNetworkCommand(
          targetIp: ep.ipAddress,
          port: ep.port,
          deviceCode: ep.deviceCode,
          command: command,
        ),
    ]);

    return mapNetworkConfigFromUdp(
      modePort: results[0],
      softAp: results[1],
      softApDetails: results[2],
      station: results[3],
      stationDetails: results[4],
    );
  }

  @override
  Future<void> saveNetworkConfig(String deviceId, NetworkConfig config) async {
    final ep = await _endpoints.resolve(deviceId);

    // Network writes stay sequential + ACK: device may reboot mid-change.
    for (final command in [1, 2, 3, 4, 5]) {
      await _udp.writeNetworkCommand(
        targetIp: ep.ipAddress,
        port: ep.port,
        payload: networkUdpWritePayload(
          deviceCode: ep.deviceCode,
          command: command,
          config: config,
        ),
      );
    }

    await _waitForDeviceAfterNetworkChange(ep, command: 1);
  }

  Future<void> _waitForDeviceAfterNetworkChange(
    DeviceEndpoint ep, {
    required int command,
  }) async {
    const maxAttempts = 30;
    for (var i = 0; i < maxAttempts; i++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      try {
        await _udp.pingNetworkCommand(
          targetIp: ep.ipAddress,
          port: ep.port,
          deviceCode: ep.deviceCode,
          command: command,
        );
        return;
      } catch (_) {}
    }
  }

  @override
  Future<CloudConfig> getCloudConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final results = await Future.wait([
      _udp.readVirtumiCloud(
        targetIp: ep.ipAddress,
        port: ep.port,
        deviceCode: ep.deviceCode,
      ),
      _udp.readMqtt(
        targetIp: ep.ipAddress,
        port: ep.port,
        deviceCode: ep.deviceCode,
      ),
    ]);
    return mapCloudConfigFromUdp(virtumi: results[0], mqtt: results[1]);
  }

  @override
  Future<void> saveMqttCloud(String deviceId, MqttCloudConfig config) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeMqtt(
      targetIp: ep.ipAddress,
      port: ep.port,
      payload: mqttCloudUdpWritePayload(
        deviceCode: ep.deviceCode,
        config: config,
      ),
    );
  }

  @override
  Future<void> saveVirtumiCloud(
    String deviceId,
    VirtumiCloudConfig config,
  ) async {
    if (config.account.isEmpty) return;
    final ep = await _endpoints.resolve(deviceId);
    final userId = requireUserId(_client);
    await _udp.sendCloudCredentials(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
      userEmail: config.account,
      userPassword: config.password,
      userId: userId,
      active: config.enabled,
    );
  }

  @override
  Future<void> resendVirtumiCloud(
    String deviceId,
    VirtumiCloudConfig config,
  ) =>
      saveVirtumiCloud(deviceId, config);

  @override
  Future<DateTimeConfig> getDateTimeConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final json = await _udp.readDateTime(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
    return mapDateTimeConfigFromUdp(json);
  }

  @override
  Future<void> saveDateTimeConfig(
    String deviceId,
    DateTimeConfig config,
  ) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeDateTime(
      targetIp: ep.ipAddress,
      port: ep.port,
      payload: dateTimeUdpWritePayloadExtended(ep.deviceCode, config),
    );
  }

  @override
  Future<MatterConfig> getMatterConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final json = await _udp.readMatter(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
    return mapMatterConfigFromUdp(json);
  }

  @override
  Future<void> saveMatterConfig(String deviceId, MatterConfig config) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeMatterCommand(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
      pairingMode: 0,
      factoryReset: 1,
    );
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  @override
  Future<DeviceLocation> getDeviceLocation(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final json = await _udp.readLocation(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
    return mapDeviceLocationFromUdp(json);
  }

  @override
  Future<void> saveDeviceLocation(
    String deviceId,
    DeviceLocation location,
  ) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeLocation(
      targetIp: ep.ipAddress,
      port: ep.port,
      payload: deviceLocationUdpWritePayload(ep.deviceCode, location),
    );
  }

  @override
  Future<UpdateConfig> getUpdateConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final json = await _udp.readUpdate(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
    return mapUpdateConfigFromUdp(json);
  }

  @override
  Future<void> saveUpdateConfig(String deviceId, UpdateConfig config) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeUpdateSchedule(
      targetIp: ep.ipAddress,
      port: ep.port,
      payload: updateUdpWritePayload(ep.deviceCode, config),
    );
  }

  @override
  Future<GeneralConfig> getGeneralConfig(String deviceId) async {
    final ep = await _endpoints.resolve(deviceId);
    final json = await _udp.readGeneral(
      targetIp: ep.ipAddress,
      port: ep.port,
      deviceCode: ep.deviceCode,
    );
    return mapGeneralConfigFromUdp(
      json,
      smartLed: ep.kind == DeviceKind.smartLed,
    );
  }

  @override
  Future<void> saveGeneralConfig(String deviceId, GeneralConfig config) async {
    final ep = await _endpoints.resolve(deviceId);
    await _udp.writeGeneral(
      targetIp: ep.ipAddress,
      port: ep.port,
      payload: generalUdpWritePayloadForKind(
        ep.deviceCode,
        config,
        smartLed: ep.kind == DeviceKind.smartLed,
      ),
    );
  }
}
