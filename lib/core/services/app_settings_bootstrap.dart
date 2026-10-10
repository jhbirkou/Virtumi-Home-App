import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/providers/data_providers.dart';
import '../../shared/providers/repository_providers.dart';
import '../navigation/start_route_providers.dart';
import '../navigation/start_route_support.dart';
import '../services/preferences_service.dart';
import '../services/theme_controller.dart';

/// Loads [appSettingsProvider] after login and syncs theme + start route.
class AppSettingsBootstrap extends ConsumerStatefulWidget {
  const AppSettingsBootstrap({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppSettingsBootstrap> createState() =>
      _AppSettingsBootstrapState();
}

class _AppSettingsBootstrapState extends ConsumerState<AppSettingsBootstrap> {
  String? _syncedUserId;

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      ref.listen(appSettingsProvider, (previous, next) {
        next.whenData((settings) async {
          if (settings == null) {
            ref.read(appSettingsReadyProvider.notifier).setReady(false);
            return;
          }

          if (_syncedUserId != session.user.id) {
            _syncedUserId = session.user.id;
            final prefs = ref.read(preferencesServiceProvider);
            if (prefs.hasStoredThemeMode) {
              await ref
                  .read(themeModeControllerProvider.notifier)
                  .toggleDarkMode(settings.darkMode);
            }
          }

          final repo = ref.read(smartHomeRepositoryProvider);
          final validated =
              await StartRouteSupport.validate(repo, settings.startRoute);
          ref.read(effectiveStartRouteProvider.notifier).setRoute(validated);
          ref.read(appSettingsReadyProvider.notifier).setReady(true);
          ref.read(routerRedirectTriggerProvider).refresh();
        });
      });
    } else {
      _syncedUserId = null;
    }

    return widget.child;
  }
}
