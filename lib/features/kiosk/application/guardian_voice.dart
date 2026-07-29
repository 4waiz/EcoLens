import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'guardian_voice_service.dart';

/// One thing the Guardian should say out loud.
///
/// [id] is the load-bearing field. It identifies the *dialogue moment*, not the
/// words — so a widget rebuild that produces an identical event is recognised
/// and skipped, while the same sentence arriving as a genuinely new moment (a
/// second correct answer in a row) is spoken again.
@immutable
class GuardianSpeechEvent {
  const GuardianSpeechEvent({
    required this.id,
    required this.text,
    this.headline,
    this.priority = 1,
  });

  final String id;

  /// The message. One short sentence: this is read aloud to a child holding a
  /// yoghurt pot, not narrated to an audience.
  final String text;

  /// Optional bold opener, spoken before [text].
  final String? headline;

  /// Higher wins. A celebration is never cut short by a routine prompt.
  final int priority;

  /// Exactly what is sent to the synthesiser.
  ///
  /// Numbers and statistics are deliberately NOT assembled here — the Guardian
  /// speaks its own line and nothing else on the screen is read out.
  String get spoken {
    final head = headline?.trim();
    if (head == null || head.isEmpty) return text.trim();
    // A full stop between the two halves, so the engine pauses rather than
    // running the greeting into the instruction.
    final punctuated = RegExp(r'[.!?…]$').hasMatch(head) ? head : '$head.';
    return '$punctuated ${text.trim()}';
  }

  @override
  bool operator ==(Object other) =>
      other is GuardianSpeechEvent &&
      other.id == id &&
      other.text == text &&
      other.headline == headline &&
      other.priority == priority;

  @override
  int get hashCode => Object.hash(id, text, headline, priority);
}

/// ---------------------------------------------------------------------------
/// The rules for when the Guardian talks.
///
/// All of the policy lives here, above the platform engine, so it is pure Dart
/// and fully testable without a browser:
///
///   * **one utterance per dialogue moment.** A repeated [GuardianSpeechEvent]
///     id is dropped, which is what makes the whole feature rebuild-safe.
///   * **never overlapping.** A new line replaces the old one; a *lower*
///     priority line that arrives mid-sentence is dropped rather than queued,
///     because a kiosk that finishes its backlog of announcements after the
///     child has walked away is worse than one that stays quiet.
///   * **mute is immediate and total.** Muting stops mid-sentence and blocks
///     every new line, while the written dialogue carries on unchanged.
///   * **replay is explicit.** The speaker button in the bubble bypasses the
///     dedupe, because asking to hear it again is a new request.
/// ---------------------------------------------------------------------------
class GuardianVoice {
  GuardianVoice(
    this._service, {
    this.settings = const GuardianVoiceSettings(),
  });

  final GuardianVoiceService _service;
  final GuardianVoiceSettings settings;

  GuardianSpeechEvent? _current;
  String? _spokenId;
  int _currentPriority = -1;
  bool _muted = false;
  int _utterances = 0;

  /// The line the replay control would speak. Tracked even while muted, so
  /// un-muting and pressing replay says the right thing.
  GuardianSpeechEvent? get currentLine => _current;

  /// How many times the engine has actually been asked to speak. Exposed so
  /// tests can prove a rebuild does not double-speak.
  int get utteranceCount => _utterances;

  bool get muted => _muted;

  bool get isAvailable => _service.isAvailable;

  ValueListenable<bool> get speaking => _service.speaking;

  /// Offer a dialogue moment to the voice.
  Future<void> announce(GuardianSpeechEvent event) async {
    // The bubble's replay target always follows the newest line, muted or not.
    _current = event;

    if (event.id == _spokenId) return; // a rebuild, not a new moment
    _spokenId = event.id;

    if (_muted) return;
    // A bigger moment is already being spoken — let it finish.
    if (_service.speaking.value && event.priority < _currentPriority) return;

    _currentPriority = event.priority;
    _utterances++;
    await _service.speak(event.spoken, settings);
  }

  /// Say the current line again. Used by the speaker control in the bubble.
  Future<void> replay() async {
    final line = _current;
    if (line == null || _muted) return;
    _currentPriority = line.priority;
    _utterances++;
    await _service.speak(line.spoken, settings);
  }

  Future<void> setMuted(bool muted) async {
    if (_muted == muted) return;
    _muted = muted;
    if (muted) await _service.stop();
  }

  Future<void> stop() async {
    _currentPriority = -1;
    await _service.stop();
  }

  /// Full reset between students: stop talking and forget what was said, so the
  /// next child's first line is spoken even if it is word-for-word identical.
  Future<void> reset() async {
    _current = null;
    _spokenId = null;
    await stop();
  }
}

/// The synthesiser for this platform. Long-lived: creating one per screen would
/// re-probe the engine and re-resolve the voice list on every navigation.
final guardianVoiceServiceProvider = Provider<GuardianVoiceService>((ref) {
  final service = createGuardianVoiceService();
  ref.onDispose(service.dispose);
  return service;
});

/// How Sprout sounds. Overridable for a school that wants a different language.
final guardianVoiceSettingsProvider = Provider<GuardianVoiceSettings>(
  (ref) => const GuardianVoiceSettings(),
);

/// The Guardian's voice, with all of the dedupe/mute/priority rules applied.
final guardianVoiceProvider = Provider<GuardianVoice>((ref) {
  final voice = GuardianVoice(
    ref.watch(guardianVoiceServiceProvider),
    settings: ref.watch(guardianVoiceSettingsProvider),
  );
  // Leaving the app (or rebuilding this provider) must never leave a sentence
  // playing over the next screen.
  ref.onDispose(voice.stop);
  return voice;
});
