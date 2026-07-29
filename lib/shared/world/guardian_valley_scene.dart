import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../components/guardian_valley.dart';
import 'guardian_world_assets.dart';

/// ---------------------------------------------------------------------------
/// Guardian Valley, rendered from the generated art.
///
/// Five plates are composited with restrained parallax:
///
///   base -> clouds -> water -> particles -> [procedural motes] -> foreground
///
/// The plates are static images; everything that moves is a cheap transform
/// over them, each inside its own [RepaintBoundary], so an animation tick never
/// re-decodes or re-lays-out artwork.
///
/// If the base plate cannot be decoded the whole scene degrades to the
/// procedural [GuardianValley] painter — the kiosk is never blank, and a
/// student never sees an error.
/// ---------------------------------------------------------------------------
class GuardianValleyGeneratedWorld extends StatefulWidget {
  const GuardianValleyGeneratedWorld({
    super.key,
    required this.child,
    this.stage,
    this.animate = true,
    this.compact = false,
    this.onBaseAssetFailed,
  });

  final Widget child;

  /// Drawn in world space between the particle sheet and the foreground, so
  /// the foreground grass overlaps the Guardian's feet.
  final Widget? stage;

  /// False freezes every decorative layer on one frame (calm mode).
  final bool animate;

  /// Small viewport: thins the procedural particle count.
  final bool compact;

  /// Raised once if the base plate cannot be decoded, so the scene can switch
  /// itself to the painted world.
  final VoidCallback? onBaseAssetFailed;

  @override
  State<GuardianValleyGeneratedWorld> createState() =>
      _GuardianValleyGeneratedWorldState();
}

class _GuardianValleyGeneratedWorldState
    extends State<GuardianValleyGeneratedWorld>
    with TickerProviderStateMixin {
  /// Cloud march. Deliberately glacial — a full pass takes ~92s.
  late final AnimationController _clouds;

  /// Stream shimmer.
  late final AnimationController _water;

  /// Autonomous parallax drift for kiosks with no pointer.
  late final AnimationController _drift;

  /// Pointer-driven parallax, -1..1 on each axis.
  Offset _pointer = Offset.zero;

  /// Layers that failed to decode; never retried.
  static final Set<String> _failed = <String>{};

  @override
  void initState() {
    super.initState();
    _clouds = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 92),
    );
    _water = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    );
    _drift = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 38),
    );
    _setAnimating(widget.animate);
  }

  void _setAnimating(bool on) {
    if (on) {
      _clouds.repeat();
      _water.repeat();
      _drift.repeat();
    } else {
      _clouds.stop();
      _water.stop();
      _drift.stop();
    }
  }

  @override
  void didUpdateWidget(covariant GuardianValleyGeneratedWorld old) {
    super.didUpdateWidget(old);
    if (widget.animate != old.animate) _setAnimating(widget.animate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAll();
  }

  void _precacheAll() {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = MediaQuery.sizeOf(context).width;
    for (final layer in GuardianWorldAssets.layers) {
      precacheImage(
        ResizeImage.resizeIfNeeded(
          _decodeWidth(width, dpr),
          null,
          AssetImage(layer.path),
        ),
        context,
        onError: (error, _) => _noteFailure(layer.path, error),
      );
    }
  }

  /// Never decode the 1376px master at more than the viewport needs.
  int _decodeWidth(double viewportWidth, double dpr) => (viewportWidth * dpr)
      .round()
      .clamp(640, GuardianWorldAssets.plateSize.width.round());

  void _noteFailure(String path, Object error) {
    if (!_failed.add(path)) return;
    debugPrint('EcoLens: valley layer failed to load ($path): $error');
    if (path == GuardianWorldAssets.base.path) {
      widget.onBaseAssetFailed?.call();
    }
  }

  @override
  void dispose() {
    _clouds.dispose();
    _water.dispose();
    _drift.dispose();
    super.dispose();
  }

  /// Parallax offset for a layer, in logical pixels.
  Offset _parallaxFor(double travel) {
    if (!widget.animate) return Offset.zero;
    // Pointer where there is one, a slow lissajous drift where there is not.
    final autoX = math.sin(_drift.value * math.pi * 2);
    final autoY = math.sin(_drift.value * math.pi * 2 * 0.6 + 1.1);
    final x = _pointer == Offset.zero ? autoX * 0.55 : _pointer.dx;
    final y = _pointer == Offset.zero ? autoY * 0.40 : _pointer.dy;
    return Offset(-x * travel, -y * travel * 0.45);
  }

  void _onHover(PointerHoverEvent event, Size size) {
    if (!widget.animate) return;
    final next = Offset(
      (event.localPosition.dx / size.width * 2 - 1).clamp(-1.0, 1.0),
      (event.localPosition.dy / size.height * 2 - 1).clamp(-1.0, 1.0),
    );
    // Only rebuild when the pointer has actually moved a meaningful amount.
    if ((next - _pointer).distance < 0.02) return;
    setState(() => _pointer = next);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final decodeWidth = _decodeWidth(
          size.width,
          MediaQuery.devicePixelRatioOf(context),
        );

        return MouseRegion(
          opaque: false,
          onHover: (e) => _onHover(e, size),
          onExit: (_) {
            if (_pointer != Offset.zero) setState(() => _pointer = Offset.zero);
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ---- 1. Base valley -------------------------------------
              _plate(GuardianWorldAssets.base, size, decodeWidth),

              // ---- 2. Clouds: a slow, seamless two-copy march ----------
              _scrollingPlate(
                GuardianWorldAssets.clouds,
                size,
                decodeWidth,
                _clouds,
                verticalDrift: 6,
              ),

              // ---- 3. Water: shimmer, confined to the stream band ------
              _scrollingPlate(
                GuardianWorldAssets.water,
                size,
                decodeWidth,
                _water,
                verticalDrift: 0,
              ),

              // ---- 4. Generated particle sheet (static richness) -------
              _plate(GuardianWorldAssets.particles, size, decodeWidth),

              // ---- 5. Procedural motes (the movement) ------------------
              RepaintBoundary(
                child: ValleyAtmosphere(
                  animate: widget.animate,
                  motes: widget.compact ? 12 : 22,
                ),
              ),

              // ---- 6. The Guardian, standing in the world --------------
              ?widget.stage,

              // ---- 7. Foreground frame --------------------------------
              _plate(GuardianWorldAssets.foreground, size, decodeWidth),

              // ---- 8. The application UI ------------------------------
              widget.child,
            ],
          ),
        );
      },
    );
  }

  /// A still plate with parallax.
  Widget _plate(WorldLayerAsset layer, Size size, int decodeWidth) {
    if (_failed.contains(layer.path)) return const SizedBox.shrink();
    final image = _image(layer, size, decodeWidth);
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _drift,
          builder: (context, child) => Transform.translate(
            offset: _parallaxFor(layer.parallax),
            child: child,
          ),
          child: image,
        ),
      ),
    );
  }

  /// A plate that scrolls horizontally and loops seamlessly by drawing two
  /// copies one viewport apart.
  Widget _scrollingPlate(
    WorldLayerAsset layer,
    Size size,
    int decodeWidth,
    AnimationController clock, {
    required double verticalDrift,
  }) {
    if (_failed.contains(layer.path)) return const SizedBox.shrink();
    final image = _image(layer, size, decodeWidth, horizontalBleed: false);

    // The plates are paintings, not tiles: butting two copies together shows a
    // seam where the artwork does not meet itself. Mirroring the middle copy
    // makes both joins match column-for-column, and scrolling across *two*
    // viewport widths (A | mirrored B | A) means the wrap lands on identical
    // pixels — so the loop has no seam and no pop.
    final strip = SizedBox(
      width: size.width * 3,
      height: size.height,
      child: Row(
        children: [
          SizedBox(width: size.width, height: size.height, child: image),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Transform.scale(scaleX: -1, child: image),
          ),
          SizedBox(width: size.width, height: size.height, child: image),
        ],
      ),
    );

    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([clock, _drift]),
          builder: (context, child) {
            final parallax = _parallaxFor(layer.parallax);
            final wander = verticalDrift == 0
                ? 0.0
                : math.sin(clock.value * math.pi * 2) * verticalDrift;
            return Transform.translate(
              offset: Offset(
                -clock.value * size.width * 2 + parallax.dx,
                parallax.dy + wander,
              ),
              child: child,
            );
          },
          // The strip is deliberately three viewports wide so it can loop, but
          // the scene Stack is StackFit.expand and would squeeze it to one.
          // OverflowBox hands the strip the width it actually needs; the Stack
          // clips whatever hangs off the edge.
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minWidth: 0,
            maxWidth: size.width * 3,
            minHeight: 0,
            maxHeight: size.height,
            child: strip,
          ),
        ),
      ),
    );
  }

  /// [horizontalBleed] must be false for the scrolling plates. They are drawn
  /// as adjacent copies, so an over-filled copy would overlap its neighbour and
  /// composite the artwork twice — which printed a bright vertical band down
  /// the sky exactly one bleed-width wide.
  Widget _image(
    WorldLayerAsset layer,
    Size size,
    int decodeWidth, {
    bool horizontalBleed = true,
  }) {
    // Parallax moves the plate, so it must over-fill the viewport slightly or
    // an empty edge would swing into view at wide aspect ratios.
    final bleed = layer.parallax * 2 + 8;
    final bleedX = horizontalBleed ? bleed : 0.0;
    return Opacity(
      opacity: layer.opacity,
      child: OverflowBox(
        minWidth: 0,
        minHeight: 0,
        maxWidth: size.width + bleedX * 2,
        maxHeight: size.height + bleed * 2,
        child: Image.asset(
          layer.path,
          width: size.width + bleedX * 2,
          height: size.height + bleed * 2,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          cacheWidth: decodeWidth,
          excludeFromSemantics: true,
          gaplessPlayback: true,
          errorBuilder: (context, error, stack) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _noteFailure(layer.path, error));
            });
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
