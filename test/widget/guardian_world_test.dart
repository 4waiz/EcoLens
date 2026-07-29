import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/application/kiosk_preferences.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/shared/components/guardian_valley.dart';
import 'package:ecolens/shared/world/guardian_emotion.dart';
import 'package:ecolens/shared/world/guardian_mascot.dart';
import 'package:ecolens/shared/world/guardian_valley_scene.dart';
import 'package:ecolens/shared/world/guardian_world.dart';
import 'package:ecolens/shared/world/guardian_world_stage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget tests for the generated Guardian Valley world and the Guardian's
/// on-screen behaviour: render modes, asset failure, accessibility and the
/// layout stability of an expression change.
void main() {
  /// Every viewport the kiosk is expected to run at.
  const surfaces = <Size>[
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
    List<Override> overrides = const [],
    bool withStudent = false,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(overrides: overrides);
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
      await tester.pump(const Duration(milliseconds: 600));
    }
    return container;
  }

  // ---------------------------------------------------------------------------
  // 16–18. Render modes and asset failure
  // ---------------------------------------------------------------------------

  testWidgets('16. generated-art mode renders the layered world', (
    tester,
  ) async {
    await pumpKiosk(tester, const Size(1440, 900));

    expect(find.byType(GuardianValleyGeneratedWorld), findsOneWidget);
    expect(find.byType(GuardianWorldStage), findsOneWidget);
    expect(find.byType(GuardianMascot), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('17. painted fallback mode renders the procedural world', (
    tester,
  ) async {
    await pumpKiosk(
      tester,
      const Size(1440, 900),
      overrides: [
        worldRenderPreferenceProvider.overrideWith(
          (ref) => GuardianWorldRenderMode.paintedFallback,
        ),
      ],
    );

    expect(find.byType(GuardianValley), findsOneWidget);
    expect(find.byType(GuardianValleyGeneratedWorld), findsNothing);
    // The Guardian is still staged, on its own drawn dais.
    expect(find.byType(GuardianMascot), findsOneWidget);
    expect(find.byType(GuardianDais), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('18. a failed background asset degrades to the painted world', (
    tester,
  ) async {
    await pumpKiosk(
      tester,
      const Size(1440, 900),
      overrides: [worldArtFailedProvider.overrideWith((ref) => true)],
    );

    expect(find.byType(GuardianValley), findsOneWidget);
    expect(find.byType(GuardianValleyGeneratedWorld), findsNothing);
    // No technical error is ever put in front of a student.
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.textContaining('failed'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('resolveWorldRenderMode prefers safety over preference', () {
    // A failed asset wins over everything.
    expect(
      resolveWorldRenderMode(
        preference: GuardianWorldRenderMode.generatedArt,
        reduceMotion: false,
        artFailed: true,
      ),
      GuardianWorldRenderMode.paintedFallback,
    );
    // Calm mode keeps the art but freezes it.
    expect(
      resolveWorldRenderMode(
        preference: GuardianWorldRenderMode.generatedArt,
        reduceMotion: true,
        artFailed: false,
      ),
      GuardianWorldRenderMode.reducedMotion,
    );
    // An explicitly pinned painted build is honoured.
    expect(
      resolveWorldRenderMode(
        preference: GuardianWorldRenderMode.paintedFallback,
        reduceMotion: false,
        artFailed: false,
      ),
      GuardianWorldRenderMode.paintedFallback,
    );
  });

  // ---------------------------------------------------------------------------
  // 14–15. Reduced motion
  // ---------------------------------------------------------------------------

  testWidgets('14/15. calm mode stops the Guardian and freezes the world', (
    tester,
  ) async {
    final container = await pumpKiosk(tester, const Size(1440, 900));

    expect(
      tester.widget<GuardianMascot>(find.byType(GuardianMascot)).animate,
      isTrue,
    );
    expect(
      tester
          .widget<GuardianValleyGeneratedWorld>(
            find.byType(GuardianValleyGeneratedWorld),
          )
          .animate,
      isTrue,
    );

    container.read(kioskPreferencesProvider.notifier).toggleReduceMotion();
    await tester.pump();

    expect(
      tester.widget<GuardianMascot>(find.byType(GuardianMascot)).animate,
      isFalse,
      reason: 'continuous Guardian motion must stop',
    );
    expect(
      tester
          .widget<GuardianValleyGeneratedWorld>(
            find.byType(GuardianValleyGeneratedWorld),
          )
          .animate,
      isFalse,
      reason: 'background parallax and drift must freeze',
    );
  });

  // ---------------------------------------------------------------------------
  // 19. Layout stability across an expression change
  // ---------------------------------------------------------------------------

  testWidgets('19. changing expression never resizes the Guardian', (
    tester,
  ) async {
    Widget host(GuardianEmotion emotion, int sequence) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: GuardianMascot(
            height: 320,
            emotion: emotion,
            sequence: sequence,
          ),
        ),
      ),
    );

    await tester.pumpWidget(host(GuardianEmotion.idle, 0));
    await tester.pump(const Duration(milliseconds: 100));
    final before = tester.getSize(find.byType(GuardianMascot));

    for (final emotion in GuardianEmotion.values) {
      await tester.pumpWidget(host(emotion, emotion.index + 1));
      // Sample part-way through the cross-fade, when both frames are alive.
      await tester.pump(const Duration(milliseconds: 120));
      expect(
        tester.getSize(find.byType(GuardianMascot)),
        before,
        reason: '${emotion.name} changed the occupied space',
      );
      await tester.pump(const Duration(milliseconds: 900));
    }
  });

  testWidgets('a missing frame falls back without an endless rebuild', (
    tester,
  ) async {
    // No asset bundle entry resolves in this harness for a bogus emotion, so
    // this exercises the same errorBuilder path a stripped build would hit.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GuardianMascot(
            height: 200,
            emotion: GuardianEmotion.celebrate,
            sequence: 1,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
    expect(find.byType(GuardianMascot), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  // 20–21. Overflow across every supported viewport
  // ---------------------------------------------------------------------------

  group('20. the world is overflow-free on every supported viewport', () {
    for (final size in surfaces) {
      testWidgets('attract at ${size.width}x${size.height}', (tester) async {
        await pumpKiosk(tester, size);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
      });

      testWidgets('student at ${size.width}x${size.height}', (tester) async {
        await pumpKiosk(tester, size, withStudent: true);
        expect(tester.takeException(), isNull, reason: 'overflow at $size');
      });
    }
  });

  group('21. bigger text is overflow-free on every supported viewport', () {
    for (final size in surfaces) {
      testWidgets('${size.width}x${size.height}', (tester) async {
        final container = await pumpKiosk(tester, size);
        container.read(kioskPreferencesProvider.notifier).toggleLargeText();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(
          tester.takeException(),
          isNull,
          reason: 'bigger text overflowed at $size',
        );
      });
    }
  });

  // ---------------------------------------------------------------------------
  // 23. Input guarding
  // ---------------------------------------------------------------------------

  test('23. rapid portal taps do not submit twice', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(kioskControllerProvider.notifier);

    await controller.readCard(MockSeedData.liamCardUid);
    controller.goToScan();
    await controller.scanItem();

    final before = container.read(kioskControllerProvider).student!.totalXp;

    // Three taps in the same instant, as an excited child would produce.
    final submissions = Future.wait([
      controller.submitAnswer(WasteCategory.plastic),
      controller.submitAnswer(WasteCategory.plastic),
      controller.submitAnswer(WasteCategory.plastic),
    ]);
    await submissions;

    final after = container.read(kioskControllerProvider);
    expect(after.itemsThisSession, 1, reason: 'one tap, one scored item');
    expect(
      after.student!.totalXp - before,
      after.lastOutcome!.xpAwarded,
      reason: 'XP must be awarded exactly once',
    );
    controller.endSession();
  });
}
