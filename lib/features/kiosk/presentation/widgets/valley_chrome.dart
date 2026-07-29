import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/valley_tokens.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../../../domain/models/models.dart';
import '../../../../shared/components/ecolens_logo.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/components/valley_ui.dart';
import '../../../../shared/painters/valley_painters.dart';
import '../../application/kiosk_preferences.dart';

/// ---------------------------------------------------------------------------
/// Guardian Valley chrome — the HUD and side panels that frame the world.
///
/// These are shared by the attract screen and the recognised-student screen so
/// the composition never jumps between states: the same HUD simply gains the
/// student's Guardian details once a physical ID card is tapped.
///
/// Everything here is built from the Guardian Valley kit
/// (`shared/components/valley_ui.dart`), so the panels read as pieces of a game
/// — layered surfaces, medallions, shields and quest trails — rather than as
/// cards on a dashboard. No panel invents its own radius, shadow or colour.
/// ---------------------------------------------------------------------------

/// Top heads-up display: brand, Guardian identity, XP, coins, streak, school
/// and the sound / accessibility controls.
class ValleyHud extends ConsumerWidget {
  const ValleyHud({
    super.key,
    required this.schoolName,
    this.guardianName,
    this.level,
    this.xpProgress,
    this.xpLabel,
    this.coins,
    this.streak,
    this.offline = false,
    this.queuedCount = 0,
    this.showDevAccess = false,
  });

  final String schoolName;

  /// Present only once a student is loaded (privacy: nothing on the idle HUD).
  final String? guardianName;
  final int? level;
  final double? xpProgress;
  final String? xpLabel;
  final int? coins;
  final int? streak;

  final bool offline;
  final int queuedCount;
  final bool showDevAccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = context.gameScale;
    final prefs = ref.watch(kioskPreferencesProvider);
    final prefsCtrl = ref.read(kioskPreferencesProvider.notifier);
    final hasGuardian = guardianName != null;

    return Row(
      children: [
        // Brand. Long-pressing the logo opens the hidden dev panel — never
        // discoverable by a student.
        Flexible(
          child: GestureDetector(
            onLongPress: showDevAccess ? () => context.go(AppRoutes.dev) : null,
            child: _HudCapsule(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  EcoLensLogo(height: 30 * s),
                  SizedBox(width: 10 * s),
                  Container(
                    width: 1.5 * s,
                    height: 26 * s,
                    color: AppColors.primary.withValues(alpha: 0.28),
                  ),
                  SizedBox(width: 10 * s),
                  Flexible(
                    child: Text(
                      'Guardian Valley',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valleyLegible(13, s, 11.5) * s,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6 * s,
                        color: ValleyPalette.forestNear,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 10 * s),

        // Guardian identity + progression (only once a card is read).
        if (hasGuardian)
          Flexible(
            child: _HudCapsule(
              // The identity cluster holds several fixed-width chips. Scaling
              // the whole cluster down keeps every stat visible on a cramped
              // HUD instead of dropping or clipping any of them.
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValleyIconMedallion(
                      icon: Icons.pets,
                      accent: AppColors.primary,
                      size: 26,
                    ),
                    SizedBox(width: 8 * s),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 190 * s),
                      child: Text(
                        guardianName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: valleyLegible(15, s, 13) * s,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (level != null) ...[
                      SizedBox(width: 8 * s),
                      HudPill(
                        label: 'Lv $level',
                        accent: AppColors.xpPurple,
                        semanticsLabel: 'Guardian level $level',
                      ),
                    ],
                    if (xpProgress != null) ...[
                      SizedBox(width: 8 * s),
                      SizedBox(
                        width: 120 * s,
                        child: GameMeter(
                          value: xpProgress!,
                          label: 'XP',
                          trailing: xpLabel,
                          accent: AppColors.xpPurple,
                          height: 12,
                        ),
                      ),
                    ],
                    if (coins != null) ...[
                      SizedBox(width: 8 * s),
                      HudPill(
                        icon: Icons.monetization_on_rounded,
                        label: '$coins',
                        accent: AppColors.coinGoldDark,
                        semanticsLabel: '$coins eco coins',
                      ),
                    ],
                    if (streak != null) ...[
                      SizedBox(width: 6 * s),
                      HudPill(
                        icon: Icons.local_fire_department_rounded,
                        label: '$streak',
                        accent: AppColors.error,
                        semanticsLabel: '$streak day streak',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

        const Spacer(),

        if (offline) ...[
          _HudCapsule(
            colour: AppColors.warningSurface,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cloud_off, size: 16 * s, color: AppColors.warning),
                SizedBox(width: 6 * s),
                Text(
                  queuedCount > 0
                      ? 'Offline · $queuedCount saved'
                      : 'Offline mode',
                  style: TextStyle(
                    fontSize: valleyLegible(12, s, 11) * s,
                    fontWeight: FontWeight.w800,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8 * s),
        ],

        // School badge.
        Flexible(
          child: _HudCapsule(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.forest, size: 16 * s, color: AppColors.primary),
                SizedBox(width: 7 * s),
                Flexible(
                  child: Text(
                    schoolName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: valleyLegible(13, s, 11.5) * s,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8 * s),

        // Sound + accessibility controls.
        GameIconButton(
          icon: prefs.soundEnabled ? Icons.volume_up : Icons.volume_off,
          tooltip: prefs.soundEnabled ? 'Sound on' : 'Sound off',
          active: prefs.soundEnabled,
          onPressed: prefsCtrl.toggleSound,
        ),
        SizedBox(width: 6 * s),
        GameIconButton(
          icon: prefs.reduceMotion
              ? Icons.motion_photos_off
              : Icons.motion_photos_on,
          tooltip: prefs.reduceMotion
              ? 'Calm mode on'
              : 'Calm mode (less motion)',
          accent: AppColors.info,
          active: !prefs.reduceMotion,
          onPressed: prefsCtrl.toggleReduceMotion,
        ),
        SizedBox(width: 6 * s),
        GameIconButton(
          icon: Icons.format_size,
          tooltip: prefs.largeText ? 'Bigger text on' : 'Bigger text',
          accent: AppColors.xpPurple,
          active: prefs.largeText,
          onPressed: prefsCtrl.toggleLargeText,
        ),
      ],
    );
  }
}

/// A HUD capsule: cream rather than white, with a leaf-green rim.
class _HudCapsule extends StatelessWidget {
  const _HudCapsule({required this.child, this.colour});

  final Widget child;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 7 * s),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (colour ?? const Color(0xFFFDFEFA)).withValues(alpha: 0.96),
            (colour ?? const Color(0xFFEDF6EC)).withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.34),
          width: 2 * s,
        ),
        boxShadow: [
          BoxShadow(
            color: ValleyPalette.forestDark.withValues(alpha: 0.22),
            blurRadius: 10 * s,
            offset: Offset(0, 4 * s),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Left panel — the student's Explorer Profile
// ---------------------------------------------------------------------------

/// Child-facing wording for the profile panel.
///
/// The internal model names are unchanged — only what a 7-year-old reads. In
/// particular there is no "OOPS": a wrong bin is practice, not a failure, and
/// the panel says so.
abstract final class ProfileCopy {
  static const String panelTitle = 'Student';
  static const String panelSubtitle = 'Eco Explorer · your Guardian journey';

  static const String coins = 'Coins';
  static const String level = 'Level';
  static const String streak = 'Streak';
  static const String bestStreak = 'Best';

  /// Was "Correct".
  static const String correct = 'Great sorts';

  /// Was "Oops". Never a scolding.
  static const String learning = 'Learning';

  static const String xp = 'XP';

  /// Was "Score".
  static const String score = 'Eco score';

  static const String dailyMission = "Today's recycling";
}

/// The full student stat panel shown once a physical Student ID card is read.
///
/// Deliberately absent from the attract screen: no previous student's details
/// are ever left on a shared kiosk.
///
/// Hierarchy is intentional. Level, XP, coins and streak are the numbers a child
/// cares about, so they are the loud ones; totals and bests are quieter. Every
/// value the brief requires is still present.
class StudentValleyPanel extends StatelessWidget {
  const StudentValleyPanel({
    super.key,
    required this.student,
    required this.config,
    this.avatar,
    this.house,
    this.animate = true,
  });

  final Student student;
  final GamificationConfig config;
  final Avatar? avatar;
  final House? house;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    // The panel's height budget has to be read OUTSIDE the panel: a
    // ValleyGamePanel hands its body an unbounded main axis, so this is the last
    // place that knows how much room there actually is.
    return LayoutBuilder(
      builder: (context, outer) {
        final s = context.gameScale;
        final chrome = ValleyGamePanel.chromeHeight(
          scale: s,
          hasSubtitle: true,
        );
        final budget = outer.maxHeight.isFinite
            ? math.max(0.0, outer.maxHeight - chrome)
            : double.infinity;
        final design = budget.isFinite && s > 0 ? budget / s : double.infinity;

        // Tier before scaling. A cramped kiosk gives up decoration and tile
        // padding — never a statistic, and never the daily mission bar.
        final tight = design < 520;
        return _build(context, tight: tight, budget: budget);
      },
    );
  }

  Widget _build(
    BuildContext context, {
    required bool tight,
    required double budget,
  }) {
    final s = context.gameScale;
    final dailyProgress = config.dailyPointsCap <= 0
        ? 0.0
        : student.dailyEarnedPoints / config.dailyPointsCap;
    final level = avatar?.level ?? 1;

    return GamePanel(
      theme: ValleyTheme.forest,
      title: ProfileCopy.panelTitle,
      subtitle: ProfileCopy.panelSubtitle,
      icon: Icons.badge_outlined,
      trailing: ValleyBadge(
        label: 'Lv $level',
        icon: Icons.military_tech_rounded,
        accent: Colors.white,
        dense: true,
        semanticsLabel: 'Guardian level $level',
      ),
      child: ValleyPanelBody(
        budget: budget,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- Identity — FIRST NAME + class only, never the ID number ----
            ValleyEntrance(
              animate: animate,
              child: Row(
                children: [
                  _ExplorerCrest(initial: student.firstName, size: 42),
                  SizedBox(width: 10 * s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          student.firstName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: valleyLegible(20, s, 17) * s,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -0.4 * s,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 3 * s),
                        // The class as a small banner rather than a caption.
                        ValleyBadge(
                          label:
                              'Grade ${student.grade} · Class ${student.className}',
                          icon: Icons.school_outlined,
                          accent: AppColors.primary,
                          dense: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11 * s),

            // ---- The loud numbers -------------------------------------------
            ValleyEntrance(
              index: 1,
              animate: animate,
              child: _tileRow(context, [
                GameStatTile(
                  label: ProfileCopy.level,
                  value: '$level',
                  count: level,
                  accent: AppColors.xpPurple,
                  icon: Icons.military_tech_rounded,
                  hero: !tight,
                  dense: tight,
                ),
                GameStatTile(
                  label: ProfileCopy.xp,
                  value: '${student.totalXp}',
                  count: student.totalXp,
                  accent: AppColors.info,
                  icon: Icons.auto_awesome,
                  hero: !tight,
                  dense: tight,
                ),
              ]),
            ),
            SizedBox(height: 7 * s),
            ValleyEntrance(
              index: 2,
              animate: animate,
              child: _tileRow(context, [
                GameStatTile(
                  label: ProfileCopy.coins,
                  value: '${student.availablePoints}',
                  count: student.availablePoints,
                  accent: AppColors.coinGoldDark,
                  icon: Icons.monetization_on_rounded,
                  hero: !tight,
                  dense: tight,
                ),
                GameStatTile(
                  label: ProfileCopy.streak,
                  value: '${student.currentStreak}',
                  count: student.currentStreak,
                  accent: AppColors.error,
                  icon: Icons.local_fire_department_rounded,
                  hero: !tight,
                  dense: tight,
                  // Decoration, so it is the first thing a cramped kiosk drops.
                  footnote:
                      !tight &&
                          student.currentStreak >= student.longestStreak &&
                          student.currentStreak > 0
                      ? 'best yet!'
                      : null,
                ),
              ]),
            ),
            SizedBox(height: 9 * s),

            // ---- The quieter totals -----------------------------------------
            ValleyEntrance(
              index: 3,
              animate: animate,
              child: _tileRow(context, [
                GameStatTile(
                  label: ProfileCopy.correct,
                  value: '${student.correctRecyclingCount}',
                  count: student.correctRecyclingCount,
                  accent: AppColors.success,
                  icon: Icons.eco_rounded,
                  dense: true,
                ),
                GameStatTile(
                  label: ProfileCopy.learning,
                  value: '${student.incorrectRecyclingCount}',
                  count: student.incorrectRecyclingCount,
                  // Info blue, not the error red: these are lessons, not faults.
                  accent: AppColors.info,
                  icon: Icons.school_rounded,
                  dense: true,
                ),
              ]),
            ),
            SizedBox(height: 7 * s),
            ValleyEntrance(
              index: 4,
              animate: animate,
              child: _tileRow(context, [
                GameStatTile(
                  label: ProfileCopy.bestStreak,
                  value: '${student.longestStreak}',
                  count: student.longestStreak,
                  accent: AppColors.warning,
                  icon: Icons.emoji_events_outlined,
                  dense: true,
                ),
                GameStatTile(
                  label: ProfileCopy.score,
                  value:
                      '${student.correctRecyclingCount * config.pointsPerCorrect}',
                  count:
                      student.correctRecyclingCount * config.pointsPerCorrect,
                  accent: AppColors.primary,
                  icon: Icons.stars_rounded,
                  dense: true,
                ),
              ]),
            ),

            SizedBox(height: 11 * s),
            ValleyEntrance(
              index: 5,
              animate: animate,
              child: ValleyProgressBar(
                value: dailyProgress,
                label: ProfileCopy.dailyMission,
                trailing:
                    '${student.dailyEarnedPoints}/${config.dailyPointsCap} pts',
                accent: AppColors.primary,
                height: 15,
                animate: animate,
                semanticsLabel: "Today's recycling progress",
              ),
            ),
            if (house != null) ...[
              SizedBox(height: 10 * s),
              ValleyEntrance(
                index: 6,
                animate: animate,
                child: _HouseStrip(house: house!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Two equal-height tiles side by side. [IntrinsicHeight] lets the shorter
  /// tile match the taller one without demanding an infinite height from the
  /// surrounding (unbounded) column.
  Widget _tileRow(BuildContext context, List<Widget> tiles) {
    final s = context.gameScale;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0) SizedBox(width: 7 * s),
            Expanded(child: tiles[i]),
          ],
        ],
      ),
    );
  }
}

/// The student's initial inside a leaf-shaped crest — a collectible frame
/// rather than an account avatar.
class _ExplorerCrest extends StatelessWidget {
  const _ExplorerCrest({required this.initial, this.size = 42});

  final String initial;
  final double size;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final d = size * s;
    final letter = initial.trim().isEmpty
        ? '?'
        : initial.characters.first.toUpperCase();

    return ExcludeSemantics(
      child: SizedBox(
        width: d,
        height: d,
        child: CustomPaint(
          painter: const _CrestPainter(),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: d * 0.44,
                fontWeight: FontWeight.w900,
                height: 1,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.6),
                    blurRadius: 3 * s,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CrestPainter extends CustomPainter {
  const _CrestPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // A rounded shield with a leaf point at the top — the Guardian's mark.
    final path = Path()
      ..moveTo(w * 0.5, h * 0.02)
      ..cubicTo(w * 0.96, h * 0.14, w, h * 0.42, w * 0.5, h * 0.99)
      ..cubicTo(0, h * 0.42, w * 0.04, h * 0.14, w * 0.5, h * 0.02)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF5FBE72), AppColors.primaryDark],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.4, w * 0.055)
        ..color = Colors.white.withValues(alpha: 0.85),
    );
    // Central leaf vein, to read as foliage rather than heraldry alone.
    canvas.drawLine(
      Offset(w * 0.5, h * 0.16),
      Offset(w * 0.5, h * 0.82),
      Paint()
        ..strokeWidth = math.max(1, w * 0.03)
        ..color = Colors.white.withValues(alpha: 0.28),
    );
  }

  @override
  bool shouldRepaint(covariant _CrestPainter old) => false;
}

/// The student's house, as a rank shield strip.
class _HouseStrip extends StatelessWidget {
  const _HouseStrip({required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final colour = AppColors.fromHex(house.colour);
    return Semantics(
      label:
          '${house.name} House, ranked ${house.leaderboardPosition} in the school',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colour.withValues(alpha: 0.2),
              colour.withValues(alpha: 0.08),
            ],
          ),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusTile * s),
          border: Border.all(
            color: colour.withValues(alpha: 0.45),
            width: ValleyTokens.borderTile * s,
          ),
        ),
        child: Row(
          children: [
            ValleyIconMedallion(
              icon: Icons.shield_moon_outlined,
              accent: colour,
              size: 26,
              glow: false,
            ),
            SizedBox(width: 8 * s),
            Expanded(
              child: Text(
                '${house.name} House',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: valleyLegible(13, s, 11.5) * s,
                  fontWeight: FontWeight.w900,
                  color: Color.lerp(colour, Colors.black, 0.3),
                ),
              ),
            ),
            ValleyBadge(
              label: 'Rank ${house.leaderboardPosition}',
              accent: colour,
              filled: true,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Right panel — the Valley Impact Board
// ---------------------------------------------------------------------------

/// Child-facing wording for the impact board.
abstract final class ImpactCopy {
  static const String panelTitle = "Today's impact";
  static const String panelSubtitle = 'Your school is helping the valley!';

  static const String itemsRecycled = 'Items recycled';
  static const String co2Saved = 'CO₂ saved';
  static const String recycledRight = 'Recycled right';

  /// Was "Weekly school goal".
  static const String quest = 'School quest';

  /// Was "Team standings".
  static const String leaderboard = 'House leaderboard';
}

/// Snapshot of what the whole school has achieved today, plus the shared goal
/// and (when a student is present) their personal contribution.
///
/// Presented as a **board**, not a report: illustrated medallions with counting
/// numbers, a quest trail with milestone stars instead of a progress bar, and
/// podium shields instead of table rows.
class ValleyImpactPanel extends StatelessWidget {
  const ValleyImpactPanel({
    super.key,
    this.itemsRecycled = 312,
    this.co2SavedKg = 48,
    this.recycledRightPercent = 86,
    this.goalLabel = ImpactCopy.quest,
    this.goalProgress = 0.62,
    this.goalCaption = '312 of 500 items',
    this.studentContribution,
    this.rankings = const [],
    this.animate = true,
  });

  final int itemsRecycled;
  final int co2SavedKg;
  final int recycledRightPercent;
  final String goalLabel;
  final double goalProgress;
  final String goalCaption;

  /// "You've added 24 items" — only present once a card has been tapped.
  final String? studentContribution;

  /// Class or house standings, highest first.
  final List<ValleyRanking> rankings;

  final bool animate;

  @override
  Widget build(BuildContext context) {
    // Same rule as the profile panel: read the height budget before the panel
    // chrome, tier the decoration, then let the safety net catch the remainder.
    return LayoutBuilder(
      builder: (context, outer) {
        final s = context.gameScale;
        final chrome = ValleyGamePanel.chromeHeight(
          scale: s,
          hasSubtitle: true,
        );
        final budget = outer.maxHeight.isFinite
            ? math.max(0.0, outer.maxHeight - chrome)
            : double.infinity;
        final design = budget.isFinite && s > 0 ? budget / s : double.infinity;
        return _build(context, tight: design < 470, budget: budget);
      },
    );
  }

  Widget _build(
    BuildContext context, {
    required bool tight,
    required double budget,
  }) {
    final s = context.gameScale;
    final leader = rankings.isEmpty
        ? 1
        : rankings.map((r) => r.points).reduce(math.max);

    return GamePanel(
      theme: ValleyTheme.adventure,
      title: ImpactCopy.panelTitle,
      subtitle: ImpactCopy.panelSubtitle,
      icon: Icons.public,
      child: ValleyPanelBody(
        budget: budget,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValleyEntrance(
              animate: animate,
              child: ImpactRow(
                icon: Icons.recycling,
                value: '$itemsRecycled',
                count: itemsRecycled,
                caption: ImpactCopy.itemsRecycled,
                accent: AppColors.primary,
                // Encouragement is decoration: the first thing to go when the
                // panel is short, before any real number.
                cheer: tight ? null : 'saved from the bin',
              ),
            ),
            SizedBox(height: 8 * s),
            ValleyEntrance(
              index: 1,
              animate: animate,
              child: ImpactRow(
                icon: Icons.cloud_outlined,
                value: '$co2SavedKg kg',
                count: co2SavedKg,
                suffix: ' kg',
                caption: ImpactCopy.co2Saved,
                accent: AppColors.info,
                cheer: tight ? null : 'cleaner air for the valley',
              ),
            ),
            SizedBox(height: 8 * s),
            ValleyEntrance(
              index: 2,
              animate: animate,
              child: ImpactRow(
                icon: Icons.workspace_premium_rounded,
                value: '$recycledRightPercent%',
                count: recycledRightPercent,
                suffix: '%',
                caption: ImpactCopy.recycledRight,
                accent: AppColors.coinGoldDark,
                cheer: tight ? null : 'sorted into the right portal',
              ),
            ),
            SizedBox(height: 12 * s),

            // ---- The shared goal, as a journey ------------------------------
            ValleyEntrance(
              index: 3,
              animate: animate,
              child: ValleyQuestTrail(
                value: goalProgress,
                label: goalLabel,
                caption: goalCaption,
                accent: AppColors.success,
                animate: animate,
              ),
            ),

            if (studentContribution != null) ...[
              SizedBox(height: 10 * s),
              ValleyEntrance(
                index: 4,
                animate: animate,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * s,
                    vertical: 8 * s,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.18),
                        AppColors.primary.withValues(alpha: 0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                      ValleyTokens.radiusTile * s,
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.38),
                      width: ValleyTokens.borderTile * s,
                    ),
                  ),
                  child: Row(
                    children: [
                      ValleyIconMedallion(
                        icon: Icons.favorite_rounded,
                        accent: AppColors.primary,
                        size: 24,
                        glow: false,
                      ),
                      SizedBox(width: 8 * s),
                      Expanded(
                        child: Text(
                          studentContribution!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: valleyLegible(11.5, s, 10.5) * s,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (rankings.isNotEmpty) ...[
              SizedBox(height: 12 * s),
              ValleySectionLabel(
                label: ImpactCopy.leaderboard,
                accent: AppColors.coinGoldDark,
                icon: Icons.emoji_events_rounded,
              ),
              SizedBox(height: 6 * s),
              for (var i = 0; i < rankings.length; i++) ...[
                if (i > 0) SizedBox(height: 5 * s),
                ValleyEntrance(
                  index: 5 + i,
                  animate: animate,
                  child: ValleyRankRow(
                    rank: i + 1,
                    name: rankings[i].name,
                    points: rankings[i].points,
                    colour: rankings[i].colour,
                    leaderPoints: leader,
                    isMine: rankings[i].isMine,
                    animate: animate,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

/// One row of the house standings.
@immutable
class ValleyRanking {
  const ValleyRanking({
    required this.name,
    required this.points,
    this.colour = AppColors.primary,
    this.isMine = false,
  });

  final String name;
  final int points;
  final Color colour;
  final bool isMine;
}

// ---------------------------------------------------------------------------
// Bottom action area — the four world portals
// ---------------------------------------------------------------------------

/// The four bin compartments presented as colourful world portals.
class WorldPortalRow extends StatelessWidget {
  const WorldPortalRow({
    super.key,
    this.onTap,
    this.selected,
    this.caption,
    this.states = const {},
    this.rewardLabel,
    this.animate = true,
    this.hints = const {
      WasteCategory.plastic: 'Bottles & cups',
      WasteCategory.paper: 'Paper & card',
      WasteCategory.organic: 'Food & leaves',
      WasteCategory.general: 'Everything else',
    },
  });

  final void Function(WasteCategory category)? onTap;
  final WasteCategory? selected;
  final String? caption;

  /// Per-portal feedback. Anything not listed is [PortalState.idle].
  final Map<WasteCategory, PortalState> states;

  /// Shown rising out of whichever portal is [PortalState.correct].
  final String? rewardLabel;

  final bool animate;
  final Map<WasteCategory, String> hints;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (caption != null) ...[
          Text(
            caption!,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: valleyLegible(12.5, s, 11.5) * s,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5 * s,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: ValleyPalette.forestDark.withValues(alpha: 0.85),
                  blurRadius: 6 * s,
                ),
                Shadow(
                  color: ValleyPalette.forestDark.withValues(alpha: 0.5),
                  blurRadius: 14 * s,
                ),
              ],
            ),
          ),
          SizedBox(height: 7 * s),
        ],
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12 * s,
          runSpacing: 8 * s,
          children: [
            for (final c in WasteCategory.values)
              WorldPortalButton(
                label: c.label,
                icon: c.icon,
                colour: c.colour,
                hint: hints[c],
                selected: selected == c,
                state: states[c] ?? PortalState.idle,
                rewardLabel: rewardLabel,
                animate: animate,
                onTap: onTap == null ? null : () => onTap!(c),
              ),
          ],
        ),
      ],
    );
  }
}
