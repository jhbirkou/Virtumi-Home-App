import '../models/app_settings.dart';

abstract interface class AppSettingsRepository {
  Future<AppSettings> getSettings(String userId);
  Future<void> saveSettings(AppSettings settings);
}
