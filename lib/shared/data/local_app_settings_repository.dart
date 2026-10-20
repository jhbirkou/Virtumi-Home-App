import '../../core/security/pin_credentials.dart';
import '../../core/services/preferences_service.dart';
import '../domain/app_settings_repository.dart';
import '../models/app_settings.dart';

/// Device-local [AppSettings] (SharedPreferences). Does not touch Supabase.
class LocalAppSettingsRepository implements AppSettingsRepository {
  LocalAppSettingsRepository(
    this._preferences, {
    PinCredentials? pinCredentials,
  }) : _pinCredentials = pinCredentials ?? PinCredentials();

  final PreferencesService _preferences;
  final PinCredentials _pinCredentials;

  @override
  Future<AppSettings> getSettings(String userId) async {
    final stored = _preferences.loadAppSettings(userId);
    if (_preferences.hasStoredPinEnabled(userId)) return stored;

    final hasPin = await _pinCredentials.hasPin(userId);
    if (!hasPin) return stored;
    return stored.copyWith(pinEnabled: true);
  }

  @override
  Future<void> saveSettings(AppSettings settings) {
    return _preferences.saveAppSettings(settings);
  }
}
