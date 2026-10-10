import 'package:flutter/widgets.dart';

/// Device discovered via UDP broadcast or Bluetooth scan.
@immutable
class DiscoveredDevice {
  const DiscoveredDevice({
    required this.name,
    required this.deviceCode,
    this.macAddress,
    this.ipAddress,
    this.hostname,
    this.port = '6000',
    this.deviceTypeName = 'Control Panel',
    this.source = 'udp',
  });

  final String name;
  final String deviceCode;
  final String? macAddress;
  final String? ipAddress;
  final String? hostname;
  final String port;
  final String deviceTypeName;
  final String source;
}
