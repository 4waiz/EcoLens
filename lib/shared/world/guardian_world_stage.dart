import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/guardian_valley.dart';
import 'guardian_world_assets.dart';

/// Where the Guardian and its speech bubble sit, resolved in world space.
@immutable
class GuardianStageMetrics {
  const GuardianStageMetrics({
    required this.feet,
    required this.guardianHeight,
    required this.daisWidth,
  });

  /// Point the Guardian's feet rest on, in viewport pixels.
  final Offset feet;
  final double guardianHeight;
  final double daisWidth;

  double get headY => feet.dy - guardianHeight;
}

/// ---------------------------------------------------------------------------
/// Positions the Guardian **inside the world**, not inside the UI column.
///
/// The base plate is `BoxFit.cover`-ed, so the stone dais painted into it lands
/// somewhere different at every aspect ratio. This widget reproduces that cover
/// transform and plants the Guardian's feet on the dais wherever it ends up —
/// which is why the character never floats above or sinks below its platform.
///
/// Living in the world layer also means the foreground grass plate draws *over*
/// the Guardian's feet, which is what sells the depth.
/// ---------------------------------------------------------------------------
class GuardianWorldStage extends StatelessWidget {
  const GuardianWorldStage({
    super.key,
    required this.guardianBuilder,
    this.speechBuilder,
    this.usePaintedDais = false,
    this.animateDais = true,
    this.minTop = 0,
  });

  /// Builds the Guardian at the resolved height.
  final Widget Function(BuildContext context, double height) guardianBuilder;

  /// Optional speech bubble, placed above the Guardian's head.
  final Widget Function(BuildContext context, double maxWidth)? speechBuilder;

  /// The procedural world has no painted platform, so it draws one.
  final bool usePaintedDais;
  final bool animateDais;

  /// Lowest y the speech bubble may reach — keeps it clear of the HUD.
  final double minTop;

  static GuardianStageMetrics metricsFor(
    Size viewport, {
    bool painted = false,
  }) {
    final plate = GuardianWorldAssets.plateSize;
    final anchor = painted
        ? GuardianWorldAssets.paintedAnchor
        : GuardianWorldAssets.daisAnchor;
    final factor = painted
        ? GuardianWorldAssets.paintedGuardianHeightFactor
        : GuardianWorldAssets.guardianHeightFactor;

    // Reproduce BoxFit.cover.
    final scale = math.max(
      viewport.width / plate.width,
      viewport.height / plate.height,
    );
    final rendered = Size(plate.width * scale, plate.height * scale);
    final origin = Offset(
      (viewport.width - rendered.width) / 2,
      (viewport.height - rendered.height) / 2,
    );

    final feet = Offset(
      origin.dx + anchor.dx * rendered.width,
      origin.dy + anchor.dy * rendered.height,
    );
    return GuardianStageMetrics(
      feet: feet,
      guardianHeight: rendered.height * factor,
      daisWidth: rendered.width * GuardianWorldAssets.daisWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = Size(constraints.maxWidth, constraints.maxHeight);
        var m = metricsFor(viewport, painted: usePaintedDais);

        // Never let the Guardian push into the HUD on a short window.
        final available = m.feet.dy - minTop;
        final height = math.min(m.guardianHeight, math.max(available, 80.0));
        m = GuardianStageMetrics(
          feet: m.feet,
          guardianHeight: height,
          daisWidth: m.daisWidth,
        );

        final width = height * 0.94;
        final bubbleGap = height * 0.06;
        final bubbleMaxWidth = math.min(viewport.width * 0.42, 460.0);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (usePaintedDais)
              Positioned(
                left: m.feet.dx - m.daisWidth * 0.62,
                top: m.feet.dy - height * 0.13,
                width: m.daisWidth * 1.24,
                height: height * 0.26,
                child: GuardianDais(animate: animateDais),
              ),
            Positioned(
              left: m.feet.dx - width / 2,
              top: m.feet.dy - height,
              width: width,
              height: height,
              child: guardianBuilder(context, height),
            ),
            if (speechBuilder != null)
              Positioned(
                left: 0,
                right: 0,
                // Anchored by its BOTTOM to just above the Guardian's head, and
                // sized by its own content. A fixed band here would clip (and
                // overflow) as soon as a line of dialogue wrapped, or as soon as
                // the bigger-text setting grew the type.
                bottom: math.max(
                  0.0,
                  viewport.height - math.max(minTop, m.headY - bubbleGap),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionalTranslation(
                    // Centre the bubble on the Guardian, not on the viewport.
                    translation: Offset(
                      (m.feet.dx - viewport.width / 2) / viewport.width,
                      0,
                    ),
                    child: speechBuilder!(context, bubbleMaxWidth),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
