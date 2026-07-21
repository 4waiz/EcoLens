import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Procedurally drawn EcoLens Guardian mascot — a friendly green leaf-sprout
/// creature matching the Nano Banana reference art. No image assets required.
///
/// The [stage] (0..4) changes the creature's environment/features so its
/// evolution visibly mirrors the student's real-world recycling impact.
class GuardianPainter extends CustomPainter {
  GuardianPainter({
    required this.stage,
    this.glow = 0,
    this.happy = true,
    this.blink = false,
  });

  /// Evolution stage: 0 seedling, 1 sprout, 2 eco guardian, 3 forest protector,
  /// 4 thriving ecosystem.
  final int stage;

  /// Cosmic-glow intensity 0..1 (pulses on a correct recycle).
  final double glow;
  final bool happy;
  final bool blink;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final bodyR = w * 0.26;
    final bodyCenter = Offset(cx, h * 0.60);

    // ---- Ground / environment by stage ----
    _paintEnvironment(canvas, size);

    // ---- Cosmic glow halo ----
    if (glow > 0) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.guardianLeaf.withValues(alpha: 0.55 * glow),
            AppColors.guardianLeaf.withValues(alpha: 0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: bodyCenter, radius: bodyR * 2.4),
        );
      canvas.drawCircle(bodyCenter, bodyR * 2.4, glowPaint);
    }

    // ---- Body (rounded blob) ----
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [AppColors.guardianGreen, AppColors.primary],
      ).createShader(Rect.fromCircle(center: bodyCenter, radius: bodyR));

    final bodyPath = Path()
      ..addOval(
        Rect.fromCenter(
          center: bodyCenter,
          width: bodyR * 2,
          height: bodyR * 2.15,
        ),
      );
    canvas.drawShadow(bodyPath, Colors.black.withValues(alpha: 0.2), 6, false);
    canvas.drawPath(bodyPath, bodyPaint);

    // Belly highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: bodyCenter.translate(0, bodyR * 0.25),
        width: bodyR * 1.1,
        height: bodyR * 1.2,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.18),
    );

    // ---- Sprout leaves on head ----
    _paintSprout(canvas, Offset(cx, bodyCenter.dy - bodyR * 1.05), bodyR);

    // ---- Face ----
    _paintFace(canvas, bodyCenter, bodyR);

    // ---- Arms ----
    final armPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyR * 0.22
      ..strokeCap = StrokeCap.round;
    // Left arm raised in a wave when happy.
    final leftShoulder = bodyCenter.translate(-bodyR * 0.85, -bodyR * 0.1);
    final leftHand = happy
        ? bodyCenter.translate(-bodyR * 1.25, -bodyR * 0.7)
        : bodyCenter.translate(-bodyR * 1.15, bodyR * 0.2);
    canvas.drawLine(leftShoulder, leftHand, armPaint);
    final rightShoulder = bodyCenter.translate(bodyR * 0.85, -bodyR * 0.1);
    final rightHand = bodyCenter.translate(bodyR * 1.15, bodyR * 0.2);
    canvas.drawLine(rightShoulder, rightHand, armPaint);
  }

  void _paintSprout(Canvas canvas, Offset base, double bodyR) {
    final leafPaint = Paint()..color = AppColors.guardianLeaf;
    final stemPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyR * 0.10
      ..strokeCap = StrokeCap.round;

    // stem
    canvas.drawLine(base, base.translate(0, bodyR * 0.4), stemPaint);

    // two leaves
    Path leaf(bool left) {
      final dir = left ? -1 : 1;
      final tip = base.translate(dir * bodyR * 0.55, -bodyR * 0.35);
      return Path()
        ..moveTo(base.dx, base.dy)
        ..quadraticBezierTo(
          base.dx + dir * bodyR * 0.1,
          base.dy - bodyR * 0.5,
          tip.dx,
          tip.dy,
        )
        ..quadraticBezierTo(
          base.dx + dir * bodyR * 0.5,
          base.dy - bodyR * 0.05,
          base.dx,
          base.dy,
        );
    }

    canvas.drawPath(leaf(true), leafPaint);
    canvas.drawPath(leaf(false), leafPaint);
    // leaf veins
    final veinPaint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.4)
      ..strokeWidth = bodyR * 0.03;
    canvas.drawLine(
      base,
      base.translate(-bodyR * 0.4, -bodyR * 0.28),
      veinPaint,
    );
    canvas.drawLine(
      base,
      base.translate(bodyR * 0.4, -bodyR * 0.28),
      veinPaint,
    );
  }

  void _paintFace(Canvas canvas, Offset bodyCenter, double bodyR) {
    final eyeY = bodyCenter.dy - bodyR * 0.15;
    final eyeDx = bodyR * 0.42;
    final eyePaint = Paint()..color = AppColors.ink;
    final eyeR = bodyR * 0.13;

    if (blink) {
      final lidPaint = Paint()
        ..color = AppColors.ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = bodyR * 0.06
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(bodyCenter.dx - eyeDx - eyeR, eyeY),
        Offset(bodyCenter.dx - eyeDx + eyeR, eyeY),
        lidPaint,
      );
      canvas.drawLine(
        Offset(bodyCenter.dx + eyeDx - eyeR, eyeY),
        Offset(bodyCenter.dx + eyeDx + eyeR, eyeY),
        lidPaint,
      );
    } else {
      canvas.drawCircle(Offset(bodyCenter.dx - eyeDx, eyeY), eyeR, eyePaint);
      canvas.drawCircle(Offset(bodyCenter.dx + eyeDx, eyeY), eyeR, eyePaint);
      // eye sparkle
      final sparkle = Paint()..color = Colors.white;
      canvas.drawCircle(
        Offset(bodyCenter.dx - eyeDx + eyeR * 0.3, eyeY - eyeR * 0.3),
        eyeR * 0.35,
        sparkle,
      );
      canvas.drawCircle(
        Offset(bodyCenter.dx + eyeDx + eyeR * 0.3, eyeY - eyeR * 0.3),
        eyeR * 0.35,
        sparkle,
      );
    }

    // rosy cheeks
    final cheekPaint = Paint()
      ..color = const Color(0xFFF48FB1).withValues(alpha: 0.55);
    canvas.drawCircle(
      Offset(bodyCenter.dx - eyeDx - eyeR * 0.5, eyeY + eyeR * 1.6),
      eyeR * 0.7,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(bodyCenter.dx + eyeDx + eyeR * 0.5, eyeY + eyeR * 1.6),
      eyeR * 0.7,
      cheekPaint,
    );

    // mouth
    final mouthPaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyR * 0.05
      ..strokeCap = StrokeCap.round;
    final mouthRect = Rect.fromCenter(
      center: Offset(bodyCenter.dx, eyeY + eyeR * 2.2),
      width: bodyR * 0.5,
      height: bodyR * (happy ? 0.4 : 0.2),
    );
    canvas.drawArc(mouthRect, 0.15, math.pi - 0.3, false, mouthPaint);
  }

  /// Environment behind/around the creature grows richer with each stage.
  void _paintEnvironment(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final groundY = h * 0.86;

    // Soil mound
    final soil = Paint()..color = const Color(0xFFBFA98A).withValues(alpha: 0.6);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, groundY),
        width: w * 0.85,
        height: h * 0.16,
      ),
      soil,
    );
    // Grass
    final grass = Paint()..color = AppColors.guardianLeaf.withValues(alpha: 0.7);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, groundY - h * 0.02),
        width: w * 0.8,
        height: h * 0.10,
      ),
      grass,
    );

    if (stage >= 2) {
      // small flowers
      _flower(canvas, Offset(w * 0.24, groundY - h * 0.02), w * 0.03,
          const Color(0xFFF6C744));
      _flower(canvas, Offset(w * 0.78, groundY - h * 0.01), w * 0.028,
          const Color(0xFFEC7FA9));
    }
    if (stage >= 3) {
      // a little tree to the side
      _tree(canvas, Offset(w * 0.83, groundY - h * 0.03), w * 0.10);
      _tree(canvas, Offset(w * 0.17, groundY - h * 0.02), w * 0.08);
    }
    if (stage >= 4) {
      // birds / butterflies
      _bird(canvas, Offset(w * 0.30, h * 0.20), w * 0.05);
      _bird(canvas, Offset(w * 0.68, h * 0.14), w * 0.04);
      _butterfly(canvas, Offset(w * 0.75, h * 0.45), w * 0.035);
    }
  }

  void _flower(Canvas canvas, Offset c, double r, Color color) {
    final petal = Paint()..color = color;
    for (var i = 0; i < 5; i++) {
      final a = i * (2 * math.pi / 5);
      canvas.drawCircle(
        c.translate(math.cos(a) * r, math.sin(a) * r),
        r * 0.7,
        petal,
      );
    }
    canvas.drawCircle(c, r * 0.6, Paint()..color = const Color(0xFFFFF3C4));
  }

  void _tree(Canvas canvas, Offset base, double size) {
    canvas.drawRect(
      Rect.fromCenter(
        center: base.translate(0, -size * 0.4),
        width: size * 0.22,
        height: size * 0.8,
      ),
      Paint()..color = const Color(0xFF8D6E63),
    );
    canvas.drawCircle(
      base.translate(0, -size),
      size * 0.7,
      Paint()..color = AppColors.primary.withValues(alpha: 0.9),
    );
    canvas.drawCircle(
      base.translate(-size * 0.4, -size * 0.8),
      size * 0.5,
      Paint()..color = AppColors.guardianGreen,
    );
  }

  void _bird(Canvas canvas, Offset c, double size) {
    final p = Paint()
      ..color = AppColors.inkMuted
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: c.translate(-size * 0.5, 0), radius: size * 0.5),
      math.pi * 0.15,
      math.pi * 0.7,
      false,
      p,
    );
    canvas.drawArc(
      Rect.fromCircle(center: c.translate(size * 0.5, 0), radius: size * 0.5),
      math.pi * 0.15,
      math.pi * 0.7,
      false,
      p,
    );
  }

  void _butterfly(Canvas canvas, Offset c, double size) {
    final wing = Paint()..color = const Color(0xFF9C6ADE).withValues(alpha: 0.8);
    canvas.drawCircle(c.translate(-size, -size * 0.3), size * 0.7, wing);
    canvas.drawCircle(c.translate(size, -size * 0.3), size * 0.7, wing);
    canvas.drawCircle(c.translate(-size, size * 0.5), size * 0.5, wing);
    canvas.drawCircle(c.translate(size, size * 0.5), size * 0.5, wing);
    canvas.drawLine(
      c.translate(0, -size),
      c.translate(0, size),
      Paint()
        ..color = AppColors.ink
        ..strokeWidth = size * 0.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant GuardianPainter old) =>
      old.stage != stage ||
      old.glow != glow ||
      old.happy != happy ||
      old.blink != blink;
}
