import 'dart:math' as math;

import 'package:ecolens/domain/enums/kiosk_state.dart';
import 'package:fake_async/fake_async.dart';
import 'package:ecolens/features/kiosk/application/guardian_interaction.dart';
import 'package:ecolens/shared/world/guardian_emotion.dart';
import 'package:flutter_test/flutter_test.dart';

/// The tap policy for the Guardian.
///
/// Children will poke the dragon, so the rules matter: only in a calm state,
/// only once per cooldown, never the same line twice in a row, and never a
/// change of expression (a tap adds motion, it does not take over the flow).
void main() {
  /// A deterministic controller. Seeding the RNG lets the "no repeats" rules be
  /// asserted rather than hoped for.
  GuardianInteractionController controller({
    int seed = 7,
    Duration cooldown = const Duration(milliseconds: 1900),
    Duration reply = const Duration(milliseconds: 2800),
  }) {
    final c = GuardianInteractionController(
      random: math.Random(seed),
      cooldown: cooldown,
      replyDuration: reply,
    );
    addTearDown(c.dispose);
    return c;
  }

  // ---------------------------------------------------------------------------
  // 12. A tap is accepted in a calm state
  // ---------------------------------------------------------------------------

  test('12. a tap in a calm state produces a reply and a motion', () {
    final c = controller();

    final accepted = c.tap(
      kioskState: KioskState.idle,
      hasStudent: false,
      now: DateTime(2026),
    );

    expect(accepted, isTrue);
    expect(c.state.taps, 1);
    expect(c.state.reply, isNotNull);
    expect(c.state.reply!.motion, isA<GuardianTapMotion>());
    expect(c.state.reply!.line.text, isNotEmpty);
    expect(c.state.reply!.sequence, 1);
    expect(c.state.ignored, 0);
  });

  test('12b. every calm state welcomes a tap', () {
    for (final state in kGuardianTapStates) {
      final c = controller();
      expect(
        c.tap(kioskState: state, hasStudent: true, now: DateTime(2026)),
        isTrue,
        reason: '${state.name} should welcome a tap',
      );
    }
  });

  // ---------------------------------------------------------------------------
  // 13. A tap never interrupts a critical state
  // ---------------------------------------------------------------------------

  test('13. a tap during a critical state is ignored, not queued', () {
    // The states where the kiosk is busy or mid-feedback.
    const critical = [
      KioskState.readingCard,
      KioskState.capturingImage,
      KioskState.analysingImage,
      KioskState.processingAnswer,
      KioskState.correctFeedback,
      KioskState.incorrectFeedback,
      KioskState.lowConfidenceFeedback,
      KioskState.openingSlot,
      KioskState.waitingForWasteDrop,
      KioskState.rewardSummary,
      KioskState.sessionComplete,
      KioskState.studentNotFound,
      KioskState.maintenance,
      KioskState.error,
    ];

    for (final state in critical) {
      final c = controller();
      final accepted = c.tap(
        kioskState: state,
        hasStudent: true,
        now: DateTime(2026),
      );

      expect(accepted, isFalse, reason: '${state.name} must refuse a tap');
      expect(c.state.reply, isNull, reason: 'nothing was queued for later');
      expect(c.state.taps, 0);
      expect(c.state.ignored, 1);
    }
  });

  test('13b. the policy predicate matches the accepted-state set', () {
    for (final state in KioskState.values) {
      expect(
        guardianAcceptsTapIn(state),
        kGuardianTapStates.contains(state),
        reason: state.name,
      );
    }
    // A state added later defaults to refusing taps, which is the safe way round.
    expect(guardianAcceptsTapIn(KioskState.analysingImage), isFalse);
  });

  test('13c. a critical transition drops a reply that is already showing', () {
    final c = controller();
    c.tap(kioskState: KioskState.idle, hasStudent: false, now: DateTime(2026));
    expect(c.state.reply, isNotNull);

    // What KioskChrome does when the kiosk moves somewhere important.
    c.clear();

    expect(c.state.reply, isNull);
    // The accepted-tap count survives — only the aside is dropped.
    expect(c.state.taps, 1);
  });

  // ---------------------------------------------------------------------------
  // 14. Cooldown
  // ---------------------------------------------------------------------------

  test('14. spam tapping produces exactly one reaction', () {
    final c = controller(cooldown: const Duration(milliseconds: 1900));
    final t0 = DateTime(2026);

    expect(
      c.tap(kioskState: KioskState.idle, hasStudent: false, now: t0),
      isTrue,
    );
    // Eight more taps in the same second, as an excited child produces.
    for (var i = 1; i <= 8; i++) {
      expect(
        c.tap(
          kioskState: KioskState.idle,
          hasStudent: false,
          now: t0.add(Duration(milliseconds: 120 * i)),
        ),
        isFalse,
        reason: 'tap $i landed inside the cooldown',
      );
    }

    expect(c.state.taps, 1);
    expect(c.state.ignored, 8);
  });

  test('14b. the cooldown opens again once it has elapsed', () {
    final c = controller(cooldown: const Duration(milliseconds: 1900));
    final t0 = DateTime(2026);

    c.tap(kioskState: KioskState.idle, hasStudent: false, now: t0);
    expect(
      c.canTap(KioskState.idle, now: t0.add(const Duration(milliseconds: 500))),
      isFalse,
    );
    expect(
      c.canTap(
        KioskState.idle,
        now: t0.add(const Duration(milliseconds: 2000)),
      ),
      isTrue,
    );
    expect(
      c.tap(
        kioskState: KioskState.idle,
        hasStudent: false,
        now: t0.add(const Duration(milliseconds: 2000)),
      ),
      isTrue,
    );
    expect(c.state.taps, 2);
  });

  test('14c. the cooldown sits inside the 1.5–2.5 second window', () {
    final c = controller();
    expect(c.cooldown.inMilliseconds, greaterThanOrEqualTo(1500));
    expect(c.cooldown.inMilliseconds, lessThanOrEqualTo(2500));
  });

  test('14d. canTap refuses a critical state regardless of the cooldown', () {
    final c = controller();
    expect(c.canTap(KioskState.analysingImage, now: DateTime(2026)), isFalse);
  });

  // ---------------------------------------------------------------------------
  // 15. The reply is an aside, never a change of flow
  // ---------------------------------------------------------------------------

  test('15. the reply expires by itself, restoring the workflow line', () {
    fakeAsync((async) {
      final c = GuardianInteractionController(
        random: math.Random(1),
        replyDuration: const Duration(milliseconds: 800),
      );
      c.tap(kioskState: KioskState.idle, hasStudent: false);
      expect(c.state.isReplying, isTrue);

      async.elapse(const Duration(milliseconds: 900));

      expect(
        c.state.isReplying,
        isFalse,
        reason: 'the bubble must fall back to the workflow line on its own',
      );
      c.dispose();
    });
  });

  test('15b. a reset clears the reply, the counters and the cooldown', () {
    final c = controller();
    final t0 = DateTime(2026);
    c.tap(kioskState: KioskState.idle, hasStudent: false, now: t0);
    expect(c.state.taps, 1);

    c.reset();

    expect(c.state.reply, isNull);
    expect(c.state.taps, 0);
    expect(c.state.ignored, 0);
    // The next student is not held back by the previous child's cooldown.
    expect(
      c.tap(
        kioskState: KioskState.idle,
        hasStudent: false,
        now: t0.add(const Duration(milliseconds: 10)),
      ),
      isTrue,
    );
  });

  // ---------------------------------------------------------------------------
  // Variety
  // ---------------------------------------------------------------------------

  test('a line is never repeated immediately', () {
    final c = controller(seed: 3, cooldown: Duration.zero);
    var previous = '';
    for (var i = 0; i < 40; i++) {
      c.tap(
        kioskState: KioskState.idle,
        hasStudent: false,
        now: DateTime(2026).add(Duration(seconds: i * 5)),
      );
      final text = c.state.reply!.line.text;
      expect(text, isNot(previous), reason: 'repeated "$text" back to back');
      previous = text;
    }
  });

  test('a motion is never repeated immediately', () {
    final c = controller(seed: 11, cooldown: Duration.zero);
    GuardianTapMotion? previous;
    for (var i = 0; i < 40; i++) {
      c.tap(
        kioskState: KioskState.idle,
        hasStudent: false,
        now: DateTime(2026).add(Duration(seconds: i * 5)),
      );
      final motion = c.state.reply!.motion;
      expect(motion, isNot(previous), reason: 'repeated ${motion.label}');
      previous = motion;
    }
  });

  test('the tap lines suit who is standing there', () {
    // Never tell a logged-in student to tap the card they just used…
    expect(
      GuardianTapLines.withStudent,
      isNot(contains("Tap your card when you're ready!")),
    );
    // …and never offer portal advice to an empty kiosk.
    expect(
      GuardianTapLines.anonymous,
      isNot(contains("Let's find the right portal!")),
    );
    expect(
      GuardianTapLines.forSession(hasStudent: true).length,
      greaterThan(3),
    );
    expect(
      GuardianTapLines.forSession(hasStudent: false).length,
      greaterThan(3),
    );
  });

  test('every tap motion has a bounded, non-trivial profile', () {
    for (final motion in GuardianTapMotion.values) {
      final p = motion.profile;
      expect(p.duration.inMilliseconds, greaterThan(300));
      expect(
        p.duration.inMilliseconds,
        lessThan(1200),
        reason: '${motion.label} would outstay its welcome',
      );
      // Something must actually move.
      expect(
        p.hop + p.spin.abs() + p.sway.abs() + p.squash + p.tilt.abs(),
        greaterThan(0),
        reason: '${motion.label} does nothing',
      );
      // …but never a full rotation. The Guardian lives in the world.
      expect(
        p.spin.abs(),
        lessThan(1.0),
        reason: '${motion.label} spins too far',
      );
      expect(p.hop, lessThan(0.25));
      expect(motion.label, isNotEmpty);
    }
  });
}
