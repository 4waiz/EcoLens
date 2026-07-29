import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The EcoLens wordmark + leaf lens mark, drawn without image assets.
class EcoLensLogo extends StatelessWidget {
  const EcoLensLogo({
    super.key,
    this.height = 44,
    this.showTagline = false,
    this.onLight = true,
  });

  final double height;
  final bool showTagline;
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final textColor = onLight ? AppColors.primaryDark : Colors.white;

    // The logo is dropped into narrow nav rails, HUD capsules AND unbounded
    // rows (e.g. inside a FittedBox). Flexing is right when there is a width to
    // flex within; a flex child under unbounded width would assert — so the
    // wordmark only becomes flexible once the incoming width is bounded.
    return LayoutBuilder(
      builder: (context, constraints) {
        final wordmark = _wordmark(textColor);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LeafLensMark(size: height),
            SizedBox(width: height * 0.28),
            if (constraints.hasBoundedWidth)
              Flexible(child: wordmark)
            else
              wordmark,
          ],
        );
      },
    );
  }

  Widget _wordmark(Color textColor) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: height * 5.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Eco',
                  style: TextStyle(
                    fontSize: height * 0.66,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                    height: 1,
                  ),
                ),
                TextSpan(
                  text: 'Lens',
                  style: TextStyle(
                    fontSize: height * 0.66,
                    fontWeight: FontWeight.w800,
                    color: onLight
                        ? AppColors.primaryLight
                        : AppColors.guardianLeaf,
                    height: 1,
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
          if (showTagline)
            Padding(
              padding: EdgeInsets.only(top: height * 0.08),
              child: Text(
                'Learn. Act. Earn. Save our planet.',
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  fontSize: height * 0.24,
                  color: onLight ? AppColors.inkMuted : Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _LeafLensMark extends StatelessWidget {
  const _LeafLensMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: AppColors.primary, width: size * 0.05),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.6, size * 0.6),
          painter: _LeafPainter(),
        ),
      ),
    );
  }
}

class _LeafPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final leaf = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.guardianLeaf, AppColors.primary],
      ).createShader(Offset.zero & size);

    final path = Path()
      ..moveTo(w * 0.5, h * 0.05)
      ..quadraticBezierTo(w * 1.0, h * 0.35, w * 0.5, h * 0.95)
      ..quadraticBezierTo(w * 0.0, h * 0.35, w * 0.5, h * 0.05)
      ..close();
    canvas.drawPath(path, leaf);

    // central vein
    final vein = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.2), Offset(w * 0.5, h * 0.82), vein);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
