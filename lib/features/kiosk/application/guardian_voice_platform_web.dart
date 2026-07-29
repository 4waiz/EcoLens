import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/foundation.dart';

import 'guardian_voice_service.dart';

/// ---------------------------------------------------------------------------
/// The Guardian's voice on Flutter Web, spoken by the browser itself.
///
/// Bound straight to the platform `speechSynthesis` API through
/// `dart:js_interop`, so there is no package, no download, no network call and
/// no API key anywhere in the path — the kiosk works offline and a school's
/// firewall cannot mute the mascot.
///
/// Everything here is defensive. A browser may:
///   * not implement speech synthesis at all;
///   * report zero voices until an asynchronous `voiceschanged` event;
///   * refuse to play until the page has seen a real user gesture;
///   * drop `onend` entirely when it silently declines to speak.
///
/// So the engine is probed lazily, the voice list is re-resolved until it is
/// populated, and a watchdog always clears the speaking flag. None of these
/// paths are allowed to throw.
/// ---------------------------------------------------------------------------

@JS('speechSynthesis')
external _SpeechSynthesis get _synth;

@JS()
extension type _SpeechSynthesis._(JSObject _) implements JSObject {
  external void speak(_Utterance utterance);
  external void cancel();
  external JSArray<_Voice> getVoices();
}

@JS('SpeechSynthesisUtterance')
extension type _Utterance._(JSObject _) implements JSObject {
  external factory _Utterance(String text);
  external set rate(double value);
  external set pitch(double value);
  external set volume(double value);
  external set lang(String value);
  external set voice(_Voice? value);
  external set onend(JSFunction value);
  external set onerror(JSFunction value);
}

@JS()
extension type _Voice._(JSObject _) implements JSObject {
  external String get name;
  external String get lang;
}

/// Voices that read as a friendly young cartoon character, most wanted first.
///
/// This is a *preference* list, not a requirement: any English voice is used
/// before falling back to the browser default, and no real person is imitated —
/// these are the stock system voices every browser already ships.
const List<String> _preferredVoices = [
  'Google UK English Female',
  'Microsoft Libby Online (Natural) - English (United Kingdom)',
  'Microsoft Sonia Online (Natural) - English (United Kingdom)',
  'Microsoft Aria Online (Natural) - English (United States)',
  'Samantha',
  'Karen',
  'Tessa',
  'Moira',
  'Google US English',
];

class WebGuardianVoice implements GuardianVoiceService {
  WebGuardianVoice._(this._supported);

  factory WebGuardianVoice() {
    var supported = false;
    try {
      // Probing the global rather than the typed getter: reading an undefined
      // global through an external getter is not guaranteed to be safe.
      supported =
          globalContext.has('speechSynthesis') &&
          globalContext.has('SpeechSynthesisUtterance');
    } catch (_) {
      supported = false;
    }
    return WebGuardianVoice._(supported);
  }

  final bool _supported;
  final ValueNotifier<bool> _speaking = ValueNotifier<bool>(false);

  _Voice? _voice;
  bool _disposed = false;

  /// Cleared when the utterance ends. Also cancels the watchdog below.
  Timer? _watchdog;

  @override
  bool get isAvailable => _supported;

  @override
  ValueListenable<bool> get speaking => _speaking;

  /// The best available voice, resolved once the browser has populated its
  /// list. Chrome reports an empty list on the first call, so this keeps
  /// returning null (browser default) until voices appear.
  _Voice? _resolveVoice(String language) {
    if (_voice != null) return _voice;
    late final List<_Voice> voices;
    try {
      voices = _synth.getVoices().toDart;
    } catch (_) {
      return null;
    }
    if (voices.isEmpty) return null;

    for (final wanted in _preferredVoices) {
      for (final v in voices) {
        if (v.name == wanted) return _voice = v;
      }
    }
    // Same language family, then any English voice, then leave it to the
    // browser — a default voice is far better than silence.
    final family = language.split('-').first.toLowerCase();
    for (final v in voices) {
      if (v.lang.toLowerCase() == language.toLowerCase()) return _voice = v;
    }
    for (final v in voices) {
      if (v.lang.toLowerCase().startsWith(family)) return _voice = v;
    }
    return null;
  }

  @override
  Future<void> speak(String text, GuardianVoiceSettings settings) async {
    if (!_supported || _disposed || text.trim().isEmpty) return;

    // No overlap, ever: whatever is being said is dropped first.
    await stop();
    if (_disposed) return;

    try {
      final utterance = _Utterance(text)
        ..rate = settings.rate
        ..pitch = settings.pitch
        ..volume = settings.volume
        ..lang = settings.language;

      final voice = _resolveVoice(settings.language);
      if (voice != null) utterance.voice = voice;

      void finished() {
        _watchdog?.cancel();
        _watchdog = null;
        if (!_disposed) _speaking.value = false;
      }

      utterance.onend = ((JSObject _) => finished()).toJS;
      // An error here is normal, not exceptional: an autoplay policy blocking
      // the first line before any user gesture arrives here.
      utterance.onerror = ((JSObject _) => finished()).toJS;

      _speaking.value = true;
      _synth.speak(utterance);

      // Belt and braces. Some browsers never fire `onend` when they decline to
      // speak, which would leave the talking indicator stuck on forever.
      // ~85ms per word is a generous ceiling for the one-sentence lines the
      // Guardian uses.
      final words = text.trim().split(RegExp(r'\s+')).length;
      _watchdog = Timer(
        Duration(milliseconds: 1200 + words * 380), // upper bound, not a guess
        finished,
      );
    } catch (error) {
      // Any synthesis failure degrades to silence; the written line stands.
      _speaking.value = false;
      if (kDebugMode) {
        debugPrint('EcoLens: Guardian voice unavailable — $error');
      }
    }
  }

  @override
  Future<void> stop() async {
    _watchdog?.cancel();
    _watchdog = null;
    if (!_supported) return;
    try {
      _synth.cancel();
    } catch (_) {
      // Nothing to cancel.
    }
    if (!_disposed) _speaking.value = false;
  }

  @override
  void dispose() {
    _disposed = true;
    _watchdog?.cancel();
    _watchdog = null;
    try {
      if (_supported) _synth.cancel();
    } catch (_) {
      // Ignored: the page is going away.
    }
    _speaking.dispose();
  }
}

GuardianVoiceService createPlatformGuardianVoice() => WebGuardianVoice();
