import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A mocked camera preview inside a scanning frame. Renders a soft "viewfinder"
/// with animated corner reticles and a sweeping scan line while capturing. When
/// [unavailable] is set it shows a camera-unavailable state instead.
///
/// A real deployment would swap the inner placeholder for a live camera texture
/// (e.g. the `camera` plugin or an MJPEG stream from the bin's IP camera).
class CameraFrame extends StatefulWidget {
  const CameraFrame({
    super.key,
    this.capturing = false,
    this.unavailable = false,
    this.errorMessage,
    this.itemLabel,
  });

  final bool capturing;
  final bool unavailable;
  final String? errorMessage;
  final String? itemLabel;

  @override
  State<CameraFrame> createState() => _CameraFrameState();
}

class _CameraFrameState extends State<CameraFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scan;

  @override
  void initState() {
    super.initState();
    _scan = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: widget.unavailable
                  ? AppColors.errorSurface
                  : const Color(0xFF223028),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: widget.unavailable ? AppColors.error : AppColors.primary,
                width: 3,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: widget.unavailable
                ? _unavailable(context)
                : _preview(constraints),
          );
        },
      ),
    );
  }

  Widget _unavailable(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.videocam_off, size: 56, color: AppColors.error),
          const SizedBox(height: 12),
          Text(
            'Camera unavailable',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.error),
          ),
          const SizedBox(height: 4),
          Text(
            widget.errorMessage ?? 'Please ask a teacher for help.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _preview(BoxConstraints constraints) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Faux camera backdrop.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                const Color(0xFF2E4034),
                const Color(0xFF1A241E).withValues(alpha: 0.9),
              ],
            ),
          ),
        ),
        // A silhouette of an item being held.
        Center(
          child: Icon(
            Icons.local_drink,
            size: constraints.maxHeight * 0.4,
            color: Colors.white.withValues(alpha: 0.28),
          ),
        ),
        if (widget.itemLabel != null)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  widget.itemLabel!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        // Corner reticles.
        _corners(),
        // Scan line while capturing.
        if (widget.capturing)
          AnimatedBuilder(
            animation: _scan,
            builder: (context, _) {
              return Align(
                alignment: Alignment(0, _scan.value * 2 - 1),
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.guardianLeaf.withValues(alpha: 0),
                        AppColors.guardianLeaf,
                        AppColors.guardianLeaf.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        if (widget.capturing)
          const Positioned(
            top: 12,
            right: 12,
            child: _RecDot(),
          ),
      ],
    );
  }

  Widget _corners() {
    const c = AppColors.guardianLeaf;
    Widget corner(Alignment a) => Align(
          alignment: a,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: CustomPaint(
              size: const Size(28, 28),
              painter: _CornerPainter(a, c),
            ),
          ),
        );
    return Stack(
      children: [
        corner(Alignment.topLeft),
        corner(Alignment.topRight),
        corner(Alignment.bottomLeft),
        corner(Alignment.bottomRight),
      ],
    );
  }
}

class _RecDot extends StatelessWidget {
  const _RecDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.circle, size: 10, color: AppColors.error),
          SizedBox(width: 6),
          Text(
            'SCANNING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter(this.alignment, this.color);
  final Alignment alignment;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final w = size.width;
    final h = size.height;
    final isLeft = alignment.x < 0;
    final isTop = alignment.y < 0;
    final path = Path();
    final cornerX = isLeft ? 0.0 : w;
    final cornerY = isTop ? 0.0 : h;
    path.moveTo(cornerX, isTop ? h : 0);
    path.lineTo(cornerX, cornerY);
    path.lineTo(isLeft ? w : 0, cornerY);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
