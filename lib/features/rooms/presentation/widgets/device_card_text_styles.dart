import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Shared typography for device cards in room overviews.
abstract final class DeviceCardTextStyles {
  static TextStyle title(BuildContext context) {
    return context.text.bodyMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: context.colors.onSurface,
    );
  }

  static TextStyle subtitle(BuildContext context) {
    return context.text.bodySmall!.copyWith(
      color: context.colors.onSurfaceVariant,
    );
  }

  static TextStyle caption(
    BuildContext context, {
    bool emphasis = false,
  }) {
    return context.text.labelSmall!.copyWith(
      letterSpacing: 0,
      fontWeight: emphasis ? FontWeight.w700 : FontWeight.w500,
      color: emphasis
          ? context.colors.onSurface
          : context.colors.onSurfaceVariant,
    );
  }

  static TextStyle statValue(BuildContext context) {
    return context.text.bodyMedium!.copyWith(
      fontWeight: FontWeight.w700,
      color: context.colors.onSurface,
    );
  }

  static TextStyle statLabel(BuildContext context) {
    return context.text.labelSmall!.copyWith(letterSpacing: 0.4);
  }
}
