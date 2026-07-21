import 'package:ecolens/features/canteen_terminal/application/canteen_controller.dart';
import 'package:ecolens/features/canteen_terminal/presentation/canteen_screens.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget test — canteen card scan. Verifies the physical-card scan resolves a
/// student into the canteen controller (no phone/QR anywhere).
void main() {
  testWidgets('canteen scan screen renders the physical-card prompt',
      (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CanteenScanCardScreen()),
      ),
    );
    await tester.pump();

    // No phone/QR SCANNER widgets (reassuring copy may mention QR, that's fine).
    expect(find.byIcon(Icons.qr_code_scanner), findsNothing);
    expect(find.byIcon(Icons.smartphone), findsNothing);
    expect(find.byIcon(Icons.phone_android), findsNothing);
  });

  // These drive the controller's async work directly, so they use plain
  // `test()` (real async completes without a pumped widget/event loop).
  test("scanning Liam's card loads his profile into the controller", () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(canteenControllerProvider.notifier);
    final ok = await controller.scanCard(MockSeedData.liamCardUid);

    expect(ok, isTrue);
    final state = container.read(canteenControllerProvider);
    expect(state.student?.firstName, 'Liam');
    expect(state.house, isNotNull);
    expect(state.error, isNull);
  });

  test('scanning an unknown card sets an error, no student', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final controller = container.read(canteenControllerProvider.notifier);
    final ok = await controller.scanCard('DEADBEEF00');

    expect(ok, isFalse);
    final state = container.read(canteenControllerProvider);
    expect(state.student, isNull);
    expect(state.error, isNotNull);
  });
}
