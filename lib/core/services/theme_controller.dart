import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preferences_service.dart';

/// Holds the globally selected [ThemeMode] and persists changes.
///
/// The settings Dark-Mode toggle drives [toggleDarkMode]; the value is restored
/// on app start from [PreferencesService].
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ref.read(preferencesServiceProvider).themeMode;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state) return;
    state = mode;
    await ref.read(preferencesServiceProvider).setThemeMode(mode);
  }

  /// Toggles between light and dark (used by the settings switch).
  Future<void> toggleDarkMode(bool isDark) {
    return setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

/// Resolves whether the app currently renders in dark mode.
bool resolveIsDarkMode(ThemeMode mode, Brightness platformBrightness) {
  return switch (mode) {
    ThemeMode.dark => true,
    ThemeMode.light => false,
    ThemeMode.system => platformBrightness == Brightness.dark,
  };
}

/// Convenience selector: is the dark theme currently active?
final isDarkModeProvider = Provider<bool>((ref) {
  final mode = ref.watch(themeModeControllerProvider);
  final brightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  return resolveIsDarkMode(mode, brightness);
});
