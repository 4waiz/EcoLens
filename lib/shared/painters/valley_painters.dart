import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// EcoLens "Guardian Valley" — the procedural game world.
///
/// The valley is painted entirely in Flutter (no bitmap background is required
/// at runtime, so the kiosk never depends on an online image service). Every
/// element is laid out in NORMALISED coordinates (0..1) so the same scene fills
/// any kiosk resolution, and every random placement is generated ONCE from a
/// fixed seed into [ValleyLayout] — painters only read it. That keeps the world
/// stable frame to frame (no jitter) while still animating.
///
/// If a school later wants a bespoke painted background, drop a 16:9 image in
/// `assets/images/` and pass it to `GuardianValley(backgroundImage: ...)`; the
/// procedural scene stays as the guaranteed offline fallback. See
/// `docs/ecolens_background_prompt.md` for the art brief.
/// ---------------------------------------------------------------------------

abstract final class ValleyPalette {
  // Sky
  static const Color skyTop = Color(0xFF5BB8E8);
  static const Color skyMid = Color(0xFF9CDCF2);
  static const Color skyHorizon = Color(0xFFDDF3E4);
  static const Color sunCore = Color(0xFFFFFBE0);
  static const Color sunGlow = Color(0xFFFFF0B8);
  static const Color cloud = Color(0xFFFFFFFF);

  // Peaks (atmospheric perspective: far = hazier / bluer)
  static const Color peakFar = Color(0xFFA9CEDC);
  static const Color peakFarLit = Color(0xFFC6E1EA);
  static const Color peakMid = Color(0xFF8FBBA6);
  static const Color peakMidLit = Color(0xFFB2D3BC);
  static const Color cliffRock = Color(0xFFC2A985);
  static const Color cliffRockLit = Color(0xFFDCC6A4);
  static const Color cliffShadow = Color(0xFF9C8564);
  static const Color cliffCap = Color(0xFF5F9E63);

  // Water
  static const Color fallBright = Color(0xFFF2FBFF);
  static const Color fallCool = Color(0xFFB9E2F5);
  static const Color pool = Color(0xFF7FC8E5);
  static const Color poolDeep = Color(0xFF4FA6CC);
  static const Color mist = Color(0xFFFFFFFF);

  // Forest bands
  static const Color forestFar = Color(0xFF6FA97F);
  static const Color forestMid = Color(0xFF4E8F5D);
  static const Color forestNear = Color(0xFF3C7749);
  static const Color forestDark = Color(0xFF2F6039);
  static const Color trunk = Color(0xFF7A5A3A);
  static const Color trunkDark = Color(0xFF5D4429);

  // Meadow
  static const Color meadowFar = Color(0xFF8FC96C);
  static const Color meadowMid = Color(0xFF74B855);
  static const Color meadowNear = Color(0xFF5EA347);
  static const Color meadowShade = Color(0xFF4C8C3C);

  // Stone dais
  static const Color stoneLit = Color(0xFFE3DCC4);
  static const Color stone = Color(0xFFCEC3A4);
  static const Color stoneShade = Color(0xFFAEA184);
  static const Color stoneEdge = Color(0xFF8E8168);
  static const Color runeGlow = Color(0xFF8BE08F);

  // Flora accents
  static const List<Color> flowers = [
    Color(0xFFFFE066),
    Color(0xFFFF8FA3),
    Color(0xFFFFFFFF),
    Color(0xFFC792EA),
    Color(0xFFFFB05C),
  ];
}

// ---------------------------------------------------------------------------
// Deterministic scene layout
// ---------------------------------------------------------------------------

@immutable
class ValleyCloud {
  const ValleyCloud(this.x, this.y, this.scale, this.opacity, this.drift);
  final double x, y, scale, opacity, drift;
}

@immutable
class ValleyTree {
  const ValleyTree(
    this.x,
    this.baseY,
    this.height,
    this.width,
    this.kind,
    this.tone,
  );

  /// 0 = conifer, 1 = round canopy, 2 = twin canopy
  final int kind;
  final double x, baseY, height, width, tone;
}

@immutable
class ValleySpeck {
  const ValleySpeck(this.x, this.y, this.size, this.colourIndex, this.phase);
  final double x, y, size, phase;
  final int colourIndex;
}

/// One-off procedural placement for the whole valley. Generated from a fixed
/// seed so the world looks hand-composed and never re-rolls between frames.
@immutable
class ValleyLayout {
  const ValleyLayout._({
    required this.clouds,
    required this.farTrees,
    required this.midTrees,
    required this.flowers,
    required this.grass,
  });

  final List<ValleyCloud> clouds;
  final List<ValleyTree> farTrees;
  final List<ValleyTree> midTrees;
  final List<ValleySpeck> flowers;
  final List<ValleySpeck> grass;

  /// The shared instance used by every kiosk screen.
  static final ValleyLayout standard = ValleyLayout.generate();

  factory ValleyLayout.generate({int seed = 20260729}) {
    final rnd = math.Random(seed);
    double between(double a, double b) => a + rnd.nextDouble() * (b - a);

    final clouds = <ValleyCloud>[
      for (var i = 0; i < 6; i++)
        ValleyCloud(
          between(-0.05, 1.05),
          between(0.05, 0.24),
          between(0.42, 0.82),
          between(0.26, 0.52),
          between(0.4, 1.0),
        ),
    ];

    // Far tree line — small silhouettes hugging the forest horizon.
    final farTrees = <ValleyTree>[
      for (var i = 0; i < 46; i++)
        ValleyTree(
          i / 45 + between(-0.012, 0.012),
          between(0.545, 0.575),
          between(0.045, 0.085),
          between(0.020, 0.034),
          rnd.nextDouble() < 0.72 ? 0 : 1,
          between(0.0, 1.0),
        ),
    ];

    // Mid tree line — fuller, taller, avoids the centre stage so the Guardian
    // always reads clearly against open meadow.
    final midTrees = <ValleyTree>[
      for (var i = 0; i < 26; i++)
        () {
          final x = i / 25;
          final centreGap = (x - 0.5).abs() < 0.17;
          return ValleyTree(
            x + between(-0.018, 0.018),
            between(0.600, 0.640),
            centreGap ? between(0.05, 0.075) : between(0.085, 0.155),
            centreGap ? between(0.030, 0.042) : between(0.038, 0.062),
            rnd.nextDouble() < 0.55 ? 0 : (rnd.nextDouble() < 0.5 ? 1 : 2),
            between(0.0, 1.0),
          );
        }(),
    ];

    final flowers = <ValleySpeck>[
      for (var i = 0; i < 90; i++)
        ValleySpeck(
          between(-0.02, 1.02),
          between(0.66, 1.02),
          between(0.0028, 0.0075),
          rnd.nextInt(ValleyPalette.flowers.length),
          between(0, math.pi * 2),
        ),
    ];

    final grass = <ValleySpeck>[
      for (var i = 0; i < 150; i++)
        ValleySpeck(
          between(-0.02, 1.02),
          between(0.64, 1.03),
          between(0.010, 0.030),
          0,
          between(0, math.pi * 2),
        ),
    ];

    return ValleyLayout._(
      clouds: clouds,
      farTrees: farTrees,
      midTrees: midTrees,
      flowers: flowers,
      grass: grass,
    );
  }
}

// ---------------------------------------------------------------------------
// Layer 1 — sky, sun, clouds, peaks, waterfalls
// ---------------------------------------------------------------------------

/// Sky + distant mountains + the twin waterfalls. [t] is a 0..1 looping clock
/// used for cloud drift and the falling-water shimmer.
class ValleySkyPainter extends CustomPainter {
  const ValleySkyPainter({required this.t, required this.layout});

  final double t;
  final ValleyLayout layout;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Offset.zero & size;

    // ---- Sky gradient -----------------------------------------------------
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ValleyPalette.skyTop,
            ValleyPalette.skyMid,
            ValleyPalette.skyHorizon,
          ],
          stops: [0.0, 0.42, 0.72],
        ).createShader(rect),
    );

    // ---- Sun + warm bloom (upper right, friendly daytime light) -----------
    final sun = Offset(w * 0.80, h * 0.10);
    canvas.drawCircle(
      sun,
      h * 0.30,
      Paint()
        ..shader = RadialGradient(
          colors: [
            ValleyPalette.sunGlow.withValues(alpha: 0.55),
            ValleyPalette.sunGlow.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: sun, radius: h * 0.30)),
    );
    canvas.drawCircle(
      sun,
      h * 0.055,
      Paint()..color = ValleyPalette.sunCore.withValues(alpha: 0.9),
    );

    // ---- Clouds -----------------------------------------------------------
    for (final c in layout.clouds) {
      final x = ((c.x + t * 0.06 * c.drift) % 1.24) - 0.12;
      _paintCloud(
        canvas,
        Offset(x * w, c.y * h),
        w * 0.085 * c.scale,
        c.opacity,
      );
    }

    // ---- Far peak range (hazy, atmospheric) -------------------------------
    _paintRange(
      canvas,
      size,
      baseY: 0.585,
      peaks: const [
        [-0.02, 0.34],
        [0.16, 0.25],
        [0.34, 0.36],
        [0.50, 0.28],
        [0.66, 0.36],
        [0.84, 0.23],
        [1.02, 0.33],
      ],
      spread: 0.13,
      body: ValleyPalette.peakFar,
      lit: ValleyPalette.peakFarLit,
      snow: true,
    );

    // ---- Mid peak / hill range -------------------------------------------
    _paintRange(
      canvas,
      size,
      baseY: 0.615,
      peaks: const [
        [-0.06, 0.46],
        [0.10, 0.41],
        [0.28, 0.48],
        [0.45, 0.42],
        [0.62, 0.48],
        [0.80, 0.40],
        [0.97, 0.47],
        [1.10, 0.42],
      ],
      spread: 0.12,
      body: ValleyPalette.peakMid,
      lit: ValleyPalette.peakMidLit,
      snow: false,
    );

    // ---- Cliff faces + waterfalls (left & right of the stage) -------------
    // Placed inside the framing trees and clear of the treeline so the falls
    // actually read from across a classroom.
    _paintCliffWithFall(canvas, size, cx: 0.200, topY: 0.320, width: 0.250);
    _paintCliffWithFall(canvas, size, cx: 0.800, topY: 0.355, width: 0.225);
  }

  void _paintCloud(Canvas canvas, Offset c, double r, double opacity) {
    final p = Paint()..color = ValleyPalette.cloud.withValues(alpha: opacity);
    canvas.drawOval(
      Rect.fromCenter(center: c, width: r * 2.6, height: r * 1.05),
      p,
    );
    canvas.drawCircle(c.translate(-r * 0.55, -r * 0.16), r * 0.55, p);
    canvas.drawCircle(c.translate(r * 0.05, -r * 0.38), r * 0.66, p);
    canvas.drawCircle(c.translate(r * 0.66, -r * 0.10), r * 0.46, p);
  }

  /// Draws one mountain range from normalised [peaks] (x, peakHeightFromTop).
  ///
  /// Flanks are drawn with slightly curved shoulders rather than straight
  /// lines so the range reads as rolling rock, not a row of paper cones.
  void _paintRange(
    Canvas canvas,
    Size size, {
    required double baseY,
    required List<List<double>> peaks,
    required double spread,
    required Color body,
    required Color lit,
    required bool snow,
  }) {
    final w = size.width;
    final h = size.height;
    final base = baseY * h;
    final half = spread * w;

    final path = Path()..moveTo(-w * 0.08, base);
    for (final p in peaks) {
      final px = p[0] * w;
      final py = p[1] * h;
      path
        ..lineTo(px - half, base)
        // Rounded shoulder up to the summit…
        ..quadraticBezierTo(px - half * 0.34, py + (base - py) * 0.30, px, py)
        // …and back down the sunlit side.
        ..quadraticBezierTo(
          px + half * 0.30,
          py + (base - py) * 0.26,
          px + half,
          base,
        );
    }
    path
      ..lineTo(w * 1.08, base)
      ..lineTo(w * 1.08, h)
      ..lineTo(-w * 0.08, h)
      ..close();
    canvas.drawPath(path, Paint()..color = body);

    // Sunlit right-hand faces + optional snowy caps.
    for (final p in peaks) {
      final px = p[0] * w;
      final py = p[1] * h;
      canvas.drawPath(
        Path()
          ..moveTo(px, py)
          ..quadraticBezierTo(
            px + half * 0.30,
            py + (base - py) * 0.26,
            px + half,
            base,
          )
          ..lineTo(px + half * 0.10, base)
          ..close(),
        Paint()..color = lit,
      );
      if (snow) {
        final capH = (base - py) * 0.20;
        canvas.drawPath(
          Path()
            ..moveTo(px, py)
            ..quadraticBezierTo(
              px + capH * 0.42,
              py + capH * 0.42,
              px + capH * 0.58,
              py + capH,
            )
            ..lineTo(px + capH * 0.16, py + capH * 0.66)
            ..lineTo(px - capH * 0.26, py + capH)
            ..lineTo(px - capH * 0.58, py + capH * 0.74)
            ..quadraticBezierTo(px - capH * 0.34, py + capH * 0.34, px, py)
            ..close(),
          Paint()..color = Colors.white.withValues(alpha: 0.88),
        );
      }
    }
  }

  /// A rocky outcrop with a shimmering waterfall dropping into a misty pool.
  ///
  /// The silhouette is deliberately stepped and asymmetric — square-shouldered
  /// cliffs read as buildings, which is the last thing an enchanted valley
  /// needs.
  void _paintCliffWithFall(
    Canvas canvas,
    Size size, {
    required double cx,
    required double topY,
    required double width,
  }) {
    final w = size.width;
    final h = size.height;
    final x = cx * w;
    final top = topY * h;
    final base = h * 0.600;
    final span = base - top;
    final halfW = width * w * 0.5;

    double ly(double f) => top + span * f;

    // ---- Rock body: a wide, stepped, leaning outcrop --------------------
    // Squat and asymmetric on purpose — tall narrow shapes read as towers.
    final rock = Path()
      ..moveTo(x - halfW * 1.30, base)
      ..lineTo(x - halfW * 1.06, ly(0.66))
      ..lineTo(x - halfW * 1.14, ly(0.50))
      ..lineTo(x - halfW * 0.86, ly(0.36))
      ..lineTo(x - halfW * 0.92, ly(0.22))
      ..lineTo(x - halfW * 0.52, ly(0.10))
      ..lineTo(x - halfW * 0.14, ly(0.02))
      ..lineTo(x + halfW * 0.30, top)
      ..lineTo(x + halfW * 0.66, ly(0.10))
      ..lineTo(x + halfW * 0.58, ly(0.26))
      ..lineTo(x + halfW * 1.00, ly(0.42))
      ..lineTo(x + halfW * 0.90, ly(0.60))
      ..lineTo(x + halfW * 1.24, base)
      ..close();
    canvas.drawPath(rock, Paint()..color = ValleyPalette.cliffRock);

    canvas.save();
    canvas.clipPath(rock);

    // Sunlit right flank.
    canvas.drawPath(
      Path()
        ..moveTo(x + halfW * 0.10, top)
        ..lineTo(x + halfW * 1.30, ly(0.30))
        ..lineTo(x + halfW * 1.30, base)
        ..lineTo(x + halfW * 0.28, base)
        ..close(),
      Paint()..color = ValleyPalette.cliffRockLit,
    );
    // Shadowed left flank.
    canvas.drawPath(
      Path()
        ..moveTo(x - halfW * 1.30, base)
        ..lineTo(x - halfW * 1.30, ly(0.18))
        ..lineTo(x - halfW * 0.44, ly(0.06))
        ..lineTo(x - halfW * 0.54, base)
        ..close(),
      Paint()..color = ValleyPalette.cliffShadow.withValues(alpha: 0.45),
    );

    // Horizontal strata — cheap, effective rock texture.
    final strata = Paint()
      ..color = ValleyPalette.cliffShadow.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, span * 0.012)
      ..strokeCap = StrokeCap.round;
    for (var i = 1; i < 6; i++) {
      final y = ly(0.18 + i * 0.135);
      canvas.drawPath(
        Path()
          ..moveTo(x - halfW * 1.2, y)
          ..quadraticBezierTo(
            x,
            y + span * 0.02,
            x + halfW * 1.2,
            y - span * 0.01,
          ),
        strata,
      );
    }
    canvas.restore();

    // ---- Green cap + a few little trees on the ledge --------------------
    canvas.drawPath(
      Path()
        ..moveTo(x - halfW * 0.58, ly(0.075))
        ..quadraticBezierTo(
          x - halfW * 0.20,
          ly(-0.035),
          x + halfW * 0.32,
          ly(0.005),
        )
        ..quadraticBezierTo(
          x + halfW * 0.58,
          ly(0.055),
          x + halfW * 0.66,
          ly(0.105),
        )
        ..quadraticBezierTo(x, ly(0.155), x - halfW * 0.58, ly(0.075))
        ..close(),
      Paint()..color = ValleyPalette.cliffCap,
    );
    for (var i = 0; i < 4; i++) {
      final tx = x + halfW * (-0.42 + i * 0.28);
      final ty = ly(0.055);
      final th = span * 0.15;
      canvas.drawPath(
        Path()
          ..moveTo(tx, ty - th)
          ..lineTo(tx + th * 0.32, ty)
          ..lineTo(tx - th * 0.32, ty)
          ..close(),
        Paint()..color = ValleyPalette.forestNear,
      );
    }

    // ---- Waterfall (offset from centre so the rock stays asymmetric) ----
    final fallX = x - halfW * 0.30;
    final fallTop = ly(0.20);
    final fallW = halfW * 0.34;
    final fallRect = Rect.fromLTRB(
      fallX - fallW * 0.5,
      fallTop,
      fallX + fallW * 0.5,
      base,
    );
    final fallShape = RRect.fromRectAndCorners(
      fallRect,
      topLeft: Radius.circular(fallW * 0.28),
      topRight: Radius.circular(fallW * 0.28),
      bottomLeft: Radius.circular(fallW * 0.45),
      bottomRight: Radius.circular(fallW * 0.45),
    );
    canvas.drawRRect(
      fallShape,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ValleyPalette.fallBright,
            ValleyPalette.fallCool,
            ValleyPalette.fallBright,
          ],
          stops: [0.0, 0.45, 1.0],
        ).createShader(fallRect),
    );

    // Falling highlight streaks — the only per-frame motion up here.
    canvas.save();
    canvas.clipRRect(fallShape);
    final streak = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 6; i++) {
      final phase = (t * 1.8 + i * 0.17) % 1.0;
      final sy = fallTop + phase * fallRect.height;
      final sx = fallX + (i - 2.5) * fallW * 0.18;
      streak.strokeWidth = fallW * (0.05 + (i % 2) * 0.035);
      canvas.drawLine(
        Offset(sx, sy),
        Offset(sx, sy + fallRect.height * 0.22),
        streak,
      );
    }
    canvas.restore();

    // Lip highlight where the water leaves the rock.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(fallX, fallTop),
        width: fallW * 1.12,
        height: span * 0.045,
      ),
      Paint()..color = ValleyPalette.fallBright,
    );

    // Pool + mist at the base.
    final poolRect = Rect.fromCenter(
      center: Offset(fallX, base),
      width: halfW * 1.5,
      height: h * 0.032,
    );
    canvas.drawOval(poolRect, Paint()..color = ValleyPalette.poolDeep);
    canvas.drawOval(
      poolRect.deflate(h * 0.005),
      Paint()..color = ValleyPalette.pool,
    );
    for (var i = 0; i < 4; i++) {
      final pulse = ((t * 0.9 + i * 0.25) % 1.0);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(fallX, base - h * 0.006 - pulse * h * 0.030),
          width: halfW * (0.6 + pulse * 0.9),
          height: h * (0.014 + pulse * 0.018),
        ),
        Paint()
          ..color = ValleyPalette.mist.withValues(alpha: 0.34 * (1 - pulse)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ValleySkyPainter old) =>
      old.t != t || old.layout != layout;
}

// ---------------------------------------------------------------------------
// Layer 2 — the forest bands
// ---------------------------------------------------------------------------

/// Two tree lines that sit between the peaks and the meadow. The centre of the
/// mid band deliberately thins out so the Guardian never fights the backdrop.
class ValleyForestPainter extends CustomPainter {
  const ValleyForestPainter({required this.layout, required this.sway});

  final ValleyLayout layout;

  /// −1..1 gentle breeze phase.
  final double sway;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Hazy band that fuses the forest into the mountains.
    canvas.drawRect(
      Rect.fromLTRB(0, h * 0.50, w, h * 0.66),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTRB(0, h * 0.50, w, h * 0.66)),
    );

    for (final tree in layout.farTrees) {
      _tree(canvas, size, tree, ValleyPalette.forestFar, 0.35);
    }
    for (final tree in layout.midTrees) {
      _tree(canvas, size, tree, ValleyPalette.forestMid, 1.0);
    }
  }

  void _tree(
    Canvas canvas,
    Size size,
    ValleyTree t,
    Color base,
    double detail,
  ) {
    final w = size.width;
    final h = size.height;
    final x = t.x * w;
    final baseY = t.baseY * h;
    final th = t.height * h;
    final tw = t.width * w;
    final lean = sway * tw * 0.10 * detail;

    final tone = Color.lerp(base, ValleyPalette.forestDark, t.tone * 0.35)!;

    if (t.kind == 0) {
      // Conifer — three stacked skirts.
      if (detail > 0.5) {
        canvas.drawRect(
          Rect.fromLTWH(x - tw * 0.09, baseY - th * 0.20, tw * 0.18, th * 0.22),
          Paint()..color = ValleyPalette.trunkDark,
        );
      }
      for (var i = 0; i < 3; i++) {
        final f = i / 3;
        final top = baseY - th * (1 - f * 0.42);
        final halfW = tw * (0.5 + f * 0.34);
        canvas.drawPath(
          Path()
            ..moveTo(x + lean * (1 - f), top)
            ..lineTo(x + halfW, top + th * 0.42)
            ..lineTo(x - halfW, top + th * 0.42)
            ..close(),
          Paint()..color = Color.lerp(tone, Colors.white, 0.10 - f * 0.05)!,
        );
      }
    } else {
      // Round / twin canopy. The trunk starts up inside the canopy so it never
      // reads as a fence post standing in the meadow.
      if (detail > 0.5) {
        canvas.drawRect(
          Rect.fromLTWH(x - tw * 0.07, baseY - th * 0.60, tw * 0.14, th * 0.62),
          Paint()..color = ValleyPalette.trunk,
        );
      }
      final cy = baseY - th * 0.58;
      final r = tw * 0.72;
      final p = Paint()..color = tone;
      canvas.drawCircle(Offset(x + lean, cy), r, p);
      canvas.drawCircle(
        Offset(x - r * 0.68 + lean, cy + r * 0.34),
        r * 0.72,
        p,
      );
      canvas.drawCircle(
        Offset(x + r * 0.70 + lean, cy + r * 0.30),
        r * 0.68,
        p,
      );
      if (t.kind == 2) {
        canvas.drawCircle(
          Offset(x + lean, cy - r * 0.62),
          r * 0.66,
          Paint()..color = Color.lerp(tone, Colors.white, 0.12)!,
        );
      }
      // Sunlit crown.
      canvas.drawCircle(
        Offset(x + r * 0.28 + lean, cy - r * 0.30),
        r * 0.42,
        Paint()..color = Colors.white.withValues(alpha: 0.13),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ValleyForestPainter old) =>
      old.sway != sway || old.layout != layout;
}

// ---------------------------------------------------------------------------
// Layer 3 — meadow, stream, flowers and the framing foreground trees
// ---------------------------------------------------------------------------

/// The grassy foreground the Guardian stands on, plus a winding stream, flower
/// meadow and the two big framing trees that close the composition.
class ValleyMeadowPainter extends CustomPainter {
  const ValleyMeadowPainter({
    required this.layout,
    required this.sway,
    required this.t,
  });

  final ValleyLayout layout;
  final double sway;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ---- Rolling meadow bands --------------------------------------------
    _band(canvas, size, 0.600, 0.650, ValleyPalette.meadowFar, 0.028);
    _band(canvas, size, 0.645, 0.730, ValleyPalette.meadowMid, -0.022);
    final near = Rect.fromLTRB(0, h * 0.712, w, h);
    canvas.drawRect(
      near,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ValleyPalette.meadowNear, ValleyPalette.meadowShade],
        ).createShader(near),
    );

    // ---- Stream winding across the mid-ground ----------------------------
    // Sits high in the mid-ground, well behind the Guardian's dais.
    final stream = Path()
      ..moveTo(-w * 0.05, h * 0.652)
      ..cubicTo(w * 0.22, h * 0.630, w * 0.34, h * 0.672, w * 0.50, h * 0.660)
      ..cubicTo(w * 0.68, h * 0.648, w * 0.80, h * 0.684, w * 1.05, h * 0.656)
      ..lineTo(w * 1.05, h * 0.690)
      ..cubicTo(w * 0.80, h * 0.718, w * 0.68, h * 0.682, w * 0.50, h * 0.694)
      ..cubicTo(w * 0.34, h * 0.706, w * 0.22, h * 0.664, -w * 0.05, h * 0.686)
      ..close();
    canvas.drawPath(stream, Paint()..color = ValleyPalette.poolDeep);
    canvas.drawPath(
      stream.shift(Offset(0, h * 0.004)),
      Paint()..color = ValleyPalette.pool,
    );
    canvas.save();
    canvas.clipPath(stream);
    for (var i = 0; i < 6; i++) {
      final phase = ((t * 0.5 + i * 0.17) % 1.0);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * phase, h * (0.664 + (i % 3) * 0.009)),
          width: w * 0.050,
          height: h * 0.006,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.40),
      );
    }
    canvas.restore();

    // ---- Grass tufts + flowers -------------------------------------------
    final tuft = Paint()
      ..color = ValleyPalette.meadowShade.withValues(alpha: 0.55)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final g in layout.grass) {
      final gx = g.x * w;
      final gy = g.y * h;
      final len = g.size * h;
      tuft.strokeWidth = math.max(1.0, len * 0.10);
      final bend = math.sin(sway * math.pi + g.phase) * len * 0.35;
      for (var i = -1; i <= 1; i++) {
        canvas.drawLine(
          Offset(gx + i * len * 0.20, gy),
          Offset(gx + i * len * 0.28 + bend, gy - len),
          tuft,
        );
      }
    }
    for (final f in layout.flowers) {
      final fx = f.x * w + math.sin(sway * math.pi + f.phase) * w * 0.002;
      final fy = f.y * h;
      final r = f.size * h;
      canvas.drawLine(
        Offset(fx, fy),
        Offset(fx, fy - r * 2.6),
        Paint()
          ..color = ValleyPalette.meadowShade
          ..strokeWidth = math.max(1.0, r * 0.35),
      );
      final c = ValleyPalette.flowers[f.colourIndex];
      for (var i = 0; i < 5; i++) {
        final a = i * math.pi * 2 / 5;
        canvas.drawCircle(
          Offset(
            fx + math.cos(a) * r * 0.8,
            fy - r * 2.6 + math.sin(a) * r * 0.8,
          ),
          r * 0.62,
          Paint()..color = c,
        );
      }
      canvas.drawCircle(
        Offset(fx, fy - r * 2.6),
        r * 0.52,
        Paint()..color = ValleyPalette.sunCore,
      );
    }

    // ---- Framing foreground trees + thicket (left + right edges) ---------
    _foregroundThicket(canvas, size);
    _framingTree(canvas, size, cx: -0.008, scale: 1.0, flip: false);
    _framingTree(canvas, size, cx: 1.008, scale: 1.08, flip: true);
  }

  void _band(
    Canvas canvas,
    Size size,
    double topY,
    double bottomY,
    Color colour,
    double curve,
  ) {
    final w = size.width;
    final h = size.height;
    canvas.drawPath(
      Path()
        ..moveTo(-w * 0.02, topY * h)
        ..quadraticBezierTo(w * 0.5, (topY + curve) * h, w * 1.02, topY * h)
        ..lineTo(w * 1.02, bottomY * h)
        ..lineTo(-w * 0.02, bottomY * h)
        ..close(),
      Paint()..color = colour,
    );
  }

  /// A large canopy tree anchored off-screen that frames the composition and
  /// adds foreground depth without covering the central stage.
  ///
  /// The trunk is deliberately slim and only climbs into the lower third; the
  /// canopy does the framing from the top corner, which keeps the valley open.
  void _framingTree(
    Canvas canvas,
    Size size, {
    required double cx,
    required double scale,
    required bool flip,
  }) {
    final w = size.width;
    final h = size.height;
    final x = cx * w;
    final dir = flip ? -1.0 : 1.0;
    final trunkW = w * 0.013 * scale;
    final baseY = h * 1.02;
    final lean = sway * w * 0.003;

    // Slim, tapering trunk that curves up out of frame.
    final trunk = Path()
      ..moveTo(x - trunkW * 1.5 * dir, baseY)
      ..quadraticBezierTo(
        x + trunkW * 0.8 * dir,
        h * 0.58,
        x + trunkW * 2.2 * dir + lean,
        h * 0.20,
      )
      ..lineTo(x + trunkW * 4.0 * dir + lean, h * 0.20)
      ..quadraticBezierTo(
        x + trunkW * 3.0 * dir,
        h * 0.60,
        x + trunkW * 2.2 * dir,
        baseY,
      )
      ..close();
    canvas.drawPath(trunk, Paint()..color = ValleyPalette.trunk);
    canvas.save();
    canvas.clipPath(trunk);
    canvas.drawRect(
      Rect.fromLTRB(
        dir > 0 ? x - trunkW * 2 : x,
        0,
        dir > 0 ? x + trunkW * 0.6 : x + trunkW * 5,
        h * 1.1,
      ),
      Paint()..color = ValleyPalette.trunkDark.withValues(alpha: 0.40),
    );
    canvas.restore();

    // Two boughs reaching into the frame.
    final bough = Paint()
      ..color = ValleyPalette.trunk
      ..style = PaintingStyle.stroke
      ..strokeWidth = trunkW * 1.1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 2; i++) {
      final by = h * (0.24 + i * 0.13);
      canvas.drawPath(
        Path()
          ..moveTo(x + trunkW * 2.4 * dir, by)
          ..quadraticBezierTo(
            x + w * 0.045 * dir,
            by - h * 0.02,
            x + w * 0.075 * dir + lean,
            by - h * 0.06,
          ),
        bough,
      );
    }

    // Canopy — overlapping blobs hugging the top corner.
    final canopy = Paint()..color = ValleyPalette.forestNear;
    final canopyDeep = Paint()..color = ValleyPalette.forestDark;
    final highlight = Paint()..color = Colors.white.withValues(alpha: 0.12);
    // [x in trunk widths, y as fraction of h, radius as fraction of h]
    final blobs = <List<double>>[
      [-1.0, 0.00, 0.150],
      [3.2, -0.03, 0.165],
      [1.2, 0.11, 0.130],
      [7.0, 0.05, 0.130],
      [5.0, 0.16, 0.105],
      [9.6, 0.14, 0.085],
      [2.6, 0.22, 0.070],
    ];
    for (var i = 0; i < blobs.length; i++) {
      final b = blobs[i];
      final bx = x + trunkW * b[0] * dir + lean;
      final by = h * b[1];
      canvas.drawCircle(Offset(bx, by + h * 0.012), h * b[2], canopyDeep);
      canvas.drawCircle(Offset(bx, by), h * b[2], canopy);
      canvas.drawCircle(
        Offset(bx + h * b[2] * 0.28 * dir, by + h * b[2] * 0.10),
        h * b[2] * 0.52,
        highlight,
      );
    }

    // Hanging leaf strands for storybook charm.
    for (var i = 0; i < 2; i++) {
      final vx = x + w * (0.030 + i * 0.028) * dir + lean;
      final vy = h * (0.20 + i * 0.06);
      final len = h * (0.10 + i * 0.03);
      canvas.drawPath(
        Path()
          ..moveTo(vx, vy)
          ..quadraticBezierTo(
            vx + lean * 4,
            vy + len * 0.6,
            vx + lean * 8,
            vy + len,
          ),
        Paint()
          ..color = ValleyPalette.forestDark.withValues(alpha: 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.5, w * 0.0016)
          ..strokeCap = StrokeCap.round,
      );
      for (var k = 1; k <= 3; k++) {
        final f = k / 3;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(vx + lean * 8 * f, vy + len * f),
            width: h * 0.016,
            height: h * 0.028,
          ),
          Paint()..color = ValleyPalette.forestNear,
        );
      }
    }
  }

  /// Chunky bushes and boulders along the bottom edge. They sit outside the
  /// central third so the Guardian and the portal buttons stay clear.
  void _foregroundThicket(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void bush(double nx, double ny, double r, Color base) {
      final cxp = nx * w;
      final cyp = ny * h;
      final rr = r * h;
      final deep = Paint()..color = Color.lerp(base, Colors.black, 0.22)!;
      final light = Paint()..color = base;
      canvas.drawCircle(
        Offset(cxp - rr * 0.8, cyp + rr * 0.2),
        rr * 0.78,
        deep,
      );
      canvas.drawCircle(
        Offset(cxp + rr * 0.85, cyp + rr * 0.25),
        rr * 0.72,
        deep,
      );
      canvas.drawCircle(Offset(cxp, cyp), rr, light);
      canvas.drawCircle(
        Offset(cxp - rr * 0.25, cyp - rr * 0.30),
        rr * 0.42,
        Paint()..color = Colors.white.withValues(alpha: 0.13),
      );
    }

    void boulder(double nx, double ny, double r) {
      final cxp = nx * w;
      final cyp = ny * h;
      final rr = r * h;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cxp, cyp),
          width: rr * 2.3,
          height: rr * 1.5,
        ),
        Paint()..color = ValleyPalette.stoneShade,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cxp - rr * 0.16, cyp - rr * 0.20),
          width: rr * 1.7,
          height: rr * 1.0,
        ),
        Paint()..color = ValleyPalette.stone,
      );
    }

    bush(0.055, 0.965, 0.070, ValleyPalette.forestNear);
    bush(0.170, 1.015, 0.058, ValleyPalette.meadowShade);
    boulder(0.115, 0.930, 0.026);
    bush(0.945, 0.960, 0.075, ValleyPalette.forestNear);
    bush(0.845, 1.020, 0.055, ValleyPalette.meadowShade);
    boulder(0.892, 0.925, 0.023);
  }

  @override
  bool shouldRepaint(covariant ValleyMeadowPainter old) =>
      old.sway != sway || old.t != t || old.layout != layout;
}

// ---------------------------------------------------------------------------
// The Guardian's stone dais
// ---------------------------------------------------------------------------

/// The circular mossy stone platform the Guardian stands on. Painted inside the
/// UI stage (not the background) so the dragon, its shadow and the dais always
/// line up exactly, at any resolution.
class GuardianDaisPainter extends CustomPainter {
  const GuardianDaisPainter({required this.glow});

  /// 0..1 pulse used by the eco-runes around the rim.
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centre = Offset(w * 0.5, h * 0.5);

    // Soft grass shadow under the whole dais.
    canvas.drawOval(
      Rect.fromCenter(
        center: centre.translate(0, h * 0.10),
        width: w * 1.05,
        height: h * 0.86,
      ),
      Paint()
        ..color = ValleyPalette.meadowShade.withValues(alpha: 0.35)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, h * 0.10),
    );

    // Stone side wall (gives the dais real thickness).
    final wall = Rect.fromCenter(
      center: centre.translate(0, h * 0.12),
      width: w * 0.94,
      height: h * 0.78,
    );
    canvas.drawOval(wall, Paint()..color = ValleyPalette.stoneEdge);
    canvas.drawOval(
      wall.translate(0, -h * 0.04),
      Paint()..color = ValleyPalette.stoneShade,
    );

    // Top face.
    final top = Rect.fromCenter(
      center: centre,
      width: w * 0.94,
      height: h * 0.78,
    );
    canvas.drawOval(
      top,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.2, -0.4),
          colors: [ValleyPalette.stoneLit, ValleyPalette.stone],
        ).createShader(top),
    );

    // Cobble seams radiating from the centre — reads as laid stone.
    canvas.save();
    canvas.clipPath(Path()..addOval(top));
    final seam = Paint()
      ..color = ValleyPalette.stoneShade.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.5, h * 0.012);
    for (var i = 0; i < 10; i++) {
      final a = i * math.pi * 2 / 10;
      canvas.drawLine(
        Offset(
          centre.dx + math.cos(a) * top.width * 0.16,
          centre.dy + math.sin(a) * top.height * 0.16,
        ),
        Offset(
          centre.dx + math.cos(a) * top.width * 0.52,
          centre.dy + math.sin(a) * top.height * 0.52,
        ),
        seam,
      );
    }
    canvas.drawOval(top.deflate(math.min(w, h) * 0.055), seam);
    canvas.restore();

    // Rim.
    canvas.drawOval(
      top,
      Paint()
        ..color = ValleyPalette.stoneEdge
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(2.0, h * 0.024),
    );

    // Moss patches creeping over the rim.
    final moss = Paint()..color = ValleyPalette.meadowNear;
    final mossDeep = Paint()..color = ValleyPalette.meadowShade;
    for (var i = 0; i < 9; i++) {
      final a = i * math.pi * 2 / 9 + 0.4;
      final p = Offset(
        centre.dx + math.cos(a) * top.width * 0.47,
        centre.dy + math.sin(a) * top.height * 0.47,
      );
      canvas.drawOval(
        Rect.fromCenter(center: p, width: w * 0.12, height: h * 0.085),
        mossDeep,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: p.translate(0, -h * 0.008),
          width: w * 0.10,
          height: h * 0.065,
        ),
        moss,
      );
    }

    // Glowing eco-runes around the rim (recycling-inspired detail).
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi * 2 / 6 + glow * 0.6;
      final p = Offset(
        centre.dx + math.cos(a) * top.width * 0.36,
        centre.dy + math.sin(a) * top.height * 0.36,
      );
      final pulse =
          0.35 + 0.65 * (0.5 + 0.5 * math.sin(glow * math.pi * 2 + i));
      canvas.drawCircle(
        p,
        h * 0.055,
        Paint()
          ..color = ValleyPalette.runeGlow.withValues(alpha: 0.30 * pulse)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, h * 0.04),
      );
      canvas.drawCircle(
        p,
        h * 0.022,
        Paint()
          ..color = ValleyPalette.runeGlow.withValues(
            alpha: 0.55 + 0.35 * pulse,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GuardianDaisPainter old) => old.glow != glow;
}
