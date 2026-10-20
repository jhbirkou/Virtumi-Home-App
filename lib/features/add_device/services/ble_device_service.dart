import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../models/wizard_found_device.dart';

const _targetCharUuid = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';
const _targetServiceUuids = [
  '4fafc201-1fb5-459e-8fcc-c5c9c331914b',
  '0000180a-0000-1000-8000-00805f9b34fb',
  '0000180f-0000-1000-8000-00805f9b34fb',
  '00001800-0000-1000-8000-00805f9b34fb',
  '00001801-0000-1000-8000-00805f9b34fb',
];

const wifiPostConnectWaitSec = 10;

class BleWifiStatus {
  const BleWifiStatus({
    required this.wifistate,
    this.ipAddress,
    this.ssid,
    this.macAddress,
    this.devicename,
    this.devicetype,
    this.hostname,
    this.currentVersion,
    this.serialNumber,
  });

  final int wifistate;
  final String? ipAddress;
  final String? ssid;
  final String? macAddress;
  final String? devicename;
  final String? devicetype;
  final String? hostname;
  final String? currentVersion;
  final String? serialNumber;

  bool get isConnected =>
      wifistate == 1 && ipAddress != null && _isValidIpv4(ipAddress!);

  WizardFoundDevice toFoundDevice({int port = 6000}) {
    return WizardFoundDevice(
      devicename: devicename ?? 'Virtumi Device',
      devicetype: devicetype ?? 'Control Panel',
      macAddress: macAddress ?? '',
      ipAddress: ipAddress ?? '',
      hostname: hostname ?? '',
      port: port,
      currentVersion: currentVersion ?? '',
      serialNumber: serialNumber ?? '',
    );
  }

  static String? _nonEmpty(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }

  static bool _isValidIpv4(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  factory BleWifiStatus.fromJson(Map<String, dynamic> json) {
    final rawState = json['wifistate'] ?? json['wifi_state'];
    final wifistate = rawState is int
        ? rawState
        : int.tryParse(rawState?.toString() ?? '') ?? -1;
    return BleWifiStatus(
      wifistate: wifistate,
      ipAddress: json['ip_address']?.toString().trim(),
      ssid: json['ssid']?.toString(),
      macAddress: json['mac_address']?.toString().trim(),
      devicename: json['devicename']?.toString().trim(),
      devicetype: json['devicetype']?.toString().trim(),
      hostname: json['hostname']?.toString().trim(),
      currentVersion: _nonEmpty(json['current_version']),
      serialNumber: _nonEmpty(json['serial_number']),
    );
  }
}

class BleConnection {
  BleConnection(this.device, this.characteristic);

  final BluetoothDevice device;
  final BluetoothCharacteristic characteristic;

  Future<void> disconnect() async {
    try {
      await device.disconnect();
    } catch (_) {}
  }
}

class BleDeviceService {
  Stream<List<ScanResult>> scan({
    Duration timeout = const Duration(seconds: 15),
  }) {
    FlutterBluePlus.startScan(timeout: timeout);
    return FlutterBluePlus.scanResults;
  }

  Future<void> stopScan() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }
  }

  Future<BleConnection> connect(BluetoothDevice device) async {
    const maxAttempts = 6;
    const connectTimeout = Duration(seconds: 28);
    Object? lastErr;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        if (device.isConnected) {
          await device.disconnect();
        }

        await device.connect(timeout: connectTimeout, autoConnect: false);
        await Future<void>.delayed(
          Duration(milliseconds: attempt == 1 ? 220 : 380),
        );

        if (!device.isConnected) {
          lastErr = StateError('GATT sofort getrennt');
          await Future<void>.delayed(const Duration(milliseconds: 400));
          continue;
        }

        final services = await _discoverServices(device);
        final characteristic = await _findTargetCharacteristic(services);
        return BleConnection(device, characteristic);
      } catch (e) {
        lastErr = e;
        if (attempt < maxAttempts && _isRecoverable(e)) {
          try {
            if (device.isConnected) await device.disconnect();
          } catch (_) {}
          await Future<void>.delayed(
            Duration(milliseconds: 450 + attempt * 120),
          );
          continue;
        }
        rethrow;
      }
    }

    throw lastErr ?? StateError('BLE-Verbindung fehlgeschlagen');
  }

  Future<List<BluetoothService>> _discoverServices(
    BluetoothDevice device,
  ) async {
    final allServices = await device.discoverServices();
    final found = <BluetoothService>[];
    for (final uuid in _targetServiceUuids) {
      for (final svc in allServices) {
        if (svc.uuid.str128.toLowerCase().startsWith(uuid)) {
          found.add(svc);
        }
      }
    }
    return found.isEmpty ? allServices : found;
  }

  Future<BluetoothCharacteristic> _findTargetCharacteristic(
    List<BluetoothService> services,
  ) async {
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.uuid.str128.toLowerCase().startsWith(_targetCharUuid)) {
          return char;
        }
      }
    }
    throw StateError(
      'Keine passende GATT-Characteristic ($_targetCharUuid) gefunden.',
    );
  }

  bool _isRecoverable(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('disconnect') ||
        msg.contains('reconnect') ||
        msg.contains('gatt');
  }

  Future<void> sendWifi(
    BluetoothCharacteristic characteristic,
    String deviceCode,
    String ssid,
    String password,
  ) async {
    final payload = jsonEncode({
      'protocol_nr': 3,
      'code': deviceCode,
      'ssid': ssid,
      'password': password,
    });
    await _writeCharacteristic(characteristic, payload);
  }

  Future<BleWifiStatus> readWifiStatus(
    BluetoothCharacteristic characteristic,
    String deviceCode, {
    int firstDelayMs = 800,
    int betweenDelayMs = 600,
    int maxAttempts = 30,
  }) async {
    final cmd = jsonEncode({'protocol_nr': 8, 'code': deviceCode.trim()});
    await _writeCharacteristic(characteristic, cmd);

    var lastResponse = '';
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final delayMs = attempt == 1 ? firstDelayMs : betweenDelayMs;
      await Future<void>.delayed(Duration(milliseconds: delayMs));

      final bytes = await characteristic.read();
      lastResponse = utf8.decode(bytes);
      try {
        final json = jsonDecode(lastResponse) as Map<String, dynamic>;
        if (json.containsKey('wifistate') || json.containsKey('wifi_state')) {
          return BleWifiStatus.fromJson(json);
        }
      } catch (_) {}
    }

    throw StateError(
      'WiFi-Status: Keine gültige Antwort nach $maxAttempts Versuchen. '
      'Letzte: ${lastResponse.length > 200 ? lastResponse.substring(0, 200) : lastResponse}',
    );
  }

  Future<void> stopBluetooth(
    BluetoothCharacteristic characteristic,
    String deviceCode,
  ) async {
    final payload = jsonEncode({'protocol_nr': 9, 'code': deviceCode.trim()});
    await _writeCharacteristic(characteristic, payload);
  }

  Future<Map<String, dynamic>> getDeviceInfo(
    BluetoothCharacteristic characteristic,
    String deviceCode,
  ) async {
    final payload = jsonEncode({'protocol_nr': 1, 'code': deviceCode.trim()});
    await _writeCharacteristic(characteristic, payload);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final bytes = await characteristic.read();
    return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  }

  Future<void> _writeCharacteristic(
    BluetoothCharacteristic characteristic,
    String payload,
  ) async {
    final bytes = utf8.encode(payload);
    if (characteristic.properties.writeWithoutResponse) {
      await characteristic.write(bytes, withoutResponse: true);
    } else {
      await characteristic.write(bytes);
    }
  }
}
