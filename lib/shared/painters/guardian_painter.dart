import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Procedurally drawn EcoLens Guardian mascot — a friendly caped green
/// leaf-sprout creature matching the Nano Banana reference art. No image assets
/// required. The [stage] (0..4) enriches the surrounding environment so the
/// creature's evolution visibly mirrors the student's real-world impact.
class GuardianPainter extends CustomPainter {
  GuardianPainter({
    required this.stage,
    this.glow = 0,
    this.happy = true,
    this.blink = false,
    this.showPodium = true,
  });

  /// Evolution stage: 0 seedling, 1 sprout, 2 eco guardian, 3 forest protector,
  /// 4 thriving ecosystem.
  final int stage;

  /// Cosmic-glow intensity 0..1 (pulses on a correct recycle).
  final double glow;
  final bool happy;
  final bool blink;
  final bool showPodium;

  static const _bodyGreen = Color(0xFF7FC24B);
  static const _bodyGreenDark = Color(0xFF5BA637);
  static const _capeGreen = Color(0xFF3F8F3A);
  static const _capeGreenDark = Color(0xFF2E6E2C);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;

    // Composition anchors.
    final bodyCenter = Offset(cx, h * 0.52);
    final bodyR = w * 0.24;

    // ---- Soft background blob + environment ----
    _paintBackdrop(canvas, size, bodyCenter, bodyR);

    // ---- Cosmic glow halo ----
    if (glow > 0) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.guardianLeaf.withValues(alpha: 0.5 * glow),
            AppColors.guardianLeaf.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: bodyCenter, radius: bodyR * 2.6));
      canvas.drawCircle(bodyCenter, bodyR * 2.6, glowPaint);
    }

    if (showPodium) _paintPodium(canvas, size, bodyCenter, bodyR);

    // ---- Cape (behind the body) ----
    _paintCape(canvas, bodyCenter, bodyR);

    // ---- Legs ----
    _paintLegs(canvas, bodyCenter, bodyR);

    // ---- Body ----
    final bodyRect = Rect.fromCenter(
      center: bodyCenter,
      width: bodyR * 1.9,
      height: bodyR * 2.25,
    );
    final bodyPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          bodyRect,
          topLeft: Radius.circular(bodyR),
          topRight: Radius.circular(bodyR),
          bottomLeft: Radius.circular(bodyR * 0.75),
          bottomRight: Radius.circular(bodyR * 0.75),
        ),
      );
    canvas.drawShadow(bodyPath, Colors.black.withValues(alpha: 0.18), 8, false);
    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_bodyGreen, _bodyGreenDark],
        ).createShader(bodyRect),
    );

    // ---- Leafy crown / hair ----
    _paintCrown(canvas, Offset(cx, bodyCenter.dy - bodyR * 0.95), bodyR);

    // ---- Recycling emblem on chest ----
    _paintRecycleEmblem(canvas, bodyCenter.translate(0, bodyR * 0.35), bodyR * 0.42);

    // ---- Arms ----
    _paintArms(canvas, bodyCenter, bodyR);

    // ---- Face ----
    _paintFace(canvas, Offset(cx, bodyCenter.dy - bodyR * 0.25), bodyR);

    // ---- Foreground sparkles ----
    _paintSparkles(canvas, size, bodyCenter, bodyR);
  }

  void _paintBackdrop(Canvas canvas, Size size, Offset c, double bodyR) {
    // A soft rounded green wash behind the creature (like the references).
    final blob = Paint()..color = AppColors.primarySurface.withValues(alpha: 0.7);
    canvas.drawOval(
      Rect.fromCenter(
        center: c.translate(0, -bodyR * 0.1),
        width: bodyR * 3.4,
        height: bodyR * 3.2,
      ),
      blob,
    );
  }

  void _paintPodium(Canvas canvas, Size size, Offset bodyCenter, double bodyR) {
    final podiumTop = bodyCenter.dy + bodyR * 1.25;
    final podiumRect = Rect.fromCenter(
      center: Offset(bodyCenter.dx, podiumTop + bodyR * 0.28),
      width: bodyR * 3.1,
      height: bodyR * 0.9,
    );
    // Grass podium.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bodyCenter.dx, podiumTop),
        width: bodyR * 3.1,
        height: bodyR * 0.7,
      ),
      Paint()..color = const Color(0xFF8FCB5A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(podiumRect, Radius.circular(bodyR * 0.2)),
      Paint()..color = const Color(0xFF7FBF4C),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bodyCenter.dx, podiumTop),
        width: bodyR * 3.1,
        height: bodyR * 0.55,
      ),
      Paint()..color = const Color(0xFFA5D96E),
    );
  }

  void _paintCape(Canvas canvas, Offset c, double bodyR) {
    final capeRect = Rect.fromCenter(
      center: c.translate(bodyR * 0.15, bodyR * 0.1),
      width: bodyR * 2.4,
      height: bodyR * 2.4,
    );
    // A single leaf-shaped cape sweeping to one side.
    final path = Path()
      ..moveTo(c.dx - bodyR * 0.4, c.dy - bodyR * 0.9)
      ..quadraticBezierTo(
        c.dx + bodyR * 1.6, c.dy - bodyR * 0.2,
        c.dx + bodyR * 0.9, c.dy + bodyR * 1.25,
      )
      ..quadraticBezierTo(
        c.dx + bodyR * 0.2, c.dy + bodyR * 0.9,
        c.dx - bodyR * 0.4, c.dy + bodyR * 1.0,
      )
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [_capeGreen, _capeGreenDark],
        ).createShader(capeRect),
    );
    // Cape vein.
    canvas.drawLine(
      c.translate(bodyR * 0.2, -bodyR * 0.5),
      c.translate(bodyR * 0.6, bodyR * 0.9),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = bodyR * 0.05
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintLegs(Canvas canvas, Offset c, double bodyR) {
    final legPaint = Paint()..color = _bodyGreenDark;
    for (final dx in [-bodyR * 0.45, bodyR * 0.45]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c.translate(dx, bodyR * 1.2),
            width: bodyR * 0.5,
            height: bodyR * 0.6,
          ),
          Radius.circular(bodyR * 0.22),
        ),
        legPaint,
      );
    }
  }

  void _paintCrown(Canvas canvas, Offset base, double bodyR) {
    final leaf = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF8BD44F), Color(0xFF5BA637)],
      ).createShader(
        Rect.fromCircle(center: base, radius: bodyR),
      );

    // Several leaves fanning out like hair.
    void oneLeaf(double angle, double len, double width) {
      canvas.save();
      canvas.translate(base.dx, base.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(-width, -len * 0.6, 0, -len)
        ..quadraticBezierTo(width, -len * 0.6, 0, 0)
        ..close();
      canvas.drawPath(path, leaf);
      // vein
      canvas.drawLine(
        Offset.zero,
        Offset(0, -len * 0.9),
        Paint()
          ..color = _capeGreenDark.withValues(alpha: 0.4)
          ..strokeWidth = bodyR * 0.03,
      );
      canvas.restore();
    }

    oneLeaf(0, bodyR * 1.05, bodyR * 0.34); // center tall
    oneLeaf(-0.5, bodyR * 0.85, bodyR * 0.30);
    oneLeaf(0.5, bodyR * 0.85, bodyR * 0.30);
    oneLeaf(-0.95, bodyR * 0.62, bodyR * 0.26);
    oneLeaf(0.95, bodyR * 0.62, bodyR * 0.26);
  }

  void _paintRecycleEmblem(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = Colors.white.withValues(alpha: 0.92));
    final arrow = Paint()
      ..color = _bodyGreenDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.22
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 3; i++) {
      final a = i * (2 * math.pi / 3) - math.pi / 2;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * 0.5),
        a,
        1.4,
        false,
        arrow,
      );
      // Arrowhead at the end of each arc.
      final aEnd = a + 1.4;
      final head = c + Offset(math.cos(aEnd), math.sin(aEnd)) * r * 0.5;
      canvas.drawCircle(head, r * 0.11, Paint()..color = _bodyGreenDark);
    }
  }

  void _paintArms(Canvas canvas, Offset c, double bodyR) {
    final armPaint = Paint()
      ..color = _bodyGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyR * 0.34
      ..strokeCap = StrokeCap.round;
    final handPaint = Paint()..color = _bodyGreenDark;

    // Left arm raised in a friendly wave.
    final lShoulder = c.translate(-bodyR * 0.85, -bodyR * 0.15);
    final lHand = happy
        ? c.translate(-bodyR * 1.35, -bodyR * 0.85)
        : c.translate(-bodyR * 1.25, bodyR * 0.35);
    canvas.drawLine(lShoulder, lHand, armPaint);
    canvas.drawCircle(lHand, bodyR * 0.2, handPaint);

    // Right arm resting on hip.
    final rShoulder = c.translate(bodyR * 0.85, -bodyR * 0.15);
    final rHand = c.translate(bodyR * 1.05, bodyR * 0.35);
    canvas.drawLine(rShoulder, rHand, armPaint);
    canvas.drawCircle(rHand, bodyR * 0.2, handPaint);
  }

  void _paintFace(Canvas canvas, Offset faceCenter, double bodyR) {
    final eyeY = faceCenter.dy;
    final eyeDx = bodyR * 0.42;
    final eyeR = bodyR * 0.19;

    // Eye whites.
    if (!blink) {
      for (final dx in [-eyeDx, eyeDx]) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(faceCenter.dx + dx, eyeY),
            width: eyeR * 1.7,
            height: eyeR * 2.1,
          ),
          Paint()..color = Colors.white,
        );
        // Pupil.
        canvas.drawCircle(
          Offset(faceCenter.dx + dx, eyeY + eyeR * 0.15),
          eyeR * 0.62,
          Paint()..color = const Color(0xFF213026),
        );
        // Sparkle.
        canvas.drawCircle(
          Offset(faceCenter.dx + dx + eyeR * 0.22, eyeY - eyeR * 0.15),
          eyeR * 0.22,
          Paint()..color = Colors.white,
        );
      }
    } else {
      final lid = Paint()
        ..color = const Color(0xFF213026)
        ..style = PaintingStyle.stroke
        ..strokeWidth = bodyR * 0.06
        ..strokeCap = StrokeCap.round;
      for (final dx in [-eyeDx, eyeDx]) {
        canvas.drawLine(
          Offset(faceCenter.dx + dx - eyeR, eyeY),
          Offset(faceCenter.dx + dx + eyeR, eyeY),
          lid,
        );
      }
    }

    // Rosy cheeks.
    final cheek = Paint()..color = const Color(0xFFF48FB1).withValues(alpha: 0.5);
    canvas.drawCircle(
        Offset(faceCenter.dx - eyeDx - eyeR * 0.3, eyeY + eyeR * 1.5),
        eyeR * 0.62, cheek);
    canvas.drawCircle(
        Offset(faceCenter.dx + eyeDx + eyeR * 0.3, eyeY + eyeR * 1.5),
        eyeR * 0.62, cheek);

    // Smile.
    final mouth = Paint()
      ..color = const Color(0xFF213026)
      ..style = PaintingStyle.stroke
      ..strokeWidth = bodyR * 0.055
      ..strokeCap = StrokeCap.round;
    final mouthRect = Rect.fromCenter(
      center: Offset(faceCenter.dx, eyeY + eyeR * 1.9),
      width: bodyR * 0.55,
      height: bodyR * (happy ? 0.45 : 0.22),
    );
    canvas.drawArc(mouthRect, 0.15, math.pi - 0.3, false, mouth);
    if (happy) {
      // little tongue
      canvas.drawCircle(
        Offset(faceCenter.dx, eyeY + eyeR * 2.15),
        bodyR * 0.09,
        Paint()..color = const Color(0xFFEF7D8E),
      );
    }
  }

  void _paintSparkles(Canvas canvas, Size size, Offset c, double bodyR) {
    final sparkle = Paint()..color = AppColors.guardianLeaf.withValues(alpha: 0.7);
    void star(Offset o, double s) {
      final path = Path()
        ..moveTo(o.dx, o.dy - s)
        ..lineTo(o.dx + s * 0.3, o.dy - s * 0.3)
        ..lineTo(o.dx + s, o.dy)
        ..lineTo(o.dx + s * 0.3, o.dy + s * 0.3)
        ..lineTo(o.dx, o.dy + s)
        ..lineTo(o.dx - s * 0.3, o.dy + s * 0.3)
        ..lineTo(o.dx - s, o.dy)
        ..lineTo(o.dx - s * 0.3, o.dy - s * 0.3)
        ..close();
      canvas.drawPath(path, sparkle);
    }

    star(c.translate(bodyR * 1.35, -bodyR * 1.05), bodyR * 0.12);
    star(c.translate(-bodyR * 1.4, bodyR * 0.1), bodyR * 0.09);

    // Floating leaves for higher stages.
    if (stage >= 2) {
      _leaf(canvas, c.translate(-bodyR * 1.5, -bodyR * 0.8), bodyR * 0.28, -0.4);
      _leaf(canvas, c.translate(bodyR * 1.55, bodyR * 0.5), bodyR * 0.24, 0.6);
    }
    if (stage >= 4) {
      _leaf(canvas, c.translate(bodyR * 1.7, -bodyR * 0.4), bodyR * 0.2, 1.2);
    }
  }

  void _leaf(Canvas canvas, Offset o, double s, double rot) {
    canvas.save();
    canvas.translate(o.dx, o.dy);
    canvas.rotate(rot);
    final path = Path()
      ..moveTo(0, -s)
      ..quadraticBezierTo(s * 0.8, 0, 0, s)
      ..quadraticBezierTo(-s * 0.8, 0, 0, -s)
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.guardianLeaf.withValues(alpha: 0.55));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant GuardianPainter old) =>
      old.stage != stage ||
      old.glow != glow ||
      old.happy != happy ||
      old.blink != blink ||
      old.showPodium != showPodium;
}
