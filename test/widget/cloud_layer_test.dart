import 'dart:io';
import 'dart:ui' as ui;

import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/features/kiosk/presentation/kiosk_screen.dart';
import 'package:ecolens/shared/world/guardian_valley_scene.dart';
import 'package:ecolens/shared/world/guardian_world_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// The cloud plate migrated from WebP to PNG because its picture lives in the
/// ALPHA channel (pure white at partial opacity), and WebP's lossy alpha put
/// visible blocking into the soft cloud edges. These tests keep the migration
/// from silently regressing — including someone "optimising" it back to WebP.
void main() {
  const cloudPng = 'assets/backgrounds/guardian_valley_clouds.png';
  const cloudWebp = 'guardian_valley_clouds.webp';

  // ---------------------------------------------------------------------------
  // 1. The PNG is the active cloud asset
  // ---------------------------------------------------------------------------

  test('1. the cloud layer points at the PNG', () {
    expect(GuardianWorldAssets.clouds.path, cloudPng);
    expect(
      GuardianWorldAssets.clouds.path,
      endsWith('.png'),
      reason: 'the cloud plate must not be transcoded back to WebP',
    );
  });

  test('1b. the PNG exists on disk and is bundled by the directory rule', () {
    expect(File(cloudPng).existsSync(), isTrue, reason: '$cloudPng is missing');

    // pubspec declares the whole backgrounds directory, so the file only has to
    // sit there. Assert the rule is still a directory rule.
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('assets/backgrounds/'));
  });

  test('1c. the clouds are still layer 2 of the parallax stack', () {
    // Painting order matters: base -> clouds -> water -> particles -> foreground.
    expect(GuardianWorldAssets.layers[0], GuardianWorldAssets.base);
    expect(GuardianWorldAssets.layers[1], GuardianWorldAssets.clouds);
    expect(GuardianWorldAssets.layers.length, 5);

    // The parallax and opacity that drive the cloud march are unchanged.
    expect(GuardianWorldAssets.clouds.parallax, 9);
    expect(GuardianWorldAssets.clouds.opacity, closeTo(0.92, 0.001));
  });

  // ---------------------------------------------------------------------------
  // 2. Nothing references the old WebP
  // ---------------------------------------------------------------------------

  test('2. no Dart source references the old cloud WebP', () {
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      if (entity.readAsStringSync().contains(cloudWebp)) {
        offenders.add(entity.path);
      }
    }
    expect(
      offenders,
      isEmpty,
      reason: 'these files still ask for the removed WebP: $offenders',
    );
  });

  test('2b. the old cloud WebP is no longer in the bundle', () {
    expect(
      File('assets/backgrounds/$cloudWebp').existsSync(),
      isFalse,
      reason: 'the superseded WebP should not ship alongside the PNG',
    );
  });

  // ---------------------------------------------------------------------------
  // 3. It decodes, at the size the stage maths assumes
  // ---------------------------------------------------------------------------

  test('3. the PNG decodes and matches the shared plate size', () async {
    final bytes = await File(cloudPng).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    addTearDown(() {
      image.dispose();
      codec.dispose();
    });

    // Every plate is normalised to this so the layers register exactly on top of
    // each other, and so GuardianWorldStage can place the Guardian's feet on the
    // painted dais.
    expect(
      Size(image.width.toDouble(), image.height.toDouble()),
      GuardianWorldAssets.plateSize,
      reason: 'a mis-sized cloud plate would stretch or expose a blank edge',
    );
  });

  test('3b. the PNG carries a real alpha channel', () async {
    final bytes = await File(cloudPng).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    addTearDown(() {
      image.dispose();
      codec.dispose();
    });

    expect(data, isNotNull);
    final pixels = data!.buffer.asUint8List();

    var transparent = 0;
    var opaque = 0;
    // Sample every 64th pixel: enough to characterise the plate cheaply.
    for (var i = 3; i < pixels.length; i += 4 * 64) {
      if (pixels[i] < 8) {
        transparent++;
      } else if (pixels[i] > 247) {
        opaque++;
      }
    }

    // The clouds sit in the top third of an otherwise clear plate, so most of it
    // must be genuinely transparent — if it were not, stacking it would paint a
    // grey sheet over the valley.
    expect(
      transparent,
      greaterThan(opaque),
      reason: 'the cloud plate should be mostly transparent',
    );
    expect(opaque, greaterThan(0), reason: 'the clouds themselves are solid');
  });

  test('3c. no transparency checkerboard survives in the cloud RGB', () async {
    // The trap this guards, in full: the clouds are pure white drawn at PARTIAL
    // opacity, so their picture lives in the alpha channel. An export that
    // clears only the background checker leaves the checker's grey baked into
    // the cloud *bodies* — and against a flat blue sky, on a plate that scrolls
    // for 92 seconds at a time, that reads as a grey grid across the sky.
    //
    // A correctly de-matted plate (`mode="white"` in tool/prepare_art_assets.py)
    // has pure-white RGB everywhere it is visible. Anything else is residue.
    final bytes = await File(cloudPng).readAsBytes();
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    addTearDown(() {
      image.dispose();
      codec.dispose();
    });

    final pixels = data!.buffer.asUint8List();
    var visible = 0;
    var notWhite = 0;
    var maxChroma = 0;

    for (var i = 0; i < pixels.length; i += 4) {
      final a = pixels[i + 3];
      if (a <= 16) continue; // not visible; its RGB is irrelevant
      visible++;
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final lowest = r < g ? (r < b ? r : b) : (g < b ? g : b);
      final highest = r > g ? (r > b ? r : b) : (g > b ? g : b);

      // rawRgba is PREMULTIPLIED, so a pure-white pixel arrives as
      // (a, a, a, a) rather than (255, 255, 255, a). Comparing the channels to
      // alpha is therefore the version-independent way to ask "is this white?",
      // and it still catches the grey checker: a 126-grey at alpha 200
      // premultiplies to ~99, nowhere near 200.
      if (a - lowest > 6) notWhite++;
      final chroma = highest - lowest;
      if (chroma > maxChroma) maxChroma = chroma;
    }

    expect(visible, greaterThan(0));
    expect(
      notWhite / visible,
      lessThan(0.01),
      reason:
          'residual matte: ${(notWhite / visible * 100).toStringAsFixed(1)}% of '
          'visible cloud pixels are not white. Re-run '
          'tool/rebuild_cloud_plate.py rather than hand-exporting the plate.',
    );
    expect(
      maxChroma,
      lessThanOrEqualTo(2),
      reason: 'white clouds must be neutral; a colour cast means a bad export',
    );
  });

  // ---------------------------------------------------------------------------
  // 4. The generated world still renders it
  // ---------------------------------------------------------------------------

  testWidgets('4. the generated cloud layer renders without an exception', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: KioskScreen())),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));

    // The generated world is on stage and nothing threw while compositing the
    // five plates (a failed plate would have demoted us to the painted world).
    expect(find.byType(GuardianValleyGeneratedWorld), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('4b. the world uses the app theme without a load error banner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: AppTheme.light(), home: const KioskScreen()),
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));

    // A student must never see an asset problem described to them.
    expect(find.textContaining('Unable to load'), findsNothing);
    expect(find.textContaining('.webp'), findsNothing);
    expect(find.textContaining('.png'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
