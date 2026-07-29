import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/features/landing/landing_screen.dart';
import 'package:ecolens/shared/components/game_ui.dart';
import 'package:ecolens/shared/components/guardian_valley.dart';
import 'package:ecolens/shared/world/guardian_mascot.dart';
import 'package:ecolens/shared/world/guardian_world.dart';
import 'package:ecolens/shared/world/guardian_world_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests for the Guardian Valley game shell.
///
/// The most important thing these assert is that NO layout overflows at any
/// realistic kiosk or dev-window size — the previous experience picker shipped
/// with a visible "BOTTOM OVERFLOWED BY 12 PIXELS" banner, and a kiosk that
/// children use must never show one.
void main() {
  /// Sizes that matter: the kiosk target, common 16:9 panels, and the smallest
  /// dev windows the demo is opened in.
  const surfaces = <Size>[
    Size(1920, 1200), // kiosk target (16:10)
    Size(1920, 1080),
    Size(1600, 900),
    Size(1440, 900),
    Size(1366, 768),
    Size(1280, 800),
    Size(1024, 768),
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
    // Long enough for the controller's start-up config/queue reads (mock
    // latency) to complete, so no timer is left pending at teardown.
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));

    if (withStudent) {
      // Real async — the mock card read has a simulated latency.
      await tester.runAsync(
        () => container
            .read(kioskControllerProvider.notifier)
            .readCard(MockSeedData.liamCardUid),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }
    return container;
  }

  // ---------------------------------------------------------------------------
  // Overflow regression
  // ---------------------------------------------------------------------------

  group('no layout overflows', () {
    for (final size in surfaces) {
      testWidgets('experience picker at ${size.width}x${size.height}', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const LandingScreen(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));

        expect(
          tester.takeException(),
          isNull,
          reason: 'LandingScreen overflowed at $size',
        );
      });

      testWidgets('kiosk attract screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        await pumpKiosk(tester, size);
        expect(
          tester.takeException(),
          isNull,
          reason: 'Kiosk idle screen overflowed at $size',
        );
      });

      testWidgets('kiosk student screen at ${size.width}x${size.height}', (
        tester,
      ) async {
        final container = await pumpKiosk(tester, size, withStudent: true);
        expect(
          container.read(kioskControllerProvider).state,
          KioskState.studentRecognised,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'Student recognised screen overflowed at $size',
        );
      });
    }
  });

  // ---------------------------------------------------------------------------
  // The world renders
  // ---------------------------------------------------------------------------

  testWidgets('the kiosk boots into the Guardian Valley world', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    // The scene picks the generated or painted world at runtime; either way the
    // atmosphere and the Guardian standing in world space must be on stage.
    expect(find.byType(GuardianValleyScene), findsOneWidget);
    expect(find.byType(ValleyAtmosphere), findsWidgets);
    expect(find.byType(GuardianWorldStage), findsOneWidget);
    expect(find.byType(GuardianMascot), findsOneWidget);
    // The HUD carries the school identity.
    expect(find.text('Oakwood Elementary'), findsOneWidget);
    expect(find.text('Guardian Valley'), findsOneWidget);
    // …and the Guardian greets the valley from the world layer.
    expect(find.textContaining('Welcome to EcoLens'), findsOneWidget);
  });

  testWidgets('the attract screen never leaks the previous student', (
    tester,
  ) async {
    final container = await pumpKiosk(
      tester,
      const Size(1920, 1200),
      withStudent: true,
    );
    expect(find.text('Liam'), findsWidgets);

    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Privacy rule: nothing personal survives on the shared kiosk.
    expect(find.text('Liam'), findsNothing);
    expect(find.textContaining('Grade 4'), findsNothing);
    expect(find.text('Tap your Student ID card to begin'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // Student panel content
  // ---------------------------------------------------------------------------

  testWidgets('the student panel shows the full game profile', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200), withStudent: true);

    // Identity — first name and class only, never the full ID number.
    expect(find.text('Liam'), findsWidgets);
    expect(find.text('Grade 4 · Class 4B'), findsOneWidget);
    expect(find.textContaining('STU-2026'), findsNothing);

    // Every stat the brief asks for.
    for (final label in [
      'COINS',
      'LEVEL',
      'STREAK',
      'BEST',
      'CORRECT',
      'OOPS',
      'XP',
      'SCORE',
    ]) {
      expect(find.text(label), findsWidgets, reason: 'missing $label tile');
    }
    expect(find.text("TODAY'S RECYCLING"), findsOneWidget);
    expect(find.text('Taurus House'), findsWidgets);
  });

  testWidgets('the impact panel reports school-wide results', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    expect(find.text('Items recycled'), findsOneWidget);
    expect(find.text('CO₂ saved'), findsOneWidget);
    expect(find.text('Recycled right'), findsOneWidget);
    expect(find.text('312'), findsOneWidget);
    expect(find.text('48 kg'), findsOneWidget);
    expect(find.text('86%'), findsOneWidget);
    expect(find.text('WEEKLY SCHOOL GOAL'), findsOneWidget);
  });

  testWidgets('the four waste categories are world portals', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    expect(find.text('Plastic'), findsWidgets);
    expect(find.text('Paper'), findsWidgets);
    expect(find.text('Organic'), findsWidgets);
    expect(find.text('General Waste'), findsWidgets);
    expect(find.byType(WorldPortalButton), findsNWidgets(4));
  });

  // ---------------------------------------------------------------------------
  // Accessibility controls
  // ---------------------------------------------------------------------------

  testWidgets('calm mode freezes the ambient world animation', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    // Asserted on the atmosphere rather than a specific world implementation:
    // both the generated and the painted valley drive it from the same flag.
    bool atmosphereAnimates() => tester
        .widget<ValleyAtmosphere>(find.byType(ValleyAtmosphere).first)
        .animate;

    expect(atmosphereAnimates(), isTrue);

    await tester.tap(find.bySemanticsLabel('Calm mode (less motion)'));
    await tester.pump();

    expect(atmosphereAnimates(), isFalse);
  });

  testWidgets('bigger text raises the game scale', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    double currentScale() =>
        tester.widgetList<GameScale>(find.byType(GameScale)).first.scale;

    final before = currentScale();
    await tester.tap(find.bySemanticsLabel('Bigger text'));
    await tester.pump();

    expect(currentScale(), greaterThan(before));
  });
}
