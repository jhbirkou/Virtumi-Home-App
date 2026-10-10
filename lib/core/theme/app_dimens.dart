import 'package:flutter/widgets.dart';

/// Spacing, radius and sizing tokens (8px grid) from the Stitch `DESIGN.md`.
///
/// Use these constants everywhere instead of magic numbers to keep the layout
/// consistent across all screens.
class AppSpacing {
  AppSpacing._();

  /// Base grid unit (8px).
  static const double unit = 8;

  static const double xs = 4;
  static const double sm = 8;
  static const double gutter = 16;
  static const double md = 20; // card-gap
  static const double cardGap = 20;
  static const double containerPadding = 24;
  static const double lg = 32;
  static const double sectionMargin = 40;

  /// Extra space between the bottom nav bar and the screen edge (above home indicator).
  static const double bottomNavInset = 8;

  /// Vertical space reserved so content can scroll clear of the floating nav.
  static const double bottomNavClearance = 108;

  /// Extra gap between the last scroll item and the top of the bottom nav bar.
  static const double bottomNavScrollGap = 16;

  /// Total bottom padding for [AppScrollView] above the floating nav bar.
  static double scrollBottomClearance(BuildContext context) {
    return bottomNavClearance +
        MediaQuery.paddingOf(context).bottom +
        bottomNavScrollGap;
  }
}

/// Corner radius tokens.
class AppRadius {
  AppRadius._();

  static const double sm = 12; // icon backgrounds (rounded-xl)
  static const double md = 16; // images (rounded-2xl)
  static const double card = 24; // standard cards (rounded-3xl)
  static const double cardLg = 32; // hero / header cards
  static const double pill = 9999;

  static const Radius smRadius = Radius.circular(sm);
  static const Radius cardRadius = Radius.circular(card);
  static const Radius cardLgRadius = Radius.circular(cardLg);

  static const BorderRadius smAll = BorderRadius.all(smRadius);
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius cardAll = BorderRadius.all(cardRadius);
  static const BorderRadius cardLgAll = BorderRadius.all(cardLgRadius);
  static const BorderRadius full = BorderRadius.all(Radius.circular(9999));
}

/// Common element sizes.
class AppSizes {
  AppSizes._();

  /// Max content width to keep the "handheld remote" feel on large screens.
  static const double maxContentWidth = 512;

  /// Breakpoint above which a tablet/expanded layout kicks in.
  static const double tabletBreakpoint = 720;

  static const double iconBoxSm = 40;
  static const double iconBoxMd = 48;
  static const double iconBoxLg = 56;

  static const double headerButton = 48;
  static const double avatar = 64;
  static const double iconSize = 24;
}
