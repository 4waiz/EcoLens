import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'guardian_emotion.dart';

/// Immutable snapshot of what the Guardian is doing.
@immutable
class GuardianState {
  const GuardianState({
    this.emotion = GuardianEmotion.idle,
    this.sequence = 0,
    this.holding = false,
  });

  final GuardianEmotion emotion;

  /// Increments on every *applied* change. Widgets key their transition off
  /// this rather than the emotion itself, so re-requesting the same expression
  /// (e.g. a second correct answer in a row) still replays the animation.
  final int sequence;

  /// True while [emotion] is inside its minimum display window.
  final bool holding;

  GuardianState copyWith({
    GuardianEmotion? emotion,
    int? sequence,
    bool? holding,
  }) => GuardianState(
    emotion: emotion ?? this.emotion,
    sequence: sequence ?? this.sequence,
    holding: holding ?? this.holding,
  );
}

/// ---------------------------------------------------------------------------
/// Owns the Guardian's expression, and the policy for changing it.
///
/// The policy exists because kiosk state arrives in bursts: several providers
/// can settle in the same frame, and without arbitration a celebration would be
/// erased by a routine "back to idle" a few milliseconds later. So:
///
/// * every emotion has a **priority** — a higher one always wins immediately;
/// * every emotion has a **minimum hold** — during it, equal-or-lower priority
///   requests are *queued*, not dropped, and applied when the hold ends;
/// * **transient** emotions (a cheer, a nudge) decay back to idle by themselves.
///
/// Holds are deliberately short. A kiosk that makes a child wait for an
/// animation is a kiosk that makes a queue.
/// ---------------------------------------------------------------------------
class GuardianController extends StateNotifier<GuardianState> {
  GuardianController({
    GuardianEmotion initial = GuardianEmotion.idle,
    this.onSound,
  }) : super(GuardianState(emotion: initial));

  /// Emitted once per accepted emotion change. Never fires from a rebuild.
  final void Function(GuardianSoundCue cue)? onSound;

  Timer? _holdTimer;
  GuardianEmotion? _pending;

  /// What a transient expression falls back to. The kiosk sets this from the
  /// current state, because "resting" means something different on the attract
  /// screen (idle, inviting a card) than it does mid-session (listening,
  /// waiting on the student).
  GuardianEmotion _resting = GuardianEmotion.idle;
  GuardianSoundCue? _lastCue;
  DateTime? _lastCueAt;

  /// Duplicate cues inside this window are swallowed, so a double-tap or a
  /// provider that settles twice cannot make the kiosk chirp twice.
  static const Duration soundDebounce = Duration(milliseconds: 450);

  bool get isHolding => state.holding;

  GuardianEmotion get restingEmotion => _resting;

  /// Set the expression transient moments decay back to.
  void setResting(GuardianEmotion emotion) {
    if (emotion.isTransient) return; // a resting state must be stable
    _resting = emotion;
  }

  /// Ask for an expression. Whether it appears now, later, or not at all is
  /// decided here.
  void request(GuardianEmotion emotion, {bool force = false}) {
    if (!mounted) return;

    if (force) {
      _apply(emotion);
      return;
    }

    // Already showing it and still inside the hold: nothing to do. (Outside
    // the hold, re-requesting replays it — a second correct answer should
    // visibly cheer again.)
    if (emotion == state.emotion && state.holding) return;

    if (state.holding && emotion.priority <= state.emotion.priority) {
      // Queue it. Keep whichever pending request matters most.
      if (_pending == null || emotion.priority >= _pending!.priority) {
        _pending = emotion;
      }
      return;
    }

    _apply(emotion);
  }

  /// Wipe all Guardian state. Used at session end so no trace of the previous
  /// student's flow — expression, queued emotion or pending decay — survives.
  void reset() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _pending = null;
    _lastCue = null;
    _lastCueAt = null;
    _resting = GuardianEmotion.idle;
    if (!mounted) return;
    state = GuardianState(
      emotion: GuardianEmotion.idle,
      sequence: state.sequence + 1,
    );
  }

  /// Emit a cue that is not tied to an expression (e.g. the card reader).
  void playCue(GuardianSoundCue cue) => _emit(cue);

  void _apply(GuardianEmotion emotion) {
    _holdTimer?.cancel();
    _pending = null;

    state = GuardianState(
      emotion: emotion,
      sequence: state.sequence + 1,
      holding: emotion.minimumHold > Duration.zero,
    );

    final cue = emotion.soundCue;
    if (cue != null) _emit(cue);

    // Transient emotions always carry a positive hold (asserted in tests), so
    // this timer is what eventually decays them back to idle.
    if (emotion.minimumHold > Duration.zero) {
      _holdTimer = Timer(emotion.minimumHold, _onHoldExpired);
    }
  }

  void _onHoldExpired() {
    if (!mounted) return;
    _holdTimer = null;

    final queued = _pending;
    _pending = null;
    if (queued != null) {
      _apply(queued);
      return;
    }

    state = state.copyWith(holding: false);
    if (state.emotion.isTransient) {
      _apply(_resting);
    }
  }

  void _emit(GuardianSoundCue cue) {
    final now = DateTime.now();
    if (_lastCue == cue &&
        _lastCueAt != null &&
        now.difference(_lastCueAt!) < soundDebounce) {
      return;
    }
    _lastCue = cue;
    _lastCueAt = now;
    onSound?.call(cue);
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _holdTimer = null;
    super.dispose();
  }
}

/// Sound cues raised by the Guardian, for the kiosk to act on.
final guardianSoundCueProvider = StateProvider<GuardianSoundCue?>(
  (ref) => null,
);

/// The kiosk's Guardian. autoDispose so leaving the kiosk tears down any
/// pending hold timer and starts the next session from idle.
final guardianControllerProvider =
    StateNotifierProvider.autoDispose<GuardianController, GuardianState>(
      (ref) => GuardianController(
        onSound: (cue) =>
            ref.read(guardianSoundCueProvider.notifier).state = cue,
      ),
    );
