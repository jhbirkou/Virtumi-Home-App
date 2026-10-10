import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens from the Stitch `DESIGN.md`.
///
/// Headlines and body use **Plus Jakarta Sans**; small labels use the same
/// family at a tighter scale for sharper rendering on mobile screens.
/// shares the exact same type scale.
class AppTypography {
  AppTypography._();

  static TextStyle headlineLg(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.56,
        color: color,
      );

  static TextStyle headlineLgMobile(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle headlineMd(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        height: 28 / 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle bodyLg(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle bodyMd(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle bodySm(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: color,
      );

  /// Uppercase technical label (Geist), used for section headers & captions.
  static TextStyle labelSm(Color color) => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: color,
      );

  /// Material [TextTheme] mapping for the global [ThemeData].
  static TextTheme textTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      displayLarge: headlineLg(onSurface),
      headlineLarge: headlineLg(onSurface),
      headlineMedium: headlineMd(onSurface),
      titleLarge: headlineMd(onSurface),
      titleMedium: bodyLg(onSurface),
      bodyLarge: bodyLg(onSurface),
      bodyMedium: bodyMd(onSurface),
      bodySmall: bodySm(onSurfaceVariant),
      labelLarge: bodyMd(onSurface),
      labelSmall: labelSm(onSurfaceVariant),
    );
  }
}
