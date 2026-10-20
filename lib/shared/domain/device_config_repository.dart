import '../models/models.dart';

/// Abstraction over per-device configuration sections (network, cloud, date &
/// time, matter, location).
abstract interface class DeviceConfigRepository {
  Future<NetworkConfig> getNetworkConfig(String deviceId);
  Future<void> saveNetworkConfig(String deviceId, NetworkConfig config);

  Future<CloudConfig> getCloudConfig(String deviceId);
  Future<void> saveMqttCloud(String deviceId, MqttCloudConfig config);
  Future<void> saveVirtumiCloud(String deviceId, VirtumiCloudConfig config);

  /// Sends the stored Virtumi Cloud credentials again, without MQTT settings.
  Future<void> resendVirtumiCloud(String deviceId, VirtumiCloudConfig config);

  Future<DateTimeConfig> getDateTimeConfig(String deviceId);
  Future<void> saveDateTimeConfig(String deviceId, DateTimeConfig config);

  Future<MatterConfig> getMatterConfig(String deviceId);
  Future<void> saveMatterConfig(String deviceId, MatterConfig config);

  Future<DeviceLocation> getDeviceLocation(String deviceId);
  Future<void> saveDeviceLocation(String deviceId, DeviceLocation location);

  Future<UpdateConfig> getUpdateConfig(String deviceId);
  Future<void> saveUpdateConfig(String deviceId, UpdateConfig config);

  Future<GeneralConfig> getGeneralConfig(String deviceId);
  Future<void> saveGeneralConfig(String deviceId, GeneralConfig config);
}
