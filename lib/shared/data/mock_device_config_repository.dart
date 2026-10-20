import '../domain/device_config_repository.dart';
import '../models/models.dart';
import 'mock_seed.dart';

/// In-memory [DeviceConfigRepository] backed by [MockStore].
class MockDeviceConfigRepository implements DeviceConfigRepository {
  MockDeviceConfigRepository(this._store);

  final MockStore _store;

  static const _latency = Duration(milliseconds: 200);

  @override
  Future<NetworkConfig> getNetworkConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.networkByDevice[deviceId] ?? const NetworkConfig();
  }

  @override
  Future<void> saveNetworkConfig(String deviceId, NetworkConfig config) async {
    _store.networkByDevice[deviceId] = config;
  }

  @override
  Future<CloudConfig> getCloudConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.cloudByDevice[deviceId] ?? const CloudConfig();
  }

  @override
  Future<void> saveMqttCloud(String deviceId, MqttCloudConfig config) async {
    final current = _store.cloudByDevice[deviceId] ?? const CloudConfig();
    _store.cloudByDevice[deviceId] = current.copyWith(mqtt: config);
  }

  @override
  Future<void> saveVirtumiCloud(
    String deviceId,
    VirtumiCloudConfig config,
  ) async {
    final current = _store.cloudByDevice[deviceId] ?? const CloudConfig();
    _store.cloudByDevice[deviceId] = current.copyWith(virtumi: config);
  }

  @override
  Future<void> resendVirtumiCloud(
    String deviceId,
    VirtumiCloudConfig config,
  ) =>
      saveVirtumiCloud(deviceId, config);

  @override
  Future<DateTimeConfig> getDateTimeConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.dateTimeByDevice[deviceId] ?? const DateTimeConfig();
  }

  @override
  Future<void> saveDateTimeConfig(String deviceId, DateTimeConfig config) async {
    _store.dateTimeByDevice[deviceId] = config;
  }

  @override
  Future<MatterConfig> getMatterConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.matterByDevice[deviceId] ?? const MatterConfig();
  }

  @override
  Future<void> saveMatterConfig(String deviceId, MatterConfig config) async {
    _store.matterByDevice[deviceId] = config;
  }

  @override
  Future<DeviceLocation> getDeviceLocation(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.locationByDevice[deviceId] ?? const DeviceLocation();
  }

  @override
  Future<void> saveDeviceLocation(
      String deviceId, DeviceLocation location) async {
    _store.locationByDevice[deviceId] = location;
  }

  @override
  Future<UpdateConfig> getUpdateConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.updateByDevice[deviceId] ?? const UpdateConfig();
  }

  @override
  Future<void> saveUpdateConfig(String deviceId, UpdateConfig config) async {
    _store.updateByDevice[deviceId] = config;
  }

  @override
  Future<GeneralConfig> getGeneralConfig(String deviceId) async {
    await Future<void>.delayed(_latency);
    return _store.generalByDevice[deviceId] ?? const GeneralConfig();
  }

  @override
  Future<void> saveGeneralConfig(String deviceId, GeneralConfig config) async {
    _store.generalByDevice[deviceId] = config;
  }
}
