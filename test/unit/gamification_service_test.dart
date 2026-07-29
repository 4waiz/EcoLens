import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/domain/models/gamification_config.dart';
import 'package:ecolens/domain/models/student.dart';
import 'package:ecolens/domain/models/waste_classification_result.dart';
import 'package:ecolens/domain/services/gamification_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unit tests for the pure gamification rules engine. These cover the core
/// acceptance criteria: correct rewards, incorrect = 0 (never negative), daily
/// cap, the 20-cycle bonus, streak behaviour, weekend/holiday streak handling
/// and low-confidence → General Waste routing.
void main() {
  const service = GamificationService();
  const config = GamificationConfig();

  Student baseStudent({
    int totalXp = 0,
    int points = 0,
    int streak = 0,
    int longest = 0,
    int daily = 0,
  }) {
    return Student(
      id: 'stu-test',
      studentNumber: 'STU-0001',
      firstName: 'Test',
      lastName: 'Student',
      grade: 4,
      className: '4B',
      houseId: 'house-taurus',
      avatarId: 'avatar-test',
      totalXp: totalXp,
      availablePoints: points,
      currentStreak: streak,
      longestStreak: longest,
      dailyEarnedPoints: daily,
    );
  }

  WasteClassificationResult result({
    WasteCategory predicted = WasteCategory.plastic,
    double confidence = 0.95,
  }) {
    return WasteClassificationResult(
      predictedCategory: predicted,
      detectedObjectName: 'Test Item',
      confidence: confidence,
      explanation: 'x',
      educationalFact: 'y',
      processedAt: DateTime(2026, 1, 1),
    );
  }

  group('correct classification reward', () {
    test('awards the configured points and XP for a correct answer', () {
      final outcome = service.calculateSessionRewards(
        student: baseStudent(),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.wasCorrect, isTrue);
      expect(outcome.basePoints, config.pointsPerCorrect); // 5
      expect(outcome.xpAwarded, config.xpPerCorrect); // 5
      expect(outcome.housePointsAwarded, config.pointsPerCorrect);
      expect(outcome.newStreak, 1);
    });
  });

  group('incorrect classification', () {
    test('awards zero points and never subtracts existing points', () {
      final outcome = service.calculateSessionRewards(
        student: baseStudent(points: 30, streak: 5),
        wasCorrect: false,
        config: config,
      );
      expect(outcome.totalPoints, 0);
      expect(outcome.xpAwarded, 0);
      expect(outcome.housePointsAwarded, 0);
      // Streak resets but points are untouched by the engine (never negative).
      expect(outcome.newStreak, 0);
      expect(outcome.basePoints, isNonNegative);
    });
  });

  group('daily point cap', () {
    test('caps base points to the remaining daily allowance', () {
      // 48 already earned, cap 50 -> only 2 more points possible.
      final outcome = service.calculateSessionRewards(
        student: baseStudent(daily: 48),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.basePoints, 2);
      expect(outcome.dailyCapReached, isTrue);
    });

    test('awards zero base points once the cap is reached', () {
      final outcome = service.calculateSessionRewards(
        student: baseStudent(daily: 50),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.basePoints, 0);
    });

    test('applyDailyCap clamps a request to the remaining allowance', () {
      expect(service.applyDailyCap(requested: 5, remainingToday: 2), 2);
      expect(service.applyDailyCap(requested: 5, remainingToday: 10), 5);
      expect(service.applyDailyCap(requested: 5, remainingToday: 0), 0);
    });
  });

  group('twenty-correct-cycle bonus', () {
    test('grants the bonus when the streak reaches the threshold', () {
      // Start at streak 19 with a fresh daily allowance so both base + bonus fit.
      final outcome = service.calculateSessionRewards(
        student: baseStudent(streak: 19, daily: 0),
        wasCorrect: true,
        config: const GamificationConfig(dailyPointsCap: 1000),
      );
      expect(outcome.newStreak, 20);
      expect(outcome.bonusApplied, isTrue);
      expect(outcome.bonusPoints, config.bonusPoints); // 25
    });

    test('does not grant a bonus off-threshold', () {
      final outcome = service.calculateSessionRewards(
        student: baseStudent(streak: 5),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.bonusApplied, isFalse);
      expect(outcome.bonusPoints, 0);
    });

    test('bonus respects the daily cap', () {
      // At cap, neither base nor bonus can be awarded.
      final outcome = service.calculateSessionRewards(
        student: baseStudent(streak: 19, daily: 50),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.bonusPoints, 0);
    });
  });

  group('streak calculation', () {
    test('increments on correct, resets to zero on incorrect', () {
      expect(service.updateStreak(currentStreak: 3, wasCorrect: true), 4);
      expect(service.updateStreak(currentStreak: 3, wasCorrect: false), 0);
    });

    test('tracks the longest streak', () {
      final outcome = service.calculateSessionRewards(
        student: baseStudent(streak: 8, longest: 8),
        wasCorrect: true,
        config: config,
      );
      expect(outcome.newStreak, 9);
      expect(outcome.newLongestStreak, 9);
    });
  });

  group('weekend / holiday streak handling', () {
    bool never(DateTime d) => false;

    test('a weekend gap does not break the streak', () {
      // Friday -> Monday (Sat+Sun in between) should not break with defaults.
      final friday = DateTime(2026, 7, 17); // Friday
      final monday = DateTime(2026, 7, 20); // Monday
      final broke = service.shouldBreakStreak(
        lastActive: friday,
        now: monday,
        config: config,
        isHoliday: never,
        isApprovedAbsence: never,
      );
      expect(broke, isFalse);
    });

    test('a holiday gap does not break the streak when holidays count', () {
      final mon = DateTime(2026, 7, 20);
      final wed = DateTime(2026, 7, 22);
      final broke = service.shouldBreakStreak(
        lastActive: mon,
        now: wed,
        config: config,
        isHoliday: (d) => d == DateTime(2026, 7, 21), // Tuesday is a holiday
        isApprovedAbsence: never,
      );
      expect(broke, isFalse);
    });

    test(
      'missing several normal school days beyond grace breaks the streak',
      () {
        final mon = DateTime(2026, 7, 6); // Monday
        final fri = DateTime(2026, 7, 10); // Friday, missed Tue-Thu (3 days)
        final broke = service.shouldBreakStreak(
          lastActive: mon,
          now: fri,
          config: const GamificationConfig(streakGraceDays: 1),
          isHoliday: never,
          isApprovedAbsence: never,
        );
        expect(broke, isTrue);
      },
    );

    test('an approved absence does not break the streak', () {
      final mon = DateTime(2026, 7, 6);
      final wed = DateTime(2026, 7, 8);
      final broke = service.shouldBreakStreak(
        lastActive: mon,
        now: wed,
        config: const GamificationConfig(streakGraceDays: 0),
        isHoliday: never,
        isApprovedAbsence: (d) => true, // fully excused
      );
      expect(broke, isFalse);
    });
  });

  group('low-confidence routing', () {
    test('below-threshold predictions route to General Waste', () {
      final r = result(predicted: WasteCategory.plastic, confidence: 0.72);
      expect(
        r.routedCategory(config.aiConfidenceThreshold),
        WasteCategory.general,
      );
    });

    test('choosing General Waste on a low-confidence item is correct', () {
      final r = result(predicted: WasteCategory.plastic, confidence: 0.72);
      final correct = service.isSelectionCorrect(
        result: r,
        selected: WasteCategory.general,
        config: config,
      );
      expect(correct, isTrue);
    });

    test(
      'choosing the predicted (but low-confidence) category is incorrect',
      () {
        final r = result(predicted: WasteCategory.plastic, confidence: 0.72);
        final correct = service.isSelectionCorrect(
          result: r,
          selected: WasteCategory.plastic,
          config: config,
        );
        expect(correct, isFalse);
      },
    );

    test('high-confidence predictions route to the predicted category', () {
      final r = result(predicted: WasteCategory.paper, confidence: 0.95);
      expect(
        r.routedCategory(config.aiConfidenceThreshold),
        WasteCategory.paper,
      );
      expect(
        service.isSelectionCorrect(
          result: r,
          selected: WasteCategory.paper,
          config: config,
        ),
        isTrue,
      );
    });
  });

  group('avatar level + stage', () {
    test('level increases with XP', () {
      expect(service.calculateAvatarLevel(0), 1);
      expect(service.calculateAvatarLevel(200) > 1, isTrue);
      expect(
        service.calculateAvatarLevel(2000) > service.calculateAvatarLevel(200),
        isTrue,
      );
    });

    test('monetary conversion is configurable and disable-able', () {
      const enabled = GamificationConfig(
        monetaryConversionEnabled: true,
        pointsPerCurrencyUnit: 50,
        currencyCode: 'AED',
      );
      expect(enabled.pointsToCurrency(50), 1.0);
      expect(enabled.formatCurrency(100), 'AED 2.00');

      const disabled = GamificationConfig(monetaryConversionEnabled: false);
      expect(disabled.pointsToCurrency(50), 0);
      expect(disabled.formatCurrency(100), '');
    });
  });
}
