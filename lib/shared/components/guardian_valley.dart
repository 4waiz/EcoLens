import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../painters/valley_painters.dart';
import 'guardian_dragon.dart';

/// ---------------------------------------------------------------------------
/// The living EcoLens world: **Guardian Valley**.
///
/// A full-bleed, softly animated enchanted eco-forest that sits behind every
/// student-facing kiosk screen. Three parallax layers (sky + peaks + falls,
/// forest bands, meadow) are painted procedurally, with drifting leaves and
/// fireflies on top.
///
/// Nothing here needs a network call or a bitmap, so the kiosk boots into the
/// world even when it is offline. An optional [backgroundImage] can replace the
/// procedural sky/forest layers if a school ships bespoke art — the meadow,
/// atmosphere and dais keep working either way.
/// ---------------------------------------------------------------------------
class GuardianValley extends StatefulWidget {
  const GuardianValley({
    super.key,
    required this.child,
    this.stage,
    this.animate = true,
    this.backgroundImage,
    this.dim = 0.0,
  });

  final Widget child;

  /// Drawn in world space above the scenery but below the UI, so the painted
  /// world and the generated world compose the Guardian identically.
  final Widget? stage;

  /// Set false for reduced-motion / screenshot tests. The world still renders,
  /// it simply holds a single frame.
  final bool animate;

  /// Optional bespoke landscape art. Falls back to the procedural valley when
  /// null or when the asset fails to decode.
  final ImageProvider? backgroundImage;

  /// 0..1 scrim strength, used when a screen needs extra text contrast.
  final double dim;

  @override
  State<GuardianValley> createState() => _GuardianValleyState();
}

class _GuardianValleyState extends State<GuardianValley>
    with TickerProviderStateMixin {
  late final AnimationController _drift; // clouds, water shimmer
  late final AnimationController _breeze; // tree + grass sway

  @override
  void initState() {
    super.initState();
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    );
    _breeze = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );
    if (widget.animate) {
      _drift.repeat();
      _breeze.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant GuardianValley oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _drift.repeat();
        _breeze.repeat(reverse: true);
      } else {
        _drift.stop();
        _breeze.stop();
      }
    }
  }

  @override
  void dispose() {
    _drift.dispose();
    _breeze.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = ValleyLayout.standard;

    return Stack(
      fit: StackFit.expand,
      children: [
        // ---- Layer 1: sky, sun, clouds, peaks, waterfalls ----------------
        if (widget.backgroundImage != null)
          Image(
            image: widget.backgroundImage!,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            errorBuilder: (context, error, stack) => _skyLayer(layout),
          )
        else
          _skyLayer(layout),

        // ---- Layer 2: forest bands ---------------------------------------
        if (widget.backgroundImage == null)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _breeze,
              builder: (context, _) => CustomPaint(
                painter: ValleyForestPainter(
                  layout: layout,
                  sway: _breeze.value * 2 - 1,
                ),
                isComplex: true,
                willChange: widget.animate,
                size: Size.infinite,
              ),
            ),
          ),

        // ---- Layer 3: meadow, stream, flowers, framing trees -------------
        if (widget.backgroundImage == null)
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: Listenable.merge([_breeze, _drift]),
              builder: (context, _) => CustomPaint(
                painter: ValleyMeadowPainter(
                  layout: layout,
                  sway: _breeze.value * 2 - 1,
                  t: _drift.value,
                ),
                isComplex: true,
                willChange: widget.animate,
                size: Size.infinite,
              ),
            ),
          ),

        // ---- Layer 4: drifting leaves, pollen and fireflies --------------
        RepaintBoundary(child: ValleyAtmosphere(animate: widget.animate)),

        // ---- Optional readability scrim ----------------------------------
        if (widget.dim > 0)
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18 * widget.dim),
                    Colors.black.withValues(alpha: 0.06 * widget.dim),
                  ],
                ),
              ),
            ),
          ),

        // ---- The Guardian, standing in the world --------------------------
        ?widget.stage,

        // ---- The UI itself ------------------------------------------------
        widget.child,
      ],
    );
  }

  Widget _skyLayer(ValleyLayout layout) => RepaintBoundary(
    child: AnimatedBuilder(
      animation: _drift,
      builder: (context, _) => CustomPaint(
        painter: ValleySkyPainter(t: _drift.value, layout: layout),
        isComplex: true,
        willChange: widget.animate,
        size: Size.infinite,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Atmosphere — drifting leaves, pollen motes and fireflies
// ---------------------------------------------------------------------------

/// Soft particle layer that makes the valley feel alive. Purely decorative and
/// never interactive, so it is wrapped in [IgnorePointer].
class ValleyAtmosphere extends StatefulWidget {
  const ValleyAtmosphere({super.key, this.animate = true, this.motes = 26});

  final bool animate;
  final int motes;

  @override
  State<ValleyAtmosphere> createState() => _ValleyAtmosphereState();
}

class _ValleyAtmosphereState extends State<ValleyAtmosphere>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Mote> _particles;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );
    if (widget.animate) _c.repeat();

    final rnd = math.Random(4242);
    _particles = List.generate(widget.motes, (i) {
      final kind = i % 5 == 0
          ? _MoteKind.firefly
          : (i % 2 == 0 ? _MoteKind.leaf : _MoteKind.pollen);
      return _Mote(
        kind: kind,
        x: rnd.nextDouble(),
        phase: rnd.nextDouble(),
        speed: 0.55 + rnd.nextDouble() * 0.9,
        size: 0.006 + rnd.nextDouble() * 0.012,
        drift: (rnd.nextDouble() * 2 - 1) * 0.16,
        spin: (rnd.nextDouble() * 2 - 1) * 3.2,
      );
    });
  }

  @override
  void didUpdateWidget(covariant ValleyAtmosphere oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _c.repeat() : _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) => CustomPaint(
          painter: _AtmospherePainter(t: _c.value, motes: _particles),
          willChange: widget.animate,
          size: Size.infinite,
        ),
      ),
    );
  }
}

enum _MoteKind { leaf, pollen, firefly }

@immutable
class _Mote {
  const _Mote({
    required this.kind,
    required this.x,
    required this.phase,
    required this.speed,
    required this.size,
    required this.drift,
    required this.spin,
  });

  final _MoteKind kind;
  final double x, phase, speed, size, drift, spin;
}

class _AtmospherePainter extends CustomPainter {
  const _AtmospherePainter({required this.t, required this.motes});

  final double t;
  final List<_Mote> motes;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    for (final m in motes) {
      final p = (t * m.speed + m.phase) % 1.0;
      final r = m.size * h;

      switch (m.kind) {
        case _MoteKind.firefly:
          // Fireflies bob near the meadow and pulse gently.
          final x = (m.x + math.sin(p * math.pi * 2) * m.drift) * w;
          final y =
              h *
              (0.60 + 0.34 * ((math.sin(p * math.pi * 2 + m.phase) + 1) / 2));
          final glow = 0.35 + 0.65 * ((math.sin(p * math.pi * 6) + 1) / 2);
          canvas.drawCircle(
            Offset(x, y),
            r * 2.4,
            Paint()
              ..color = ValleyPalette.sunGlow.withValues(alpha: 0.30 * glow)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 1.6),
          );
          canvas.drawCircle(
            Offset(x, y),
            r * 0.55,
            Paint()
              ..color = const Color(0xFFFFF9C4).withValues(alpha: 0.85 * glow),
          );

        case _MoteKind.pollen:
          final x = (m.x + math.sin(p * math.pi * 2 + m.phase) * m.drift) * w;
          final y = h * (1.05 - p * 1.15);
          canvas.drawCircle(
            Offset(x, y),
            r * 0.45,
            Paint()..color = Colors.white.withValues(alpha: 0.42),
          );

        case _MoteKind.leaf:
          // Leaves fall from the canopy and swing side to side.
          final x =
              (m.x + math.sin(p * math.pi * 3 + m.phase * 6) * m.drift) * w;
          final y = h * (-0.08 + p * 1.16);
          canvas.save();
          canvas.translate(x, y);
          canvas.rotate(p * m.spin * math.pi);
          final leaf = Path()
            ..moveTo(0, -r)
            ..quadraticBezierTo(r * 1.05, 0, 0, r)
            ..quadraticBezierTo(-r * 1.05, 0, 0, -r)
            ..close();
          canvas.drawPath(
            leaf,
            Paint()
              ..color =
                  (m.spin > 0
                          ? ValleyPalette.forestNear
                          : ValleyPalette.meadowFar)
                      .withValues(alpha: 0.55),
          );
          canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter old) => old.t != t;
}

// ---------------------------------------------------------------------------
// The Guardian's stone dais
// ---------------------------------------------------------------------------

/// The glowing mossy platform the Guardian stands on. Lives inside the UI layer
/// (not the background) so the dragon, its shadow and the dais always align.
class GuardianDais extends StatefulWidget {
  const GuardianDais({super.key, this.animate = true});

  final bool animate;

  @override
  State<GuardianDais> createState() => _GuardianDaisState();
}

class _GuardianDaisState extends State<GuardianDais>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 6));
    if (widget.animate) _c.repeat();
  }

  @override
  void didUpdateWidget(covariant GuardianDais oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      widget.animate ? _c.repeat() : _c.stop();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => CustomPaint(
            painter: GuardianDaisPainter(glow: _c.value),
            willChange: widget.animate,
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The Guardian, standing on the dais
// ---------------------------------------------------------------------------

/// Composes [GuardianDais] and [GuardianDragon] into the valley's centre stage.
///
/// Sizing is derived from the height handed down by the parent, so the dragon,
/// its contact shadow and the glowing platform always line up — at any kiosk
/// resolution and at any [GameScale].
class GuardianOnDais extends StatelessWidget {
  const GuardianOnDais({
    super.key,
    this.mood = GuardianMood.idle,
    this.animate = true,
    this.onTap,
    this.fallbackStage = 2,
    this.semanticLabel = 'Your EcoLens Guardian',
    this.maxDragonHeight = 460,
  });

  final GuardianMood mood;
  final bool animate;
  final VoidCallback? onTap;
  final int fallbackStage;
  final String semanticLabel;
  final double maxDragonHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : maxDragonHeight;
        final dragonH = math.min(available * 0.86, maxDragonHeight);
        final daisW = dragonH * 0.95;
        final daisH = dragonH * 0.27;

        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              width: daisW,
              height: daisH,
              child: GuardianDais(animate: animate),
            ),
            Positioned(
              bottom: daisH * 0.42,
              child: GuardianDragon(
                height: dragonH,
                mood: mood,
                animate: animate,
                onTap: onTap,
                fallbackStage: fallbackStage,
                semanticLabel: semanticLabel,
              ),
            ),
          ],
        );
      },
    );
  }
}
