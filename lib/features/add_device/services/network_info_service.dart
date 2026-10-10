import 'package:network_info_plus/network_info_plus.dart';

class NetworkInfoService {
  NetworkInfoService({NetworkInfo? networkInfo})
      : _networkInfo = networkInfo ?? NetworkInfo();

  final NetworkInfo _networkInfo;
  static const fallbackBroadcast = '192.168.178.255';

  Future<String?> getLocalIp() async {
    return _networkInfo.getWifiIP();
  }

  Future<String> getBroadcastIp() async {
    final ip = await getLocalIp();
    if (ip == null || ip.isEmpty) return fallbackBroadcast;
    final parts = ip.split('.');
    if (parts.length != 4) return fallbackBroadcast;
    parts[3] = '255';
    return parts.join('.');
  }
}
