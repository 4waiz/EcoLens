import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/guardian_avatar.dart';
import 'guardian_emotion.dart';
import 'guardian_world_assets.dart';

/// ---------------------------------------------------------------------------
/// The Guardian on stage.
///
/// Renders one static expression frame and animates *around* it: a continuous
/// breathing/bob loop, plus a short entrance whenever the expression changes —
/// always including a small hop, so a change of face reads as the character
/// reacting rather than a texture swap.
///
/// Layout is fixed by a [SizedBox] the size of the stage, and the cross-fade
/// happens inside it, so changing expression can never reflow the scene.
///
/// Fallback ladder: requested emotion → idle frame → legacy `guardian_dragon`
/// → vector [GuardianAvatar]. The centre of the valley is never empty.
/// ---------------------------------------------------------------------------
class GuardianMascot extends StatefulWidget {
  const GuardianMascot({
    super.key,
    required this.height,
    required this.emotion,
    required this.sequence,
    this.animate = true,
    this.onTap,
    this.showAura = true,
    this.showShadow = true,
    this.fallbackStage = 2,
    this.semanticLabel = 'Your EcoLens Guardian',
  });

  final double height;
  final GuardianEmotion emotion;

  /// Bumped by the controller on every applied change. Replays the entrance
  /// even when the same emotion is requested twice in a row.
  final int sequence;

  final bool animate;
  final VoidCallback? onTap;
  final bool showAura;
  final bool showShadow;
  final int fallbackStage;
  final String semanticLabel;

  /// Cross-fade length between expressions.
  static const Duration transition = Duration(milliseconds: 240);

  @override
  State<GuardianMascot> createState() => _GuardianMascotState();
}

class _GuardianMascotState extends State<GuardianMascot>
    with TickerProviderStateMixin {
  /// Continuous ambient loop (breathing, bob, sway).
  late final AnimationController _ambient;

  /// One-shot entrance played on every expression change.
  late final AnimationController _entrance;

  /// Emotions whose artwork failed to decode; never retried, so a missing file
  /// cannot spin the widget in a rebuild loop.
  static final Set<GuardianEmotion> _broken = <GuardianEmotion>{};
  static bool _legacyBroken = false;

  @override
  void initState() {
    super.initState();
    _ambient = AnimationController(vsync: this, duration: _profile.period);
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
      value: 1,
    );
    if (widget.animate) _ambient.repeat(reverse: true);
  }

  GuardianMotionProfile get _profile => widget.emotion.motion;

  @override
  void didUpdateWidget(covariant GuardianMascot old) {
    super.didUpdateWidget(old);

    if (widget.emotion != old.emotion) {
      _ambient.duration = _profile.period;
      if (widget.animate) _ambient.repeat(reverse: true);
    }
    if (widget.sequence != old.sequence && widget.animate) {
      _entrance.forward(from: 0);
    }
    if (widget.animate != old.animate) {
      if (widget.animate) {
        _ambient.repeat(reverse: true);
      } else {
        _ambient.stop();
        _entrance.value = 1;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precache(widget.emotion.assetPath);
  }

  void _precache(String path) {
    precacheImage(AssetImage(path), context, onError: (_, _) {});
  }

  @override
  void dispose() {
    _ambient.dispose();
    _entrance.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Artwork with a fallback ladder
  // ---------------------------------------------------------------------------

  Widget _vectorGuardian(double h) => GuardianAvatar(
    stage: widget.fallbackStage,
    size: h,
    glowing: widget.emotion != GuardianEmotion.idle,
    bob: false,
    showPodium: false,
  );

  Widget _legacyGuardian(double h) {
    if (_legacyBroken) return _vectorGuardian(h);
    return Image.asset(
      GuardianWorldAssets.legacyGuardian,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
      errorBuilder: (context, error, stack) {
        _legacyBroken = true;
        return _vectorGuardian(h);
      },
    );
  }

  Widget _frame(GuardianEmotion emotion, double h, {bool isFallback = false}) {
    if (_broken.contains(emotion)) {
      // Requested frame is missing: try the idle frame, then the legacy art.
      return isFallback || emotion == GuardianEmotion.idle
          ? _legacyGuardian(h)
          : _frame(GuardianEmotion.idle, h, isFallback: true);
    }
    return Image.asset(
      emotion.assetPath,
      height: h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      isAntiAlias: true,
      excludeFromSemantics: true,
      // Decoding at the display size rather than the 1024² master keeps the
      // image cache small on a low-memory tablet.
      cacheHeight: (h * MediaQuery.devicePixelRatioOf(context)).round().clamp(
        128,
        1024,
      ),
      errorBuilder: (context, error, stack) {
        if (_broken.add(emotion)) {
          debugPrint(
            'EcoLens: Guardian frame missing (${emotion.name}) — '
            'falling back. $error',
          );
        }
        return isFallback || emotion == GuardianEmotion.idle
            ? _legacyGuardian(h)
            : _frame(GuardianEmotion.idle, h, isFallback: true);
      },
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync || frame != null) return child;
        // Frames are precached, so this gap is a frame or two at most. It is
        // left EMPTY on purpose: flashing the old vector mascot here would show
        // students a character the app no longer uses. The vector is kept only
        // for a genuine load failure, below.
        return SizedBox(height: h, width: h * 0.94);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.height;
    final profile = _profile;
    final layout = widget.emotion.layout;

    return Semantics(
      label: widget.semanticLabel,
      button: widget.onTap != null,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          // A fixed box: the expression can change freely without the
          // surrounding layout moving by a single pixel.
          child: SizedBox(
            height: h,
            width: h * 0.94,
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: Listenable.merge([_ambient, _entrance]),
                builder: (context, _) => _buildStage(h, profile, layout),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStage(
    double h,
    GuardianMotionProfile profile,
    GuardianEmotionLayout layout,
  ) {
    final wave = math.sin(_ambient.value * math.pi);
    final t = _entrance.value;

    // ---- Entrance: a short series of decaying hops --------------------
    // `jumps` arches over the first ~65% of the entrance, each lower than the
    // last, then settles. Even idle gets a small one so every expression
    // change is felt.
    double hop = 0;
    double hopSpin = 0;
    if (widget.animate && t < 1) {
      final p = (t / 0.68).clamp(0.0, 1.0);
      if (p < 1) {
        final arch = math.sin(p * math.pi * profile.jumps).abs();
        final decay = 1 - p * 0.55;
        hop = arch * decay * profile.jump * h;
        hopSpin = math.sin(p * math.pi * 2) * profile.spin * (1 - p);
      }
    }

    // ---- Ambient loop --------------------------------------------------
    final bob = wave * h * profile.bob;
    final breatheY = 1 + wave * profile.breathe;
    final breatheX = 1 - wave * profile.breathe * 0.65;
    final sway = math.sin(_ambient.value * math.pi * 2) * profile.sway;

    // ---- Cross-fade scale: 0.97 -> 1.0 ---------------------------------
    final settle = Curves.easeOutCubic.transform(t);
    final entryScale = 0.97 + 0.03 * settle;

    final dx = layout.translation.dx * h;
    final dy = layout.translation.dy * h;

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        if (widget.showAura)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _AuraPainter(
                  colour: profile.glow ?? const Color(0xFF9FE8A6),
                  intensity: 0.30 + wave * 0.22 + (1 - settle) * 0.35,
                  sparkle: profile.sparkle && t < 1 ? t : null,
                ),
              ),
            ),
          ),
        if (widget.showShadow)
          Positioned(
            bottom: h * 0.004,
            child: IgnorePointer(
              child: Container(
                // The shadow tightens as the Guardian leaves the ground.
                width: h * (0.50 - wave * 0.02 - (hop / h) * 0.9),
                height: h * 0.055,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF3E6B33,
                  ).withValues(alpha: 0.30 - (hop / h) * 0.5),
                  borderRadius: BorderRadius.all(
                    Radius.elliptical(h * 0.25, h * 0.028),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          bottom: bob + hop - dy,
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..translateByDouble(dx, 0, 0, 1)
              ..rotateZ(sway * 0.12 + profile.tilt + hopSpin)
              ..scaleByDouble(
                breatheX * entryScale * layout.scale,
                breatheY * entryScale * layout.scale,
                1,
                1,
              ),
            child: AnimatedSwitcher(
              duration: GuardianMascot.transition,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              // Both frames occupy the same box, so the swap cannot resize
              // anything around it.
              layoutBuilder: (current, previous) => Stack(
                alignment: Alignment.bottomCenter,
                children: [...previous, ?current],
              ),
              child: KeyedSubtree(
                key: ValueKey(widget.emotion),
                child: _frame(widget.emotion, h),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Soft aura behind the Guardian, with an optional celebration burst.
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
    final centre = Offset(size.width * 0.5, size.height * 0.56);
    final radius = size.width * 0.64;
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            colour.withValues(alpha: 0.26 * intensity),
            colour.withValues(alpha: 0.09 * intensity),
            colour.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: centre, radius: radius)),
    );

    final s = sparkle;
    if (s == null) return;
    for (var i = 0; i < 10; i++) {
      final a = i * math.pi * 2 / 10 + s * math.pi * 0.7;
      final d = radius * (0.55 + 0.34 * ((i % 3) / 3) + s * 0.30);
      final p = centre + Offset(math.cos(a) * d, math.sin(a) * d * 0.82);
      final r = size.width * 0.020 * (0.5 + (1 - s) * 0.9);
      _leaf(canvas, p, r, a, Paint()..color = colour.withValues(alpha: 1 - s));
    }
  }

  void _leaf(Canvas canvas, Offset c, double r, double angle, Paint paint) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(angle);
    canvas.drawPath(
      Path()
        ..moveTo(0, -r)
        ..quadraticBezierTo(r, 0, 0, r)
        ..quadraticBezierTo(-r, 0, 0, -r)
        ..close(),
      paint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) =>
      old.intensity != intensity ||
      old.colour != colour ||
      old.sparkle != sparkle;
}

/// A still Guardian portrait for use inside panels and cards.
///
/// Same artwork and same fallback ladder as [GuardianMascot], without the aura,
/// contact shadow or entrance hop — those belong to the character standing in
/// the world, not to a thumbnail in a results table.
class GuardianPortrait extends StatelessWidget {
  const GuardianPortrait({
    super.key,
    required this.size,
    this.emotion = GuardianEmotion.idle,
    this.animate = true,
    this.semanticLabel = 'Your EcoLens Guardian',
  });

  final double size;
  final GuardianEmotion emotion;
  final bool animate;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return GuardianMascot(
      height: size,
      emotion: emotion,
      sequence: 0,
      animate: animate,
      showAura: false,
      showShadow: false,
      semanticLabel: semanticLabel,
    );
  }
}
