import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/services/preferences_service.dart';
import '../../domain/app_settings_repository.dart';
import '../../models/app_settings.dart';
import 'mappers/user_mappers.dart';

class SupabaseAppSettingsRepository implements AppSettingsRepository {
  SupabaseAppSettingsRepository(this._client, this._preferences);

  final SupabaseClient _client;
  final PreferencesService _preferences;

  @override
  Future<AppSettings> getSettings(String userId) async {
    final row = await _client
        .from('app_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (row == null) {
      final defaults = _withLocalStartRoute(AppSettings(userId: userId), userId);
      await saveSettings(defaults);
      return defaults;
    }

    return _withLocalStartRoute(appSettingsFromRow(row), userId);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _preferences.setStartRouteForUser(
      settings.userId,
      settings.startRoute,
    );

    try {
      await _client
          .from('app_settings')
          .upsert(appSettingsToRow(settings));
    } on PostgrestException catch (error) {
      if (!_isMissingStartRouteColumn(error)) rethrow;

      await _client.from('app_settings').upsert(
            appSettingsToRow(settings, includeStartRoute: false),
          );
    }
  }

  AppSettings _withLocalStartRoute(AppSettings settings, String userId) {
    final localRoute = _preferences.startRouteForUser(userId);
    if (localRoute == null || localRoute.isEmpty) return settings;
    return settings.copyWith(startRoute: localRoute);
  }

  bool _isMissingStartRouteColumn(PostgrestException error) {
    return error.code == 'PGRST204' &&
        (error.message.contains('start_route') ||
            error.message.contains("'start_route'"));
  }
}
