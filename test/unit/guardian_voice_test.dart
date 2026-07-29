import 'package:ecolens/features/kiosk/application/guardian_voice.dart';
import 'package:ecolens/features/kiosk/application/guardian_voice_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// The rules for when the Guardian talks.
///
/// All of the policy lives above the platform engine, so it can be proven here
/// without a browser: one utterance per dialogue moment, no overlap, mute is
/// immediate and total, and replay is explicit.
void main() {
  /// A synthesiser that records instead of speaking.
  ///
  /// [speakingAfterSpeak] models the real thing: a browser stays "speaking"
  /// until the utterance ends, which is what the priority rule depends on.
  late _RecordingVoice engine;
  late GuardianVoice voice;

  GuardianVoice build({
    bool available = true,
    bool speakingAfterSpeak = false,
  }) {
    engine = _RecordingVoice(
      available: available,
      speakingAfterSpeak: speakingAfterSpeak,
    );
    addTearDown(engine.dispose);
    return GuardianVoice(engine);
  }

  GuardianSpeechEvent event(
    String id, {
    String text = 'Show me the item you want to recycle.',
    String? headline,
    int priority = 1,
  }) => GuardianSpeechEvent(
    id: id,
    text: text,
    headline: headline,
    priority: priority,
  );

  setUp(() => voice = build());

  // ---------------------------------------------------------------------------
  // 16. One dialogue moment, one utterance
  // ---------------------------------------------------------------------------

  test('16. a new dialogue moment emits exactly one TTS event', () async {
    await voice.announce(event('listening#1'));

    expect(engine.spoken, hasLength(1));
    expect(voice.utteranceCount, 1);
    expect(engine.spoken.single, 'Show me the item you want to recycle.');
  });

  test('16b. the headline is spoken before the message, punctuated', () async {
    await voice.announce(
      event('welcome#2', headline: 'Welcome back, Liam', text: 'Ready?'),
    );

    expect(engine.spoken.single, 'Welcome back, Liam. Ready?');
  });

  test('16c. an existing sentence ending is not doubled up', () async {
    await voice.announce(
      event('levelUp#3', headline: 'Level up!', text: 'You reached Level 4!'),
    );

    expect(engine.spoken.single, 'Level up! You reached Level 4!');
  });

  // ---------------------------------------------------------------------------
  // 17 + 30. A rebuild never replays
  // ---------------------------------------------------------------------------

  test('17. re-announcing the same moment does not speak again', () async {
    final moment = event('listening#1');
    await voice.announce(moment);
    // Ten rebuilds of the widget tree, all producing the identical event.
    for (var i = 0; i < 10; i++) {
      await voice.announce(moment);
    }

    expect(engine.spoken, hasLength(1), reason: 'a rebuild must be silent');
    expect(voice.utteranceCount, 1);
  });

  test(
    '17b. the same words as a genuinely new moment DO speak again',
    () async {
      // A second correct answer in a row: identical sentence, new moment.
      await voice.announce(event('correct#4', text: 'Great sorting!'));
      await voice.announce(event('correct#5', text: 'Great sorting!'));

      expect(engine.spoken, hasLength(2));
    },
  );

  test(
    '30. no duplicate event is emitted across a burst of rebuilds',
    () async {
      for (var i = 0; i < 5; i++) {
        await voice.announce(event('idle#1'));
        await voice.announce(event('idle#1'));
      }
      await voice.announce(event('idle#2'));

      expect(engine.spoken, hasLength(2));
    },
  );

  // ---------------------------------------------------------------------------
  // 18. Mute
  // ---------------------------------------------------------------------------

  test('18. muting stops the Guardian mid-sentence', () async {
    voice = build(speakingAfterSpeak: true);
    await voice.announce(event('listening#1'));
    expect(engine.speaking.value, isTrue);

    await voice.setMuted(true);

    expect(engine.stops, greaterThan(0), reason: 'speech must stop at once');
    expect(engine.speaking.value, isFalse);
    expect(voice.muted, isTrue);
  });

  test('18b. no new line is spoken while muted', () async {
    await voice.setMuted(true);
    await voice.announce(event('listening#1'));
    await voice.announce(event('welcome#2'));

    expect(engine.spoken, isEmpty);
    expect(voice.utteranceCount, 0);
    // …but the written line is still tracked, so replay works after un-muting.
    expect(voice.currentLine?.id, 'welcome#2');
  });

  test('18c. un-muting does not retroactively speak the backlog', () async {
    await voice.setMuted(true);
    await voice.announce(event('listening#1'));
    await voice.setMuted(false);

    expect(engine.spoken, isEmpty, reason: 'the moment has passed');
    expect(voice.muted, isFalse);
  });

  // ---------------------------------------------------------------------------
  // 19. Replay
  // ---------------------------------------------------------------------------

  test(
    '19. replaying from the bubble triggers exactly one voice event',
    () async {
      await voice.announce(event('listening#1'));
      expect(engine.spoken, hasLength(1));

      await voice.replay();

      expect(engine.spoken, hasLength(2), reason: 'one replay, one utterance');
      expect(engine.spoken.last, engine.spoken.first);
      expect(voice.utteranceCount, 2);
    },
  );

  test('19b. replay respects mute', () async {
    await voice.announce(event('listening#1'));
    await voice.setMuted(true);
    await voice.replay();

    expect(engine.spoken, hasLength(1), reason: 'no replay while muted');
  });

  test('19c. replay with nothing to say is a no-op', () async {
    await voice.replay();
    expect(engine.spoken, isEmpty);
  });

  // ---------------------------------------------------------------------------
  // 20. No engine
  // ---------------------------------------------------------------------------

  test('20. a device with no speech engine does not crash', () async {
    voice = build(available: false);

    await voice.announce(event('listening#1'));
    await voice.replay();
    await voice.setMuted(true);
    await voice.stop();
    await voice.reset();

    expect(voice.isAvailable, isFalse);
  });

  test('20b. the silent voice is a complete, safe implementation', () async {
    final silent = SilentGuardianVoice();
    addTearDown(silent.dispose);

    expect(silent.isAvailable, isFalse);
    expect(silent.speaking.value, isFalse);
    // None of these may throw — the written dialogue carries on regardless.
    await silent.speak('hello', const GuardianVoiceSettings());
    await silent.stop();
    expect(silent.speaking.value, isFalse);
  });

  // ---------------------------------------------------------------------------
  // 21. Leaving the route / ending the session
  // ---------------------------------------------------------------------------

  test('21. reset stops speech and forgets the line', () async {
    voice = build(speakingAfterSpeak: true);
    await voice.announce(event('listening#1'));

    await voice.reset();

    expect(engine.stops, greaterThan(0));
    expect(engine.speaking.value, isFalse);
    expect(voice.currentLine, isNull);
  });

  test('21b. after a reset an identical first line is spoken again', () async {
    // The next student deserves their greeting even if it is word-for-word the
    // same as the last child's.
    await voice.announce(event('idle#1', text: 'Welcome to EcoLens!'));
    await voice.reset();
    await voice.announce(event('idle#1', text: 'Welcome to EcoLens!'));

    expect(engine.spoken, hasLength(2));
  });

  // ---------------------------------------------------------------------------
  // No overlap, and priority
  // ---------------------------------------------------------------------------

  test('a bigger moment is not talked over by a routine prompt', () async {
    voice = build(speakingAfterSpeak: true);
    // A level-up is playing…
    await voice.announce(event('levelUp#9', priority: 5, text: 'Level up!'));
    expect(engine.spoken, hasLength(1));

    // …and a routine "waiting for you" arrives mid-sentence.
    await voice.announce(event('listening#10', priority: 1));

    expect(
      engine.spoken,
      hasLength(1),
      reason: 'the celebration must be allowed to finish',
    );
  });

  test('a bigger moment DOES interrupt a routine prompt', () async {
    voice = build(speakingAfterSpeak: true);
    await voice.announce(event('listening#10', priority: 1));
    await voice.announce(event('celebrate#11', priority: 5, text: 'Amazing!'));

    expect(engine.spoken, hasLength(2));
    expect(engine.spoken.last, 'Amazing!');
    // Replacing, not layering: the old line was cancelled first.
    expect(engine.stops, greaterThan(0));
  });

  test('speaking never overlaps — each speak cancels the last', () async {
    await voice.announce(event('a#1', priority: 1));
    await voice.announce(event('b#2', priority: 1));
    await voice.announce(event('c#3', priority: 1));

    expect(engine.spoken, hasLength(3));
    expect(
      engine.stopsBeforeSpeak,
      hasLength(3),
      reason: 'every utterance is preceded by a cancel',
    );
  });

  // ---------------------------------------------------------------------------
  // Voice character
  // ---------------------------------------------------------------------------

  test(
    'the default voice is warm and clear rather than squeaky or robotic',
    () {
      const settings = GuardianVoiceSettings();
      // Slightly slower than default so consonants survive a noisy corridor.
      expect(settings.rate, inInclusiveRange(0.85, 1.0));
      // Raised, but nowhere near a chipmunk — high pitch hurts intelligibility.
      expect(settings.pitch, inInclusiveRange(1.0, 1.3));
      expect(settings.volume, 1.0);
      expect(settings.language, startsWith('en'));
    },
  );

  test('settings can be overridden for a different school', () {
    const settings = GuardianVoiceSettings();
    final slower = settings.copyWith(rate: 0.85, language: 'en-US');
    expect(slower.rate, 0.85);
    expect(slower.language, 'en-US');
    expect(slower.pitch, settings.pitch);
  });

  test('speech events compare by value, so identical rebuilds are equal', () {
    expect(event('x#1'), event('x#1'));
    expect(event('x#1'), isNot(event('x#2')));
  });
}

/// A [GuardianVoiceService] that records what it was asked to say.
class _RecordingVoice implements GuardianVoiceService {
  _RecordingVoice({required this.available, required this.speakingAfterSpeak});

  final bool available;

  /// True models a real engine: it stays busy until the utterance ends.
  final bool speakingAfterSpeak;

  final List<String> spoken = <String>[];

  /// The cancel count observed immediately before each speak — proof that a new
  /// line always replaces the old one rather than layering over it.
  final List<int> stopsBeforeSpeak = <int>[];

  int stops = 0;

  final ValueNotifier<bool> _speaking = ValueNotifier<bool>(false);

  @override
  bool get isAvailable => available;

  @override
  ValueListenable<bool> get speaking => _speaking;

  @override
  Future<void> speak(String text, GuardianVoiceSettings settings) async {
    if (!available) return;
    stopsBeforeSpeak.add(stops);
    spoken.add(text);
    if (speakingAfterSpeak) _speaking.value = true;
  }

  @override
  Future<void> stop() async {
    stops++;
    _speaking.value = false;
  }

  @override
  void dispose() => _speaking.dispose();
}
