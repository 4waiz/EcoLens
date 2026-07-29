import '../enums/waste_category.dart';
import '../models/avatar.dart';
import '../models/avatar_evolution_stage.dart';
import '../models/gamification_config.dart';
import '../models/student.dart';
import '../models/waste_classification_result.dart';

/// Outcome of scoring a single recycling attempt. Immutable value object so the
/// calculation is trivially unit-testable and free of side effects.
class SessionRewardOutcome {
  const SessionRewardOutcome({
    required this.wasCorrect,
    required this.basePoints,
    required this.bonusPoints,
    required this.xpAwarded,
    required this.housePointsAwarded,
    required this.newStreak,
    required this.newLongestStreak,
    required this.dailyCapReached,
    required this.bonusApplied,
  });

  final bool wasCorrect;
  final int basePoints;
  final int bonusPoints;
  final int xpAwarded;
  final int housePointsAwarded;
  final int newStreak;
  final int newLongestStreak;
  final bool dailyCapReached;
  final bool bonusApplied;

  int get totalPoints => basePoints + bonusPoints;
}

/// Pure gamification rules engine.
///
/// Business rules (all configurable via [GamificationConfig]):
/// - Each correct cycle awards `pointsPerCorrect` (default 5).
/// - Incorrect answers award 0 and NEVER subtract existing points.
/// - Daily earnable points are capped at `dailyPointsCap` (default 50).
/// - `bonusStreakThreshold` correct-in-a-row triggers a configurable bonus.
/// - Weekends / holidays / grace days do not break a streak.
/// - Reward positive behaviour; never punish.
class GamificationService {
  const GamificationService();

  /// Determine whether the student's chosen category matches the category the
  /// item should actually be routed to. When the AI confidence is below the
  /// threshold the correct answer is General Waste, so choosing General Waste
  /// on a low-confidence item is treated as correct.
  bool isSelectionCorrect({
    required WasteClassificationResult result,
    required WasteCategory selected,
    required GamificationConfig config,
  }) {
    final routed = result.routedCategory(config.aiConfidenceThreshold);
    return selected == routed;
  }

  /// Score a single attempt. Does not mutate the student — returns an outcome
  /// the caller applies via the repository.
  SessionRewardOutcome calculateSessionRewards({
    required Student student,
    required bool wasCorrect,
    required GamificationConfig config,
  }) {
    if (!wasCorrect) {
      // Never punish: 0 points, streak resets to 0, longest preserved.
      return SessionRewardOutcome(
        wasCorrect: false,
        basePoints: 0,
        bonusPoints: 0,
        xpAwarded: 0,
        housePointsAwarded: 0,
        newStreak: 0,
        newLongestStreak: student.longestStreak,
        dailyCapReached: student.dailyEarnedPoints >= config.dailyPointsCap,
        bonusApplied: false,
      );
    }

    // Apply the daily cap to base points.
    final remainingToday = (config.dailyPointsCap - student.dailyEarnedPoints)
        .clamp(0, config.dailyPointsCap);
    final basePoints = applyDailyCap(
      requested: config.pointsPerCorrect,
      remainingToday: remainingToday,
    );
    final dailyCapReached =
        (student.dailyEarnedPoints + basePoints) >= config.dailyPointsCap;

    final newStreak = updateStreak(
      currentStreak: student.currentStreak,
      wasCorrect: true,
    );

    // Streak bonus: awarded when the new streak hits a multiple of the
    // threshold (e.g. every 20 correct in a row). Bonus also respects the cap.
    final hitsBonus =
        config.bonusStreakThreshold > 0 &&
        newStreak > 0 &&
        newStreak % config.bonusStreakThreshold == 0;
    final remainingAfterBase = (remainingToday - basePoints).clamp(0, 1 << 30);
    final bonusPoints = hitsBonus
        ? applyTwentyCorrectCycleBonus(
            configuredBonus: config.bonusPoints,
            remainingToday: remainingAfterBase,
          )
        : 0;

    return SessionRewardOutcome(
      wasCorrect: true,
      basePoints: basePoints,
      bonusPoints: bonusPoints,
      xpAwarded: config.xpPerCorrect,
      housePointsAwarded: calculateHousePoints(
        basePoints: basePoints,
        bonusPoints: bonusPoints,
      ),
      newStreak: newStreak,
      newLongestStreak: newStreak > student.longestStreak
          ? newStreak
          : student.longestStreak,
      dailyCapReached: dailyCapReached,
      bonusApplied: bonusPoints > 0,
    );
  }

  /// Clamp requested points to what remains under the daily cap.
  int applyDailyCap({required int requested, required int remainingToday}) {
    if (remainingToday <= 0) return 0;
    return requested > remainingToday ? remainingToday : requested;
  }

  /// Correct increments the streak; incorrect resets it to 0.
  int updateStreak({required int currentStreak, required bool wasCorrect}) {
    if (!wasCorrect) return 0;
    return currentStreak + 1;
  }

  /// The configurable streak bonus (default: 20 correct in a row), clamped to
  /// the remaining daily allowance.
  int applyTwentyCorrectCycleBonus({
    required int configuredBonus,
    required int remainingToday,
  }) {
    if (remainingToday <= 0) return 0;
    return configuredBonus > remainingToday ? remainingToday : configuredBonus;
  }

  /// House points earned for an attempt (base + bonus contribute equally).
  int calculateHousePoints({
    required int basePoints,
    required int bonusPoints,
  }) {
    return basePoints + bonusPoints;
  }

  /// Whether an absence day breaks a streak. Weekends, holidays and approved
  /// absences (within the grace window) never break it.
  bool shouldBreakStreak({
    required DateTime lastActive,
    required DateTime now,
    required GamificationConfig config,
    required bool Function(DateTime day) isHoliday,
    required bool Function(DateTime day) isApprovedAbsence,
  }) {
    var missedActiveDays = 0;
    var cursor = DateTime(
      lastActive.year,
      lastActive.month,
      lastActive.day,
    ).add(const Duration(days: 1));
    final today = DateTime(now.year, now.month, now.day);

    while (cursor.isBefore(today)) {
      final isWeekend =
          cursor.weekday == DateTime.saturday ||
          cursor.weekday == DateTime.sunday;
      final counts =
          !(isWeekend && config.weekendsCountAsActive) &&
          !(isHoliday(cursor) && config.holidaysCountAsActive) &&
          !isApprovedAbsence(cursor);
      if (counts) missedActiveDays++;
      cursor = cursor.add(const Duration(days: 1));
    }

    // A streak only breaks if the student missed more *countable* school days
    // than the grace allowance.
    return missedActiveDays > config.streakGraceDays;
  }

  /// Compute avatar level from total XP. Uses a smooth curve where each level
  /// costs progressively more XP. Level 1 at 0 XP.
  int calculateAvatarLevel(int totalXp) {
    // xpForLevel(n) = 25 * (n-1)^2  -> level up roughly every few recycles.
    var level = 1;
    while (25 * level * level <= totalXp) {
      level++;
    }
    return level;
  }

  /// XP required to reach the next level from the current total.
  int xpToNextLevel(int totalXp) {
    final level = calculateAvatarLevel(totalXp);
    final nextThreshold = 25 * level * level;
    return (nextThreshold - totalXp).clamp(1, 1 << 30);
  }

  /// Resolve which evolution stage the given XP unlocks.
  AvatarEvolutionStage unlockAvatarStage({
    required int totalXp,
    required List<AvatarEvolutionStage> ladder,
  }) {
    final sorted = [...ladder]
      ..sort((a, b) => a.minimumXp.compareTo(b.minimumXp));
    var current = sorted.first;
    for (final stage in sorted) {
      if (totalXp >= stage.minimumXp) {
        current = stage;
      } else {
        break;
      }
    }
    return current;
  }

  /// Rebuild an avatar's derived fields (level, stage, xp-to-next) from XP.
  Avatar recomputeAvatar({
    required Avatar avatar,
    required int totalXp,
    required List<AvatarEvolutionStage> ladder,
  }) {
    final stage = unlockAvatarStage(totalXp: totalXp, ladder: ladder);
    return avatar.copyWith(
      level: calculateAvatarLevel(totalXp),
      currentXp: totalXp,
      xpRequiredForNextLevel:
          25 *
          (calculateAvatarLevel(totalXp)) *
          (calculateAvatarLevel(totalXp)),
      stage: stage.stageIndex,
    );
  }

  /// Weekly challenge progress for a house (0..1) toward a target count.
  double checkWeeklyChallengeProgress({
    required int current,
    required int target,
  }) {
    if (target <= 0) return 1;
    return (current / target).clamp(0.0, 1.0);
  }
}
