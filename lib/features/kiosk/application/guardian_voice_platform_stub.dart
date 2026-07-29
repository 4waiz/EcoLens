import 'guardian_voice_service.dart';

/// The voice implementation for every non-web target.
///
/// Android, iOS, Windows and the test VM have no zero-dependency synthesiser
/// reachable from Dart, so the Guardian stays silent there and every other part
/// of the experience — the dialogue bubble, the written line, the interaction —
/// carries on unchanged.
///
/// To give Android a voice, add `flutter_tts` and return an implementation of
/// [GuardianVoiceService] from here. Nothing else in the app changes: the
/// coordinator, the mute rules, the dedupe and the replay control all sit above
/// this interface.
GuardianVoiceService createPlatformGuardianVoice() => SilentGuardianVoice();
