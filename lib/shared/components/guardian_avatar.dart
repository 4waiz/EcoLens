import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../painters/guardian_painter.dart';

/// Animated EcoLens Guardian mascot. Blinks periodically, gently bobs, and can
/// pulse a cosmic glow (e.g. on a correct recycle).
class GuardianAvatar extends StatefulWidget {
  const GuardianAvatar({
    super.key,
    this.stage = 1,
    this.size = 220,
    this.happy = true,
    this.glowing = false,
    this.bob = true,
  });

  final int stage;
  final double size;
  final bool happy;

  /// When true, a persistent cosmic glow pulses around the creature.
  final bool glowing;
  final bool bob;

  @override
  State<GuardianAvatar> createState() => _GuardianAvatarState();
}

class _GuardianAvatarState extends State<GuardianAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _bobController;
  late final AnimationController _glowController;
  late final AnimationController _blinkController;
  bool _blink = false;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _scheduleBlink();
  }

  void _scheduleBlink() {
    // Blink every 3.5–5.5s.
    final ms = 3500 + math.Random().nextInt(2000);
    Future.delayed(Duration(milliseconds: ms), () async {
      if (!mounted) return;
      setState(() => _blink = true);
      await _blinkController.forward(from: 0);
      await Future<void>.delayed(const Duration(milliseconds: 90));
      if (!mounted) return;
      setState(() => _blink = false);
      _scheduleBlink();
    });
  }

  @override
  void dispose() {
    _bobController.dispose();
    _glowController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bobController, _glowController]),
      builder: (context, _) {
        final bobOffset =
            widget.bob ? math.sin(_bobController.value * math.pi) * 6 : 0.0;
        final glow = widget.glowing
            ? 0.4 + _glowController.value * 0.6
            : 0.0;
        return Transform.translate(
          offset: Offset(0, -bobOffset),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CustomPaint(
              painter: GuardianPainter(
                stage: widget.stage,
                glow: glow,
                happy: widget.happy,
                blink: _blink,
              ),
            ),
          ),
        );
      },
    );
  }
}
