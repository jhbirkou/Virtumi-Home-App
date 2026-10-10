import '../domain/device_discovery_repository.dart';
import '../models/discovered_device.dart';

class MockDeviceDiscoveryRepository implements DeviceDiscoveryRepository {
  @override
  Future<List<DiscoveredDevice>> scanUdp({Duration timeout = const Duration(seconds: 5)}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return const [
      DiscoveredDevice(
        name: 'Mock Control Panel',
        deviceCode: 'MOCK-CP-001',
        macAddress: 'AA:BB:CC:DD:EE:01',
        ipAddress: '192.168.1.100',
        hostname: 'virtumi-cp',
      ),
    ];
  }
}
