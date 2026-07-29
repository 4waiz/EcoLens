import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// One number that sizes the entire game interface.
///
/// Every component multiplies its design-space measurements by this factor, so
/// the whole UI shrinks gracefully on a small window and grows on a 4K kiosk
/// WITHOUT any layout ever overflowing.
///
/// Kept in its own file so both the original game kit (`game_ui.dart`) and the
/// Guardian Valley kit (`valley_ui.dart`) can depend on it without one having to
/// import the other.
/// ---------------------------------------------------------------------------

/// Provides the current UI scale to the whole game subtree.
class GameScale extends InheritedWidget {
  const GameScale({super.key, required this.scale, required super.child});

  final double scale;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GameScale>()?.scale ?? 1.0;

  @override
  bool updateShouldNotify(GameScale oldWidget) => oldWidget.scale != scale;
}

extension GameScaleX on BuildContext {
  /// The current game UI scale factor.
  double get gameScale => GameScale.of(this);

  /// Scales a design-space value into the current surface.
  double gs(double designValue) => designValue * GameScale.of(this);
}

/// Wraps [child] in a [GameScale] derived from the surface size.
///
/// The design canvas is 1440 x 860 logical pixels (a 16:10 kiosk). The scale is
/// clamped so text stays legible on small dev windows and does not become
/// cartoonishly large on very tall displays.
class GameStage extends StatelessWidget {
  const GameStage({
    super.key,
    required this.builder,
    this.designHeight = 860,
    this.designWidth = 1440,
    this.minScale = 0.52,
    // Generous ceiling: the hero layouts absorb extra scale in their flexible
    // centre stage, so a large kiosk (and the "bigger text" boost) can grow the
    // UI without the fixed chrome ever exceeding the surface.
    this.maxScale = 1.55,
    this.boost = 1.0,
  });

  final Widget Function(BuildContext context, double scale) builder;
  final double designHeight;
  final double designWidth;
  final double minScale;
  final double maxScale;

  /// Accessibility multiplier (e.g. the kiosk "bigger text" toggle). Applied
  /// before clamping so it can never push the layout past [maxScale].
  final double boost;

  /// The scale this stage would resolve for [surface].
  ///
  /// Exposed so subtrees rendered *outside* the stage — the Guardian and its
  /// speech bubble, which live in the world layer — can size themselves
  /// identically instead of silently falling back to 1.0.
  static double scaleFor(
    Size surface, {
    double boost = 1.0,
    double designHeight = 860,
    double designWidth = 1440,
    double minScale = 0.52,
    double maxScale = 1.55,
  }) {
    final raw =
        math.min(
          surface.height / designHeight,
          (surface.width / designWidth) * 1.25,
        ) *
        boost;
    return raw.clamp(minScale, maxScale);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : designHeight;
        final w = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : designWidth;
        // Height drives the scale (kiosks are height-constrained); width acts
        // as a ceiling so a short-and-narrow window still fits.
        final raw =
            math.min(h / designHeight, (w / designWidth) * 1.25) * boost;
        final scale = raw.clamp(minScale, maxScale);
        return GameScale(
          scale: scale,
          child: Builder(builder: (context) => builder(context, scale)),
        );
      },
    );
  }
}
