import 'package:flutter/material.dart';

import 'app_colors.dart';

/// ---------------------------------------------------------------------------
/// Guardian Valley design tokens.
///
/// One place for every radius, border weight, shadow, surface tint, spacing
/// step, icon size and animation duration used by the game UI. Screens and
/// components read these instead of inventing their own numbers, which is the
/// difference between "a coherent game" and "twelve white boxes that happen to
/// be rounded".
///
/// Everything here is in DESIGN pixels. Widgets multiply by the surface's
/// [GameScale] factor, so the whole language shrinks and grows as one.
/// ---------------------------------------------------------------------------
abstract final class ValleyTokens {
  // ---- Corner radii -------------------------------------------------------
  /// A full information panel.
  static const double radiusPanel = 26;

  /// A stat tile / inner card.
  static const double radiusTile = 17;

  /// A small inline element (banner, hint strip).
  static const double radiusInner = 13;

  /// Fully rounded — pills, chips, medallions.
  static const double radiusPill = 999;

  // ---- Borders ------------------------------------------------------------
  static const double borderPanel = 2.6;
  static const double borderTile = 1.6;
  static const double borderStrong = 3.2;

  // ---- Panel chrome -------------------------------------------------------
  /// Height of the coloured band across the top of a panel.
  static const double headerHeight = 34;
  static const double headerHeightCompact = 28;

  // ---- Spacing scale ------------------------------------------------------
  static const double space2 = 2;
  static const double space4 = 4;
  static const double space6 = 6;
  static const double space8 = 8;
  static const double space11 = 11;
  static const double space14 = 14;
  static const double space18 = 18;
  static const double space24 = 24;

  // ---- Icon + medallion sizes --------------------------------------------
  static const double iconSm = 13;
  static const double iconMd = 17;
  static const double iconLg = 22;
  static const double medallionSm = 28;
  static const double medallionMd = 36;
  static const double medallionLg = 50;
  static const double medallionHero = 62;

  // ---- Text hierarchy -----------------------------------------------------
  /// Panel header — always upper case, always tight.
  static const double textHeader = 13;

  /// A panel's friendly one-line subtitle under the header.
  static const double textSubtitle = 10.5;

  /// Small-caps section divider ("HOUSE LEADERBOARD").
  static const double textSectionLabel = 10;

  /// A stat's caption.
  static const double textCaption = 11;

  /// A stat's label.
  static const double textLabel = 10;

  /// A normal body line.
  static const double textBody = 12.5;

  /// A stat value.
  static const double textValue = 20;

  /// The one number a panel is really about.
  static const double textValueHero = 30;

  // ---- Animation ----------------------------------------------------------
  /// Hover / press response. Must feel instant.
  static const Duration fast = Duration(milliseconds: 160);

  /// A state change the eye should follow.
  static const Duration normal = Duration(milliseconds: 260);

  /// Panel entry.
  static const Duration entry = Duration(milliseconds: 420);

  /// Per-child stagger inside one panel entry.
  static const Duration stagger = Duration(milliseconds: 70);

  /// A number counting up to its new value.
  static const Duration count = Duration(milliseconds: 850);

  /// A celebratory pulse on a badge or a milestone.
  static const Duration pulse = Duration(milliseconds: 620);

  // ---- Shadows ------------------------------------------------------------
  /// Two-part panel shadow: a wide ambient bloom plus a tight contact shadow.
  /// One big blur alone reads as a floating web card; the contact shadow is
  /// what makes a panel look like a physical thing resting in the valley.
  static List<BoxShadow> panelShadow(double s, {Color? tint}) => [
    BoxShadow(
      color: (tint ?? const Color(0xFF2F6039)).withValues(alpha: 0.22),
      blurRadius: 26 * s,
      spreadRadius: -2 * s,
      offset: Offset(0, 12 * s),
    ),
    BoxShadow(
      color: (tint ?? const Color(0xFF2F6039)).withValues(alpha: 0.16),
      blurRadius: 6 * s,
      offset: Offset(0, 3 * s),
    ),
  ];

  /// A raised inner element (tile, chip, medallion).
  static List<BoxShadow> tileShadow(double s, Color accent) => [
    BoxShadow(
      color: accent.withValues(alpha: 0.20),
      blurRadius: 8 * s,
      offset: Offset(0, 3 * s),
    ),
  ];

  /// The lift a destination card or portal gets on hover.
  static List<BoxShadow> liftShadow(double s, Color accent) => [
    BoxShadow(
      color: accent.withValues(alpha: 0.42),
      blurRadius: 24 * s,
      spreadRadius: -1 * s,
      offset: Offset(0, 12 * s),
    ),
  ];
}

/// ---------------------------------------------------------------------------
/// The panel personalities.
///
/// Colour carries meaning across the whole experience, so a student learns the
/// language once: green is *you and your Guardian*, blue is *the whole school*,
/// gold is *rewards and rankings*, purple is *level and XP*, teal is *your
/// card*, and coral is the only warning colour — used gently, never as an alarm.
/// ---------------------------------------------------------------------------
enum ValleyTheme {
  /// Student and Guardian information.
  forest,

  /// School-wide impact and discovery.
  adventure,

  /// Rewards, goals and rankings.
  treasure,

  /// Level, XP and evolution.
  arcane,

  /// Card scanning and identification.
  tide,

  /// A successful sort.
  bloom,

  /// A gentle "not quite" — never an error state.
  ember,
}

/// Resolved colours for one [ValleyTheme].
@immutable
class ValleyThemeColours {
  const ValleyThemeColours({
    required this.accent,
    required this.accentDeep,
    required this.surfaceTop,
    required this.surfaceBottom,
    required this.ink,
  });

  /// The identity colour: header band, borders, medallions.
  final Color accent;

  /// A darker sibling for the band gradient and text on light surfaces.
  final Color accentDeep;

  /// Panel body gradient — warm cream / pale tint at the top, more saturated at
  /// the bottom. Never pure white: white is what made these panels read as a
  /// business dashboard.
  final Color surfaceTop;
  final Color surfaceBottom;

  /// Readable text colour on [surfaceTop]/[surfaceBottom].
  final Color ink;

  /// The gradient painted across a panel's body.
  LinearGradient get surfaceGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surfaceTop, surfaceBottom],
  );

  /// The gradient painted across a panel's header band.
  LinearGradient get bandGradient => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.lerp(accent, Colors.white, 0.14)!, accentDeep],
  );

  /// A soft tinted fill for an inner tile.
  Color get tileFill => Color.lerp(surfaceTop, accent, 0.10)!;

  /// The border of an inner tile.
  Color get tileBorder => accent.withValues(alpha: 0.34);
}

extension ValleyThemeX on ValleyTheme {
  ValleyThemeColours get colours => switch (this) {
    ValleyTheme.forest => const ValleyThemeColours(
      accent: AppColors.primary,
      accentDeep: AppColors.primaryDark,
      // Pale mint over warm cream — reads as parchment in a forest, not paper
      // in an office.
      surfaceTop: Color(0xFFFCFEF8),
      surfaceBottom: Color(0xFFE4F2E5),
      ink: AppColors.ink,
    ),
    ValleyTheme.adventure => const ValleyThemeColours(
      accent: Color(0xFF3A79C4),
      accentDeep: Color(0xFF2C5C9B),
      surfaceTop: Color(0xFFFBFDFF),
      surfaceBottom: Color(0xFFE3EDFA),
      ink: Color(0xFF1B2A3D),
    ),
    ValleyTheme.treasure => const ValleyThemeColours(
      accent: AppColors.coinGold,
      accentDeep: Color(0xFFB57C10),
      surfaceTop: Color(0xFFFFFDF5),
      surfaceBottom: Color(0xFFFAEFD3),
      ink: Color(0xFF3D2E10),
    ),
    ValleyTheme.arcane => const ValleyThemeColours(
      accent: AppColors.xpPurple,
      accentDeep: AppColors.xpPurpleDark,
      surfaceTop: Color(0xFFFDFBFF),
      surfaceBottom: Color(0xFFEBE4FA),
      ink: Color(0xFF241A3D),
    ),
    ValleyTheme.tide => const ValleyThemeColours(
      accent: Color(0xFF2BA7A0),
      accentDeep: Color(0xFF1B7E79),
      surfaceTop: Color(0xFFF8FEFD),
      surfaceBottom: Color(0xFFDCF1EF),
      ink: Color(0xFF12332F),
    ),
    ValleyTheme.bloom => const ValleyThemeColours(
      accent: AppColors.success,
      accentDeep: Color(0xFF1F7A3B),
      surfaceTop: Color(0xFFFAFFFA),
      surfaceBottom: Color(0xFFE1F5E5),
      ink: Color(0xFF16331F),
    ),
    ValleyTheme.ember => const ValleyThemeColours(
      // Soft coral / amber. Deliberately warm rather than red: a child who
      // sorted a yoghurt pot into paper has not made an error, they have
      // learned something.
      accent: Color(0xFFE8935A),
      accentDeep: Color(0xFFC9702F),
      surfaceTop: Color(0xFFFFFCF7),
      surfaceBottom: Color(0xFFFAEADB),
      ink: Color(0xFF3D2617),
    ),
  };
}
