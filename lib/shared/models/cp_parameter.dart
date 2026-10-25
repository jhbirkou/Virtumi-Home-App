import 'package:flutter/widgets.dart';

/// Control Panel responder module (StDevice), index 0–9.
@immutable
class CpParameter {
  const CpParameter({
    required this.parameterIndex,
    this.id,
    this.active = 0,
    this.enabled = 0,
    this.init = 0,
    this.mode = 1,
    this.macAddress = '00:00:00:00:00:00',
    this.ipAddress = '192.168.1.1',
    this.port,
    this.ipv6 = '',
    this.channel = 1,
    this.name = '',
    this.code = '',
    this.resourceName = '',
    this.deviceType = 0,
    this.command0Active = 0,
    this.command0Exists = 0,
    this.command0Function = 0,
    this.command0ProtokolNr = 0,
    this.command1Active = 0,
    this.command1Exists = 0,
    this.command1Function = 0,
    this.command1ProtokolNr = 0,
    this.command2Active = 0,
    this.command2Exists = 0,
    this.command2Function = 0,
    this.command2ProtokolNr = 0,
  });

  final String? id;
  final int parameterIndex;
  final int active;
  final int enabled;
  final int init;
  final int mode;
  final String macAddress;
  final String ipAddress;
  final int? port;
  final String ipv6;
  final int channel;
  final String name;
  final String code;
  final String resourceName;
  final int deviceType;
  final int command0Active;
  final int command0Exists;
  final int command0Function;
  final int command0ProtokolNr;
  final int command1Active;
  final int command1Exists;
  final int command1Function;
  final int command1ProtokolNr;
  final int command2Active;
  final int command2Exists;
  final int command2Function;
  final int command2ProtokolNr;

  CpParameter copyWith({
    String? id,
    int? active,
    int? enabled,
    int? init,
    int? mode,
    String? macAddress,
    String? ipAddress,
    Object? port = _keepPort,
    String? ipv6,
    int? channel,
    String? name,
    String? code,
    String? resourceName,
    int? deviceType,
    int? command0Active,
    int? command0Exists,
    int? command0Function,
    int? command0ProtokolNr,
    int? command1Active,
    int? command1Exists,
    int? command1Function,
    int? command1ProtokolNr,
    int? command2Active,
    int? command2Exists,
    int? command2Function,
    int? command2ProtokolNr,
  }) {
    return CpParameter(
      id: id ?? this.id,
      parameterIndex: parameterIndex,
      active: active ?? this.active,
      enabled: enabled ?? this.enabled,
      init: init ?? this.init,
      mode: mode ?? this.mode,
      macAddress: macAddress ?? this.macAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      port: identical(port, _keepPort) ? this.port : port as int?,
      ipv6: ipv6 ?? this.ipv6,
      channel: channel ?? this.channel,
      name: name ?? this.name,
      code: code ?? this.code,
      resourceName: resourceName ?? this.resourceName,
      deviceType: deviceType ?? this.deviceType,
      command0Active: command0Active ?? this.command0Active,
      command0Exists: command0Exists ?? this.command0Exists,
      command0Function: command0Function ?? this.command0Function,
      command0ProtokolNr: command0ProtokolNr ?? this.command0ProtokolNr,
      command1Active: command1Active ?? this.command1Active,
      command1Exists: command1Exists ?? this.command1Exists,
      command1Function: command1Function ?? this.command1Function,
      command1ProtokolNr: command1ProtokolNr ?? this.command1ProtokolNr,
      command2Active: command2Active ?? this.command2Active,
      command2Exists: command2Exists ?? this.command2Exists,
      command2Function: command2Function ?? this.command2Function,
      command2ProtokolNr: command2ProtokolNr ?? this.command2ProtokolNr,
    );
  }
}

const _keepPort = Object();
