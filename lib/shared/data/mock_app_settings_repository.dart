import '../domain/app_settings_repository.dart';
import '../models/app_settings.dart';

class MockAppSettingsRepository implements AppSettingsRepository {
  final Map<String, AppSettings> _store = {};

  @override
  Future<AppSettings> getSettings(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _store[userId] ?? AppSettings(userId: userId);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    _store[settings.userId] = settings;
  }
}
