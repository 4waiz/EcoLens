import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../painters/valley_painters.dart';
import 'guardian_avatar.dart';

/// How the Guardian is feeling — drives the idle animation and aura colour.
enum GuardianMood {
  /// Calm breathing loop, used on the attract screen.
  idle,

  /// Brighter aura + a quicker bob (student recognised, correct answer).
  happy,

  /// Big celebration: hops, sparkles and a strong aura.
  celebrate,

  /// Leaning in, slow and attentive (analysing / quiz).
  thinking,

  /// Gentle, low bob with a cool aura (mistake — never harsh for children).
  encouraging,
}

/// The EcoLens Guardian — a friendly dragon who guides students through
/// recycling. Rendered from the supplied transparent PNG, with a procedural
/// idle animation (bob, breathe, sway), a contact shadow and a soft aura.
///
/// The bitmap is never stretched: it is drawn with [BoxFit.contain] at high
/// filter quality. If the asset cannot be decoded (e.g. a stripped build), the
/// widget falls back to the vector [GuardianAvatar] so the kiosk always has a
/// Guardian on screen.
class GuardianDragon extends StatefulWidget {
  const GuardianDragon({
    super.key,
    this.height = 380,
    this.mood = GuardianMood.idle,
    this.animate = true,
    this.showShadow = true,
    this.showAura = true,
    this.onTap,
    this.semanticLabel = 'Your EcoLens Guardian',
    this.fallbackStage = 2,
  });

  /// Rendered height in logical pixels. Width follows the artwork's aspect.
  final double height;
  final GuardianMood mood;
  final bool animate;
  final bool showShadow;
  final bool showAura;
  final VoidCallback? onTap;
  final String semanticLabel;

  /// Evolution stage used only by the vector fallback.
  final int fallbackStage;

  /// Path of the primary Guardian artwork (transparent PNG).
  static const String assetPath = 'assets/images/guardian_dragon.png';

  @override
  State<GuardianDragon> createState() => _GuardianDragonState();
}

class _GuardianDragonState extends State<GuardianDragon>
    with TickerProviderStateMixin {
  late final AnimationController _idle;
  late final AnimationController _react;

  @override
  void initState() {
    super.initState();
    _idle = AnimationController(vsync: this, duration: _idlePeriod);
    _react = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    if (widget.animate) _idle.repeat(reverse: true);
  }

  Duration get _idlePeriod => switch (widget.mood) {
    GuardianMood.celebrate => const Duration(milliseconds: 620),
    GuardianMood.happy => const Duration(milliseconds: 1500),
    GuardianMood.thinking => const Duration(milliseconds: 2600),
    GuardianMood.encouraging => const Duration(milliseconds: 2400),
    GuardianMood.idle => const Duration(milliseconds: 2100),
  };

  Color get _auraColour => switch (widget.mood) {
    GuardianMood.celebrate => const Color(0xFFFFD54F),
    GuardianMood.happy => const Color(0xFF8BE08F),
    GuardianMood.thinking => const Color(0xFF8ECBF5),
    GuardianMood.encouraging => const Color(0xFFFFB74D),
    GuardianMood.idle => const Color(0xFF9FE8A6),
  };

  @override
  void didUpdateWidget(covariant GuardianDragon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mood != oldWidget.mood) {
      _idle.duration = _idlePeriod;
      if (widget.animate) _idle.repeat(reverse: true);
    }
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _idle.repeat(reverse: true);
      } else {
        _idle.stop();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Warm the decoder so the Guardian is on stage in the first painted frame
    // rather than popping in a beat later on a cold kiosk boot.
    precacheImage(
      const AssetImage(GuardianDragon.assetPath),
      context,
      onError: (error, stack) {}, // handled by the vector fallback below
    );
  }

  @override
  void dispose() {
    _idle.dispose();
    _react.dispose();
    super.dispose();
  }

  /// Vector Guardian used both as the decode placeholder and as the hard
  /// fallback if the artwork cannot be loaded at all.
  Widget _vectorGuardian(double h) => GuardianAvatar(
    stage: widget.fallbackStage,
    size: h,
    glowing: widget.mood != GuardianMood.idle,
    bob: false,
    showPodium: false,
  );

  void _handleTap() {
    if (widget.animate) _react.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;

    final art = Image.asset(
      GuardianDragon.assetPath,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      isAntiAlias: true,
      excludeFromSemantics: true,
      // While the bitmap decodes, hold the stage with the vector Guardian and
      // cross-fade — the centre of the valley is never empty.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        final ready = wasSynchronouslyLoaded || frame != null;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          child: ready
              ? KeyedSubtree(key: const ValueKey('guardian-art'), child: child)
              : KeyedSubtree(
                  key: const ValueKey('guardian-placeholder'),
                  child: _vectorGuardian(h),
                ),
        );
      },
      errorBuilder: (context, error, stack) => _vectorGuardian(h),
    );

    return Semantics(
      label: widget.semanticLabel,
      button: widget.onTap != null,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: GestureDetector(
          onTap: widget.onTap != null ? _handleTap : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: Listenable.merge([_idle, _react]),
            builder: (context, child) {
              final wave = math.sin(_idle.value * math.pi);
              final celebrating = widget.mood == GuardianMood.celebrate;

              // Vertical bob — bigger and springier when celebrating.
              final bob = wave * h * (celebrating ? 0.045 : 0.018);

              // "Breathing": a subtle non-uniform scale anchored at the feet so
              // the Guardian never appears to sink into the platform.
              final breatheY = 1 + wave * (celebrating ? 0.030 : 0.012);
              final breatheX = 1 - wave * (celebrating ? 0.018 : 0.008);

              // A gentle sway keeps the pose from looking frozen.
              final sway =
                  math.sin(_idle.value * math.pi * 2) *
                  (widget.mood == GuardianMood.thinking ? 0.020 : 0.010);

              // Tap reaction: a quick squash-and-stretch hop.
              final react = Curves.elasticOut.transform(
                _react.isAnimating || _react.isCompleted ? _react.value : 0,
              );
              final hop = react * h * 0.05 * (1 - _react.value);

              return SizedBox(
                height: h,
                width: h * 0.92,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    if (widget.showAura)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _AuraPainter(
                              colour: _auraColour,
                              intensity:
                                  0.35 + wave * (celebrating ? 0.55 : 0.25),
                              sparkle: celebrating ? _idle.value : null,
                            ),
                          ),
                        ),
                      ),
                    if (widget.showShadow)
                      Positioned(
                        bottom: h * 0.005,
                        child: Container(
                          width: h * (0.50 - wave * 0.03),
                          height: h * 0.058,
                          decoration: BoxDecoration(
                            color: ValleyPalette.meadowShade.withValues(
                              alpha: 0.34 - wave * 0.06,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(h * 0.25, h * 0.029),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: bob + hop,
                      child: Transform(
                        alignment: Alignment.bottomCenter,
                        transform: Matrix4.identity()
                          ..rotateZ(sway * 0.10)
                          ..scaleByDouble(breatheX, breatheY, 1, 1),
                        child: child,
                      ),
                    ),
                  ],
                ),
              );
            },
            child: art,
          ),
        ),
      ),
    );
  }
}

/// A soft radial aura behind the Guardian, with optional celebration sparkles.
class _AuraPainter extends CustomPainter {
  const _AuraPainter({
    required this.colour,
    required this.intensity,
    this.sparkle,
  });

  final Color colour;
  final double intensity;
  final double? sparkle;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width * 0.5, size.height * 0.55);
    final radius = size.width * 0.62;
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colour.withValues(alpha: 0.30 * intensity),
            colour.withValues(alpha: 0.10 * intensity),
            colour.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: centre, radius: radius)),
    );

    final s = sparkle;
    if (s == null) return;
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi * 2 / 8 + s * math.pi;
      final d = radius * (0.62 + 0.30 * ((i % 3) / 3) + s * 0.16);
      final p = centre + Offset(math.cos(a) * d, math.sin(a) * d * 0.86);
      final r = size.width * 0.018 * (0.6 + (1 - s) * 0.8);
      _star(
        canvas,
        p,
        r,
        Paint()..color = Colors.white.withValues(alpha: 0.85 * (1 - s)),
      );
    }
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final rad = i.isEven ? r : r * 0.36;
      final p = c + Offset(math.cos(a) * rad, math.sin(a) * rad);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) =>
      old.intensity != intensity ||
      old.colour != colour ||
      old.sparkle != sparkle;
}
