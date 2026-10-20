import 'package:flutter/foundation.dart';

@immutable
class WizardFoundDevice {
  const WizardFoundDevice({
    required this.devicename,
    required this.devicetype,
    required this.macAddress,
    required this.ipAddress,
    required this.hostname,
    this.port = 6000,
    this.home = '',
    this.floor = '',
    this.room = '',
    this.userMail = '',
    this.currentVersion = '',
    this.serialNumber = '',
  });

  final String devicename;
  final String devicetype;
  final String macAddress;
  final String ipAddress;
  final String hostname;
  final int port;
  final String home;
  final String floor;
  final String room;
  final String userMail;
  final String currentVersion;
  final String serialNumber;

  factory WizardFoundDevice.fromJson(
    Map<String, dynamic> json, {
    String? fallbackIp,
  }) {
    final ip = _nonEmpty(json['ip_address']) ?? fallbackIp ?? '';
    return WizardFoundDevice(
      devicename:
          _nonEmpty(json['devicename']) ??
          _nonEmpty(json['name']) ??
          'Virtumi Device',
      devicetype:
          _nonEmpty(json['devicetype']) ??
          _nonEmpty(json['device_type']) ??
          'Control Panel',
      macAddress:
          _nonEmpty(json['mac_address']) ?? _nonEmpty(json['mac']) ?? '',
      ipAddress: ip,
      hostname: _nonEmpty(json['hostname']) ?? '',
      port: _parsePort(json['port']),
      home: _nonEmpty(json['home']) ?? '',
      floor: _nonEmpty(json['floor']) ?? '',
      room: _nonEmpty(json['room']) ?? '',
      userMail:
          _nonEmpty(json['user_mail']) ?? _nonEmpty(json['user_email']) ?? '',
      currentVersion: _nonEmpty(json['current_version']) ?? '',
      serialNumber: _nonEmpty(json['serial_number']) ?? '',
    );
  }

  static String? _nonEmpty(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static int _parsePort(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 6000;
    return 6000;
  }

  /// Stable key for UI state such as the LAN flash toggle.
  String get flashKey => '$ipAddress|$macAddress';

  WizardFoundDevice copyWith({
    String? devicename,
    String? devicetype,
    String? macAddress,
    String? ipAddress,
    String? hostname,
    int? port,
    String? home,
    String? floor,
    String? room,
    String? userMail,
    String? currentVersion,
    String? serialNumber,
  }) {
    return WizardFoundDevice(
      devicename: devicename ?? this.devicename,
      devicetype: devicetype ?? this.devicetype,
      macAddress: macAddress ?? this.macAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      hostname: hostname ?? this.hostname,
      port: port ?? this.port,
      home: home ?? this.home,
      floor: floor ?? this.floor,
      room: room ?? this.room,
      userMail: userMail ?? this.userMail,
      currentVersion: currentVersion ?? this.currentVersion,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  /// Fills an empty version or serial from [other] when this device has none.
  WizardFoundDevice withIdentityFrom(WizardFoundDevice other) {
    return copyWith(
      currentVersion: currentVersion.isNotEmpty
          ? currentVersion
          : other.currentVersion,
      serialNumber: serialNumber.isNotEmpty ? serialNumber : other.serialNumber,
    );
  }
}
