import 'package:material_symbols_icons/symbols.dart';

import '../models/models.dart';

/// In-memory seed data store shared by the mock repositories.
///
/// Holds mutable copies so power toggles / edits persist within a session. When
/// moving to a real backend, this whole class is dropped in favor of REST calls.
class MockStore {
  MockStore._();

  static final MockStore instance = MockStore._();

  final User user = const User(
    id: 'u1',
    name: 'Jalal',
    firstName: 'Jalal',
    lastName: '',
    email: 'j.hbirkou@outlook.de',
    phone: '+49 170 1234567',
    isOnline: true,
    badges: [
      UserBadge(label: 'Besitzer', accentKey: 'green'),
      UserBadge(label: 'Pro Plan', accentKey: 'blue'),
    ],
  );

  final List<House> houses = [
    const House(
      id: 'h1',
      name: 'Home',
      icon: Symbols.home,
      floorCount: 2,
      roomCount: 1,
      deviceCount: 1,
    ),
  ];

  final List<Floor> floors = [
    const Floor(
      id: 'f1',
      houseId: 'h1',
      name: 'Etage 1',
      icon: Symbols.layers,
      accentKey: 'blue',
      roomCount: 1,
      deviceCount: 1,
    ),
    const Floor(
      id: 'f2',
      houseId: 'h1',
      name: 'Erdgeschoss',
      icon: Symbols.meeting_room,
      accentKey: 'cyan',
      roomCount: 0,
      deviceCount: 0,
    ),
  ];

  final List<Room> rooms = [
    const Room(
      id: 'r1',
      floorId: 'f1',
      name: 'Büro',
      icon: Symbols.chair,
      accentKey: 'blue',
      deviceCount: 1,
    ),
  ];

  final List<Device> devices = [
    const Device(
      id: 'd1',
      roomId: 'r1',
      name: 'My Control Panel',
      type: DeviceType.controlPanel,
      isOn: true,
      connectivity: DeviceConnectivity.online,
      summary: 'Control Panel',
      temperature: 22.5,
      firmwareVersion: '2.4.1',
      model: 'Virtumi Panel Pro',
      serialNumber: 'VRT-00142-AP',
      ipAddress: '192.168.1.42',
      macAddress: 'A4:CF:12:9B:00:142',
      hostname: 'VM-CP_42D34C',
    ),
  ];

  final Map<String, NetworkConfig> networkByDevice = {
    'd1': const NetworkConfig(),
  };

  final Map<String, CloudConfig> cloudByDevice = {
    'd1': const CloudConfig(
      virtumi: VirtumiCloudConfig(
        enabled: true,
        status: ConnectionStatus.connected,
        account: 'j.hbirkou@outlook.de',
        password: 'password123',
      ),
      mqtt: MqttCloudConfig(
        enabled: false,
        status: ConnectionStatus.disconnected,
        host: 'mqtt.virtumi.io',
        port: 8883,
        username: 'panel-00142',
        useTls: true,
        allowAnonymous: false,
        customerNumber: 'virtumihome_Smart_LED',
        retainMessages: false,
        cleanSession: true,
      ),
    ),
  };

  final Map<String, DateTimeConfig> dateTimeByDevice = {
    'd1': const DateTimeConfig(),
  };

  final Map<String, MatterConfig> matterByDevice = {
    'd1': const MatterConfig(),
  };

  final Map<String, DeviceLocation> locationByDevice = {
    'd1': const DeviceLocation(
      deviceName: 'My Control Panel',
      houseName: 'Home',
      houseIconKey: 'haus',
      floorName: 'Etage 1',
      floorIconKey: 'obergeschoss',
      roomName: 'Büro',
      roomIconKey: 'buero',
      note: 'Neben der Eingangstür montiert',
    ),
  };

  final Map<String, UpdateConfig> updateByDevice = {
    'd1': const UpdateConfig(
      osName: 'Aura OS',
      currentVersion: 'v2.4.1',
      availableVersion: 'v2.5.0',
      updateAvailable: true,
      autoUpdatesEnabled: true,
      updateSchedule: UpdateSchedule.everyDay,
      weekday: Weekday.monday,
      scheduledTime: '23:50:00',
    ),
  };

  final Map<String, GeneralConfig> generalByDevice = {
    'd1': const GeneralConfig(
      ledColorValue: 0xFF0070EA,
      brightness: 80,
      ledStatus: LedStatus.alwaysOn,
      commandType: CommandType.everyday,
      startTime: '18:00',
      endTime: '23:00',
    ),
  };
}
