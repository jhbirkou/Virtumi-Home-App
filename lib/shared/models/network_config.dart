import 'package:flutter/widgets.dart';

enum NetworkMode { wifi, ethernet }

enum IpMode { dhcp, manual }

enum WifiOperatingMode {
  stationSoftAp('Station+Soft-AP'),
  station('Station'),
  softAp('Soft-AP');

  const WifiOperatingMode(this.label);
  final String label;
}

enum WifiEncryption {
  wpaPsk('WPA_PSK'),
  open('OPEN'),
  wpa2Psk('WPA2_PSK');

  const WifiEncryption(this.label);
  final String label;
}

enum NetworkMainCategory {
  modePort('Mode/Port Einstellungen'),
  wifiAp('WiFi AP'),
  wifiStation('WiFi Station');

  const NetworkMainCategory(this.label);
  final String label;
}

enum NetworkSubCategory {
  general('Allgemeine Einstellungen'),
  details('Details');

  const NetworkSubCategory(this.label);
  final String label;
}

/// Network configuration for a device (mode/port, WiFi AP and station).
@immutable
class NetworkConfig {
  const NetworkConfig({
    this.wifiMode = WifiOperatingMode.stationSoftAp,
    this.port = '6000',
    this.apActiveConnections = '1',
    this.apSsid = 'CP_274551',
    this.apPassword = 'password123',
    this.apChannel = '1',
    this.apEncryption = WifiEncryption.wpaPsk,
    this.apDetailsPort = '6000',
    this.apIpMode = IpMode.dhcp,
    this.apMacAddress = 'F0:F5:BD:27:45:51',
    this.apIpAddress = '192.168.100.1',
    this.apSubnetMask = '255.255.255.0',
    this.apGateway = '192.168.100.254',
    this.apDns = '0.0.0.0',
    this.apDhcpServerIp = '0.0.0.0',
    this.apWebServerIp = '0.0.0.0',
    this.stationActiveConnections = '1',
    this.stationSsid = 'MyWifi',
    this.stationPassword = 'password123',
    this.stationChannel = '1',
    this.stationEncryption = WifiEncryption.open,
    this.stationDetailsPort = '6000',
    this.stationIpMode = IpMode.dhcp,
    this.stationMacAddress = 'F0:F5:BD:27:45:50',
    this.stationIpAddress = '192.168.178.161',
    this.stationSubnetMask = '255.255.255.0',
    this.stationGateway = '192.168.178.1',
    this.stationDns = '192.168.178.1',
    this.stationDhcpServerIp = '0.0.0.0',
    this.stationWebServerIp = '',
    this.stationWebServerIpStation = '',
  });

  final WifiOperatingMode wifiMode;
  final String port;

  final String apActiveConnections;
  final String apSsid;
  final String apPassword;
  final String apChannel;
  final WifiEncryption apEncryption;
  final String apDetailsPort;
  final IpMode apIpMode;
  final String apMacAddress;
  final String apIpAddress;
  final String apSubnetMask;
  final String apGateway;
  final String apDns;
  final String apDhcpServerIp;
  final String apWebServerIp;

  final String stationActiveConnections;
  final String stationSsid;
  final String stationPassword;
  final String stationChannel;
  final WifiEncryption stationEncryption;
  final String stationDetailsPort;
  final IpMode stationIpMode;
  final String stationMacAddress;
  final String stationIpAddress;
  final String stationSubnetMask;
  final String stationGateway;
  final String stationDns;
  final String stationDhcpServerIp;
  final String stationWebServerIp;
  final String stationWebServerIpStation;

  NetworkConfig copyWith({
    WifiOperatingMode? wifiMode,
    String? port,
    String? apActiveConnections,
    String? apSsid,
    String? apPassword,
    String? apChannel,
    WifiEncryption? apEncryption,
    String? apDetailsPort,
    IpMode? apIpMode,
    String? apMacAddress,
    String? apIpAddress,
    String? apSubnetMask,
    String? apGateway,
    String? apDns,
    String? apDhcpServerIp,
    String? apWebServerIp,
    String? stationActiveConnections,
    String? stationSsid,
    String? stationPassword,
    String? stationChannel,
    WifiEncryption? stationEncryption,
    String? stationDetailsPort,
    IpMode? stationIpMode,
    String? stationMacAddress,
    String? stationIpAddress,
    String? stationSubnetMask,
    String? stationGateway,
    String? stationDns,
    String? stationDhcpServerIp,
    String? stationWebServerIp,
    String? stationWebServerIpStation,
  }) {
    return NetworkConfig(
      wifiMode: wifiMode ?? this.wifiMode,
      port: port ?? this.port,
      apActiveConnections: apActiveConnections ?? this.apActiveConnections,
      apSsid: apSsid ?? this.apSsid,
      apPassword: apPassword ?? this.apPassword,
      apChannel: apChannel ?? this.apChannel,
      apEncryption: apEncryption ?? this.apEncryption,
      apDetailsPort: apDetailsPort ?? this.apDetailsPort,
      apIpMode: apIpMode ?? this.apIpMode,
      apMacAddress: apMacAddress ?? this.apMacAddress,
      apIpAddress: apIpAddress ?? this.apIpAddress,
      apSubnetMask: apSubnetMask ?? this.apSubnetMask,
      apGateway: apGateway ?? this.apGateway,
      apDns: apDns ?? this.apDns,
      apDhcpServerIp: apDhcpServerIp ?? this.apDhcpServerIp,
      apWebServerIp: apWebServerIp ?? this.apWebServerIp,
      stationActiveConnections:
          stationActiveConnections ?? this.stationActiveConnections,
      stationSsid: stationSsid ?? this.stationSsid,
      stationPassword: stationPassword ?? this.stationPassword,
      stationChannel: stationChannel ?? this.stationChannel,
      stationEncryption: stationEncryption ?? this.stationEncryption,
      stationDetailsPort: stationDetailsPort ?? this.stationDetailsPort,
      stationIpMode: stationIpMode ?? this.stationIpMode,
      stationMacAddress: stationMacAddress ?? this.stationMacAddress,
      stationIpAddress: stationIpAddress ?? this.stationIpAddress,
      stationSubnetMask: stationSubnetMask ?? this.stationSubnetMask,
      stationGateway: stationGateway ?? this.stationGateway,
      stationDns: stationDns ?? this.stationDns,
      stationDhcpServerIp: stationDhcpServerIp ?? this.stationDhcpServerIp,
      stationWebServerIp: stationWebServerIp ?? this.stationWebServerIp,
      stationWebServerIpStation:
          stationWebServerIpStation ?? this.stationWebServerIpStation,
    );
  }
}
