import 'package:flutter/widgets.dart';

enum ConnectionStatus {
  connected('Verbunden'),
  disconnected('Getrennt'),
  connecting('Verbindet');

  const ConnectionStatus(this.label);
  final String label;
}

/// MQTT Quality of Service level.
enum MqttQosLevel {
  atMostOnce(0, '0 - At most once'),
  atLeastOnce(1, '1 - At least once'),
  exactlyOnce(2, '2 - Exactly once');

  const MqttQosLevel(this.value, this.label);

  final int value;
  final String label;

  static MqttQosLevel fromValue(int value) {
    for (final level in values) {
      if (level.value == value) return level;
    }
    return atMostOnce;
  }
}

/// Virtumi Cloud account/sync configuration.
@immutable
class VirtumiCloudConfig {
  const VirtumiCloudConfig({
    this.enabled = true,
    this.status = ConnectionStatus.connected,
    this.account = '',
    this.password = '',
  });

  final bool enabled;
  final ConnectionStatus status;
  final String account;
  final String password;

  VirtumiCloudConfig copyWith({
    bool? enabled,
    ConnectionStatus? status,
    String? account,
    String? password,
  }) {
    return VirtumiCloudConfig(
      enabled: enabled ?? this.enabled,
      status: status ?? this.status,
      account: account ?? this.account,
      password: password ?? this.password,
    );
  }
}

/// MQTT broker configuration.
@immutable
class MqttCloudConfig {
  const MqttCloudConfig({
    this.enabled = false,
    this.status = ConnectionStatus.disconnected,
    this.host = '',
    this.port = 8883,
    this.username = '',
    this.password = '',
    this.useTls = true,
    this.allowAnonymous = false,
    this.customerNumber = '',
    this.qosLevel = MqttQosLevel.atMostOnce,
    this.retainMessages = false,
    this.cleanSession = true,
  });

  final bool enabled;
  final ConnectionStatus status;
  final String host;
  final int port;
  final String username;
  final String password;
  final bool useTls;
  final bool allowAnonymous;
  final String customerNumber;
  final MqttQosLevel qosLevel;
  final bool retainMessages;
  final bool cleanSession;

  MqttCloudConfig copyWith({
    bool? enabled,
    ConnectionStatus? status,
    String? host,
    int? port,
    String? username,
    String? password,
    bool? useTls,
    bool? allowAnonymous,
    String? customerNumber,
    MqttQosLevel? qosLevel,
    bool? retainMessages,
    bool? cleanSession,
  }) {
    return MqttCloudConfig(
      enabled: enabled ?? this.enabled,
      status: status ?? this.status,
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      useTls: useTls ?? this.useTls,
      allowAnonymous: allowAnonymous ?? this.allowAnonymous,
      customerNumber: customerNumber ?? this.customerNumber,
      qosLevel: qosLevel ?? this.qosLevel,
      retainMessages: retainMessages ?? this.retainMessages,
      cleanSession: cleanSession ?? this.cleanSession,
    );
  }
}

/// Aggregate cloud configuration for a device.
@immutable
class CloudConfig {
  const CloudConfig({
    this.virtumi = const VirtumiCloudConfig(),
    this.mqtt = const MqttCloudConfig(),
  });

  final VirtumiCloudConfig virtumi;
  final MqttCloudConfig mqtt;

  CloudConfig copyWith({VirtumiCloudConfig? virtumi, MqttCloudConfig? mqtt}) {
    return CloudConfig(
      virtumi: virtumi ?? this.virtumi,
      mqtt: mqtt ?? this.mqtt,
    );
  }
}
