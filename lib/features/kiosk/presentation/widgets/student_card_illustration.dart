import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A procedural illustration of a physical Student ID card being tapped on an
/// NFC reader, with an animated pulse. Deliberately NOT a phone — students are
/// identified only by their physical card.
///
/// Everything inside the card is sized as a fraction of [width], and every text
/// run is capped to a single line, so the illustration renders identically at
/// any size and can never overflow (it is often placed inside a scaled game
/// panel).
class StudentCardIllustration extends StatefulWidget {
  const StudentCardIllustration({super.key, this.compact = false, this.width});

  /// Convenience preset: a smaller card for side panels.
  final bool compact;

  /// Explicit card width. Overrides [compact] when provided.
  final double? width;

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
    final cardW = widget.width ?? (widget.compact ? 210.0 : 300.0);
    final cardH = cardW * 0.64;
    final pad = cardW * 0.055;
    final readerW = cardW * 0.30;

    return SizedBox(
      width: cardW + readerW,
      height: cardH + cardW * 0.10,
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
                  width: readerW,
                  height: readerW,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 0; i < 3; i++)
                        _ring((_pulse.value + i / 3) % 1.0, readerW),
                      Icon(
                        Icons.wifi_tethering,
                        color: AppColors.primary,
                        size: readerW * 0.34,
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
                borderRadius: BorderRadius.circular(cardW * 0.06),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: cardW * 0.07,
                    offset: Offset(0, cardW * 0.035),
                  ),
                ],
              ),
              padding: EdgeInsets.all(pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ---- Header -------------------------------------------
                  Row(
                    children: [
                      Container(
                        width: cardW * 0.10,
                        height: cardW * 0.10,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(cardW * 0.026),
                        ),
                        child: Icon(
                          Icons.eco,
                          size: cardW * 0.062,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: cardW * 0.03),
                      Flexible(
                        child: Text(
                          'STUDENT ID',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: cardW * 0.005,
                            fontSize: cardW * 0.048,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: cardW * 0.02),
                      // NFC chip glyph.
                      Icon(
                        Icons.contactless,
                        color: Colors.white.withValues(alpha: 0.85),
                        size: cardW * 0.078,
                      ),
                    ],
                  ),

                  // ---- Photo + name placeholders -------------------------
                  Row(
                    children: [
                      Container(
                        width: cardH * 0.40,
                        height: cardH * 0.40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(cardW * 0.035),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: cardH * 0.24,
                        ),
                      ),
                      SizedBox(width: cardW * 0.045),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _bar(cardW * 0.42, cardH * 0.07),
                            SizedBox(height: cardH * 0.055),
                            _bar(cardW * 0.30, cardH * 0.055, alpha: 0.5),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ---- Masked number — never the full identifier ---------
                  Text(
                    '•••• •••• 0417',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      letterSpacing: cardW * 0.007,
                      fontSize: cardW * 0.050,
                      height: 1.1,
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

  Widget _bar(double w, double h, {double alpha = 0.85}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: alpha),
      borderRadius: BorderRadius.circular(h * 0.5),
    ),
  );

  Widget _ring(double t, double box) {
    final size = box * (0.22 + t * 0.78);
    final opacity = (1 - t).clamp(0.0, 1.0) * 0.5;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: opacity),
          width: box * 0.034,
        ),
      ),
    );
  }
}
