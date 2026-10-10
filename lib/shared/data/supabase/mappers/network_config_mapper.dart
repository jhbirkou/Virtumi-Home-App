import '../../../../core/supabase/supabase_helpers.dart';
import '../../../models/cloud_config.dart';
import '../../../models/network_config.dart';

WifiOperatingMode wifiModeFromInt(int? value) {
  return switch (value) {
    1 => WifiOperatingMode.station,
    2 => WifiOperatingMode.softAp,
    3 => WifiOperatingMode.stationSoftAp,
    _ => WifiOperatingMode.stationSoftAp,
  };
}

int wifiModeToInt(WifiOperatingMode mode) {
  return switch (mode) {
    WifiOperatingMode.station => 1,
    WifiOperatingMode.softAp => 2,
    WifiOperatingMode.stationSoftAp => 3,
  };
}

WifiEncryption ecnFromInt(int? value) {
  return switch (value) {
    0 => WifiEncryption.open,
    2 => WifiEncryption.wpaPsk,
    3 => WifiEncryption.wpa2Psk,
    _ => WifiEncryption.wpaPsk,
  };
}

int ecnToInt(WifiEncryption encryption) {
  return switch (encryption) {
    WifiEncryption.open => 0,
    WifiEncryption.wpaPsk => 2,
    WifiEncryption.wpa2Psk => 3,
  };
}

IpMode ipModeFromInt(int? value) =>
    value == 1 ? IpMode.manual : IpMode.dhcp;

int ipModeToInt(IpMode mode) => mode == IpMode.manual ? 1 : 0;

ConnectionStatus connectionFromInt(int? connected) {
  if (connected == 1) return ConnectionStatus.connected;
  return ConnectionStatus.disconnected;
}

ConnectionStatus mqttConnectionFromBool(bool? connected) {
  if (connected == true) return ConnectionStatus.connected;
  return ConnectionStatus.disconnected;
}

NetworkConfig mapNetworkConfig({
  Map<String, dynamic>? network,
  Map<String, dynamic>? softAp,
  Map<String, dynamic>? softApDetails,
  Map<String, dynamic>? station,
  Map<String, dynamic>? stationDetails,
}) {
  return NetworkConfig(
    wifiMode: wifiModeFromInt(network?['wifi_mode'] as int?),
    port: (network?['port'] ?? 6000).toString(),
    apActiveConnections: (softAp?['active_conn'] ?? 0).toString(),
    apSsid: softAp?['ssid'] as String? ?? '',
    apPassword: softAp?['password'] as String? ?? '',
    apChannel: (softAp?['channel'] ?? 6).toString(),
    apEncryption: ecnFromInt(softAp?['ecn'] as int?),
    apDetailsPort: (softApDetails?['port'] ?? 6000).toString(),
    apIpMode: ipModeFromInt(softApDetails?['networ_type'] as int?),
    apMacAddress: softApDetails?['mac'] as String? ?? '',
    apIpAddress: softApDetails?['ip'] as String? ?? '',
    apSubnetMask: softApDetails?['netmask'] as String? ?? '',
    apGateway: softApDetails?['gwip'] as String? ?? '',
    apDns: softApDetails?['dnsip'] as String? ?? '',
    apDhcpServerIp: softApDetails?['dhcpsvrip'] as String? ?? '',
    apWebServerIp: softApDetails?['websvrip'] as String? ?? '',
    stationActiveConnections: (station?['active_conn'] ?? 0).toString(),
    stationSsid: station?['ssid'] as String? ?? '',
    stationPassword: station?['password'] as String? ?? '',
    stationChannel: (station?['channel'] ?? 6).toString(),
    stationEncryption: ecnFromInt(station?['ecn'] as int?),
    stationDetailsPort: (stationDetails?['port'] ?? 6000).toString(),
    stationIpMode: ipModeFromInt(stationDetails?['networ_type'] as int?),
    stationMacAddress: stationDetails?['mac'] as String? ?? '',
    stationIpAddress: stationDetails?['ip'] as String? ?? '',
    stationSubnetMask: stationDetails?['netmask'] as String? ?? '',
    stationGateway: stationDetails?['gwip'] as String? ?? '',
    stationDns: stationDetails?['dnsip'] as String? ?? '',
    stationDhcpServerIp: stationDetails?['dhcpsvrip'] as String? ?? '',
    stationWebServerIp: stationDetails?['websvrip'] as String? ?? '',
  );
}

Map<String, dynamic> networkSettingsPayload(
  String deviceId,
  String userId,
  NetworkConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'wifi_mode': wifiModeToInt(config.wifiMode),
    'hostname': 'virtumi-device',
    'port': int.tryParse(config.port) ?? 6000,
  };
}

Map<String, dynamic> softApSettingsPayload(
  String deviceId,
  String userId,
  NetworkConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'active_conn': int.tryParse(config.apActiveConnections) ?? 0,
    'ssid': config.apSsid,
    'password': config.apPassword,
    'channel': int.tryParse(config.apChannel) ?? 6,
    'ecn': ecnToInt(config.apEncryption),
  };
}

Map<String, dynamic> softApDetailsPayload(
  String deviceId,
  String userId,
  NetworkConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'ip': config.apIpAddress,
    'netmask': config.apSubnetMask,
    'gwip': config.apGateway,
    'dnsip': config.apDns,
    'dhcpsvrip': config.apDhcpServerIp,
    'websvrip': config.apWebServerIp,
    'mac': config.apMacAddress,
    'networ_type': ipModeToInt(config.apIpMode),
    'port': int.tryParse(config.apDetailsPort) ?? 6000,
  };
}

Map<String, dynamic> stationSettingsPayload(
  String deviceId,
  String userId,
  NetworkConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'active_conn': int.tryParse(config.stationActiveConnections) ?? 0,
    'ssid': config.stationSsid,
    'password': config.stationPassword,
    'channel': int.tryParse(config.stationChannel) ?? 6,
    'ecn': ecnToInt(config.stationEncryption),
  };
}

Map<String, dynamic> stationDetailsPayload(
  String deviceId,
  String userId,
  NetworkConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'ip': config.stationIpAddress,
    'netmask': config.stationSubnetMask,
    'gwip': config.stationGateway,
    'dnsip': config.stationDns,
    'dhcpsvrip': config.stationDhcpServerIp,
    'websvrip': config.stationWebServerIp,
    'mac': config.stationMacAddress,
    'networ_type': ipModeToInt(config.stationIpMode),
    'port': int.tryParse(config.stationDetailsPort) ?? 6000,
  };
}

CloudConfig mapCloudConfig({
  Map<String, dynamic>? virtumi,
  Map<String, dynamic>? mqtt,
}) {
  return CloudConfig(
    virtumi: VirtumiCloudConfig(
      enabled: intToBool(virtumi?['active'] as int?),
      status: connectionFromInt(virtumi?['connected'] as int?),
      account: virtumi?['user_email'] as String? ?? '',
      password: virtumi?['user_password'] as String? ?? '',
    ),
    mqtt: MqttCloudConfig(
      enabled: mqtt?['mqtt_active'] as bool? ?? false,
      status: mqttConnectionFromBool(mqtt?['mqtt_connected'] as bool?),
      host: mqtt?['mqtt_server'] as String? ?? '',
      port: mqtt?['mqtt_port'] as int? ?? 1883,
      username: mqtt?['mqtt_user'] as String? ?? '',
      password: mqtt?['mqtt_password'] as String? ?? '',
      useTls: (mqtt?['mqtt_port'] as int? ?? 1883) == 8883,
      allowAnonymous: mqtt?['mqtt_allow_anonymous'] as bool? ?? false,
      customerNumber: mqtt?['mqtt_customer_number'] as String? ?? '',
      qosLevel: MqttQosLevel.fromValue(mqtt?['mqtt_qos'] as int? ?? 0),
      retainMessages: mqtt?['mqtt_retain'] as bool? ?? false,
      cleanSession: mqtt?['mqtt_clean_session'] as bool? ?? true,
    ),
  );
}

Map<String, dynamic> virtumiCloudPayload(
  String deviceId,
  String userId,
  VirtumiCloudConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'user_email': config.account,
    'user_password': config.password,
    'active': boolToInt(config.enabled),
    'connected': config.status == ConnectionStatus.connected ? 1 : 0,
  };
}

Map<String, dynamic> mqttCloudPayload(
  String deviceId,
  String userId,
  MqttCloudConfig config,
) {
  return {
    'device_id': deviceId,
    'user_id': userId,
    'mqtt_server': config.host,
    'mqtt_port': config.port,
    'mqtt_user': config.username,
    'mqtt_password': config.password,
    'mqtt_allow_anonymous': config.allowAnonymous,
    'mqtt_active': config.enabled,
    'mqtt_clean_session': config.cleanSession,
    'mqtt_customer_number': config.customerNumber,
    'mqtt_qos': config.qosLevel.value,
    'mqtt_retain': config.retainMessages,
  };
}
