import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/enums/kiosk_state.dart';
import '../../../shared/world/guardian_emotion.dart';
import 'guardian_speech.dart';

/// ---------------------------------------------------------------------------
/// Touching the Guardian.
///
/// Sprout is the most inviting thing on the screen, so children WILL poke it.
/// This turns that into a designed moment instead of a bug:
///
///   * **A tap is only accepted in a calm state.** Scanning, classifying,
///     feedback, level-up, session end and hardware trouble are all off limits
///     — a tap there is silently ignored rather than queued, because a cheer
///     that arrives after the moment has passed reads as a glitch.
///   * **A reaction is motion only.** It layers a hop or a wiggle over the
///     current expression (see [GuardianTapMotion]), so the workflow emotion is
///     never overwritten and nothing has to be "restored" afterwards.
///   * **There is a cooldown.** Spam-tapping produces one reaction, not twenty.
///   * **No line repeats back to back**, and neither does a motion, so the
///     character does not feel like a vending machine.
///
/// The reply expires by itself, which is what returns the bubble to the real
/// workflow line without any screen having to remember to put it back.
/// ---------------------------------------------------------------------------

/// The Guardian's accepted answer to a tap.
@immutable
class GuardianTapReply {
  const GuardianTapReply({
    required this.line,
    required this.motion,
    required this.sequence,
  });

  final GuardianLine line;
  final GuardianTapMotion motion;

  /// Increments per accepted tap. Widgets key their one-shot animation (and the
  /// voice its dedupe) off this, so two identical replies still both play.
  final int sequence;
}

@immutable
class GuardianInteractionState {
  const GuardianInteractionState({this.reply, this.taps = 0, this.ignored = 0});

  /// The reply currently on screen; null when the Guardian has nothing extra to
  /// say and the workflow line is showing.
  final GuardianTapReply? reply;

  /// Accepted taps this session — exposed for tests and the dev panel.
  final int taps;

  /// Taps refused by the policy or the cooldown.
  final int ignored;

  bool get isReplying => reply != null;
}

/// Every line the Guardian can offer when touched.
///
/// Split in two so the Guardian never tells a logged-in student to tap the card
/// they are already holding, and never offers portal advice to an empty kiosk.
abstract final class GuardianTapLines {
  static const List<String> anonymous = [
    'Hi there, Eco Explorer!',
    'Ready to help Guardian Valley?',
    'Every item can make a difference!',
    "Tap your card when you're ready!",
    'I love keeping our valley clean!',
    'Can you spot something recyclable?',
  ];

  static const List<String> withStudent = [
    'Hi there, Eco Explorer!',
    'Ready to help Guardian Valley?',
    'Every item can make a difference!',
    "Let's find the right portal!",
    "You're doing great!",
    'I love keeping our valley clean!',
    'Can you spot something recyclable?',
  ];

  static List<String> forSession({required bool hasStudent}) =>
      hasStudent ? withStudent : anonymous;
}

/// The states in which a tap is welcome.
///
/// Everything absent from this set is treated as critical. Listing the calm
/// states rather than the busy ones is deliberate: a new kiosk state added later
/// defaults to *ignoring* taps, which is the safe direction.
const Set<KioskState> kGuardianTapStates = {
  KioskState.idle,
  KioskState.offline,
  KioskState.waitingForCard,
  KioskState.studentRecognised,
  KioskState.readyToScan,
  KioskState.classificationReady,
  KioskState.waitingForStudentAnswer,
  KioskState.houseLeaderboard,
  KioskState.guardianEvolution,
};

/// Whether the Guardian will react to a touch in [state].
bool guardianAcceptsTapIn(KioskState state) =>
    kGuardianTapStates.contains(state);

class GuardianInteractionController
    extends StateNotifier<GuardianInteractionState> {
  GuardianInteractionController({
    math.Random? random,
    this.cooldown = const Duration(milliseconds: 1900),
    this.replyDuration = const Duration(milliseconds: 2800),
  }) : _random = random ?? math.Random(),
       super(const GuardianInteractionState());

  final math.Random _random;

  /// How long after an accepted tap the next one is ignored. Sits inside the
  /// brief's 1.5–2.5s window: long enough to stop a drum solo, short enough
  /// that a child who waits does not think the Guardian broke.
  final Duration cooldown;

  /// How long the reply stays on screen before the workflow line returns.
  final Duration replyDuration;

  DateTime? _acceptedAt;
  Timer? _expiry;
  int _lastLine = -1;
  int _lastMotion = -1;

  /// Whether a tap right now would be accepted. Drives the cursor and the
  /// hover affordance, so the Guardian only *looks* touchable when it is.
  bool canTap(KioskState kioskState, {DateTime? now}) =>
      guardianAcceptsTapIn(kioskState) && !_cooling(now ?? DateTime.now());

  bool _cooling(DateTime now) {
    final last = _acceptedAt;
    return last != null && now.difference(last) < cooldown;
  }

  /// Offer a tap. Returns true when the Guardian reacted.
  bool tap({
    required KioskState kioskState,
    required bool hasStudent,
    DateTime? now,
  }) {
    if (!mounted) return false;
    final at = now ?? DateTime.now();

    if (!guardianAcceptsTapIn(kioskState) || _cooling(at)) {
      state = GuardianInteractionState(
        reply: state.reply,
        taps: state.taps,
        ignored: state.ignored + 1,
      );
      return false;
    }

    _acceptedAt = at;
    final text = _pickLine(hasStudent: hasStudent);
    final motion = _pickMotion();
    final sequence = state.taps + 1;

    _expiry?.cancel();
    _expiry = Timer(replyDuration, clear);

    state = GuardianInteractionState(
      reply: GuardianTapReply(
        line: GuardianLine(text: text),
        motion: motion,
        sequence: sequence,
      ),
      taps: sequence,
      ignored: state.ignored,
    );
    return true;
  }

  /// Drop the reply so the workflow line shows again. Called by the expiry
  /// timer, and directly whenever the kiosk moves into a state where the
  /// Guardian has something more important to say.
  void clear() {
    _expiry?.cancel();
    _expiry = null;
    if (!mounted || state.reply == null) return;
    state = GuardianInteractionState(taps: state.taps, ignored: state.ignored);
  }

  /// Between students: forget the counters, the cooldown and the reply.
  void reset() {
    _expiry?.cancel();
    _expiry = null;
    _acceptedAt = null;
    _lastLine = -1;
    _lastMotion = -1;
    if (!mounted) return;
    state = const GuardianInteractionState();
  }

  /// A line that is not the one just used.
  String _pickLine({required bool hasStudent}) {
    final pool = GuardianTapLines.forSession(hasStudent: hasStudent);
    if (pool.length == 1) return pool.first;
    var index = _random.nextInt(pool.length);
    if (index == _lastLine) index = (index + 1) % pool.length;
    _lastLine = index;
    return pool[index];
  }

  /// A motion that is not the one just used.
  GuardianTapMotion _pickMotion() {
    const all = GuardianTapMotion.values;
    var index = _random.nextInt(all.length);
    if (index == _lastMotion) index = (index + 1) % all.length;
    _lastMotion = index;
    return all[index];
  }

  @override
  void dispose() {
    _expiry?.cancel();
    _expiry = null;
    super.dispose();
  }
}

/// The Guardian's interaction state for the current kiosk surface.
///
/// autoDispose, so leaving the kiosk cancels a pending reply timer and the next
/// session starts with a Guardian that has never been touched.
final guardianInteractionProvider =
    StateNotifierProvider.autoDispose<
      GuardianInteractionController,
      GuardianInteractionState
    >((ref) => GuardianInteractionController());
