import 'package:flutter/material.dart';

/// EcoLens brand palette.
///
/// Derived from the Nano Banana Pro reference designs:
/// - EcoLens green visual identity (primary)
/// - Purple gamification accent (XP / levels)
/// - Gold rewards accent (coins / points)
///
/// All colours are exposed as static const so they can be used in const
/// widget trees and unit-tested without a BuildContext.
abstract final class AppColors {
  // ---- Brand greens ----
  static const Color primary = Color(0xFF2E7D46); // deep EcoLens green
  static const Color primaryDark = Color(0xFF1B5E34);
  static const Color primaryLight = Color(0xFF4CAF6D);
  static const Color primarySurface = Color(0xFFE8F3EC);
  static const Color primaryContainer = Color(0xFFD3EBDA);
  static const Color guardianGreen = Color(0xFF6BBE5E); // mascot body colour
  static const Color guardianLeaf = Color(0xFF8BC34A);

  // ---- Gamification purple ----
  static const Color xpPurple = Color(0xFF7C4DFF);
  static const Color xpPurpleDark = Color(0xFF5E35B1);
  static const Color xpPurpleSurface = Color(0xFFEDE7FB);

  // ---- Rewards gold ----
  static const Color coinGold = Color(0xFFF2B733);
  static const Color coinGoldDark = Color(0xFFD99A1C);
  static const Color coinGoldSurface = Color(0xFFFDF3DC);

  // ---- Waste category colours (match bin LED semantics) ----
  static const Color plastic = Color(0xFF3A9BDC); // blue
  static const Color paper = Color(0xFF4A6BC4); // indigo/blue
  static const Color organic = Color(0xFF57A639); // green
  static const Color general = Color(0xFF7C8A99); // grey

  // ---- House colours (PE houses) ----
  static const Color houseAries = Color(0xFFB5322E); // red
  static const Color houseTaurus = Color(0xFF2E7D46); // green
  static const Color houseLeo = Color(0xFFE0A400); // gold/amber
  static const Color houseAquarius = Color(0xFF2F72C4); // blue

  // ---- Feedback / semantic ----
  static const Color success = Color(0xFF2E9E4F);
  static const Color successSurface = Color(0xFFE6F6EB);
  static const Color error = Color(0xFFD64545);
  static const Color errorSurface = Color(0xFFFBEAEA);
  static const Color warning = Color(0xFFE08A1E);
  static const Color warningSurface = Color(0xFFFBF0DF);
  static const Color info = Color(0xFF3A79C4);

  // ---- Neutrals ----
  static const Color ink = Color(0xFF1D2B22);
  static const Color inkMuted = Color(0xFF5A6B60);
  static const Color inkFaint = Color(0xFF8B978F);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F9F6);
  static const Color scaffoldBg = Color(0xFFF0F6F1);
  static const Color border = Color(0xFFDCE7DF);
  static const Color borderStrong = Color(0xFFC3D4C8);

  // ---- Attract / hero gradient (idle kiosk background) ----
  static const List<Color> attractGradient = [
    Color(0xFFEAF6ED),
    Color(0xFFDCEFE1),
    Color(0xFFE7EFDB),
  ];

  static const List<Color> heroGreenGradient = [
    Color(0xFF2E7D46),
    Color(0xFF3E9A5C),
  ];

  /// Returns the LED / accent colour for a house colour token stored on the
  /// [House] model. Accepts a hex string like "#E0A400".
  static Color fromHex(String hex, {Color fallback = AppColors.primary}) {
    var value = hex.replaceAll('#', '').trim();
    if (value.length == 6) value = 'FF$value';
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return fallback;
    return Color(parsed);
  }
}
