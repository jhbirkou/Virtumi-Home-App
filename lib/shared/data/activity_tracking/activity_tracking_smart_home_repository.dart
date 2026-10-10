import '../../domain/smart_home_repository.dart';
import '../../models/models.dart';

typedef DeviceActivityCallback = void Function(String deviceId);

/// Records device actuation after successful [SmartHomeRepository.setDevicePower].
class ActivityTrackingSmartHomeRepository implements SmartHomeRepository {
  ActivityTrackingSmartHomeRepository(this._inner, this._onActivity);

  final SmartHomeRepository _inner;
  final DeviceActivityCallback _onActivity;

  @override
  Future<List<House>> getHouses() => _inner.getHouses();

  @override
  Future<House?> getHouse(String houseId) => _inner.getHouse(houseId);

  @override
  Future<List<Floor>> getFloors(String houseId) => _inner.getFloors(houseId);

  @override
  Future<Floor?> getFloor(String floorId) => _inner.getFloor(floorId);

  @override
  Future<List<Room>> getRooms(String floorId) => _inner.getRooms(floorId);

  @override
  Future<Room?> getRoom(String roomId) => _inner.getRoom(roomId);

  @override
  Future<List<Device>> getDevices(String roomId) => _inner.getDevices(roomId);

  @override
  Future<Device?> getDevice(
    String deviceId, {
    bool includeConnectivity = true,
  }) =>
      _inner.getDevice(deviceId, includeConnectivity: includeConnectivity);

  @override
  Future<void> setDevicePower(String deviceId, bool isOn) async {
    await _inner.setDevicePower(deviceId, isOn);
    _onActivity(deviceId);
  }

  @override
  Future<void> updateDeviceName(String deviceId, String name) =>
      _inner.updateDeviceName(deviceId, name);

  @override
  Future<String> addDevice({
    required String name,
    required String deviceCode,
    String? macAddress,
    String? ipAddress,
    String? hostname,
    String? port,
    String deviceTypeName = 'Control Panel',
    String homeName = 'My Haus',
    String floorName = 'Erdgeschoss',
    String roomName = 'Buero',
  }) =>
      _inner.addDevice(
        name: name,
        deviceCode: deviceCode,
        macAddress: macAddress,
        ipAddress: ipAddress,
        hostname: hostname,
        port: port,
        deviceTypeName: deviceTypeName,
        homeName: homeName,
        floorName: floorName,
        roomName: roomName,
      );

  @override
  Future<void> deleteDevice(String deviceId) => _inner.deleteDevice(deviceId);

  @override
  Future<House> createHome(String name, {String? description, String? address}) =>
      _inner.createHome(name, description: description, address: address);

  @override
  Future<void> updateHome(House house) => _inner.updateHome(house);

  @override
  Future<void> updateHouseIcon(String houseId, String iconKey) =>
      _inner.updateHouseIcon(houseId, iconKey);

  @override
  Future<void> updateFloorIcon(String floorId, String iconKey) =>
      _inner.updateFloorIcon(floorId, iconKey);

  @override
  Future<void> updateRoomIcon(String roomId, String iconKey) =>
      _inner.updateRoomIcon(roomId, iconKey);
}
