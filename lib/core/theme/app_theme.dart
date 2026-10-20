import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_palette.dart';
import 'app_typography.dart';

/// Central Material 3 theme definitions for Virtumi Home.
///
/// Both [light] and [dark] themes; dark follows the Stitch "Aura Intelligence"
/// reference (tonal layering, turquoise accent, flat card elevation).
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      surfaceTint: AppColors.surfaceTint,
    );

    return _base(
      scheme,
      AppPalette.light,
      AppColors.onSurface,
      AppColors.onSurfaceVariant,
    );
  }

  static ThemeData get dark {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColorsDark.primary,
      onPrimary: AppColorsDark.onPrimary,
      primaryContainer: AppColorsDark.primaryContainer,
      onPrimaryContainer: AppColorsDark.onPrimaryContainer,
      secondary: AppColorsDark.secondary,
      onSecondary: AppColorsDark.onSecondary,
      secondaryContainer: AppColorsDark.secondaryContainer,
      onSecondaryContainer: AppColorsDark.onSecondaryContainer,
      tertiary: AppColorsDark.tertiary,
      onTertiary: AppColorsDark.onTertiary,
      error: AppColorsDark.error,
      onError: AppColorsDark.onError,
      errorContainer: AppColorsDark.errorContainer,
      onErrorContainer: AppColorsDark.onErrorContainer,
      surface: AppColorsDark.surface,
      onSurface: AppColorsDark.onSurface,
      surfaceContainerLowest: AppColorsDark.surfaceContainerLowest,
      surfaceContainerLow: AppColorsDark.surfaceContainerLow,
      surfaceContainer: AppColorsDark.surfaceContainer,
      surfaceContainerHigh: AppColorsDark.surfaceContainerHigh,
      surfaceContainerHighest: AppColorsDark.surfaceContainerHighest,
      onSurfaceVariant: AppColorsDark.onSurfaceVariant,
      outline: AppColorsDark.outline,
      outlineVariant: AppColorsDark.outlineVariant,
      inverseSurface: AppColorsDark.inverseSurface,
      onInverseSurface: AppColorsDark.inverseOnSurface,
      surfaceTint: AppColorsDark.surfaceTint,
    );

    return _base(
      scheme,
      AppPalette.dark,
      AppColorsDark.onSurface,
      AppColorsDark.onSurfaceVariant,
    );
  }

  static ThemeData _base(
    ColorScheme scheme,
    AppPalette palette,
    Color onSurface,
    Color onSurfaceVariant,
  ) {
    final textTheme = AppTypography.textTheme(onSurface, onSurfaceVariant);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: [palette],
      iconTheme: IconThemeData(color: onSurfaceVariant, size: 24),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: onSurface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          overlayColor: _buttonOverlay(
            scheme,
            pressed: scheme.onPrimary.withValues(alpha: 0.18),
            hovered: scheme.onPrimary.withValues(alpha: 0.08),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: _buttonOverlay(
            scheme,
            pressed: scheme.primary.withValues(alpha: 0.16),
            hovered: scheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: _buttonOverlay(
            scheme,
            pressed: scheme.primary.withValues(alpha: 0.14),
            hovered: scheme.primary.withValues(alpha: 0.06),
          ),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          overlayColor: _buttonOverlay(
            scheme,
            pressed: scheme.onSurface.withValues(alpha: 0.12),
            hovered: scheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
      ),
    );
  }

  static WidgetStateProperty<Color?> _buttonOverlay(
    ColorScheme scheme, {
    required Color pressed,
    required Color hovered,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) return pressed;
      if (states.contains(WidgetState.hovered)) return hovered;
      if (states.contains(WidgetState.focused)) {
        return hovered.withValues(alpha: hovered.a * 0.8);
      }
      return null;
    });
  }
}
