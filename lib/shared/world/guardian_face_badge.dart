import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A small friendly Sprout face — the Guardian in badge form.
///
/// Drawn rather than loaded, for two reasons: the attract screen keeps exactly
/// ONE Guardian bitmap on stage (the character standing on the dais), and a
/// vector face stays crisp at 28 px where a downscaled 1024² frame would not.
///
/// Used wherever the Guardian needs to appear *inside* the UI — the mission
/// panel header and the dialogue bubble — as opposed to standing in the world.
class GuardianFaceBadge extends StatefulWidget {
  const GuardianFaceBadge({super.key, required this.size, this.animate = true});

  final double size;
  final bool animate;

  @override
  State<GuardianFaceBadge> createState() => _GuardianFaceBadgeState();
}

class _GuardianFaceBadgeState extends State<GuardianFaceBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob;

  @override
  void initState() {
    super.initState();
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.animate) _bob.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant GuardianFaceBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate == oldWidget.animate) return;
    if (widget.animate) {
      _bob.repeat(reverse: true);
    } else {
      _bob.stop();
      _bob.value = 0;
    }
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Sprout, your Guardian',
      image: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _bob,
          builder: (context, _) => CustomPaint(
            size: Size.square(widget.size),
            painter: _GuardianFacePainter(t: _bob.value),
          ),
        ),
      ),
    );
  }
}

class _GuardianFacePainter extends CustomPainter {
  const _GuardianFacePainter({required this.t});

  /// 0..1 idle wave — drives a tiny blink / bob.
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final c = Offset(w * 0.5, h * 0.54 + math.sin(t * math.pi) * h * 0.02);
    final r = w * 0.38;

    // Soft aura.
    canvas.drawCircle(
      c,
      r * 1.32,
      Paint()..color = AppColors.guardianGreen.withValues(alpha: 0.16),
    );

    // Leaf horns.
    final leaf = Paint()..color = AppColors.guardianLeaf;
    for (final dir in const [-1.0, 1.0]) {
      final path = Path()
        ..moveTo(c.dx + dir * r * 0.42, c.dy - r * 0.72)
        ..quadraticBezierTo(
          c.dx + dir * r * 1.16,
          c.dy - r * 1.36,
          c.dx + dir * r * 0.96,
          c.dy - r * 0.52,
        )
        ..quadraticBezierTo(
          c.dx + dir * r * 0.72,
          c.dy - r * 0.52,
          c.dx + dir * r * 0.42,
          c.dy - r * 0.72,
        );
      canvas.drawPath(path, leaf);
    }

    // Head.
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF8FD97F), AppColors.guardianGreen],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    // Snout.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy + r * 0.34),
        width: r * 0.96,
        height: r * 0.62,
      ),
      Paint()..color = const Color(0xFFD9F2C4),
    );

    // Eyes — a slow blink so the badge feels alive without being distracting.
    final blink = t > 0.92 ? 0.2 : 1.0;
    for (final dir in const [-1.0, 1.0]) {
      final eye = Offset(c.dx + dir * r * 0.34, c.dy - r * 0.14);
      canvas.drawOval(
        Rect.fromCenter(center: eye, width: r * 0.30, height: r * 0.36 * blink),
        Paint()..color = Colors.white,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: eye.translate(0, r * 0.02),
          width: r * 0.15,
          height: r * 0.20 * blink,
        ),
        Paint()..color = AppColors.ink,
      );
    }

    // Cheeks + smile.
    final blush = Paint()
      ..color = const Color(0xFFFF9EAE).withValues(alpha: 0.5);
    for (final dir in const [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(c.dx + dir * r * 0.62, c.dy + r * 0.24),
          width: r * 0.30,
          height: r * 0.18,
        ),
        blush,
      );
    }
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(c.dx, c.dy + r * 0.30),
        width: r * 0.46,
        height: r * 0.34,
      ),
      0.25,
      math.pi - 0.5,
      false,
      Paint()
        ..color = AppColors.primaryDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, r * 0.09)
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GuardianFacePainter old) => old.t != t;
}
