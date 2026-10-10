import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

/// Resolves a model's string `accentKey` to a theme-aware accent [Color].
///
/// Keeps the data models free of Flutter color objects while still letting the
/// UI render consistent, palette-driven accents.
extension AccentResolver on BuildContext {
  Color accent(String key) {
    final p = palette;
    return switch (key) {
      'blue' => p.accentBlue,
      'sky' => p.accentSky,
      'cyan' => p.accentCyan,
      'indigo' => p.accentIndigo,
      'purple' => p.accentPurple,
      'teal' => p.accentTeal,
      'green' => p.accentGreen,
      'orange' => p.accentOrange,
      'amber' => p.accentAmber,
      'yellow' => p.accentYellow,
      'red' => p.accentRed,
      'stone' => p.accentStone,
      _ => p.accentBlue,
    };
  }
}
