import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/preferences_service.dart';
import '../../core/supabase/supabase_client.dart';
import '../data/supabase/supabase_app_settings_repository.dart';
import '../models/app_settings.dart';

final connectionAppSettingsProvider = FutureProvider<AppSettings?>((ref) async {
  final authUser = ref.watch(supabaseClientProvider).auth.currentUser;
  if (authUser == null) return null;
  final repo = SupabaseAppSettingsRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(preferencesServiceProvider),
  );
  return repo.getSettings(authUser.id);
});

/// Current connection mode: `cloud` or `direct`.
final connectionModeProvider = Provider<String>((ref) {
  return ref.watch(connectionAppSettingsProvider).value?.connectionMode ??
      'cloud';
});

/// True when the app uses local UDP instead of Supabase for device I/O.
final isDirectConnectionProvider = Provider<bool>((ref) {
  return ref.watch(connectionModeProvider) == 'direct';
});
