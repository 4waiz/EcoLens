import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/world/guardian_controller.dart';
import '../../../shared/world/guardian_emotion.dart';
import 'kiosk_preferences.dart';

/// ---------------------------------------------------------------------------
/// Turns Guardian moments into sound.
///
/// EcoLens ships no audio files — adding any would mean shipping third-party
/// recordings — so cues are played through the platform's own system sounds and
/// haptics. That is deliberately conservative: it works on every target, needs
/// no licensing, and is the right volume and tone for a classroom.
///
/// Swapping in real audio later means changing only [_play]; every caller
/// already speaks in [GuardianSoundCue]s.
///
/// Rules this enforces:
///   * muting the kiosk mutes everything here;
///   * reduced motion does **not** imply silence — they are separate needs;
///   * a cue is played at most once per event, never once per rebuild, and
///     duplicates inside a short window are dropped (the controller debounces
///     first, this is the second guard);
///   * a missing or failing platform channel is swallowed — audio must never
///     take the kiosk down.
/// ---------------------------------------------------------------------------
class GuardianAudio {
  GuardianAudio(this._ref);

  final Ref _ref;

  GuardianSoundCue? _lastCue;
  DateTime? _lastAt;

  static const Duration _debounce = Duration(milliseconds: 350);

  void play(GuardianSoundCue cue) {
    if (!_ref.read(kioskPreferencesProvider).soundEnabled) return;

    final now = DateTime.now();
    if (_lastCue == cue &&
        _lastAt != null &&
        now.difference(_lastAt!) < _debounce) {
      return;
    }
    _lastCue = cue;
    _lastAt = now;
    _emit(cue);
  }

  void _emit(GuardianSoundCue cue) {
    try {
      switch (cue) {
        // Something good happened — a click plus a light tap.
        case GuardianSoundCue.correct:
        case GuardianSoundCue.welcome:
        case GuardianSoundCue.cardDetected:
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.lightImpact();

        // Bigger moments get a firmer confirmation.
        case GuardianSoundCue.celebrate:
        case GuardianSoundCue.levelUp:
          SystemSound.play(SystemSoundType.click);
          HapticFeedback.mediumImpact();

        // Never an alarm: a mistake is acknowledged, not punished.
        case GuardianSoundCue.tryAgain:
          HapticFeedback.selectionClick();

        case GuardianSoundCue.goodbye:
          SystemSound.play(SystemSoundType.click);
      }
    } catch (_) {
      // No audio/haptics on this device. Silence is an acceptable outcome.
    }
  }
}

final guardianAudioProvider = Provider<GuardianAudio>(GuardianAudio.new);

/// Bridges the Guardian's cue stream to the audio player.
///
/// Watch this from the kiosk surface so it stays alive for the session. It
/// listens rather than watches, so a rebuild cannot replay a cue.
final guardianAudioBridgeProvider = Provider.autoDispose<void>((ref) {
  ref.listen<GuardianSoundCue?>(guardianSoundCueProvider, (previous, next) {
    if (next == null || next == previous) return;
    ref.read(guardianAudioProvider).play(next);
  });
});
