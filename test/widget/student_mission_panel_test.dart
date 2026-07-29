import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/student_mission_panel.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/valley_chrome.dart';
import 'package:ecolens/shared/components/game_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests for the redesigned "Start your eco mission" Student ID panel.
///
/// Two kinds of coverage:
///   * the panel driven directly through [StudentScanPhase], so every visual
///     state can be asserted without a controller;
///   * the panel inside the real kiosk, so the CTA is proven to be wired to the
///     actual card-read path rather than being a decorative button.
void main() {
  // ---------------------------------------------------------------------------
  // Harnesses
  // ---------------------------------------------------------------------------

  /// Pumps the panel on its own, in a box the size of the real left column at
  /// [surface], so metric selection behaves exactly as it does on the kiosk.
  Future<void> pumpPanel(
    WidgetTester tester, {
    StudentScanPhase phase = StudentScanPhase.idle,
    String? firstName,
    bool animate = true,
    VoidCallback? onTapCard,
    Size surface = const Size(1920, 1200),
  }) async {
    tester.view.physicalSize = surface;
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
                  Expanded(
                    flex: 26,
                    child: StudentMissionPanel(
                      phase: phase,
                      studentFirstName: firstName,
                      animate: animate,
                      onTapCard: onTapCard ?? () {},
                    ),
                  ),
                  const Spacer(flex: 74),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
  }

  /// Pumps the full kiosk so the panel is exercised against the real FSM.
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
      await tester.pump(const Duration(milliseconds: 500));
    }
    return container;
  }

  // ---------------------------------------------------------------------------
  // 1. Idle
  // ---------------------------------------------------------------------------

  testWidgets('1. the idle panel invites the student to start their mission', (
    tester,
  ) async {
    await pumpPanel(tester);

    expect(find.text(MissionCopy.title), findsOneWidget);
    expect(find.text(MissionCopy.subtitle), findsOneWidget);
    expect(find.text('Tap your card here'), findsOneWidget);
    expect(find.text(MissionCopy.cta), findsOneWidget);
    // The physical card and its reader are both on stage.
    expect(find.byType(PlayfulStudentCard), findsOneWidget);
    expect(find.byType(AnimatedCardReader), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 2. Privacy
  // ---------------------------------------------------------------------------

  testWidgets('2. the idle panel never shows a previous student', (
    tester,
  ) async {
    // Even when a stale name is passed in, a non-student phase must ignore it.
    await pumpPanel(tester, firstName: 'Liam');

    expect(find.textContaining('Liam'), findsNothing);
    expect(find.text('Welcome back!'), findsNothing);
    // The card art itself is always anonymous: fully masked, no digits.
    expect(find.text('•••• •••• ••••'), findsOneWidget);
    expect(find.textContaining('0417'), findsNothing);
  });

  testWidgets('2b. the card stays anonymous even after a successful scan', (
    tester,
  ) async {
    await pumpPanel(
      tester,
      phase: StudentScanPhase.studentFound,
      firstName: 'Liam',
    );

    // The greeting names the child; the card illustration still does not.
    expect(find.text('Welcome, Liam!'), findsOneWidget);
    expect(find.text('•••• •••• ••••'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 3–5. Scan states
  // ---------------------------------------------------------------------------

  testWidgets('3. the scanning state shows loading feedback', (tester) async {
    await pumpPanel(tester, phase: StudentScanPhase.scanning);

    expect(find.text('Reading your card…'), findsWidgets);
    expect(find.text('Keep it on the reader for a moment.'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('4. a successful scan shows the welcome state', (tester) async {
    await pumpPanel(
      tester,
      phase: StudentScanPhase.studentFound,
      firstName: 'Liam',
    );

    expect(find.text('Welcome, Liam!'), findsOneWidget);
    expect(find.text('Your mission is ready.'), findsOneWidget);
    expect(find.text(MissionCopy.ctaSuccess), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('5. an invalid card gets gentle retry guidance', (tester) async {
    await pumpPanel(tester, phase: StudentScanPhase.invalidCard);

    expect(find.text('I couldn’t read that card'), findsOneWidget);
    expect(find.text('Hold it closer and try again.'), findsOneWidget);
    expect(find.text(MissionCopy.ctaRetry), findsOneWidget);
    // Never a scolding: no error cross, no red "failed" language.
    expect(find.byIcon(Icons.close), findsNothing);
    expect(find.textContaining('Error'), findsNothing);
    expect(find.textContaining('Invalid'), findsNothing);
  });

  testWidgets('5b. an unavailable reader disables the CTA without alarm', (
    tester,
  ) async {
    await pumpPanel(tester, phase: StudentScanPhase.hardwareUnavailable);

    expect(find.text('The reader is resting'), findsOneWidget);
    expect(find.text('Please ask a teacher for help.'), findsOneWidget);
    expect(StudentScanPhase.hardwareUnavailable.acceptsTap, isFalse);
  });

  // ---------------------------------------------------------------------------
  // 6. The CTA drives the real scan path
  // ---------------------------------------------------------------------------

  testWidgets('6. the panel CTA triggers the real card-read action', (
    tester,
  ) async {
    var taps = 0;
    await pumpPanel(tester, onTapCard: () => taps++);

    await tester.tap(find.text(MissionCopy.cta));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('6b. tapping the CTA on the kiosk starts a real card read', (
    tester,
  ) async {
    final container = await pumpKiosk(tester, const Size(1920, 1200));
    expect(container.read(kioskControllerProvider).student, isNull);

    await tester.tap(find.text(MissionCopy.cta));
    await tester.pump();

    // The CTA reached the real state machine, not a decorative handler.
    expect(
      container.read(kioskControllerProvider).state,
      KioskState.readingCard,
    );

    // Let the mock auth + repository latency play out.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(
      container.read(kioskControllerProvider).state,
      KioskState.studentRecognised,
    );
    expect(container.read(kioskControllerProvider).student?.firstName, 'Liam');

    // Clear the session so the privacy inactivity timer does not outlive the
    // widget tree.
    container.read(kioskControllerProvider.notifier).endSession();
    await tester.pump();
  });

  // ---------------------------------------------------------------------------
  // 7. Reduced motion
  // ---------------------------------------------------------------------------

  testWidgets('7. calm mode stops the repeating reader animation', (
    tester,
  ) async {
    await pumpPanel(tester, animate: false);

    expect(
      tester
          .widget<AnimatedCardReader>(find.byType(AnimatedCardReader))
          .animate,
      isFalse,
    );
    // Nothing is ticking, but the reader target is still on screen.
    expect(tester.hasRunningAnimations, isFalse);
    expect(find.byType(AnimatedCardReader), findsOneWidget);
    expect(find.text('Tap your card here'), findsOneWidget);
  });

  testWidgets('7b. the reader keeps animating when motion is allowed', (
    tester,
  ) async {
    await pumpPanel(tester);

    expect(
      tester
          .widget<AnimatedCardReader>(find.byType(AnimatedCardReader))
          .animate,
      isTrue,
    );
    expect(tester.hasRunningAnimations, isTrue);
  });

  testWidgets('7c. calm mode on the kiosk reaches the panel', (tester) async {
    await pumpKiosk(tester, const Size(1920, 1200));

    await tester.tap(find.bySemanticsLabel('Calm mode (less motion)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      tester
          .widget<AnimatedCardReader>(find.byType(AnimatedCardReader))
          .animate,
      isFalse,
    );
  });

  // ---------------------------------------------------------------------------
  // 8–11. Layout
  // ---------------------------------------------------------------------------

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

  group('10. the panel is overflow-free on every supported viewport', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size);
        expect(
          tester.takeException(),
          isNull,
          reason: 'the mission panel overflowed at $size',
        );
        expect(find.byType(StudentMissionPanel), findsOneWidget);
        expect(find.text(MissionCopy.cta), findsOneWidget);
      });
    }
  });

  group('11. compact layouts keep all three mission steps', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpPanel(tester, surface: size);

        expect(find.byType(MissionStepTile), findsNWidgets(3));
        expect(find.text('Tap your card'), findsOneWidget);
        expect(find.text('Show your item'), findsOneWidget);
        expect(find.text('Choose its portal'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('8. bigger text does not overflow the panel', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size);

        await tester.tap(find.bySemanticsLabel('Bigger text'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(
          tester.takeException(),
          isNull,
          reason: 'bigger text overflowed the mission panel at $size',
        );
        expect(find.byType(MissionStepTile), findsNWidgets(3));
        expect(find.text(MissionCopy.cta), findsOneWidget);
      });
    }
  });

  testWidgets('9. a very long school name does not overflow the HUD', (
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
              builder: (context, s) => Column(
                children: [
                  const ValleyHud(
                    schoolName:
                        'St. Bartholomew-on-the-Hill Church of England '
                        'Primary and Nursery Academy Trust',
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 26,
                          child: StudentMissionPanel(onTapCard: () {}),
                        ),
                        const Spacer(flex: 74),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(tester.takeException(), isNull);
    expect(find.byType(MissionStepTile), findsNWidgets(3));
  });

  // ---------------------------------------------------------------------------
  // 12. Reset
  // ---------------------------------------------------------------------------

  testWidgets('12. ending a session returns the panel to anonymous idle', (
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
    await tester.pump(const Duration(milliseconds: 600));

    expect(container.read(kioskControllerProvider).state, KioskState.idle);
    expect(find.textContaining('Liam'), findsNothing);
    expect(find.byType(StudentMissionPanel), findsOneWidget);
    expect(find.text('Tap your card here'), findsOneWidget);
    expect(find.text(MissionCopy.cta), findsOneWidget);
    expect(find.text('•••• •••• ••••'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // Phase mapping + accessibility
  // ---------------------------------------------------------------------------

  testWidgets('the CTA meets the 48px minimum touch target', (tester) async {
    // The smallest supported surface is where a scaled button is most at risk.
    await pumpPanel(tester, surface: const Size(1024, 600));

    final box = tester.getRect(find.byType(StudentScanCTA));
    expect(box.height, greaterThanOrEqualTo(48.0));
  });

  testWidgets('the mission steps are labelled for screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpPanel(tester);

    expect(
      find.bySemanticsLabel('Step 1. Tap your card. Meet your Guardian'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Step 2. Show your item. Let EcoLens check it'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Step 3. Choose its portal. Earn XP and coins'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Tap your Student ID card on the reader to begin'),
      findsOneWidget,
    );
    handle.dispose();
  });
}
