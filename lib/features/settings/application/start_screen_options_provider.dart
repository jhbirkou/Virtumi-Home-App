import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/navigation/start_route_support.dart';
import '../../../shared/providers/data_providers.dart';
import '../../../shared/providers/repository_providers.dart';

/// Human-readable label for the user's chosen start screen in Einstellungen.
final startRouteDisplayLabelProvider = FutureProvider<String>((ref) async {
  final settings = await ref.watch(appSettingsProvider.future);
  if (settings == null) return 'Home';

  final repo = ref.watch(smartHomeRepositoryProvider);
  return StartRouteSupport.resolveLabel(repo, settings.startRoute);
});
