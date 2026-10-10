import '../models/models.dart';

/// Abstraction over the location hierarchy (houses -> floors -> rooms ->
/// devices). Backed by an in-memory mock today; swap with a REST-backed
/// implementation later without touching the UI or providers.
abstract interface class SmartHomeRepository {
  Future<List<House>> getHouses();
  Future<House?> getHouse(String houseId);

  Future<List<Floor>> getFloors(String houseId);
  Future<Floor?> getFloor(String floorId);

  Future<List<Room>> getRooms(String floorId);
  Future<Room?> getRoom(String roomId);

  Future<List<Device>> getDevices(String roomId);

  /// When [includeConnectivity] is false, skips the livecom lookup so UDP
  /// endpoint resolution stays fast.
  Future<Device?> getDevice(
    String deviceId, {
    bool includeConnectivity = true,
  });

  Future<void> setDevicePower(String deviceId, bool isOn);
  Future<void> updateDeviceName(String deviceId, String name);

  /// Registers a scanned device in Supabase (hierarchy find-or-create by name).
  Future<String> addDevice({
    required String name,
    required String deviceCode,
    String? macAddress,
    String? ipAddress,
    String? hostname,
    String? port,
    String deviceTypeName,
    String homeName,
    String floorName,
    String roomName,
  });

  /// Deletes a device and all related Supabase rows, then removes empty
  /// hierarchy nodes (device_types, rooms, floors, homes).
  Future<void> deleteDevice(String deviceId);

  /// Creates a new home for the current user.
  Future<House> createHome(String name, {String? description, String? address});

  /// Updates home metadata.
  Future<void> updateHome(House house);

  /// Updates the icon preset for a home.
  Future<void> updateHouseIcon(String houseId, String iconKey);

  /// Updates the icon preset for a floor.
  Future<void> updateFloorIcon(String floorId, String iconKey);

  /// Updates the icon preset for a room.
  Future<void> updateRoomIcon(String roomId, String iconKey);
}
