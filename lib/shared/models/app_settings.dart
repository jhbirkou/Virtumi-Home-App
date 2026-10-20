import 'package:flutter/widgets.dart';

import '../../core/navigation/app_routes.dart';

/// Per-user app preferences stored on the device (Einstellungen screen).
@immutable
class AppSettings {
  const AppSettings({
    required this.userId,
    this.darkMode = false,
    this.language = 'de',
    this.biometricEnabled = false,
    this.pinEnabled = false,
    this.twoFactorEnabled = false,
    this.connectionMode = 'cloud',
    this.startRoute = Paths.home,
  });

  final String userId;
  final bool darkMode;
  final String language;
  final bool biometricEnabled;
  final bool pinEnabled;
  final bool twoFactorEnabled;
  final String connectionMode;

  /// GoRouter location opened after login / cold start (default: [Paths.home]).
  final String startRoute;

  String get languageLabel => switch (language) {
        'de' => 'Deutsch',
        'en' => 'English',
        _ => language,
      };

  String get connectionModeLabel => switch (connectionMode) {
        'cloud' => 'Cloud',
        'direct' => 'Lokales Netzwerk',
        _ => connectionMode,
      };

  AppSettings copyWith({
    bool? darkMode,
    String? language,
    bool? biometricEnabled,
    bool? pinEnabled,
    bool? twoFactorEnabled,
    String? connectionMode,
    String? startRoute,
  }) {
    return AppSettings(
      userId: userId,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinEnabled: pinEnabled ?? this.pinEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      connectionMode: connectionMode ?? this.connectionMode,
      startRoute: startRoute ?? this.startRoute,
    );
  }
}
