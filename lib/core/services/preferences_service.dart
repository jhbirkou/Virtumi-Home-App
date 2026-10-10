import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] for persisting global app settings.
///
/// Keep all preference keys here so storage access stays centralized and easy
/// to swap for another backend later.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String _themeModeKey = 'theme_mode';
  static const String _recentDeviceIdsKey = 'recent_device_ids';
  static const String _recentHouseIdsKey = 'recent_house_ids';
  static const String _startRouteKeyPrefix = 'start_route_';

  static const int maxRecentDevices = 3;
  static const int maxRecentHouses = 2;

  ThemeMode get themeMode {
    final value = _prefs.getString(_themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Whether the user has explicitly chosen light or dark (not system default).
  bool get hasStoredThemeMode => _prefs.containsKey(_themeModeKey);

  Future<void> setThemeMode(ThemeMode mode) {
    return _prefs.setString(_themeModeKey, mode.name);
  }

  List<String> get recentDeviceIds =>
      _prefs.getStringList(_recentDeviceIdsKey) ?? const [];

  Future<void> setRecentDeviceIds(List<String> ids) {
    return _prefs.setStringList(_recentDeviceIdsKey, ids);
  }

  List<String> get recentHouseIds =>
      _prefs.getStringList(_recentHouseIdsKey) ?? const [];

  Future<void> setRecentHouseIds(List<String> ids) {
    return _prefs.setStringList(_recentHouseIdsKey, ids);
  }

  String? startRouteForUser(String userId) {
    return _prefs.getString('$_startRouteKeyPrefix$userId');
  }

  Future<void> setStartRouteForUser(String userId, String route) {
    return _prefs.setString('$_startRouteKeyPrefix$userId', route);
  }
}

/// Provides the [PreferencesService]. Overridden in `main()` with the resolved
/// [SharedPreferences] instance so it is available synchronously everywhere.
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  throw UnimplementedError(
    'preferencesServiceProvider must be overridden in main()',
  );
});
