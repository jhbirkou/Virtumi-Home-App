import '../domain/smart_home_repository.dart';
import '../models/models.dart';
import 'mock_seed.dart';

/// In-memory [SmartHomeRepository] backed by [MockStore]. Simulates a small
/// async delay to mimic network latency.
class MockSmartHomeRepository implements SmartHomeRepository {
  MockSmartHomeRepository(this._store);

  final MockStore _store;

  static const _latency = Duration(milliseconds: 250);

  bool _roomHasDevices(String roomId) =>
      _store.devices.any((d) => d.roomId == roomId);

  bool _floorHasDevices(String floorId) {
    final roomIds =
        _store.rooms.where((r) => r.floorId == floorId).map((r) => r.id);
    return _store.devices.any((d) => roomIds.contains(d.roomId));
  }

  bool _houseHasDevices(String houseId) {
    final floorIds =
        _store.floors.where((f) => f.houseId == houseId).map((f) => f.id);
    for (final floorId in floorIds) {
      if (_floorHasDevices(floorId)) return true;
    }
    return false;
  }

  void _cleanupEmptyHierarchy({String? roomId, String? floorId, String? houseId}) {
    if (roomId != null && !_roomHasDevices(roomId)) {
      final room = _store.rooms.where((r) => r.id == roomId).firstOrNull;
      final resolvedFloorId = floorId ?? room?.floorId;
      _store.rooms.removeWhere((r) => r.id == roomId);

      if (resolvedFloorId != null && !_floorHasDevices(resolvedFloorId)) {
        final floor =
            _store.floors.where((f) => f.id == resolvedFloorId).firstOrNull;
        final resolvedHouseId = houseId ?? floor?.houseId;
        _store.floors.removeWhere((f) => f.id == resolvedFloorId);

        if (resolvedHouseId != null && !_houseHasDevices(resolvedHouseId)) {
          _store.houses.removeWhere((h) => h.id == resolvedHouseId);
        }
      }
    }
  }

  @override
  Future<List<House>> getHouses() async {
    await Future<void>.delayed(_latency);
    return _store.houses.where((h) => _houseHasDevices(h.id)).toList();
  }

  @override
  Future<House?> getHouse(String houseId) async {
    await Future<void>.delayed(_latency);
    final house = _store.houses.where((h) => h.id == houseId).firstOrNull;
    if (house == null || !_houseHasDevices(houseId)) return null;
    return house;
  }

  @override
  Future<List<Floor>> getFloors(String houseId) async {
    await Future<void>.delayed(_latency);
    return _store.floors
        .where((f) => f.houseId == houseId && _floorHasDevices(f.id))
        .toList();
  }

  @override
  Future<Floor?> getFloor(String floorId) async {
    await Future<void>.delayed(_latency);
    final floor = _store.floors.where((f) => f.id == floorId).firstOrNull;
    if (floor == null || !_floorHasDevices(floorId)) return null;
    return floor;
  }

  @override
  Future<List<Room>> getRooms(String floorId) async {
    await Future<void>.delayed(_latency);
    return _store.rooms
        .where((r) => r.floorId == floorId && _roomHasDevices(r.id))
        .toList();
  }

  @override
  Future<Room?> getRoom(String roomId) async {
    await Future<void>.delayed(_latency);
    final room = _store.rooms.where((r) => r.id == roomId).firstOrNull;
    if (room == null || !_roomHasDevices(roomId)) return null;
    return room;
  }

  @override
  Future<List<Device>> getDevices(String roomId) async {
    await Future<void>.delayed(_latency);
    return _store.devices.where((d) => d.roomId == roomId).toList();
  }

  @override
  Future<Device?> getDevice(
    String deviceId, {
    bool includeConnectivity = true,
  }) async {
    await Future<void>.delayed(_latency);
    return _store.devices.where((d) => d.id == deviceId).firstOrNull;
  }

  @override
  Future<void> setDevicePower(String deviceId, bool isOn) async {
    final index = _store.devices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _store.devices[index] = _store.devices[index].copyWith(isOn: isOn);
    }
  }

  @override
  Future<void> updateDeviceName(String deviceId, String name) async {
    final index = _store.devices.indexWhere((d) => d.id == deviceId);
    if (index != -1) {
      _store.devices[index] = _store.devices[index].copyWith(name: name);
    }
  }

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
  }) async {
    throw UnimplementedError('MockSmartHomeRepository.addDevice');
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    final device = _store.devices.where((d) => d.id == deviceId).firstOrNull;
    if (device == null) return;

    final room = _store.rooms.where((r) => r.id == device.roomId).firstOrNull;
    final floor =
        room == null ? null : _store.floors.where((f) => f.id == room.floorId).firstOrNull;

    _store.devices.removeWhere((d) => d.id == deviceId);

    _cleanupEmptyHierarchy(
      roomId: device.roomId,
      floorId: room?.floorId,
      houseId: floor?.houseId,
    );
  }

  @override
  Future<House> createHome(String name, {String? description, String? address}) async {
    final house = House(id: 'mock-${DateTime.now().millisecondsSinceEpoch}', name: name);
    _store.houses.add(house);
    return house;
  }

  @override
  Future<void> updateHome(House house) async {
    final index = _store.houses.indexWhere((h) => h.id == house.id);
    if (index != -1) _store.houses[index] = house;
  }

  @override
  Future<void> updateHouseIcon(String houseId, String iconKey) async {
    final index = _store.houses.indexWhere((h) => h.id == houseId);
    if (index == -1) return;

    final icon = LocationPresets.iconForKey(iconKey, LocationPresets.house);
    _store.houses[index] = _store.houses[index].copyWith(
      iconKey: iconKey,
      icon: icon,
    );
  }

  @override
  Future<void> updateFloorIcon(String floorId, String iconKey) async {
    final index = _store.floors.indexWhere((f) => f.id == floorId);
    if (index == -1) return;

    final icon = LocationPresets.iconForKey(iconKey, LocationPresets.floor);
    _store.floors[index] = _store.floors[index].copyWith(
      iconKey: iconKey,
      icon: icon,
    );
  }

  @override
  Future<void> updateRoomIcon(String roomId, String iconKey) async {
    final index = _store.rooms.indexWhere((r) => r.id == roomId);
    if (index == -1) return;

    final icon = LocationPresets.iconForKey(iconKey, LocationPresets.room);
    _store.rooms[index] = _store.rooms[index].copyWith(
      iconKey: iconKey,
      icon: icon,
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
