import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

import 'pin_credentials.dart';

/// Result of checking biometric availability on the device.
class BiometricSupport {
  const BiometricSupport({
    required this.isSupported,
    required this.canCheckBiometrics,
    this.errorMessage,
  });

  final bool isSupported;
  final bool canCheckBiometrics;
  final String? errorMessage;

  bool get isAvailable => isSupported && canCheckBiometrics;
}

/// Coordinates app lock, biometric auth and PIN verification.
class AppLockService {
  AppLockService({
    LocalAuthentication? localAuth,
    PinCredentials? pinCredentials,
  })  : _localAuth = localAuth ?? LocalAuthentication(),
        _pinCredentials = pinCredentials ?? PinCredentials();

  final LocalAuthentication _localAuth;
  final PinCredentials _pinCredentials;

  static bool get isPlatformSupported {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }

  PinCredentials get pinCredentials => _pinCredentials;

  Future<BiometricSupport> checkBiometricSupport() async {
    if (!isPlatformSupported) {
      return const BiometricSupport(
        isSupported: false,
        canCheckBiometrics: false,
        errorMessage: 'Biometrie ist auf dieser Plattform nicht verfügbar.',
      );
    }

    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = supported && await _localAuth.canCheckBiometrics;
      return BiometricSupport(
        isSupported: supported,
        canCheckBiometrics: canCheck,
        errorMessage: canCheck
            ? null
            : 'Auf diesem Gerät ist keine Biometrie eingerichtet.',
      );
    } catch (e) {
      return BiometricSupport(
        isSupported: false,
        canCheckBiometrics: false,
        errorMessage: 'Biometrie konnte nicht geprüft werden: $e',
      );
    }
  }

  Future<bool> authenticateWithBiometrics({
    required String reason,
    bool biometricOnly = true,
  }) async {
    if (!isPlatformSupported) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> hasPin(String userId) => _pinCredentials.hasPin(userId);

  Future<void> setPin(String userId, String pin) =>
      _pinCredentials.setPin(userId, pin);

  Future<bool> verifyPin(String userId, String pin) =>
      _pinCredentials.verifyPin(userId, pin);

  Future<void> clearPin(String userId) => _pinCredentials.clearPin(userId);
}
