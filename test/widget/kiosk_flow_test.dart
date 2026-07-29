import 'package:ecolens/app/providers.dart';
import 'package:ecolens/data/datasources/mock_ai_classification_service.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/features/kiosk/application/kiosk_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// End-to-end kiosk flow tests using the real controller + mock services.
/// These drive the controller programmatically (real async) and assert the
/// state machine + gamification outcomes — covering the core acceptance path.
void main() {
  test(
    'Liam card → recognised → scan → correct answer → rewards → clear',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Force the AI to a known high-confidence plastic bottle.
      (container.read(aiClassificationProvider) as MockAiClassificationService)
          .setForcedItem('bottle'); // plastic, 0.95

      final controller = container.read(kioskControllerProvider.notifier);

      // 1. Read Liam's physical card.
      await controller.readCard(MockSeedData.liamCardUid);
      expect(
        container.read(kioskControllerProvider).state,
        KioskState.studentRecognised,
      );
      expect(
        container.read(kioskControllerProvider).student?.firstName,
        'Liam',
      );
      final startingXp = container
          .read(kioskControllerProvider)
          .student!
          .totalXp;

      // 2. Scan + classify.
      controller.goToScan();
      await controller.scanItem();
      expect(
        container.read(kioskControllerProvider).state,
        KioskState.waitingForStudentAnswer,
      );
      expect(
        container
            .read(kioskControllerProvider)
            .classification
            ?.predictedCategory,
        WasteCategory.plastic,
      );

      // 3. Answer correctly.
      await controller.submitAnswer(WasteCategory.plastic);
      final afterAnswer = container.read(kioskControllerProvider);
      expect(afterAnswer.state, KioskState.correctFeedback);
      expect(afterAnswer.lastOutcome?.wasCorrect, isTrue);
      expect(afterAnswer.lastOutcome!.pointsAwarded, greaterThan(0));
      expect(afterAnswer.student!.totalXp, greaterThan(startingXp));

      // 4. Open slot → reward summary.
      await controller.openSlotAndContinue();
      expect(
        container.read(kioskControllerProvider).state,
        KioskState.rewardSummary,
      );

      // 5. End session clears student data (privacy).
      controller.endSession();
      final cleared = container.read(kioskControllerProvider);
      expect(cleared.student, isNull);
      expect(cleared.state, KioskState.idle);
    },
  );

  test(
    'an incorrect answer awards no points and never goes negative',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      (container.read(aiClassificationProvider) as MockAiClassificationService)
          .setForcedItem('newspaper'); // paper, high confidence

      final controller = container.read(kioskControllerProvider.notifier);
      await controller.readCard(MockSeedData.liamCardUid);
      final pointsBefore = container
          .read(kioskControllerProvider)
          .student!
          .availablePoints;

      controller.goToScan();
      await controller.scanItem();

      // Answer WRONG (organic for a newspaper).
      await controller.submitAnswer(WasteCategory.organic);

      final state = container.read(kioskControllerProvider);
      expect(state.state, KioskState.incorrectFeedback);
      expect(state.lastOutcome?.wasCorrect, isFalse);
      expect(state.lastOutcome?.pointsAwarded, 0);
      // Points never decreased.
      expect(
        state.student!.availablePoints,
        greaterThanOrEqualTo(pointsBefore),
      );

      controller.endSession();
    },
  );

  test('a low-confidence item routes to General Waste', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    (container.read(aiClassificationProvider) as MockAiClassificationService)
      ..setForcedItem('yoghurt') // plastic but low base confidence
      ..setForcedConfidence(0.60); // below the 0.80 threshold

    final controller = container.read(kioskControllerProvider.notifier);
    await controller.readCard(MockSeedData.liamCardUid);
    controller.goToScan();
    await controller.scanItem();

    // The routed (correct) category is General Waste despite a plastic
    // prediction, because confidence is below threshold.
    expect(
      container.read(kioskControllerProvider).routedCategory,
      WasteCategory.general,
    );

    // Choosing General Waste is treated as correct.
    await controller.submitAnswer(WasteCategory.general);
    final state = container.read(kioskControllerProvider);
    expect(state.state, KioskState.lowConfidenceFeedback);
    expect(state.lastOutcome?.wasCorrect, isTrue);

    controller.endSession();
  });
}
