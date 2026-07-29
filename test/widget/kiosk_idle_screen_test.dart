import 'package:ecolens/features/kiosk/presentation/screens/kiosk_idle_screen.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/student_mission_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Widget test — SCREEN 1 (Idle / attract).
/// Verifies the physical-card prompt and the absence of any phone workflow.
void main() {
  /// The idle screen watches the kiosk controller, whose start-up config and
  /// queue reads have simulated latency — drain them so no timer is pending at
  /// teardown.
  Future<void> pumpIdle(WidgetTester tester) async {
    await pumpEcoWidget(tester, const KioskIdleScreen());
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 900));
  }

  testWidgets('idle screen invites tapping a physical Student ID card', (
    tester,
  ) async {
    await pumpIdle(tester);

    expect(find.text('Tap your Student ID card to begin'), findsOneWidget);
    expect(find.byType(PlayfulStudentCard), findsOneWidget);
    expect(find.byType(AnimatedCardReader), findsOneWidget);
    // The Guardian's greeting now lives in the world layer (KioskChrome), so it
    // is asserted against the full kiosk in guardian_valley_test. What must be
    // on this screen is the mission panel's own invitation.
    expect(find.text(MissionCopy.title), findsOneWidget);
    expect(find.text(MissionCopy.cta), findsOneWidget);
  });

  testWidgets('idle screen shows all four waste categories', (tester) async {
    await pumpIdle(tester);

    expect(find.text('Plastic'), findsWidgets);
    expect(find.text('Paper'), findsWidgets);
    expect(find.text('Organic'), findsWidgets);
    expect(find.text('General Waste'), findsWidgets);
  });

  testWidgets('idle screen shows no phone imagery (physical card only)', (
    tester,
  ) async {
    await pumpIdle(tester);

    // Hard product rule: no phone imagery anywhere in the student experience.
    expect(find.byIcon(Icons.smartphone), findsNothing);
    expect(find.byIcon(Icons.phone_android), findsNothing);
    expect(find.byIcon(Icons.phone_iphone), findsNothing);
    expect(find.byIcon(Icons.qr_code), findsNothing);
    expect(find.byIcon(Icons.qr_code_scanner), findsNothing);
    // The card-contactless imagery IS present (physical ID card + NFC).
    expect(find.byIcon(Icons.contactless_outlined), findsWidgets);
  });
}
