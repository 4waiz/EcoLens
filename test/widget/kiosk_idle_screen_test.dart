import 'package:ecolens/features/kiosk/presentation/screens/kiosk_idle_screen.dart';
import 'package:ecolens/features/kiosk/presentation/widgets/student_card_illustration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump_app.dart';

/// Widget test — SCREEN 1 (Idle / attract).
/// Verifies the physical-card prompt and the absence of any phone workflow.
void main() {
  testWidgets('idle screen invites tapping a physical Student ID card',
      (tester) async {
    await pumpEcoWidget(tester, const KioskIdleScreen());
    await tester.pump();

    expect(find.text('Tap your Student ID card to begin'), findsOneWidget);
    expect(find.byType(StudentCardIllustration), findsOneWidget);
    expect(find.textContaining('Welcome to EcoLens'), findsOneWidget);
  });

  testWidgets('idle screen shows all four waste categories', (tester) async {
    await pumpEcoWidget(tester, const KioskIdleScreen());
    await tester.pump();

    expect(find.text('Plastic'), findsWidgets);
    expect(find.text('Paper'), findsWidgets);
    expect(find.text('Organic'), findsWidgets);
    expect(find.text('General Waste'), findsWidgets);
  });

  testWidgets('idle screen shows no phone imagery (physical card only)',
      (tester) async {
    await pumpEcoWidget(tester, const KioskIdleScreen());
    await tester.pump();

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
