import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/enums/kiosk_state.dart';
import '../../../shared/world/guardian_controller.dart';
import '../../../shared/world/guardian_emotion.dart';
import 'kiosk_session_state.dart';

/// ---------------------------------------------------------------------------
/// Translates the kiosk's finite state machine into Guardian expressions.
///
/// This is the only place that knows both vocabularies. It is a pure mapping
/// plus one piece of memory — how many times in a row the student has picked
/// the wrong portal — so that a second mistake is met with encouragement rather
/// than the same correction again.
/// ---------------------------------------------------------------------------
class GuardianDirector {
  GuardianDirector(this._guardian);

  final GuardianController _guardian;

  KioskState? _lastState;
  int _wrongStreak = 0;
  bool _celebratedThisSession = false;
  bool _levelledUpThisSession = false;

  int get wrongStreak => _wrongStreak;

  /// Feed every kiosk snapshot in. Repeated snapshots of the same state are
  /// ignored, so a provider that rebuilds cannot re-trigger an expression or
  /// re-fire a sound.
  void onKioskState(KioskSessionState session) {
    final state = session.state;
    final changed = state != _lastState;
    _lastState = state;
    if (!changed) return;

    // A fresh session starts from a clean slate — no expression, streak or
    // celebration from the previous student survives.
    if (state == KioskState.idle && !session.hasStudent) {
      _wrongStreak = 0;
      _celebratedThisSession = false;
      _levelledUpThisSession = false;
      _guardian.reset();
      return;
    }

    if (state == KioskState.incorrectFeedback) _wrongStreak++;
    if (state == KioskState.correctFeedback) _wrongStreak = 0;

    final emotion = emotionFor(
      session,
      wrongStreak: _wrongStreak,
      alreadyCelebrated: _celebratedThisSession,
      alreadyLevelledUp: _levelledUpThisSession,
    );

    if (emotion == GuardianEmotion.celebrate) _celebratedThisSession = true;
    if (emotion == GuardianEmotion.levelUp) _levelledUpThisSession = true;

    if (state == KioskState.readingCard) {
      _guardian.playCue(GuardianSoundCue.cardDetected);
    }

    // Where this moment settles back to once it has played out. A cheer on the
    // attract screen returns to idle; the same cheer mid-session returns to
    // listening, because the Guardian is still waiting on the student.
    _guardian.setResting(restingFor(session));
    _guardian.request(emotion);
  }

  /// Full reset — used when the kiosk surface is torn down.
  void reset() {
    _lastState = null;
    _wrongStreak = 0;
    _celebratedThisSession = false;
    _levelledUpThisSession = false;
    _guardian.reset();
  }

  /// The expression a transient moment decays back to, for this session.
  ///
  /// Exposed for tests.
  static GuardianEmotion restingFor(KioskSessionState session) {
    final base = emotionFor(session);
    if (!base.isTransient) return base;
    // The mapped emotion is a moment, not a state — rest on something stable.
    return session.hasStudent
        ? GuardianEmotion.listening
        : GuardianEmotion.idle;
  }

  /// The pure mapping. Exposed for tests.
  static GuardianEmotion emotionFor(
    KioskSessionState session, {
    int wrongStreak = 0,
    bool alreadyCelebrated = false,
    bool alreadyLevelledUp = false,
  }) {
    final outcome = session.lastOutcome;

    switch (session.state) {
      // ---- Attract -------------------------------------------------
      case KioskState.idle:
      case KioskState.offline:
        return GuardianEmotion.idle;

      // Actively inviting a card tap.
      case KioskState.waitingForCard:
        return GuardianEmotion.listening;

      // ---- Card ----------------------------------------------------
      case KioskState.readingCard:
        return GuardianEmotion.thinking;
      case KioskState.studentNotFound:
        return GuardianEmotion.tryAgain;
      case KioskState.studentRecognised:
        return GuardianEmotion.welcome;

      // ---- Scanning ------------------------------------------------
      case KioskState.readyToScan:
        return GuardianEmotion.listening;
      case KioskState.capturingImage:
      case KioskState.analysingImage:
        return GuardianEmotion.thinking;

      // Result is in; now it is the student's move.
      case KioskState.classificationReady:
      case KioskState.waitingForStudentAnswer:
        return GuardianEmotion.listening;
      case KioskState.processingAnswer:
        return GuardianEmotion.thinking;

      // ---- Feedback ------------------------------------------------
      case KioskState.correctFeedback:
      case KioskState.lowConfidenceFeedback:
        if (outcome != null && outcome.stageChanged && !alreadyLevelledUp) {
          return GuardianEmotion.levelUp;
        }
        if (outcome != null && outcome.bonusApplied && !alreadyCelebrated) {
          return GuardianEmotion.celebrate;
        }
        return outcome?.wasCorrect == false
            ? GuardianEmotion.tryAgain
            : GuardianEmotion.correct;

      case KioskState.incorrectFeedback:
        // First slip: a nudge. After that, support rather than correction.
        return wrongStreak >= 2
            ? GuardianEmotion.encourage
            : GuardianEmotion.tryAgain;

      // ---- Reward / wrap-up ----------------------------------------
      case KioskState.openingSlot:
      case KioskState.waitingForWasteDrop:
      case KioskState.rewardSummary:
        if (outcome != null && outcome.stageChanged && !alreadyLevelledUp) {
          return GuardianEmotion.levelUp;
        }
        if (outcome != null && outcome.dailyCapReached && !alreadyCelebrated) {
          return GuardianEmotion.celebrate;
        }
        return GuardianEmotion.idle;

      case KioskState.sessionComplete:
        return GuardianEmotion.goodbye;

      // ---- Sub-screens ---------------------------------------------
      case KioskState.houseLeaderboard:
        return GuardianEmotion.idle;
      case KioskState.guardianEvolution:
        return GuardianEmotion.welcome;

      // ---- Trouble — always calm, never alarming --------------------
      case KioskState.maintenance:
      case KioskState.error:
        return GuardianEmotion.tryAgain;
    }
  }
}

/// The director for the current kiosk surface.
final guardianDirectorProvider = Provider.autoDispose<GuardianDirector>((ref) {
  final director = GuardianDirector(
    ref.read(guardianControllerProvider.notifier),
  );
  ref.onDispose(director.reset);
  return director;
});
