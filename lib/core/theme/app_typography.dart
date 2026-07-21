import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typographic scale for EcoLens.
///
/// Uses the platform default (Roboto on most targets) to keep the app
/// self-contained (no bundled font binaries). Sizes are tuned for a large
/// landscape kiosk display where legibility from ~50cm matters, while the
/// dashboard/canteen layouts reuse the smaller ramp.
abstract final class AppTypography {
  static const String? fontFamily = null; // platform default

  static TextTheme textTheme(Color onSurface, Color muted) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: TextStyle(fontSize: 18, height: 1.4, color: onSurface),
      bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: onSurface),
      bodySmall: TextStyle(fontSize: 13, height: 1.35, color: muted),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: muted,
      ),
    );
  }

  /// Extra-large numeric style for kiosk stat tiles (XP, points, streak).
  static const TextStyle kioskStatNumber = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w800,
    height: 1.0,
    color: AppColors.ink,
  );
}
