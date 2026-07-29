import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// The single source of truth for every generated Guardian Valley asset.
///
/// Nothing else in the app spells out an asset path. That matters because the
/// art is replaceable: a school can regenerate the valley or the Guardian and
/// only this file changes. It also lets the loader verify the whole manifest up
/// front and fall back cleanly when a file is missing.
/// ---------------------------------------------------------------------------

/// How the valley behind the UI is drawn.
enum GuardianWorldRenderMode {
  /// The generated painted art, composited as parallax layers. Preferred.
  generatedArt,

  /// The procedural Flutter world (`valley_painters.dart`). Used when the art
  /// cannot be loaded, in tests, and as a deliberate low-resource mode.
  paintedFallback,

  /// Generated art held on a single frame: no parallax, no drift, no
  /// decorative particles. For motion-sensitive students and weak hardware.
  reducedMotion,
}

extension GuardianWorldRenderModeX on GuardianWorldRenderMode {
  bool get usesGeneratedArt => this != GuardianWorldRenderMode.paintedFallback;

  /// Whether ambient decoration is allowed to move.
  bool get animates => this != GuardianWorldRenderMode.reducedMotion;

  String get label => switch (this) {
    GuardianWorldRenderMode.generatedArt => 'Painted valley',
    GuardianWorldRenderMode.paintedFallback => 'Drawn valley (low resource)',
    GuardianWorldRenderMode.reducedMotion => 'Painted valley (calm)',
  };
}

/// One parallax plate of the generated valley.
@immutable
class WorldLayerAsset {
  const WorldLayerAsset({
    required this.path,
    required this.parallax,
    this.opacity = 1.0,
    this.blend = BlendMode.srcOver,
  });

  final String path;

  /// Maximum travel in logical pixels for this plate. Kept deliberately small:
  /// the valley should breathe, not swim.
  final double parallax;

  final double opacity;

  final BlendMode blend;
}

/// Every generated asset the world and the Guardian need.
abstract final class GuardianWorldAssets {
  static const String _bg = 'assets/backgrounds/';
  static const String guardianDir = 'assets/guardian/';

  /// The valley plates, in painting order (furthest first).
  static const WorldLayerAsset base = WorldLayerAsset(
    path: '${_bg}guardian_valley_base.webp',
    parallax: 2,
  );

  /// The cloud plate ships as a **PNG**, not WebP, unlike every other layer.
  ///
  /// Clouds are pure white drawn at partial opacity across their whole extent,
  /// so they are the one plate whose alpha channel carries most of the picture.
  /// WebP's lossy alpha put faint blocking into the soft cloud edges where it
  /// was most visible — against a flat sky, with the plate scrolling. PNG's
  /// lossless alpha costs ~140 KB more and is the right trade here.
  ///
  /// Do not transcode this back to WebP. See `docs/ecolens_background_prompt.md`.
  static const WorldLayerAsset clouds = WorldLayerAsset(
    path: '${_bg}guardian_valley_clouds.png',
    parallax: 9,
    opacity: 0.92,
  );

  /// The stream shimmer. Its confinement to the stream is baked into the
  /// asset's alpha (see tool/prepare_art_assets.py), so no runtime clip or
  /// mask is needed — and there is no hard band edge across the meadow.
  static const WorldLayerAsset water = WorldLayerAsset(
    path: '${_bg}guardian_valley_water.webp',
    parallax: 5,
    opacity: 0.55,
  );

  static const WorldLayerAsset particles = WorldLayerAsset(
    path: '${_bg}guardian_valley_particles.webp',
    parallax: 6,
    // Kept low: this plate is atmosphere, and the animated motes above it are
    // what the eye should follow.
    opacity: 0.42,
  );

  static const WorldLayerAsset foreground = WorldLayerAsset(
    path: '${_bg}guardian_valley_foreground.webp',
    parallax: 12,
  );

  static const List<WorldLayerAsset> layers = [
    base,
    clouds,
    water,
    particles,
    foreground,
  ];

  /// The intrinsic size every plate was normalised to. Used to pick a sensible
  /// decode resolution rather than decoding at full size on a small kiosk.
  static const Size plateSize = Size(1376, 768);

  /// Where the Guardian's feet meet the stone dais painted into the base
  /// plate, in plate-normalised coordinates. Measured from the artwork: the
  /// dais spans x 0.396–0.600 and its top surface sits at y ≈ 0.67.
  static const Offset daisAnchor = Offset(0.498, 0.688);

  /// Width of the painted dais as a fraction of the plate.
  static const double daisWidth = 0.204;

  /// Guardian height as a fraction of the *rendered* plate height, chosen so
  /// its stance covers roughly 85% of the dais.
  static const double guardianHeightFactor = 0.47;

  /// The same anchor for the procedural world, which has no painted dais and
  /// draws its own.
  static const Offset paintedAnchor = Offset(0.5, 0.745);
  static const double paintedGuardianHeightFactor = 0.46;

  /// Legacy single-image Guardian, kept as the third rung of the fallback
  /// ladder below the emotion set.
  static const String legacyGuardian = 'assets/images/guardian_dragon.png';

  static List<String> get allPaths => [
    for (final l in layers) l.path,
    legacyGuardian,
  ];
}
