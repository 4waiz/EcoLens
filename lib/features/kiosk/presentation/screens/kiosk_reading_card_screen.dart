import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/valley_tokens.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/components/valley_ui.dart';
import '../../application/kiosk_controller.dart';
import '../../application/kiosk_preferences.dart';
import '../widgets/student_mission_panel.dart';
import '../widgets/valley_chrome.dart';

/// SCREEN 2 — Reading Student ID card (+ not-found handling).
///
/// The moment a child's card is recognised should be the most magical beat in
/// the flow, so this is staged rather than reported: the card leans in toward a
/// glowing reader, leaves lift off it and travel up toward Sprout, and energy
/// runs along a vine while the real lookup happens.
///
/// Two rules the animation obeys:
///   * the progress track is **indeterminate on purpose**. It shows activity,
///     not a percentage — a fake bar that stalls at 90% is worse than none;
///   * nothing here delays the real scan. The screen is replaced the instant the
///     controller resolves the card, mid-animation if that is when it lands.
///
/// When a card does not resolve, the same surface turns into a calm retry — warm
/// amber, never an error red, and never a scolding.
class KioskReadingCardScreen extends ConsumerWidget {
  const KioskReadingCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = context.gameScale;
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final animate = !ref.watch(kioskPreferencesProvider).reduceMotion;
    final notFound = session.state == KioskState.studentNotFound;

    // Same three-column composition as the attract and recognised screens, so
    // the layout does not jump as a card is read: the panel takes the left
    // column, the Guardian keeps the centre of the world (and its bubble), and
    // the school's impact board stays on the right.
    return Padding(
      padding: EdgeInsets.fromLTRB(18 * s, 10 * s, 18 * s, 14 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 26,
            child: notFound
                ? _CardNotFoundPanel(
                    message: session.errorMessage,
                    onRetry: controller.retryCard,
                  )
                : _ReadingPanel(animate: animate),
          ),
          SizedBox(width: 14 * s),

          // Reserved for the Guardian, which is drawn in the world layer.
          const Expanded(flex: 48, child: SizedBox.expand()),
          SizedBox(width: 14 * s),

          const Expanded(
            flex: 26,
            child: ValleyImpactPanel(
              rankings: [
                ValleyRanking(
                  name: 'Taurus House',
                  points: 4850,
                  colour: AppColors.houseTaurus,
                ),
                ValleyRanking(
                  name: 'Leo House',
                  points: 4310,
                  colour: AppColors.houseLeo,
                ),
                ValleyRanking(
                  name: 'Aquarius House',
                  points: 3980,
                  colour: AppColors.houseAquarius,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The reading sequence: card, reader, rising leaves and a vine of energy.
class _ReadingPanel extends StatelessWidget {
  const _ReadingPanel({required this.animate});

  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;

    return GamePanel(
      theme: ValleyTheme.tide,
      title: 'Reading your Student ID',
      icon: Icons.contactless_outlined,
      trailing: const ValleyBadge(
        label: 'Almost ready!',
        icon: Icons.hourglass_top_rounded,
        accent: Colors.white,
        dense: true,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // The card reaching for the reader, with leaves lifting off it.
          _CardTravelStage(animate: animate),
          SizedBox(height: 14 * s),

          // Energy running along a vine. Indeterminate by design.
          _EnergyVine(animate: animate),
          SizedBox(height: 12 * s),

          Semantics(
            liveRegion: true,
            label: 'Reading your Student ID card. Almost ready.',
            excludeSemantics: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hold tight — the valley is waking up for you!',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: valleyLegible(13.5, s, 12) * s,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    color: ValleyTheme.tide.colours.accentDeep,
                  ),
                ),
                SizedBox(height: 3 * s),
                Text(
                  'Your card is your key. No phone needed.',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: valleyLegible(11, s, 10) * s,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The card leaning toward the reader while leaves drift up toward Sprout.
class _CardTravelStage extends StatefulWidget {
  const _CardTravelStage({required this.animate});

  final bool animate;

  @override
  State<_CardTravelStage> createState() => _CardTravelStageState();
}

class _CardTravelStageState extends State<_CardTravelStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _loop.repeat();
  }

  @override
  void didUpdateWidget(covariant _CardTravelStage old) {
    super.didUpdateWidget(old);
    if (widget.animate == old.animate) return;
    if (widget.animate) {
      _loop.repeat();
    } else {
      _loop.stop();
      _loop.value = 0;
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 320.0;
        final cardW = math.min(width * 0.56, 190 * s);
        final ring = math.min(width * 0.34, 92 * s);
        final blockH = math.max(cardW * 0.62, ring) + 18 * s;

        return SizedBox(
          height: blockH,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Leaves lifting off the card toward the Guardian above.
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _loop,
                      builder: (context, _) => CustomPaint(
                        painter: _RisingLeavesPainter(
                          t: widget.animate ? _loop.value : 0,
                          animate: widget.animate,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: (blockH - cardW * 0.62) / 2,
                child: AnimatedBuilder(
                  animation: _loop,
                  builder: (context, child) {
                    if (!widget.animate) return child!;
                    final wave = math.sin(_loop.value * math.pi * 2);
                    // A steady lean toward the reader, rather than a bounce:
                    // the card is being HELD there, not thrown.
                    final reach = Curves.easeInOut.transform(
                      (math.sin(_loop.value * math.pi * 2 - 0.9) * 0.5 + 0.5)
                          .clamp(0.0, 1.0),
                    );
                    return Transform.translate(
                      offset: Offset(reach * cardW * 0.07, wave * 3 * s),
                      child: Transform.rotate(
                        angle: wave * 0.015,
                        child: child,
                      ),
                    );
                  },
                  child: PlayfulStudentCard(
                    width: cardW,
                    phase: StudentScanPhase.scanning,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: (blockH - ring) / 2,
                child: AnimatedCardReader(
                  size: ring,
                  phase: StudentScanPhase.scanning,
                  animate: widget.animate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Leaves drifting upward out of the card, on their way to the Guardian.
class _RisingLeavesPainter extends CustomPainter {
  const _RisingLeavesPainter({required this.t, required this.animate});

  final double t;
  final bool animate;

  static const int _count = 6;

  @override
  void paint(Canvas canvas, Size size) {
    if (!animate) return;
    for (var i = 0; i < _count; i++) {
      final phase = (t + i / _count) % 1.0;
      // Rise from the card (left third) and drift toward the centre-top, which
      // is where the Guardian stands.
      final x = size.width * (0.16 + 0.30 * i / _count) + phase * 26;
      final y = size.height * (1 - phase);
      final r = 4.0 + (i % 3);
      final fade = math.sin(phase * math.pi);
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(phase * 3 + i);
      canvas.drawPath(
        Path()
          ..moveTo(0, -r)
          ..quadraticBezierTo(r, 0, 0, r)
          ..quadraticBezierTo(-r, 0, 0, -r),
        Paint()..color = AppColors.guardianLeaf.withValues(alpha: 0.55 * fade),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _RisingLeavesPainter old) =>
      old.t != t || old.animate != animate;
}

/// Energy travelling along a vine.
///
/// Indeterminate: a bright segment sweeps the track while the lookup runs. When
/// motion is reduced it holds as a softly filled vine, so the state is still
/// visibly "working" without anything moving.
class _EnergyVine extends StatefulWidget {
  const _EnergyVine({required this.animate});

  final bool animate;

  @override
  State<_EnergyVine> createState() => _EnergyVineState();
}

class _EnergyVineState extends State<_EnergyVine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) _sweep.repeat();
  }

  @override
  void didUpdateWidget(covariant _EnergyVine old) {
    super.didUpdateWidget(old);
    if (widget.animate == old.animate) return;
    if (widget.animate) {
      _sweep.repeat();
    } else {
      _sweep.stop();
      _sweep.value = 0;
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Semantics(
      label: 'Reading in progress',
      excludeSemantics: true,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _sweep,
          builder: (context, _) => CustomPaint(
            size: Size(double.infinity, 14 * s),
            painter: _EnergyVinePainter(
              t: _sweep.value,
              animate: widget.animate,
              scale: s,
            ),
          ),
        ),
      ),
    );
  }
}

class _EnergyVinePainter extends CustomPainter {
  const _EnergyVinePainter({
    required this.t,
    required this.animate,
    required this.scale,
  });

  final double t;
  final bool animate;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scale;
    final accent = ValleyTheme.tide.colours.accent;
    final cy = size.height * 0.5;
    final h = 8.0 * s;
    final track = RRect.fromRectAndRadius(
      Rect.fromLTRB(0, cy - h / 2, size.width, cy + h / 2),
      Radius.circular(h),
    );

    canvas.drawRRect(track, Paint()..color = accent.withValues(alpha: 0.18));

    canvas.save();
    canvas.clipRRect(track);

    if (!animate) {
      // Calm mode: a static, softly filled vine.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(0, cy - h / 2, size.width * 0.55, cy + h / 2),
          Radius.circular(h),
        ),
        Paint()..color = accent.withValues(alpha: 0.7),
      );
      canvas.restore();
      return;
    }

    // A bright pulse of energy sweeping along the vine.
    final segment = size.width * 0.34;
    final head = -segment + (size.width + segment * 2) * t;
    canvas.drawRect(
      Rect.fromLTRB(head - segment, cy - h / 2, head, cy + h / 2),
      Paint()
        ..shader =
            LinearGradient(
              colors: [
                accent.withValues(alpha: 0),
                accent,
                Color.lerp(accent, Colors.white, 0.55)!,
              ],
              stops: const [0, 0.7, 1],
            ).createShader(
              Rect.fromLTRB(head - segment, cy - h / 2, head, cy + h / 2),
            ),
    );
    canvas.restore();

    // Small leaf nodes along the vine, so it reads as a plant not a bar.
    for (var i = 1; i < 4; i++) {
      final x = size.width * i / 4;
      canvas.drawCircle(
        Offset(x, cy),
        2.2 * s,
        Paint()..color = accent.withValues(alpha: 0.5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyVinePainter old) =>
      old.t != t || old.animate != animate || old.scale != scale;
}

/// A card that did not resolve. Calm, warm and always retryable.
class _CardNotFoundPanel extends StatelessWidget {
  const _CardNotFoundPanel({required this.onRetry, this.message});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return GamePanel(
      theme: ValleyTheme.ember,
      title: 'Let’s try that again',
      icon: Icons.replay_rounded,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ValleyIconMedallion(
                icon: Icons.contactless_outlined,
                accent: ValleyTheme.ember.colours.accent,
                size: ValleyTokens.medallionLg,
              ),
              SizedBox(width: 11 * s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hmm, I don't recognise that card",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valleyLegible(16, s, 14) * s,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: ValleyTheme.ember.colours.accentDeep,
                      ),
                    ),
                    SizedBox(height: 3 * s),
                    Text(
                      message ??
                          'Hold it closer and try again, or ask a teacher '
                              'for help.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valleyLegible(12, s, 11) * s,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14 * s),
          ValleyActionButton(
            label: 'Try Again',
            icon: Icons.refresh_rounded,
            theme: ValleyTheme.ember,
            expand: true,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}
