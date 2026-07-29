import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../../../domain/models/models.dart';
import '../../../../shared/components/ecolens_logo.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/painters/valley_painters.dart';
import '../../application/kiosk_preferences.dart';

/// ---------------------------------------------------------------------------
/// Guardian Valley chrome — the HUD and side panels that frame the world.
///
/// These are shared by the attract screen and the recognised-student screen so
/// the composition never jumps between states: the same HUD simply gains the
/// student's Guardian details once a physical ID card is tapped.
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
                    color: AppColors.border,
                  ),
                  SizedBox(width: 10 * s),
                  Flexible(
                    child: Text(
                      'Guardian Valley',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13 * s,
                        fontWeight: FontWeight.w800,
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
                    Container(
                      width: 28 * s,
                      height: 28 * s,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            ValleyPalette.runeGlow,
                            ValleyPalette.forestNear,
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.pets,
                        size: 15 * s,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8 * s),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 190 * s),
                      child: Text(
                        guardianName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15 * s,
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
                    fontSize: 12 * s,
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
                      fontSize: 13 * s,
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
        color: (colour ?? Colors.white).withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.30),
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
// Left panel — the student's game profile
// ---------------------------------------------------------------------------

/// The full student stat panel shown once a physical Student ID card is read.
///
/// Deliberately absent from the attract screen: no previous student's details
/// are ever left on a shared kiosk.
class StudentValleyPanel extends StatelessWidget {
  const StudentValleyPanel({
    super.key,
    required this.student,
    required this.config,
    this.avatar,
    this.house,
  });

  final Student student;
  final GamificationConfig config;
  final Avatar? avatar;
  final House? house;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final dailyProgress = config.dailyPointsCap <= 0
        ? 0.0
        : student.dailyEarnedPoints / config.dailyPointsCap;

    return GamePanel(
      title: 'Student',
      icon: Icons.badge_outlined,
      accent: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Identity — FIRST NAME + class only. Never the full ID number.
          Row(
            children: [
              Container(
                width: 40 * s,
                height: 40 * s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: AppColors.heroGreenGradient,
                  ),
                  borderRadius: BorderRadius.circular(12 * s),
                ),
                child: Text(
                  student.firstName.characters.first.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20 * s,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
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
                        fontSize: 20 * s,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      'Grade ${student.grade} · Class ${student.className}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11 * s,
                        fontWeight: FontWeight.w700,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10 * s),

          // Stat grid — two per row so it stays readable in a narrow panel.
          _tileRow(context, [
            GameStatTile(
              label: 'Coins',
              value: '${student.availablePoints}',
              accent: AppColors.coinGoldDark,
              icon: Icons.monetization_on_rounded,
            ),
            GameStatTile(
              label: 'Level',
              value: '${avatar?.level ?? 1}',
              accent: AppColors.xpPurple,
              icon: Icons.military_tech_rounded,
            ),
          ]),
          SizedBox(height: 7 * s),
          _tileRow(context, [
            GameStatTile(
              label: 'Streak',
              value: '${student.currentStreak}',
              accent: AppColors.error,
              icon: Icons.local_fire_department_rounded,
            ),
            GameStatTile(
              label: 'Best',
              value: '${student.longestStreak}',
              accent: AppColors.warning,
              icon: Icons.emoji_events_outlined,
            ),
          ]),
          SizedBox(height: 7 * s),
          _tileRow(context, [
            GameStatTile(
              label: 'Correct',
              value: '${student.correctRecyclingCount}',
              accent: AppColors.success,
              icon: Icons.check_circle_outline,
            ),
            GameStatTile(
              label: 'Oops',
              value: '${student.incorrectRecyclingCount}',
              accent: AppColors.general,
              icon: Icons.refresh,
            ),
          ]),
          SizedBox(height: 7 * s),
          _tileRow(context, [
            GameStatTile(
              label: 'XP',
              value: '${student.totalXp}',
              accent: AppColors.info,
              icon: Icons.auto_awesome,
            ),
            GameStatTile(
              label: 'Score',
              value:
                  '${student.correctRecyclingCount * config.pointsPerCorrect}',
              accent: AppColors.primary,
              icon: Icons.stars_rounded,
            ),
          ]),

          SizedBox(height: 11 * s),
          GameMeter(
            value: dailyProgress,
            label: "TODAY'S RECYCLING",
            trailing:
                '${student.dailyEarnedPoints}/${config.dailyPointsCap} pts',
            accent: AppColors.primary,
            height: 14,
          ),
          if (house != null) ...[
            SizedBox(height: 10 * s),
            _HouseStrip(house: house!),
          ],
        ],
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

class _HouseStrip extends StatelessWidget {
  const _HouseStrip({required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final colour = AppColors.fromHex(house.colour);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 8 * s),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14 * s),
        border: Border.all(
          color: colour.withValues(alpha: 0.4),
          width: 1.5 * s,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_moon_outlined, size: 18 * s, color: colour),
          SizedBox(width: 8 * s),
          Expanded(
            child: Text(
              '${house.name} House',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13 * s,
                fontWeight: FontWeight.w800,
                color: Color.lerp(colour, Colors.black, 0.3),
              ),
            ),
          ),
          Text(
            'Rank ${house.leaderboardPosition}',
            style: TextStyle(
              fontSize: 12 * s,
              fontWeight: FontWeight.w900,
              color: colour,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Right panel — school-wide environmental impact
// ---------------------------------------------------------------------------

/// Snapshot of what the whole school has achieved today, plus the shared goal
/// and (when a student is present) their personal contribution.
class ValleyImpactPanel extends StatelessWidget {
  const ValleyImpactPanel({
    super.key,
    this.itemsRecycled = 312,
    this.co2SavedKg = 48,
    this.recycledRightPercent = 86,
    this.goalLabel = 'Weekly school goal',
    this.goalProgress = 0.62,
    this.goalCaption = '312 of 500 items',
    this.studentContribution,
    this.rankings = const [],
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

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return GamePanel(
      title: "Today's impact",
      icon: Icons.public,
      accent: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ImpactRow(
            icon: Icons.recycling,
            value: '$itemsRecycled',
            caption: 'Items recycled',
            accent: AppColors.primary,
          ),
          SizedBox(height: 8 * s),
          ImpactRow(
            icon: Icons.cloud_outlined,
            value: '$co2SavedKg kg',
            caption: 'CO₂ saved',
            accent: AppColors.info,
          ),
          SizedBox(height: 8 * s),
          ImpactRow(
            icon: Icons.verified_outlined,
            value: '$recycledRightPercent%',
            caption: 'Recycled right',
            accent: AppColors.coinGoldDark,
          ),
          SizedBox(height: 11 * s),
          GameMeter(
            value: goalProgress,
            label: goalLabel.toUpperCase(),
            trailing: goalCaption,
            accent: AppColors.success,
            height: 14,
          ),
          if (studentContribution != null) ...[
            SizedBox(height: 9 * s),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10 * s,
                vertical: 7 * s,
              ),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12 * s),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, size: 15 * s, color: AppColors.primary),
                  SizedBox(width: 7 * s),
                  Expanded(
                    child: Text(
                      studentContribution!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5 * s,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (rankings.isNotEmpty) ...[
            SizedBox(height: 11 * s),
            Text(
              'TEAM STANDINGS',
              style: TextStyle(
                fontSize: 10 * s,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.9 * s,
                color: AppColors.inkMuted,
              ),
            ),
            SizedBox(height: 6 * s),
            for (var i = 0; i < rankings.length; i++) ...[
              if (i > 0) SizedBox(height: 5 * s),
              _RankingRow(rank: i + 1, entry: rankings[i]),
            ],
          ],
        ],
      ),
    );
  }
}

/// One row of the team standings list.
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

class _RankingRow extends StatelessWidget {
  const _RankingRow({required this.rank, required this.entry});

  final int rank;
  final ValleyRanking entry;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 6 * s),
      decoration: BoxDecoration(
        color: entry.isMine
            ? entry.colour.withValues(alpha: 0.16)
            : AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10 * s),
        border: entry.isMine
            ? Border.all(
                color: entry.colour.withValues(alpha: 0.55),
                width: 1.5 * s,
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 18 * s,
            height: 18 * s,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: entry.colour,
              borderRadius: BorderRadius.circular(6 * s),
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 10 * s,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8 * s),
          Expanded(
            child: Text(
              entry.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12 * s,
                fontWeight: entry.isMine ? FontWeight.w900 : FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          Text(
            '${entry.points}',
            style: TextStyle(
              fontSize: 12 * s,
              fontWeight: FontWeight.w900,
              color: entry.colour,
            ),
          ),
        ],
      ),
    );
  }
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
              fontSize: 12.5 * s,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5 * s,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: ValleyPalette.forestDark.withValues(alpha: 0.8),
                  blurRadius: 6 * s,
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
                onTap: onTap == null ? null : () => onTap!(c),
              ),
          ],
        ),
      ],
    );
  }
}
