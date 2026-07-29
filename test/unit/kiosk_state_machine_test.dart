import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the kiosk finite-state-machine transition rules. Guards against
/// invalid transitions ever being permitted.
void main() {
  group('valid transitions', () {
    test('the canonical happy path is fully permitted', () {
      const path = [
        KioskState.idle,
        KioskState.waitingForCard,
        KioskState.readingCard,
        KioskState.studentRecognised,
        KioskState.readyToScan,
        KioskState.capturingImage,
        KioskState.analysingImage,
        KioskState.classificationReady,
        KioskState.waitingForStudentAnswer,
        KioskState.processingAnswer,
        KioskState.correctFeedback,
        KioskState.openingSlot,
        KioskState.rewardSummary,
        KioskState.sessionComplete,
        KioskState.idle,
      ];
      for (var i = 0; i < path.length - 1; i++) {
        expect(
          path[i].canTransitionTo(path[i + 1]),
          isTrue,
          reason: '${path[i].name} → ${path[i + 1].name} should be allowed',
        );
      }
    });

    test('processingAnswer can reach all three feedback outcomes', () {
      expect(
        KioskState.processingAnswer.canTransitionTo(KioskState.correctFeedback),
        isTrue,
      );
      expect(
        KioskState.processingAnswer.canTransitionTo(
          KioskState.incorrectFeedback,
        ),
        isTrue,
      );
      expect(
        KioskState.processingAnswer.canTransitionTo(
          KioskState.lowConfidenceFeedback,
        ),
        isTrue,
      );
    });
  });

  group('invalid transitions are rejected', () {
    test('idle cannot jump straight to a reward summary', () {
      expect(
        KioskState.idle.canTransitionTo(KioskState.rewardSummary),
        isFalse,
      );
    });

    test('idle cannot jump to feedback', () {
      expect(
        KioskState.idle.canTransitionTo(KioskState.correctFeedback),
        isFalse,
      );
    });

    test('a feedback state cannot skip opening the slot', () {
      expect(
        KioskState.correctFeedback.canTransitionTo(KioskState.rewardSummary),
        isFalse,
      );
    });

    test('waitingForStudentAnswer cannot skip processing', () {
      expect(
        KioskState.waitingForStudentAnswer.canTransitionTo(
          KioskState.correctFeedback,
        ),
        isFalse,
      );
    });
  });

  group('privacy helpers', () {
    test('idle-like states report no student loaded', () {
      expect(KioskState.idle.hasStudentLoaded, isFalse);
      expect(KioskState.waitingForCard.hasStudentLoaded, isFalse);
      expect(KioskState.studentNotFound.hasStudentLoaded, isFalse);
    });

    test('mid-session states report a student loaded', () {
      expect(KioskState.studentRecognised.hasStudentLoaded, isTrue);
      expect(KioskState.rewardSummary.hasStudentLoaded, isTrue);
    });

    test('feedback states are identified', () {
      expect(KioskState.correctFeedback.isFeedback, isTrue);
      expect(KioskState.incorrectFeedback.isFeedback, isTrue);
      expect(KioskState.lowConfidenceFeedback.isFeedback, isTrue);
      expect(KioskState.idle.isFeedback, isFalse);
    });
  });

  test('every state can always transition to itself', () {
    for (final state in KioskState.values) {
      expect(state.canTransitionTo(state), isTrue);
    }
  });
}
