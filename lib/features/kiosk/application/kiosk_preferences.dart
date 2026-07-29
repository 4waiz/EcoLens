import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Student-facing accessibility + sound preferences for the kiosk.
///
/// These live on the DEVICE (not the student account) so a child never has to
/// configure anything: whatever the last person set stays until it is changed
/// again, and nothing is persisted against an identity.
class KioskPreferences {
  const KioskPreferences({
    this.soundEnabled = true,
    this.reduceMotion = false,
    this.largeText = false,
  });

  /// Play a short confirmation sound on every touch.
  final bool soundEnabled;

  /// Freeze the ambient world animation (drifting clouds, falling leaves,
  /// waterfall shimmer). Important for motion-sensitive students.
  final bool reduceMotion;

  /// Bump the UI scale so labels are easier to read from a distance.
  final bool largeText;

  /// Extra multiplier applied on top of the surface-derived game scale.
  double get textScaleBoost => largeText ? 1.12 : 1.0;

  KioskPreferences copyWith({
    bool? soundEnabled,
    bool? reduceMotion,
    bool? largeText,
  }) {
    return KioskPreferences(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      largeText: largeText ?? this.largeText,
    );
  }
}

class KioskPreferencesController extends StateNotifier<KioskPreferences> {
  KioskPreferencesController() : super(const KioskPreferences());

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    click();
  }

  void toggleReduceMotion() {
    state = state.copyWith(reduceMotion: !state.reduceMotion);
    click();
  }

  void toggleLargeText() {
    state = state.copyWith(largeText: !state.largeText);
    click();
  }

  /// A short touch confirmation, honoured only when sound is enabled.
  void click() {
    if (!state.soundEnabled) return;
    SystemSound.play(SystemSoundType.click);
  }
}

final kioskPreferencesProvider =
    StateNotifierProvider<KioskPreferencesController, KioskPreferences>(
      (ref) => KioskPreferencesController(),
    );
