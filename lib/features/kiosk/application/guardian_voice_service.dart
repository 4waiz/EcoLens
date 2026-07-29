import 'package:flutter/foundation.dart';

import 'guardian_voice_platform_stub.dart'
    if (dart.library.js_interop) 'guardian_voice_platform_web.dart'
    as platform;

/// ---------------------------------------------------------------------------
/// How the Guardian's voice is produced.
///
/// The kiosk never talks to a speech engine directly: it talks to this
/// interface, and one small platform file decides what is behind it. That is
/// what lets EcoLens ship a talking mascot with **no cloud service, no API key
/// and no third-party voice recordings** — and stay completely functional on a
/// device that cannot speak at all.
///
/// Implementations must honour three hard rules:
///   * [speak] never overlaps itself — a new line replaces the old one;
///   * a missing, blocked or broken engine is swallowed, never thrown: audio is
///     an enhancement and must never take a kiosk down;
///   * [speaking] is the single source of truth for the "Sprout is talking"
///     visual, so it has to settle back to false even when a browser silently
///     refuses to play.
/// ---------------------------------------------------------------------------
abstract class GuardianVoiceService {
  /// Whether this device can actually speak. False switches the whole feature
  /// off cleanly: the speech bubble stays, the replay button disappears.
  bool get isAvailable;

  /// True while a line is being spoken. Drives the bubble's talking indicator.
  ValueListenable<bool> get speaking;

  /// Speak [text], replacing anything currently being spoken.
  Future<void> speak(String text, GuardianVoiceSettings settings);

  /// Stop immediately and clear [speaking].
  Future<void> stop();

  void dispose();
}

/// How the Guardian sounds.
///
/// Tuned for a warm, youthful cartoon mascot a 7-year-old can follow across a
/// noisy corridor: very slightly slower than default so consonants survive, and
/// only mildly raised in pitch — a squeaky voice is harder to understand, not
/// friendlier.
@immutable
class GuardianVoiceSettings {
  const GuardianVoiceSettings({
    this.rate = 0.97,
    this.pitch = 1.16,
    this.volume = 1.0,
    this.language = 'en-GB',
  });

  final double rate;
  final double pitch;
  final double volume;
  final String language;

  GuardianVoiceSettings copyWith({
    double? rate,
    double? pitch,
    double? volume,
    String? language,
  }) => GuardianVoiceSettings(
    rate: rate ?? this.rate,
    pitch: pitch ?? this.pitch,
    volume: volume ?? this.volume,
    language: language ?? this.language,
  );
}

/// A voice service that cannot speak.
///
/// Used on every platform without a built-in synthesiser, and in tests. It is a
/// first-class implementation rather than a null check scattered through the
/// app: everything downstream keeps working, silently.
class SilentGuardianVoice implements GuardianVoiceService {
  final ValueNotifier<bool> _speaking = ValueNotifier<bool>(false);

  @override
  bool get isAvailable => false;

  @override
  ValueListenable<bool> get speaking => _speaking;

  @override
  Future<void> speak(String text, GuardianVoiceSettings settings) async {}

  @override
  Future<void> stop() async {}

  @override
  void dispose() => _speaking.dispose();
}

/// The voice for this platform.
///
/// Web resolves to the browser's own `speechSynthesis` (no dependency, no
/// network, no key). Everything else resolves to [SilentGuardianVoice] until a
/// native engine is wired in — see `docs/guardian_voice_and_interaction.md`.
GuardianVoiceService createGuardianVoiceService() =>
    platform.createPlatformGuardianVoice();
