import '../models/discovered_device.dart';

abstract interface class DeviceDiscoveryRepository {
  Future<List<DiscoveredDevice>> scanUdp({Duration timeout = const Duration(seconds: 5)});
}
