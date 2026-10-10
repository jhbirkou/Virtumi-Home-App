import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_routes.dart';

class EffectiveStartRoute extends Notifier<String> {
  @override
  String build() => Paths.home;

  void setRoute(String route) => state = route;

  void reset() => state = Paths.home;
}

class AppSettingsReady extends Notifier<bool> {
  @override
  bool build() => false;

  void setReady(bool value) => state = value;

  void reset() => state = false;
}

class StartRouteApplied extends Notifier<bool> {
  @override
  bool build() => false;

  void markApplied() => state = true;

  void reset() => state = false;
}

/// Resolved launch route after validation against the current hierarchy.
final effectiveStartRouteProvider =
    NotifierProvider<EffectiveStartRoute, String>(EffectiveStartRoute.new);

/// True once [appSettingsProvider] has loaded for the signed-in user.
final appSettingsReadyProvider =
    NotifierProvider<AppSettingsReady, bool>(AppSettingsReady.new);

/// Ensures the start route redirect runs only once per session.
final startRouteAppliedProvider =
    NotifierProvider<StartRouteApplied, bool>(StartRouteApplied.new);

/// Triggers GoRouter redirect re-evaluation when the start route is ready.
final routerRedirectTriggerProvider = Provider<RouterRedirectTrigger>((ref) {
  return RouterRedirectTrigger();
});

class RouterRedirectTrigger extends ChangeNotifier {
  void refresh() => notifyListeners();
}

void resetStartRouteSessionState(Ref ref) {
  ref.read(startRouteAppliedProvider.notifier).reset();
  ref.read(appSettingsReadyProvider.notifier).reset();
  ref.read(effectiveStartRouteProvider.notifier).reset();
}
