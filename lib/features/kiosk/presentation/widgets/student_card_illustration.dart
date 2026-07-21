import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A procedural illustration of a physical Student ID card being tapped on an
/// NFC reader, with an animated pulse. Deliberately NOT a phone — students are
/// identified only by their physical card.
class StudentCardIllustration extends StatefulWidget {
  const StudentCardIllustration({super.key, this.compact = false});
  final bool compact;

  @override
  State<StudentCardIllustration> createState() =>
      _StudentCardIllustrationState();
}

class _StudentCardIllustrationState extends State<StudentCardIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardW = widget.compact ? 200.0 : 300.0;
    final cardH = cardW * 0.62;
    return SizedBox(
      width: cardW + 90,
      height: cardH + 30,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // NFC pulse rings on the right edge.
          Positioned(
            right: 0,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) {
                return SizedBox(
                  width: 90,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        _ring((_pulse.value + i / 3) % 1.0),
                      const Icon(
                        Icons.wifi_tethering,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // The ID card.
          Positioned(
            left: 0,
            child: Container(
              width: cardW,
              height: cardH,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Icon(Icons.eco,
                            size: 16, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'STUDENT ID',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      // NFC chip glyph.
                      Icon(
                        Icons.contactless,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: 22,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      // Photo placeholder.
                      Container(
                        width: cardH * 0.42,
                        height: cardH * 0.42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 64,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Masked number — never show a full identifier.
                  Text(
                    '•••• •••• 0417',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: 2,
                      fontSize: 14,
                      fontFeatures: const [],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ring(double t) {
    final size = 20 + t * 70;
    final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: opacity),
          width: 3,
        ),
      ),
    );
  }
}
