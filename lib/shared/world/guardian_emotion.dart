import 'package:flutter/material.dart';

import 'guardian_world_assets.dart';

/// ---------------------------------------------------------------------------
/// The Guardian's expression vocabulary.
///
/// Each emotion owns its artwork, its motion profile, its priority and how long
/// it must stay on screen. Screens never name an asset or a duration — they
/// request an emotion and the controller decides whether and when to show it.
/// ---------------------------------------------------------------------------
enum GuardianEmotion {
  /// Resting on the attract screen. Everything decays back to this.
  idle,

  /// A student has just been recognised.
  welcome,

  /// Waiting on the student — card tap, or an item held up to the camera.
  listening,

  /// Working: reading a card, running classification.
  thinking,

  /// The student sorted correctly.
  correct,

  /// A first wrong guess. Gentle, never a harsh error.
  tryAgain,

  /// Repeated wrong guesses — supportive rather than corrective.
  encourage,

  /// A mission or daily goal is complete.
  celebrate,

  /// A new Guardian level was reached.
  levelUp,

  /// The session is ending.
  goodbye,
}

/// Per-emotion positional correction.
///
/// The generated frames are on a shared 1024² canvas and turned out to be very
/// well registered — the head centroid sits within 1.1% of canvas width across
/// the whole set. Only three frames drift enough to read as a jump during a
/// cross-fade, so only those three carry a correction; everything else uses the
/// neutral default. Values are fractions of the rendered box.
@immutable
class GuardianEmotionLayout {
  const GuardianEmotionLayout({
    this.alignment = Alignment.bottomCenter,
    this.translation = Offset.zero,
    this.scale = 1.0,
  });

  final Alignment alignment;

  /// Fractions of the rendered size, applied as a translation. Positive x moves
  /// right, positive y moves down.
  final Offset translation;

  final double scale;

  static const GuardianEmotionLayout neutral = GuardianEmotionLayout();
}

/// How an emotion moves once it is on screen.
@immutable
class GuardianMotionProfile {
  const GuardianMotionProfile({
    required this.period,
    this.breathe = 0.012,
    this.bob = 0.018,
    this.sway = 0.010,
    this.tilt = 0.0,
    this.jump = 0.0,
    this.jumps = 1,
    this.spin = 0.0,
    this.sparkle = false,
    this.glow,
  });

  /// Length of one idle cycle.
  final Duration period;

  /// Vertical scale amplitude of the breathing loop.
  final double breathe;

  /// Vertical bob amplitude, as a fraction of the Guardian's height.
  final double bob;

  /// Horizontal rocking amplitude in radians.
  final double sway;

  /// Static lean in radians (thinking tilts its head, listening leans in).
  final double tilt;

  /// Height of the entrance hop, as a fraction of the Guardian's height.
  /// Every expression change plays at least a small one.
  final double jump;

  /// How many hops the entrance plays.
  final int jumps;

  /// Rotation during the entrance hop, in radians.
  final double spin;

  /// Whether the entrance throws a leaf/sparkle burst.
  final bool sparkle;

  /// Aura colour. Null keeps the calm default.
  final Color? glow;
}

extension GuardianEmotionX on GuardianEmotion {
  String get assetPath =>
      '${GuardianWorldAssets.guardianDir}guardian_$_fileStem.webp';

  String get _fileStem => switch (this) {
    GuardianEmotion.idle => 'idle',
    GuardianEmotion.welcome => 'welcome',
    GuardianEmotion.listening => 'listening',
    GuardianEmotion.thinking => 'thinking',
    GuardianEmotion.correct => 'correct',
    GuardianEmotion.tryAgain => 'try_again',
    GuardianEmotion.encourage => 'encourage',
    GuardianEmotion.celebrate => 'celebrate',
    GuardianEmotion.levelUp => 'level_up',
    GuardianEmotion.goodbye => 'goodbye',
  };

  /// Measured correction so the character does not shift during a cross-fade.
  /// See `docs/guardian_emotion_system.md` for how these were derived.
  GuardianEmotionLayout get layout => switch (this) {
    // Head centroid sits 0.42% left and the feet 0.59% low on these frames.
    GuardianEmotion.celebrate => const GuardianEmotionLayout(
      translation: Offset(0.0042, -0.0059),
    ),
    GuardianEmotion.levelUp => const GuardianEmotionLayout(
      translation: Offset(0.0042, -0.0039),
    ),
    GuardianEmotion.goodbye => const GuardianEmotionLayout(
      translation: Offset(0.0107, -0.0039),
    ),
    _ => GuardianEmotionLayout.neutral,
  };

  /// Higher wins. A celebration is never stomped on by a routine update.
  int get priority => switch (this) {
    GuardianEmotion.idle => 0,
    GuardianEmotion.listening => 1,
    GuardianEmotion.thinking => 1,
    GuardianEmotion.welcome => 2,
    GuardianEmotion.tryAgain => 3,
    GuardianEmotion.encourage => 3,
    GuardianEmotion.correct => 3,
    GuardianEmotion.goodbye => 4,
    GuardianEmotion.celebrate => 5,
    GuardianEmotion.levelUp => 5,
  };

  /// How long this expression holds before anything of equal or lower priority
  /// may replace it. Deliberately short — a kiosk must never feel sluggish.
  Duration get minimumHold => switch (this) {
    GuardianEmotion.idle => Duration.zero,
    GuardianEmotion.listening => Duration.zero,
    // Interruptible: a result arriving mid-"thinking" should show immediately.
    GuardianEmotion.thinking => Duration.zero,
    GuardianEmotion.welcome => const Duration(milliseconds: 900),
    GuardianEmotion.correct => const Duration(milliseconds: 900),
    GuardianEmotion.tryAgain => const Duration(milliseconds: 800),
    GuardianEmotion.encourage => const Duration(milliseconds: 800),
    GuardianEmotion.celebrate => const Duration(milliseconds: 1600),
    GuardianEmotion.levelUp => const Duration(milliseconds: 1600),
    GuardianEmotion.goodbye => const Duration(milliseconds: 1400),
  };

  /// Emotions that are a moment rather than a state: once their hold expires
  /// they decay back to [idle] on their own.
  bool get isTransient => switch (this) {
    GuardianEmotion.correct ||
    GuardianEmotion.tryAgain ||
    GuardianEmotion.encourage ||
    GuardianEmotion.celebrate ||
    GuardianEmotion.levelUp ||
    GuardianEmotion.welcome => true,
    _ => false,
  };

  /// Motion around the static frame. Every expression entrance includes a small
  /// hop so a change of face always reads as the character *doing* something.
  GuardianMotionProfile get motion => switch (this) {
    GuardianEmotion.idle => const GuardianMotionProfile(
      period: Duration(milliseconds: 3200),
      breathe: 0.015,
      bob: 0.010,
      jump: 0.020,
    ),
    GuardianEmotion.welcome => const GuardianMotionProfile(
      period: Duration(milliseconds: 1500),
      breathe: 0.018,
      bob: 0.022,
      sway: 0.030,
      jump: 0.070,
      jumps: 2,
      glow: Color(0xFF8BE08F),
    ),
    GuardianEmotion.listening => const GuardianMotionProfile(
      period: Duration(milliseconds: 2400),
      breathe: 0.014,
      bob: 0.012,
      tilt: 0.028,
      jump: 0.028,
    ),
    GuardianEmotion.thinking => const GuardianMotionProfile(
      period: Duration(milliseconds: 2800),
      breathe: 0.010,
      bob: 0.008,
      sway: 0.026,
      tilt: -0.034,
      jump: 0.022,
      glow: Color(0xFF8ECBF5),
    ),
    GuardianEmotion.correct => const GuardianMotionProfile(
      period: Duration(milliseconds: 1100),
      breathe: 0.020,
      bob: 0.024,
      jump: 0.085,
      jumps: 2,
      sparkle: true,
      glow: Color(0xFF7BE08B),
    ),
    GuardianEmotion.tryAgain => const GuardianMotionProfile(
      period: Duration(milliseconds: 1900),
      breathe: 0.012,
      bob: 0.010,
      // A gentle side-to-side rock, never an aggressive error shake.
      sway: 0.038,
      jump: 0.030,
      glow: Color(0xFFFFC773),
    ),
    GuardianEmotion.encourage => const GuardianMotionProfile(
      period: Duration(milliseconds: 2000),
      breathe: 0.020,
      bob: 0.016,
      jump: 0.045,
      glow: Color(0xFFFFB74D),
    ),
    GuardianEmotion.celebrate => const GuardianMotionProfile(
      period: Duration(milliseconds: 700),
      breathe: 0.030,
      bob: 0.030,
      jump: 0.150,
      jumps: 3,
      spin: 0.075,
      sparkle: true,
      glow: Color(0xFFFFD54F),
    ),
    GuardianEmotion.levelUp => const GuardianMotionProfile(
      period: Duration(milliseconds: 900),
      breathe: 0.026,
      bob: 0.026,
      jump: 0.120,
      jumps: 2,
      sparkle: true,
      glow: Color(0xFFFFE07A),
    ),
    GuardianEmotion.goodbye => const GuardianMotionProfile(
      period: Duration(milliseconds: 1700),
      breathe: 0.014,
      bob: 0.014,
      sway: 0.042,
      jump: 0.040,
      glow: Color(0xFF9FE8A6),
    ),
  };

  /// Sound cue, if this emotion should make a noise. Null stays silent.
  GuardianSoundCue? get soundCue => switch (this) {
    GuardianEmotion.welcome => GuardianSoundCue.welcome,
    GuardianEmotion.correct => GuardianSoundCue.correct,
    GuardianEmotion.tryAgain => GuardianSoundCue.tryAgain,
    GuardianEmotion.encourage => GuardianSoundCue.tryAgain,
    GuardianEmotion.celebrate => GuardianSoundCue.celebrate,
    GuardianEmotion.levelUp => GuardianSoundCue.levelUp,
    GuardianEmotion.goodbye => GuardianSoundCue.goodbye,
    _ => null,
  };
}

/// Abstract sound events. The kiosk maps these onto whatever audio (or haptic)
/// backend is configured; missing audio must never break the flow.
enum GuardianSoundCue {
  cardDetected,
  welcome,
  correct,
  tryAgain,
  celebrate,
  levelUp,
  goodbye,
}
