import '../domain/device_data_repository.dart';
import '../models/device_data_entry.dart';

class MockDeviceDataRepository implements DeviceDataRepository {
  final _entries = <String, List<DeviceDataEntry>>{};
  final _status = <String, DeviceUpdateStatus>{};

  @override
  Future<List<DeviceDataEntry>> getDeviceData(String deviceId) async {
    return _entries[deviceId] ?? [];
  }

  @override
  Future<void> deleteDeviceData(String entryId) async {
    for (final key in _entries.keys) {
      _entries[key]!.removeWhere((e) => e.id == entryId);
    }
  }

  @override
  Future<void> deleteAllDeviceData(String deviceId) async {
    _entries.remove(deviceId);
  }

  @override
  Future<DeviceUpdateStatus> getUpdateStatus(String deviceId) async {
    return _status[deviceId] ?? const DeviceUpdateStatus();
  }
}
