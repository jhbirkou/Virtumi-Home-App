import '../models/device_data_entry.dart';

abstract interface class DeviceDataRepository {
  Future<List<DeviceDataEntry>> getDeviceData(String deviceId);
  Future<void> deleteDeviceData(String entryId);
  Future<void> deleteAllDeviceData(String deviceId);

  Future<DeviceUpdateStatus> getUpdateStatus(String deviceId);
}
