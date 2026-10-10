import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores and verifies a device-local PIN hash (never the plain PIN).
class PinCredentials {
  PinCredentials({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static String _hashKey(String userId) => 'pin_hash:$userId';
  static String _saltKey(String userId) => 'pin_salt:$userId';

  Future<bool> hasPin(String userId) async {
    final hash = await _storage.read(key: _hashKey(userId));
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String userId, String pin) async {
    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);
    await _storage.write(key: _saltKey(userId), value: salt);
    await _storage.write(key: _hashKey(userId), value: hash);
  }

  Future<bool> verifyPin(String userId, String pin) async {
    final salt = await _storage.read(key: _saltKey(userId));
    final storedHash = await _storage.read(key: _hashKey(userId));
    if (salt == null || storedHash == null) return false;
    return storedHash == _hashPin(pin, salt);
  }

  Future<void> clearPin(String userId) async {
    await _storage.delete(key: _hashKey(userId));
    await _storage.delete(key: _saltKey(userId));
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }
}
