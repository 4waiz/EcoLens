import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:ecolens/features/kiosk/application/kiosk_preferences.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/valley_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// ---------------------------------------------------------------------------
/// Is the content actually LOOKABLE-AT?
///
/// "No overflow" is a much weaker promise than it appears. A `FittedBox` will
/// happily silence the overflow assertion by scaling a panel down until nothing
/// in it can be read; an entrance animation stuck at `opacity: 0` reserves its
/// space and paints nothing. Both leave `tester.takeException()` null, so a
/// suite that only checks for overflow reports green on a blank panel.
///
/// So these tests assert three things about every value a student needs, at
/// every supported viewport:
///
///   * it EXISTS in the tree;
///   * it is fully OPAQUE — no ancestor `Opacity` is mid-fade or stuck at zero;
///   * its rect sits INSIDE the viewport and has a real, legible height.
/// ---------------------------------------------------------------------------
void main() {
  const viewports = <Size>[
    Size(1024, 600),
    Size(1180, 820),
    Size(1280, 720),
    Size(1280, 800),
    Size(1366, 768),
    Size(1440, 900),
    Size(1920, 1080),
  ];

  /// The smallest a value may render and still be read across a corridor.
  const minLegibleHeight = 8.0;

  Future<ProviderContainer> pumpKiosk(
    WidgetTester tester,
    Size size, {
    bool withStudent = false,
    bool largeText = false,
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
    if (largeText) {
      container.read(kioskPreferencesProvider.notifier).toggleLargeText();
      await tester.pump();
    }
    // Long enough for every entrance, count-up and progress fill to settle.
    await tester.pump(const Duration(milliseconds: 1500));
    return container;
  }

  /// Asserts [label] is on screen, opaque, and a sensible size.
  ///
  /// [within] scopes the search to one panel. That matters because several
  /// labels ("XP") deliberately appear twice: once as the authoritative stat in
  /// a panel, and once as a compact HUD chip inside the HUD's own
  /// `FittedBox` — which is *designed* to shrink so a cramped HUD keeps every
  /// stat rather than dropping one. Only the panel copy carries the legibility
  /// promise, so only the panel copy is measured for it.
  void expectLookable(
    WidgetTester tester,
    String label,
    Size viewport, {
    Finder? within,
  }) {
    final finder = within == null
        ? find.text(label)
        : find.descendant(of: within, matching: find.text(label));
    expect(finder, findsWidgets, reason: '"$label" is not in the tree');

    final target = finder.first;

    // Nothing between this text and the root may still be faded out.
    final fades = tester.widgetList<Opacity>(
      find.ancestor(of: target, matching: find.byType(Opacity)),
    );
    for (final fade in fades) {
      expect(
        fade.opacity,
        1.0,
        reason:
            '"$label" is painted at opacity ${fade.opacity} — an entrance '
            'animation never finished, so the panel looks empty',
      );
    }

    final rect = tester.getRect(target);
    expect(
      rect.height,
      greaterThan(minLegibleHeight),
      reason: '"$label" rendered ${rect.height.toStringAsFixed(1)}px tall',
    );
    expect(
      rect.top,
      greaterThanOrEqualTo(-0.5),
      reason: '"$label" is above the top of the viewport',
    );
    expect(
      rect.bottom,
      lessThanOrEqualTo(viewport.height + 0.5),
      reason:
          '"$label" runs off the bottom '
          '(${rect.bottom.toStringAsFixed(1)} > ${viewport.height})',
    );
    expect(
      rect.left,
      greaterThanOrEqualTo(-0.5),
      reason: '"$label" is off the left edge',
    );
    expect(
      rect.right,
      lessThanOrEqualTo(viewport.width + 0.5),
      reason: '"$label" is off the right edge',
    );
  }

  // ---------------------------------------------------------------------------
  // The attract screen
  // ---------------------------------------------------------------------------

  group('the attract screen is fully lookable-at', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size);

        // Impact board: all three headline numbers, the quest and the standings.
        for (final label in [
          '312',
          '48 kg',
          '86%',
          'Items recycled',
          'CO₂ saved',
          'Recycled right',
          'SCHOOL QUEST',
          '312 of 500 items',
          'HOUSE LEADERBOARD',
          'Taurus House',
          '4850',
        ]) {
          expectLookable(
            tester,
            label,
            size,
            within: find.byType(ValleyImpactPanel),
          );
        }

        // Mission panel: the three steps and the primary action.
        for (final label in [
          'Start Your Eco Mission!',
          'Tap your card',
          'Show your item',
          'Choose its portal',
          'Tap your Student ID to begin',
        ]) {
          expectLookable(tester, label, size);
        }

        // The four portals.
        for (final label in ['Plastic', 'Paper', 'Organic', 'General Waste']) {
          expectLookable(tester, label, size);
        }

        expect(tester.takeException(), isNull);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // The recognised student
  // ---------------------------------------------------------------------------

  group('the recognised-student screen is fully lookable-at', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size, withStudent: true);

        for (final label in [
          'Liam',
          'Grade 4 · Class 4B',
          'LEVEL',
          'XP',
          'COINS',
          'STREAK',
          'GREAT SORTS',
          'LEARNING',
          'BEST',
          'ECO SCORE',
          "TODAY'S RECYCLING",
          'Taurus House',
        ]) {
          expectLookable(
            tester,
            label,
            size,
            within: find.byType(StudentValleyPanel),
          );
        }

        expect(tester.takeException(), isNull);
      });
    }
  });

  // ---------------------------------------------------------------------------
  // Bigger text — the setting most likely to push content out of view
  // ---------------------------------------------------------------------------

  group('bigger text keeps every statistic lookable-at', () {
    for (final size in viewports) {
      testWidgets('${size.width.toInt()}x${size.height.toInt()}', (
        tester,
      ) async {
        await pumpKiosk(tester, size, withStudent: true, largeText: true);

        for (final label in [
          'LEVEL',
          'XP',
          'COINS',
          'STREAK',
          'GREAT SORTS',
          'LEARNING',
          "TODAY'S RECYCLING",
        ]) {
          expectLookable(
            tester,
            label,
            size,
            within: find.byType(StudentValleyPanel),
          );
        }
        for (final label in ['312', 'SCHOOL QUEST']) {
          expectLookable(
            tester,
            label,
            size,
            within: find.byType(ValleyImpactPanel),
          );
        }

        expect(tester.takeException(), isNull);
      });
    }
  });
}
