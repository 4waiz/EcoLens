import 'package:ecolens/app/router.dart';
import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/core/theme/valley_tokens.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/domain/models/models.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/application/kiosk_preferences.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/valley_chrome.dart';
import 'package:ecolens/features/landing/landing_screen.dart';
import 'package:ecolens/shared/components/game_ui.dart';
import 'package:ecolens/shared/components/valley_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The redesigned Guardian Valley panels.
///
/// The point of these is that "made it prettier" did not cost anything: every
/// route, value, action and workflow that existed before still exists, at every
/// supported viewport, with bigger text on, and with hostile data (very long
/// names, very large numbers) in it.
void main() {
  /// Every viewport the brief requires the kiosk to survive.
  const viewports = <Size>[
    Size(1024, 600),
    Size(1180, 820),
    Size(1280, 720),
    Size(1280, 800),
    Size(1366, 768),
    Size(1440, 900),
    Size(1920, 1080),
  ];

  Future<ProviderContainer> pumpKiosk(
    WidgetTester tester,
    Size size, {
    bool withStudent = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.light(), home: const KioskScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));

    if (withStudent) {
      await tester.runAsync(
        () => container
            .read(kioskControllerProvider.notifier)
            .readCard(MockSeedData.liamCardUid),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
    }
    return container;
  }

  Future<void> pumpPanel(
    WidgetTester tester,
    Widget panel, {
    Size size = const Size(1440, 900),
    // Long enough for the count-ups and entrances to land. Shorten it to catch a
    // one-shot mid-flight.
    Duration settle = const Duration(milliseconds: 1200),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: GameStage(
            builder: (context, s) => Padding(
              padding: EdgeInsets.all(18 * s),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 26, child: panel),
                  const Spacer(flex: 74),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(settle);
  }

  // ---------------------------------------------------------------------------
  // 4. The experience selector keeps every route
  // ---------------------------------------------------------------------------

  group('4. the destination cards preserve every route', () {
    const destinations = <String, String>{
      'Recycling Kiosk': 'Enter Kiosk',
      'Teacher Dashboard': 'View Class Quest',
      'Admin Dashboard': 'Manage Valley',
      'Canteen Terminal': 'Open Reward Shop',
    };

    testWidgets('all four destinations are offered, with game-style actions', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LandingScreen())),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(ValleyDestinationCard), findsNWidgets(4));
      destinations.forEach((title, action) {
        // The name adults need, and the action a child understands.
        expect(find.text(title), findsOneWidget, reason: 'missing $title');
        expect(find.text(action), findsOneWidget, reason: 'missing "$action"');
      });

      // The friendlier invitation, with the privacy rule still clearly stated.
      expect(find.text('Where are we exploring today?'), findsOneWidget);
      expect(
        find.textContaining('school ID card'),
        findsOneWidget,
        reason: 'the physical-card rule must stay visible',
      );
      expect(find.text('No phone needed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping a destination navigates to its real route', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(LandingScreen), findsOneWidget);

      // Travel to the kiosk through the redesigned card.
      await tester.tap(find.text('Enter Kiosk'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump(const Duration(milliseconds: 900));

      expect(
        find.byType(KioskScreen),
        findsOneWidget,
        reason: 'the destination card must still reach /kiosk',
      );
      expect(tester.takeException(), isNull);

      container.read(kioskControllerProvider.notifier).endSession();
      await tester.pump();
    });

    testWidgets('the staff destinations still reach their login guards', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.light(),
            routerConfig: container.read(routerProvider),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      await tester.tap(find.text('View Class Quest'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Unauthenticated staff land on a login, exactly as before the redesign.
      expect(find.byType(LandingScreen), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // 5/6. Privacy, and the full profile after recognition
  // ---------------------------------------------------------------------------

  testWidgets('5. the panels are anonymous before a card is read', (
    tester,
  ) async {
    await pumpKiosk(tester, const Size(1440, 900));

    // Nothing personal, and no profile panel at all.
    expect(find.byType(StudentValleyPanel), findsNothing);
    expect(find.textContaining('Liam'), findsNothing);
    expect(find.textContaining('Grade'), findsNothing);
    // The school-wide board is still there — that is not personal data.
    expect(find.byType(ValleyImpactPanel), findsOneWidget);
  });

  testWidgets('6. every statistic survives the redesign', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1080), withStudent: true);

    // Identity: first name + class banner, never the ID number.
    expect(find.text('Liam'), findsWidgets);
    expect(find.text('Grade 4 · Class 4B'), findsOneWidget);
    expect(find.textContaining('STU-2026'), findsNothing);

    for (final label in [
      'COINS',
      'LEVEL',
      'STREAK',
      'BEST',
      'GREAT SORTS',
      'LEARNING',
      'XP',
      'ECO SCORE',
    ]) {
      expect(find.text(label), findsWidgets, reason: 'missing $label');
    }
    expect(find.text("TODAY'S RECYCLING"), findsOneWidget);

    // The impact board keeps all three headline numbers plus the quest.
    expect(find.text('Items recycled'), findsOneWidget);
    expect(find.text('CO₂ saved'), findsOneWidget);
    expect(find.text('Recycled right'), findsOneWidget);
    expect(find.text('SCHOOL QUEST'), findsOneWidget);
    expect(find.text('HOUSE LEADERBOARD'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 7. Kinder wording
  // ---------------------------------------------------------------------------

  testWidgets('7. nothing in the student experience says "Oops"', (
    tester,
  ) async {
    await pumpKiosk(tester, const Size(1440, 900), withStudent: true);

    expect(find.text('OOPS'), findsNothing);
    expect(find.textContaining('Oops'), findsNothing);
    expect(find.textContaining('oops'), findsNothing);
    expect(find.textContaining('Wrong'), findsNothing);
    expect(find.textContaining('Failed'), findsNothing);
    expect(find.textContaining('Error'), findsNothing);
    // Replaced by something a child can be proud of.
    expect(find.text('LEARNING'), findsWidgets);

    expect(ProfileCopy.learning, 'Learning');
    expect(ProfileCopy.correct, 'Great sorts');
    expect(ProfileCopy.score, 'Eco score');
  });

  // ---------------------------------------------------------------------------
  // 8/9. Impact values and the quest
  // ---------------------------------------------------------------------------

  testWidgets('8/9. the impact board reports the real values', (tester) async {
    await pumpPanel(
      tester,
      const ValleyImpactPanel(
        itemsRecycled: 312,
        co2SavedKg: 48,
        recycledRightPercent: 86,
        goalProgress: 0.62,
        goalCaption: '312 of 500 items',
        rankings: [
          ValleyRanking(name: 'Taurus House', points: 4850),
          ValleyRanking(name: 'Leo House', points: 4310),
          ValleyRanking(name: 'Aquarius House', points: 3980),
        ],
      ),
    );

    expect(find.text('312'), findsOneWidget);
    expect(find.text('48 kg'), findsOneWidget);
    expect(find.text('86%'), findsOneWidget);
    expect(find.text('312 of 500 items'), findsOneWidget);
    expect(find.byType(ValleyQuestTrail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('10. the standings keep their order and their points', (
    tester,
  ) async {
    await pumpPanel(
      tester,
      const ValleyImpactPanel(
        rankings: [
          ValleyRanking(name: 'Taurus House', points: 4850),
          ValleyRanking(name: 'Leo House', points: 4310),
          ValleyRanking(name: 'Class 4B', points: 360, isMine: true),
        ],
      ),
    );

    expect(find.byType(ValleyRankRow), findsNWidgets(3));
    for (final entry in ['Taurus House', 'Leo House', 'Class 4B']) {
      expect(find.text(entry), findsOneWidget);
    }
    for (final points in ['4850', '4310', '360']) {
      expect(find.text(points), findsOneWidget);
    }
    // Rank numbers are always drawn, so the podium never depends on colour.
    for (final rank in ['1', '2', '3']) {
      expect(find.text(rank), findsWidgets);
    }
    // The student's own team is called out in words, not just a tint.
    expect(find.text('YOU'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // ---------------------------------------------------------------------------
  // 11. Portals keep their actions
  // ---------------------------------------------------------------------------

  testWidgets('11. every portal still fires its category action', (
    tester,
  ) async {
    final tapped = <WasteCategory>[];
    await pumpPanel(
      tester,
      WorldPortalRow(onTap: tapped.add, caption: 'PICK A PORTAL'),
      size: const Size(1920, 1080),
    );

    expect(find.byType(WorldPortalButton), findsNWidgets(4));
    for (final category in WasteCategory.values) {
      await tester.tap(find.text(category.label));
      await tester.pump();
    }

    expect(tapped, WasteCategory.values);
  });

  testWidgets('26/27. portal feedback is drawn, not just tinted', (
    tester,
  ) async {
    // Correct: a check badge, and a reward that rises out of the portal.
    // Sampled mid-flight, which is when a child actually sees it.
    await pumpPanel(
      tester,
      const WorldPortalRow(
        states: {WasteCategory.plastic: PortalState.correct},
        rewardLabel: '+10 XP',
      ),
      size: const Size(1920, 1080),
      settle: const Duration(milliseconds: 250),
    );

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('+10 XP'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // …and it clears itself rather than sitting on the portal forever.
    await tester.pump(const Duration(milliseconds: 1400));
    expect(find.text('+10 XP'), findsNothing);
    expect(
      find.byIcon(Icons.check_rounded),
      findsOneWidget,
      reason: 'the check badge is the lasting signal',
    );
  });

  testWidgets('27b. an incorrect portal is a hint, never an alarm', (
    tester,
  ) async {
    await pumpPanel(
      tester,
      const WorldPortalRow(
        states: {WasteCategory.paper: PortalState.incorrect},
      ),
      size: const Size(1920, 1080),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // A lightbulb, not a cross. Nothing here is red.
    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.cancel), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.byIcon(Icons.error), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(milliseconds: 800));
  });

  testWidgets('a locked portal is marked and refuses taps', (tester) async {
    var taps = 0;
    await pumpPanel(
      tester,
      WorldPortalRow(
        onTap: (_) => taps++,
        states: const {WasteCategory.general: PortalState.locked},
      ),
      size: const Size(1920, 1080),
    );

    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    await tester.tap(find.text('General Waste'));
    await tester.pump();
    expect(taps, 0, reason: 'a locked portal must not submit');

    // The others still work.
    await tester.tap(find.text('Plastic'));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('General Waste is stone, never red', (tester) async {
    await pumpPanel(
      tester,
      const WorldPortalRow(),
      size: const Size(1920, 1080),
    );

    // Red is reserved; the general portal reads as silver/stone.
    final colour = WasteCategory.general.colour;
    expect(colour.r, closeTo(colour.g, 0.12));
    expect(colour.g, closeTo(colour.b, 0.12));
  });

  // ---------------------------------------------------------------------------
  // 23/24/25. Layout under pressure
  // ---------------------------------------------------------------------------

  group('23. every redesigned panel renders overflow-free', () {
    for (final size in viewports) {
      testWidgets('attract at ${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
        expect(find.byType(ValleyImpactPanel), findsOneWidget);
        expect(find.byType(WorldPortalButton), findsNWidgets(4));
      });

      testWidgets('student at ${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size, withStudent: true);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
        expect(find.byType(StudentValleyPanel), findsOneWidget);
        expect(find.byType(ValleyImpactPanel), findsOneWidget);
      });

      testWidgets('selector at ${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LandingScreen())),
        );
        await tester.pump(const Duration(milliseconds: 400));

        expect(tester.takeException(), isNull, reason: 'overflow at $size');
        expect(find.byType(ValleyDestinationCard), findsNWidgets(4));
      });
    }
  });

  group('24. bigger text stays overflow-free', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        final container = await pumpKiosk(tester, size, withStudent: true);
        container.read(kioskPreferencesProvider.notifier).toggleLargeText();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 900));

        expect(
          tester.takeException(),
          isNull,
          reason: 'bigger text overflowed at $size',
        );
        expect(find.text('LEARNING'), findsWidgets);
      });
    }
  });

  testWidgets('25. a very long name and huge numbers stay contained', (
    tester,
  ) async {
    // Hostile data: a long hyphenated name, and values far beyond a school year.
    const student = Student(
      id: 'stu-long',
      studentNumber: 'STU-2026-99999',
      firstName: 'Bartholomew-Alexander',
      lastName: 'Von Hindenburg-Fitzgerald',
      grade: 12,
      className: '12-Delta-Upper',
      houseId: 'house-taurus',
      avatarId: 'avatar-long',
      totalXp: 987654,
      availablePoints: 456789,
      currentStreak: 365,
      longestStreak: 999,
      correctRecyclingCount: 123456,
      incorrectRecyclingCount: 9876,
      dailyEarnedPoints: 48,
    );

    for (final size in [const Size(1024, 600), const Size(1920, 1080)]) {
      await pumpPanel(
        tester,
        const StudentValleyPanel(
          student: student,
          config: GamificationConfig(),
          house: House(
            id: 'house-taurus',
            name: 'Taurus',
            colour: '#2E7D46',
            emblem: '🌱',
            sustainabilityGoal: 'Recycle 500 items this term',
            totalPoints: 4850,
            leaderboardPosition: 2,
          ),
        ),
        size: size,
      );

      expect(
        tester.takeException(),
        isNull,
        reason: 'long name / large numbers overflowed at $size',
      );
      expect(find.textContaining('Bartholomew'), findsOneWidget);
    }
  });

  testWidgets('25b. a very long school name does not break the HUD', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1024, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: GameStage(
              builder: (context, s) => const Column(
                children: [
                  ValleyHud(
                    schoolName:
                        'St. Bartholomew-on-the-Hill Church of England '
                        'Primary and Nursery Academy Trust',
                    guardianName: 'Sprout the Extremely Long Named Guardian',
                    level: 999,
                    xpProgress: 0.5,
                    xpLabel: '987654/999999',
                    coins: 456789,
                    streak: 365,
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });

  // ---------------------------------------------------------------------------
  // 28/29. Session reset and the other surfaces
  // ---------------------------------------------------------------------------

  testWidgets('28. ending a session clears the previous student entirely', (
    tester,
  ) async {
    final container = await pumpKiosk(
      tester,
      const Size(1440, 900),
      withStudent: true,
    );
    expect(find.byType(StudentValleyPanel), findsOneWidget);
    expect(find.text('Liam'), findsWidgets);

    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(container.read(kioskControllerProvider).state, KioskState.idle);
    expect(find.byType(StudentValleyPanel), findsNothing);
    expect(find.textContaining('Liam'), findsNothing);
    expect(find.textContaining('Grade 4'), findsNothing);
    // The personal contribution line goes with it.
    expect(find.textContaining("You've sorted"), findsNothing);
  });

  // ---------------------------------------------------------------------------
  // Design-system integrity
  // ---------------------------------------------------------------------------

  test('the kit has one source of truth for its geometry', () {
    // Guards against a panel quietly reintroducing its own radius or shadow.
    expect(ValleyTokens.radiusPanel, greaterThan(ValleyTokens.radiusTile));
    expect(ValleyTokens.radiusTile, greaterThan(ValleyTokens.radiusInner));
    expect(ValleyTokens.panelShadow(1), hasLength(2));
    expect(
      ValleyTokens.headerHeightCompact,
      lessThan(ValleyTokens.headerHeight),
    );
  });

  test('every panel theme lands on a warm surface, not white', () {
    for (final theme in ValleyTheme.values) {
      final c = theme.colours;
      expect(
        c.surfaceTop,
        isNot(const Color(0xFFFFFFFF)),
        reason: '${theme.name} is pure white — the look we moved away from',
      );
      // The body has a real gradient rather than a flat fill.
      expect(c.surfaceBottom, isNot(c.surfaceTop), reason: theme.name);
      // And a distinct band colour to head the panel with.
      expect(c.accentDeep, isNot(c.accent), reason: theme.name);
    }
  });

  test('a derived palette still lands in the family', () {
    final derived = ValleyThemeColours.fromAccent(const Color(0xFFB5322E));
    expect(derived.surfaceTop, isNot(const Color(0xFFFFFFFF)));
    expect(derived.surfaceBottom, isNot(derived.surfaceTop));
    expect(derived.accentDeep, isNot(derived.accent));
  });
}
