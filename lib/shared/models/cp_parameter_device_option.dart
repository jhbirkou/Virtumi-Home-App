import 'package:flutter/widgets.dart';

/// A device that can be linked to a Control Panel parameter slot.
@immutable
class CpParameterDeviceOption {
  const CpParameterDeviceOption({
    required this.deviceId,
    required this.name,
    required this.code,
    required this.espnowMac,
    required this.deviceType,
    required this.deviceTypeName,
    required this.locationPath,
  });

  final String deviceId;
  final String name;
  final String code;
  final String espnowMac;
  final int deviceType;
  final String deviceTypeName;
  final String locationPath;
}
