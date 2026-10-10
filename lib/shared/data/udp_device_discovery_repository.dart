import 'dart:io';

import '../../features/add_device/services/network_info_service.dart';
import '../data/udp/udp_device_service.dart';
import '../domain/device_discovery_repository.dart';
import '../models/discovered_device.dart';

/// UDP broadcast discovery for Virtumi ESP32 devices (port 6000).
///
/// The add-device wizard uses [UdpDeviceService] directly with a device code.
/// This repository remains for interface compatibility; [scanUdp] requires a
/// device code and therefore returns an empty list here.
class UdpDeviceDiscoveryRepository implements DeviceDiscoveryRepository {
  UdpDeviceDiscoveryRepository({
    UdpDeviceService? udpService,
    NetworkInfoService? networkInfo,
  })  : _udp = udpService ?? UdpDeviceService(),
        _network = networkInfo ?? NetworkInfoService();

  final UdpDeviceService _udp;
  final NetworkInfoService _network;

  @override
  Future<List<DiscoveredDevice>> scanUdp({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS && !Platform.isWindows) {
      return [];
    }

    // Legacy API without device code — use NewDeviceWizard instead.
    return [];
  }

  Future<List<DiscoveredDevice>> scanUdpWithCode({
    required String deviceCode,
    Duration maxTimeout = const Duration(seconds: 5),
    Duration quietPeriod = const Duration(milliseconds: 600),
  }) async {
    if (deviceCode.isEmpty) return [];

    final broadcastIp = await _network.getBroadcastIp();
    final devices = await _udp.discoverDevices(
      broadcastIp: broadcastIp,
      port: UdpDeviceService.defaultPort,
      deviceCode: deviceCode,
      maxTimeout: maxTimeout,
      quietPeriod: quietPeriod,
    );

    return devices
        .map(
          (d) => DiscoveredDevice(
            name: d.devicename,
            deviceCode: deviceCode,
            macAddress: d.macAddress.isEmpty ? null : d.macAddress,
            ipAddress: d.ipAddress,
            hostname: d.hostname.isEmpty ? null : d.hostname,
            port: d.port.toString(),
            deviceTypeName: d.devicetype,
            source: 'udp',
          ),
        )
        .toList();
  }
}
