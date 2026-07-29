import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/painters/valley_painters.dart';
import '../../../../shared/world/guardian_face_badge.dart';
import '../../application/kiosk_session_state.dart';

/// ---------------------------------------------------------------------------
/// "Start your eco mission" — the left-hand Student ID panel of the attract
/// screen, rebuilt as a piece of the game rather than a piece of admin.
///
/// The panel is PURE PRESENTATION: it knows nothing about Riverpod, the
/// hardware bridge or the auth service. Screens map the kiosk FSM onto a
/// [StudentScanPhase] (see [StudentScanPhase.fromKiosk]) and hand it in, so the
/// visual state and the scanning logic stay independent and separately
/// testable.
///
/// Product rules that are load-bearing here:
///   * students are identified by a PHYSICAL card — no phone, no QR, no
///     personal-device login imagery anywhere;
///   * nothing personal is drawn until a card actually resolves, and the name
///     disappears again the moment the phase leaves [StudentScanPhase.studentFound].
/// ---------------------------------------------------------------------------

/// What the panel is currently showing. Mapped from the kiosk FSM, but kept as
/// its own type so the visuals can be driven in isolation (tests, storybook,
/// the dev panel) without a controller.
enum StudentScanPhase {
  /// Nobody is here. Reader glows gently, inviting a tap.
  idle,

  /// The reader is armed (hover / focus / `waitingForCard`).
  readerActive,

  /// A card is being read.
  scanning,

  /// The card resolved to a student.
  studentFound,

  /// The card could not be resolved — gentle, never a scolding.
  invalidCard,

  /// The reader itself is unavailable (maintenance / error).
  hardwareUnavailable,

  /// The session just ended and the kiosk is returning to anonymous idle.
  resetting;

  /// Maps the kiosk finite state machine onto a panel phase.
  static StudentScanPhase fromKiosk(KioskSessionState session) =>
      switch (session.state) {
        KioskState.idle || KioskState.offline => StudentScanPhase.idle,
        KioskState.waitingForCard => StudentScanPhase.readerActive,
        KioskState.readingCard => StudentScanPhase.scanning,
        KioskState.studentNotFound => StudentScanPhase.invalidCard,
        KioskState.maintenance ||
        KioskState.error => StudentScanPhase.hardwareUnavailable,
        KioskState.sessionComplete => StudentScanPhase.resetting,
        _ => StudentScanPhase.studentFound,
      };

  /// Only this phase may render anything belonging to a real child.
  bool get revealsStudent => this == StudentScanPhase.studentFound;

  bool get isBusy => this == StudentScanPhase.scanning;

  bool get isSuccess => this == StudentScanPhase.studentFound;

  bool get isProblem =>
      this == StudentScanPhase.invalidCard ||
      this == StudentScanPhase.hardwareUnavailable;

  /// Whether the CTA should still accept a tap.
  bool get acceptsTap =>
      this != StudentScanPhase.scanning &&
      this != StudentScanPhase.hardwareUnavailable;
}

// ---------------------------------------------------------------------------
// Copy
// ---------------------------------------------------------------------------

/// Every string the panel can say, in one place, so the reading age stays
/// consistent and the tests can assert on it.
abstract final class MissionCopy {
  static const String title = 'Start Your Eco Mission!';
  static const String subtitle =
      'Tap your school card to enter Guardian Valley.';
  static const String keyLine =
      'Your school card is your key to Guardian Valley!';
  static const String noPhone = 'No phone needed.';
  static const String cta = 'Tap your Student ID to begin';
  static const String ctaBusy = 'Reading your card…';
  static const String ctaSuccess = 'You’re in!';
  static const String ctaRetry = 'Try your card again';
  static const String ctaUnavailable = 'Reader unavailable';

  /// Headline + hint shown in the status strip under the reader.
  static (String, String) status(StudentScanPhase phase, String? firstName) =>
      switch (phase) {
        StudentScanPhase.idle || StudentScanPhase.readerActive => (
          'Tap your card here',
          'Hold it near the glowing reader.',
        ),
        StudentScanPhase.scanning => (
          'Reading your card…',
          'Keep it on the reader for a moment.',
        ),
        StudentScanPhase.studentFound => (
          firstName == null ? 'Welcome back!' : 'Welcome, $firstName!',
          'Your mission is ready.',
        ),
        StudentScanPhase.invalidCard => (
          'I couldn’t read that card',
          'Hold it closer and try again.',
        ),
        StudentScanPhase.hardwareUnavailable => (
          'The reader is resting',
          'Please ask a teacher for help.',
        ),
        StudentScanPhase.resetting => (
          'All done — thank you!',
          'Getting ready for the next Guardian.',
        ),
      };
}

// ---------------------------------------------------------------------------
// Palette
// ---------------------------------------------------------------------------

/// Bright, coordinated accents — deliberately lighter than the old dark-green
/// panel so the surface reads as a game card, not a form.
abstract final class _MissionPalette {
  static const Color cardTop = Color(0xFF63C88A);
  static const Color cardBottom = Color(0xFF3FA9A0);
  static const Color readerIdle = Color(0xFF34B27B);
  static const Color readerBusy = Color(0xFF2BA7C9);
  static const Color step1 = Color(0xFF2E9E4F);
  static const Color step2 = Color(0xFF3A9BDC);
  static const Color step3 = AppColors.xpPurple;
}

// ---------------------------------------------------------------------------
// Metrics
// ---------------------------------------------------------------------------

/// Design-space sizing for the panel, chosen from the height it actually has.
///
/// Compact kiosks give up decoration first (the "no phone" line, spacing, a
/// slightly smaller card) and NEVER give up a mission step or the CTA.
@immutable
class MissionMetrics {
  const MissionMetrics({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.cardWidth,
    required this.readerCore,
    required this.gap,
    required this.bannerTitle,
    required this.bannerDetail,
    required this.keyLine,
    required this.showKeyLine,
    required this.showNoPhone,
    required this.stepTitle,
    required this.stepDetail,
    required this.stepIcon,
    required this.stepPad,
    required this.connector,
    required this.ctaHeight,
    required this.ctaText,
  });

  final double badge;
  final double title;
  final double subtitle;
  final double cardWidth;
  final double readerCore;
  final double gap;
  final double bannerTitle;
  final double bannerDetail;
  final double keyLine;
  final bool showKeyLine;
  final bool showNoPhone;
  final double stepTitle;
  final double stepDetail;
  final double stepIcon;
  final double stepPad;
  final double connector;
  final double ctaHeight;
  final double ctaText;

  /// [designHeight] is the panel's available height expressed in design pixels
  /// (i.e. already divided by the [GameScale] factor).
  factory MissionMetrics.forHeight(double designHeight) {
    if (!designHeight.isFinite || designHeight >= 600) return roomy;
    if (designHeight >= 470) return cosy;
    return tight;
  }

  static const roomy = MissionMetrics(
    badge: 44,
    title: 22,
    subtitle: 12,
    cardWidth: 168,
    readerCore: 56,
    gap: 10,
    bannerTitle: 12.5,
    bannerDetail: 10.5,
    keyLine: 12,
    showKeyLine: true,
    showNoPhone: true,
    stepTitle: 14,
    stepDetail: 10.5,
    stepIcon: 32,
    stepPad: 8,
    connector: 12,
    ctaHeight: 52,
    ctaText: 14.5,
  );

  static const cosy = MissionMetrics(
    badge: 38,
    title: 20,
    subtitle: 11,
    cardWidth: 144,
    readerCore: 50,
    gap: 8,
    bannerTitle: 11.5,
    bannerDetail: 10,
    keyLine: 11,
    showKeyLine: true,
    showNoPhone: false,
    stepTitle: 13,
    stepDetail: 10,
    stepIcon: 28,
    stepPad: 6,
    connector: 10,
    ctaHeight: 48,
    ctaText: 13.5,
  );

  static const tight = MissionMetrics(
    badge: 33,
    title: 18,
    subtitle: 10,
    cardWidth: 122,
    readerCore: 44,
    gap: 6,
    bannerTitle: 11,
    bannerDetail: 9.5,
    keyLine: 10,
    showKeyLine: false,
    showNoPhone: false,
    stepTitle: 12,
    stepDetail: 9.5,
    stepIcon: 25,
    stepPad: 5,
    connector: 8,
    ctaHeight: 46,
    ctaText: 12.5,
  );
}

/// Raises a design-space font size so that, once multiplied by the game scale,
/// it never renders below [floorPx] logical pixels. Small kiosk screens shrink
/// the decoration, not the legibility.
double _legible(double designSize, double scale, double floorPx) =>
    scale <= 0 ? designSize : math.max(designSize, floorPx / scale);

// ---------------------------------------------------------------------------
// The panel
// ---------------------------------------------------------------------------

/// The left-hand "Start your eco mission" panel.
class StudentMissionPanel extends StatefulWidget {
  const StudentMissionPanel({
    super.key,
    this.phase = StudentScanPhase.idle,
    this.studentFirstName,
    this.onTapCard,
    this.animate = true,
  });

  /// What the panel is showing right now.
  final StudentScanPhase phase;

  /// The recognised student's FIRST NAME — ignored unless [phase] is
  /// [StudentScanPhase.studentFound], so a finished session can never leave a
  /// name on the shared kiosk.
  final String? studentFirstName;

  /// Fires the real card-read / simulator action owned by the screen.
  final VoidCallback? onTapCard;

  /// False in calm (reduced motion) mode: all repeating animation stops and the
  /// reader stays statically highlighted.
  final bool animate;

  @override
  State<StudentMissionPanel> createState() => _StudentMissionPanelState();
}

class _StudentMissionPanelState extends State<StudentMissionPanel> {
  /// Someone is pointing at the panel — the reader lights up to say "I'm
  /// listening". Purely visual; it never touches the kiosk state machine.
  bool _pointerNear = false;

  /// `idle` becomes `readerActive` while the panel is under the pointer; every
  /// other phase comes straight from the controller.
  StudentScanPhase get _phase =>
      widget.phase == StudentScanPhase.idle && _pointerNear
      ? StudentScanPhase.readerActive
      : widget.phase;

  String? get _name =>
      widget.phase.revealsStudent ? widget.studentFirstName : null;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final phase = _phase;
    final reduceMotion =
        !widget.animate ||
        (MediaQuery.maybeOf(context)?.disableAnimations ?? false);
    final chrome = 24 * s; // GamePanel's own vertical padding.

    return MouseRegion(
      onEnter: (_) => setState(() => _pointerNear = true),
      onExit: (_) => setState(() => _pointerNear = false),
      // Measured OUTSIDE the panel: GamePanel's Column hands its child an
      // unbounded main-axis constraint, so the height budget has to be read
      // here, before the chrome, and carried inwards.
      child: LayoutBuilder(
        builder: (context, outer) {
          final budget = outer.maxHeight.isFinite
              ? math.max(0.0, outer.maxHeight - chrome)
              : double.infinity;
          final m = MissionMetrics.forHeight(
            budget.isFinite && s > 0 ? budget / s : double.infinity,
          );

          return GamePanel(
            accent: _MissionPalette.readerIdle,
            padding: EdgeInsets.fromLTRB(12 * s, 12 * s, 12 * s, 12 * s),
            child: LayoutBuilder(
              builder: (context, inner) {
                final width = inner.maxWidth.isFinite ? inner.maxWidth : 260.0;

                final content = SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _MissionHeader(metrics: m, animate: !reduceMotion),
                      SizedBox(height: m.gap * s),
                      _CardReaderStage(
                        metrics: m,
                        phase: phase,
                        animate: !reduceMotion,
                      ),
                      SizedBox(height: m.gap * s),
                      ScanStatusBanner(
                        phase: phase,
                        studentFirstName: _name,
                        metrics: m,
                      ),
                      if (m.showKeyLine) ...[
                        SizedBox(height: (m.gap * 0.8) * s),
                        _KeyLine(metrics: m),
                      ],
                      SizedBox(height: m.gap * s),
                      _MissionTrail(
                        metrics: m,
                        animate: !reduceMotion,
                        phase: phase,
                      ),
                      SizedBox(height: m.gap * s),
                      StudentScanCTA(
                        phase: phase,
                        metrics: m,
                        animate: !reduceMotion,
                        onPressed: widget.onTapCard,
                      ),
                    ],
                  ),
                );

                return Stack(
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: RepaintBoundary(
                          child: CustomPaint(
                            painter: const _PanelDecorPainter(),
                          ),
                        ),
                      ),
                    ),
                    // Safety net: the tiered metrics are sized to fit every
                    // supported kiosk resolution, but if a host ever hands the
                    // panel less room than that, the whole composition scales
                    // down as one instead of overflowing or clipping the CTA.
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: budget),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: content,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _MissionHeader extends StatelessWidget {
  const _MissionHeader({required this.metrics, required this.animate});

  final MissionMetrics metrics;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = metrics;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GuardianFaceBadge(size: m.badge * s, animate: animate),
        SizedBox(width: 9 * s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MissionCopy.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _legible(m.title, s, 18) * s,
                  fontWeight: FontWeight.w900,
                  height: 1.12,
                  letterSpacing: -0.2 * s,
                  color: AppColors.primaryDark,
                ),
              ),
              SizedBox(height: 2 * s),
              Text(
                MissionCopy.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: _legible(m.subtitle, s, 12) * s,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card + reader
// ---------------------------------------------------------------------------

/// Composes the school card and the reader disc, and owns the gentle float plus
/// the "card nudges toward the reader" motion.
class _CardReaderStage extends StatefulWidget {
  const _CardReaderStage({
    required this.metrics,
    required this.phase,
    required this.animate,
  });

  final MissionMetrics metrics;
  final StudentScanPhase phase;
  final bool animate;

  @override
  State<_CardReaderStage> createState() => _CardReaderStageState();
}

class _CardReaderStageState extends State<_CardReaderStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    if (widget.animate) _float.repeat();
  }

  @override
  void didUpdateWidget(covariant _CardReaderStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate == oldWidget.animate) return;
    if (widget.animate) {
      _float.repeat();
    } else {
      _float.stop();
      _float.value = 0;
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = widget.metrics;

    final baseCardW = m.cardWidth * s;
    final baseRing = m.readerCore * 1.55 * s;
    final baseBlockW = baseCardW + baseRing * 0.58;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Fill the panel's width rather than floating in it — but never wider
        // than the panel (which would force the whole composition to shrink)
        // and never so tall that the height budget stops adding up.
        final fit = constraints.maxWidth.isFinite && baseBlockW > 0
            ? (constraints.maxWidth / baseBlockW).clamp(0.55, 1.22)
            : 1.0;

        final cardW = baseCardW * fit;
        final cardH = cardW * 0.62;
        final ringBox = baseRing * fit;
        final blockH = math.max(cardH, ringBox) + cardW * 0.07;
        final blockW = cardW + ringBox * 0.58;

        return Center(
          child: SizedBox(
            width: blockW,
            height: blockH,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: (blockH - cardH) / 2,
                  child: AnimatedBuilder(
                    animation: _float,
                    builder: (context, child) {
                      final wave = math.sin(_float.value * math.pi * 2);
                      // A short "reach for the reader" nudge once per loop.
                      final reach =
                          Curves.easeInOut.transform(
                            (math.sin(_float.value * math.pi * 2 - 0.9) * 0.5 +
                                    0.5)
                                .clamp(0.0, 1.0),
                          ) *
                          (widget.phase.isBusy ? 1.0 : 0.55);
                      return Transform.translate(
                        offset: Offset(
                          reach * cardW * 0.05,
                          wave * cardH * 0.035,
                        ),
                        child: Transform.rotate(
                          angle: wave * 0.012,
                          child: child,
                        ),
                      );
                    },
                    child: PlayfulStudentCard(
                      width: cardW,
                      phase: widget.phase,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: (blockH - ringBox) / 2,
                  child: AnimatedCardReader(
                    size: ringBox,
                    phase: widget.phase,
                    animate: widget.animate,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The school card itself: bright, rounded and unmistakably a physical card.
///
/// It is always anonymous — a placeholder avatar, two blank profile lines and
/// fully masked digits. Nothing belonging to a real child is ever drawn here,
/// including after a successful scan.
class PlayfulStudentCard extends StatelessWidget {
  const PlayfulStudentCard({
    super.key,
    required this.width,
    this.phase = StudentScanPhase.idle,
  });

  final double width;
  final StudentScanPhase phase;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final h = w * 0.62;
    final radius = (w * 0.17).clamp(18.0, 30.0);
    final pad = w * 0.075;

    return Semantics(
      label: 'A school Student ID card being held near the card reader',
      image: true,
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          children: [
            Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_MissionPalette.cardTop, _MissionPalette.cardBottom],
                ),
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
                  width: math.max(1.2, w * 0.012),
                ),
                boxShadow: [
                  // Layered, not one harsh drop.
                  BoxShadow(
                    color: ValleyPalette.forestDark.withValues(alpha: 0.18),
                    blurRadius: w * 0.10,
                    offset: Offset(0, w * 0.045),
                  ),
                  BoxShadow(
                    color: _MissionPalette.cardBottom.withValues(alpha: 0.22),
                    blurRadius: w * 0.05,
                    offset: Offset(0, w * 0.015),
                  ),
                ],
              ),
              padding: EdgeInsets.all(pad),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: w * 0.115,
                        height: w * 0.115,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(w * 0.032),
                        ),
                        child: Icon(
                          Icons.eco,
                          size: w * 0.075,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: w * 0.035),
                      // The official label, kept small and secondary.
                      Flexible(
                        child: Text(
                          'STUDENT ID',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: w * 0.004,
                            fontSize: w * 0.052,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.02),
                      Icon(
                        Icons.contactless_outlined,
                        color: Colors.white.withValues(alpha: 0.92),
                        size: w * 0.085,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: h * 0.36,
                        height: h * 0.36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.34),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.65),
                            width: math.max(1.0, w * 0.008),
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: h * 0.22,
                        ),
                      ),
                      SizedBox(width: w * 0.05),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _bar(w * 0.40, h * 0.075),
                            SizedBox(height: h * 0.06),
                            _bar(w * 0.27, h * 0.058, alpha: 0.55),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Fully masked — the panel never shows a card number.
                  Text(
                    '•••• •••• ••••',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.92),
                      letterSpacing: w * 0.008,
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.052,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            // Gentle shine.
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: CustomPaint(painter: const _CardShinePainter()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double w, double h, {double alpha = 0.9}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: alpha),
      borderRadius: BorderRadius.circular(h * 0.5),
    ),
  );
}

class _CardShinePainter extends CustomPainter {
  const _CardShinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.62)
      ..lineTo(size.width * 0.52, 0)
      ..lineTo(size.width * 0.86, 0)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.28),
            Colors.white.withValues(alpha: 0.02),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant _CardShinePainter old) => false;
}

/// The card reader — the panel's strongest interaction point.
///
/// Idle: expanding pulse rings and a soft green glow. Scanning: cooler cyan and
/// a sweeping arc. Success: a checkmark that pops in with a small sparkle
/// burst. Problem: a calm amber prompt, never an angry red cross.
///
/// In reduced-motion mode every repeating animation stops and a static
/// highlighted target remains.
class AnimatedCardReader extends StatefulWidget {
  const AnimatedCardReader({
    super.key,
    required this.size,
    required this.phase,
    this.animate = true,
  });

  final double size;
  final StudentScanPhase phase;
  final bool animate;

  @override
  State<AnimatedCardReader> createState() => _AnimatedCardReaderState();
}

class _AnimatedCardReaderState extends State<AnimatedCardReader>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _burst;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
    _burst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    if (widget.animate) _pulse.repeat();
    if (widget.phase.isSuccess) _burst.value = 1;
  }

  @override
  void didUpdateWidget(covariant AnimatedCardReader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate != oldWidget.animate) {
      if (widget.animate) {
        _pulse.repeat();
      } else {
        _pulse.stop();
        _pulse.value = 0;
      }
    }
    if (widget.phase != oldWidget.phase) {
      if (widget.phase.isSuccess) {
        widget.animate ? _burst.forward(from: 0) : _burst.value = 1;
      } else {
        _burst.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    _burst.dispose();
    super.dispose();
  }

  Color get _accent => switch (widget.phase) {
    StudentScanPhase.scanning => _MissionPalette.readerBusy,
    StudentScanPhase.studentFound => AppColors.success,
    StudentScanPhase.invalidCard ||
    StudentScanPhase.hardwareUnavailable => AppColors.warning,
    _ => _MissionPalette.readerIdle,
  };

  IconData get _glyph => switch (widget.phase) {
    StudentScanPhase.studentFound => Icons.check_rounded,
    StudentScanPhase.invalidCard => Icons.replay_rounded,
    StudentScanPhase.hardwareUnavailable => Icons.build_circle_outlined,
    _ => Icons.contactless_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final box = widget.size;
    final core = box / 1.55;
    final accent = _accent;

    return Semantics(
      label: 'Card reader',
      value: MissionCopy.status(widget.phase, null).$1,
      liveRegion: true,
      child: RepaintBoundary(
        child: SizedBox(
          width: box,
          height: box,
          child: AnimatedBuilder(
            animation: Listenable.merge([_pulse, _burst]),
            builder: (context, child) {
              return CustomPaint(
                painter: _ReaderPainter(
                  t: widget.animate ? _pulse.value : 0,
                  burst: _burst.value,
                  accent: accent,
                  core: core,
                  animate: widget.animate,
                  busy: widget.phase.isBusy,
                  success: widget.phase.isSuccess,
                ),
                child: child,
              );
            },
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  _glyph,
                  key: ValueKey(_glyph),
                  size: core * 0.44,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReaderPainter extends CustomPainter {
  const _ReaderPainter({
    required this.t,
    required this.burst,
    required this.accent,
    required this.core,
    required this.animate,
    required this.busy,
    required this.success,
  });

  final double t;
  final double burst;
  final Color accent;
  final double core;
  final bool animate;
  final bool busy;
  final bool success;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final maxR = size.width * 0.5;

    // Expanding pulse rings (or one static ring when motion is reduced).
    if (animate) {
      for (var i = 0; i < 3; i++) {
        final p = (t + i / 3) % 1.0;
        final r = core * 0.5 + (maxR - core * 0.5) * p;
        canvas.drawCircle(
          c,
          r,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = size.width * 0.035
            ..color = accent.withValues(alpha: (1 - p) * 0.45),
        );
      }
    } else {
      canvas.drawCircle(
        c,
        maxR * 0.86,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.035
          ..color = accent.withValues(alpha: 0.42),
      );
    }

    // Soft halo.
    canvas.drawCircle(
      c,
      core * 0.86,
      Paint()
        ..color = accent.withValues(alpha: 0.24)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, core * 0.20),
    );

    // The target disc.
    canvas.drawCircle(
      c,
      core * 0.5,
      Paint()
        ..shader = RadialGradient(
          colors: [Color.lerp(accent, Colors.white, 0.30)!, accent],
        ).createShader(Rect.fromCircle(center: c, radius: core * 0.5)),
    );
    canvas.drawCircle(
      c,
      core * 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, size.width * 0.022)
        ..color = Colors.white.withValues(alpha: 0.85),
    );

    // Scanning sweep.
    if (busy && animate) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: core * 0.66),
        t * math.pi * 2,
        math.pi * 0.7,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = size.width * 0.045
          ..color = Colors.white.withValues(alpha: 0.9),
      );
    }

    // Success sparkle burst.
    if (success && burst > 0) {
      final b = Curves.easeOut.transform(burst);
      for (var i = 0; i < 7; i++) {
        final a = i * math.pi * 2 / 7 - 0.4;
        final d = core * (0.55 + b * 0.75);
        final p = c + Offset(math.cos(a) * d, math.sin(a) * d);
        _star(
          canvas,
          p,
          size.width * 0.05 * (1 - b * 0.5),
          Paint()..color = Colors.white.withValues(alpha: 0.9 * (1 - b)),
        );
      }
    }
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      final rad = i.isEven ? r : r * 0.34;
      final p = c + Offset(math.cos(a) * rad, math.sin(a) * rad);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(covariant _ReaderPainter old) =>
      old.t != t ||
      old.burst != burst ||
      old.accent != accent ||
      old.core != core ||
      old.animate != animate ||
      old.busy != busy ||
      old.success != success;
}

// ---------------------------------------------------------------------------
// Status banner
// ---------------------------------------------------------------------------

/// The short "what is happening right now" strip under the reader. Colour is
/// never the only signal — the icon and the wording change too.
class ScanStatusBanner extends StatelessWidget {
  const ScanStatusBanner({
    super.key,
    required this.phase,
    required this.metrics,
    this.studentFirstName,
  });

  final StudentScanPhase phase;
  final MissionMetrics metrics;
  final String? studentFirstName;

  Color get _accent => switch (phase) {
    StudentScanPhase.scanning => _MissionPalette.readerBusy,
    StudentScanPhase.studentFound => AppColors.success,
    StudentScanPhase.invalidCard ||
    StudentScanPhase.hardwareUnavailable => AppColors.warning,
    StudentScanPhase.resetting => AppColors.info,
    _ => _MissionPalette.readerIdle,
  };

  IconData get _icon => switch (phase) {
    StudentScanPhase.scanning => Icons.hourglass_top_rounded,
    StudentScanPhase.studentFound => Icons.celebration_outlined,
    StudentScanPhase.invalidCard => Icons.replay_rounded,
    StudentScanPhase.hardwareUnavailable => Icons.build_circle_outlined,
    StudentScanPhase.resetting => Icons.eco_outlined,
    _ => Icons.contactless_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = metrics;
    final (headline, hint) = MissionCopy.status(phase, studentFirstName);
    final accent = _accent;

    return Semantics(
      liveRegion: true,
      label: '$headline. $hint',
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 9 * s, vertical: 7 * s),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16 * s),
          border: Border.all(
            color: accent.withValues(alpha: 0.42),
            width: 1.6 * s,
          ),
        ),
        child: Row(
          children: [
            Icon(_icon, size: _legible(15, s, 14) * s, color: accent),
            SizedBox(width: 7 * s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _legible(m.bannerTitle, s, 12) * s,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      color: Color.lerp(accent, Colors.black, 0.42),
                    ),
                  ),
                  Text(
                    hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _legible(m.bannerDetail, s, 10) * s,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeyLine extends StatelessWidget {
  const _KeyLine({required this.metrics});

  final MissionMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          MissionCopy.keyLine,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: _legible(metrics.keyLine, s, 11) * s,
            fontWeight: FontWeight.w800,
            height: 1.3,
            color: AppColors.primaryDark,
          ),
        ),
        if (metrics.showNoPhone)
          Text(
            MissionCopy.noPhone,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: _legible(metrics.keyLine * 0.85, s, 9.5) * s,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: AppColors.inkFaint,
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Mission trail
// ---------------------------------------------------------------------------

/// The three mission steps, presented as a numbered adventure trail joined by a
/// dotted path so they read as one journey rather than three bullet points.
class _MissionTrail extends StatelessWidget {
  const _MissionTrail({
    required this.metrics,
    required this.animate,
    required this.phase,
  });

  final MissionMetrics metrics;
  final bool animate;
  final StudentScanPhase phase;

  static const _steps =
      <({IconData icon, String title, String detail, Color accent})>[
        (
          icon: Icons.contactless_outlined,
          title: 'Tap your card',
          detail: 'Meet your Guardian',
          accent: _MissionPalette.step1,
        ),
        (
          icon: Icons.center_focus_strong_outlined,
          title: 'Show your item',
          detail: 'Let EcoLens check it',
          accent: _MissionPalette.step2,
        ),
        (
          icon: Icons.auto_awesome,
          title: 'Choose its portal',
          detail: 'Earn XP and coins',
          accent: _MissionPalette.step3,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = metrics;
    return Semantics(
      container: true,
      // Without this the three step labels merge into one long announcement.
      explicitChildNodes: true,
      label: 'Your mission, in three steps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            if (i > 0)
              _TrailConnector(
                height: m.connector * s,
                indent: (m.stepPad + m.stepIcon * 0.5) * s,
                from: _steps[i - 1].accent,
                to: _steps[i].accent,
              ),
            _StepEntrance(
              index: i,
              animate: animate,
              child: MissionStepTile(
                number: i + 1,
                icon: _steps[i].icon,
                title: _steps[i].title,
                detail: _steps[i].detail,
                accent: _steps[i].accent,
                metrics: m,
                active: i == 0 && phase.isBusy,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Fades + lifts each step in with a short stagger the first time it appears.
class _StepEntrance extends StatefulWidget {
  const _StepEntrance({
    required this.index,
    required this.animate,
    required this.child,
  });

  final int index;
  final bool animate;
  final Widget child;

  @override
  State<_StepEntrance> createState() => _StepEntranceState();
}

class _StepEntranceState extends State<_StepEntrance>
    with SingleTickerProviderStateMixin {
  // The stagger is baked into the curve rather than a delayed timer, so the
  // widget never leaves a pending timer behind when it is disposed early.
  static const _step = 90;
  static const _run = 340;

  late final AnimationController _in;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    final total = _run + _step * widget.index;
    _in = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: total),
      value: widget.animate ? 0 : 1,
    );
    _curve = CurvedAnimation(
      parent: _in,
      curve: Interval(
        (_step * widget.index) / total,
        1,
        curve: Curves.easeOutCubic,
      ),
    );
    if (widget.animate) _in.forward();
  }

  @override
  void dispose() {
    _curve.dispose();
    _in.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 10),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// One step of the trail: a numbered, coloured badge with an icon, a short
/// title and one supporting line. Number AND icon are always visible, so the
/// order never depends on colour alone.
class MissionStepTile extends StatelessWidget {
  const MissionStepTile({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.detail,
    required this.accent,
    required this.metrics,
    this.active = false,
  });

  final int number;
  final IconData icon;
  final String title;
  final String detail;
  final Color accent;
  final MissionMetrics metrics;

  /// Highlights the step the student is being asked to do right now.
  final bool active;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = metrics;
    final badge = m.stepIcon * s;

    return Semantics(
      label: 'Step $number. $title. $detail',
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: EdgeInsets.all(m.stepPad * s),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: active ? 0.16 : 0.08),
          borderRadius: BorderRadius.circular(18 * s),
          border: Border.all(
            color: accent.withValues(alpha: active ? 0.65 : 0.28),
            width: (active ? 2.2 : 1.5) * s,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: badge,
              height: badge,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: badge,
                    height: badge,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color.lerp(accent, Colors.white, 0.30)!,
                          accent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withValues(alpha: 0.35),
                          blurRadius: 6 * s,
                          offset: Offset(0, 2 * s),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: badge * 0.50, color: Colors.white),
                  ),
                  Positioned(
                    left: -2 * s,
                    top: -2 * s,
                    child: Container(
                      width: badge * 0.44,
                      height: badge * 0.44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: accent.withValues(alpha: 0.55),
                          width: 1.2 * s,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$number',
                          style: TextStyle(
                            fontSize: badge * 0.26,
                            fontWeight: FontWeight.w900,
                            height: 1,
                            color: Color.lerp(accent, Colors.black, 0.35),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 9 * s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _legible(m.stepTitle, s, 12) * s,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _legible(m.stepDetail, s, 9.5) * s,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dotted path joining two steps.
class _TrailConnector extends StatelessWidget {
  const _TrailConnector({
    required this.height,
    required this.indent,
    required this.from,
    required this.to,
  });

  final double height;
  final double indent;
  final Color from;
  final Color to;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _DottedTrailPainter(indent: indent, from: from, to: to),
      ),
    );
  }
}

class _DottedTrailPainter extends CustomPainter {
  const _DottedTrailPainter({
    required this.indent,
    required this.from,
    required this.to,
  });

  final double indent;
  final Color from;
  final Color to;

  @override
  void paint(Canvas canvas, Size size) {
    const dots = 3;
    final r = math.min(size.height / (dots * 3), 2.2);
    for (var i = 0; i < dots; i++) {
      final f = (i + 0.5) / dots;
      canvas.drawCircle(
        Offset(indent, size.height * f),
        r,
        Paint()..color = Color.lerp(from, to, f)!.withValues(alpha: 0.55),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DottedTrailPainter old) =>
      old.indent != indent || old.from != from || old.to != to;
}

// ---------------------------------------------------------------------------
// Call to action
// ---------------------------------------------------------------------------

/// The panel's primary call to action. Always at least 48 logical pixels tall,
/// keyboard focusable on the web build, and wired to whatever card-read action
/// the host screen provides — it is never a decorative button.
class StudentScanCTA extends StatefulWidget {
  const StudentScanCTA({
    super.key,
    required this.phase,
    required this.metrics,
    required this.animate,
    this.onPressed,
  });

  final StudentScanPhase phase;
  final MissionMetrics metrics;
  final bool animate;
  final VoidCallback? onPressed;

  @override
  State<StudentScanCTA> createState() => _StudentScanCTAState();
}

class _StudentScanCTAState extends State<StudentScanCTA>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathe;
  bool _focused = false;
  bool _pressed = false;

  bool get _shouldBreathe =>
      widget.animate && widget.onPressed != null && widget.phase.acceptsTap;

  @override
  void initState() {
    super.initState();
    _breathe = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    );
    if (_shouldBreathe) _breathe.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant StudentScanCTA oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldBreathe && !_breathe.isAnimating) {
      _breathe.repeat(reverse: true);
    } else if (!_shouldBreathe && _breathe.isAnimating) {
      _breathe.stop();
      _breathe.value = 0;
    }
  }

  @override
  void dispose() {
    _breathe.dispose();
    super.dispose();
  }

  String get _label => switch (widget.phase) {
    StudentScanPhase.scanning => MissionCopy.ctaBusy,
    StudentScanPhase.studentFound => MissionCopy.ctaSuccess,
    StudentScanPhase.invalidCard => MissionCopy.ctaRetry,
    StudentScanPhase.hardwareUnavailable => MissionCopy.ctaUnavailable,
    _ => MissionCopy.cta,
  };

  List<Color> get _gradient => switch (widget.phase) {
    StudentScanPhase.studentFound => const [
      Color(0xFF3FB56A),
      Color(0xFF2E9E4F),
    ],
    StudentScanPhase.invalidCard || StudentScanPhase.hardwareUnavailable =>
      const [Color(0xFFE9A83E), Color(0xFFD68A1B)],
    StudentScanPhase.scanning => const [Color(0xFF52C0D8), Color(0xFF2B93B5)],
    _ => const [Color(0xFF44BE85), Color(0xFF2E8F5E)],
  };

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final m = widget.metrics;
    // The design-space height, floored so the real target is never under 48px.
    final height = math.max(m.ctaHeight * s, 48.0);
    final enabled = widget.onPressed != null && widget.phase.acceptsTap;
    final radius = BorderRadius.circular(height * 0.42);

    return Semantics(
      button: true,
      enabled: enabled,
      label: 'Tap your Student ID card on the reader to begin',
      hint: _label,
      excludeSemantics: true,
      child: AnimatedBuilder(
        animation: _breathe,
        builder: (context, child) {
          final glow = _shouldBreathe ? 0.30 + _breathe.value * 0.30 : 0.30;
          return Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: [
                BoxShadow(
                  color: _gradient.last.withValues(alpha: glow * 0.8),
                  blurRadius:
                      (12 + (_shouldBreathe ? _breathe.value * 10 : 0)) * s,
                  offset: Offset(0, 4 * s),
                ),
              ],
            ),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: height,
          transform: Matrix4.translationValues(0, _pressed ? 2 * s : 0, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: enabled
                  ? _gradient
                  : [const Color(0xFFB6C4BB), const Color(0xFF97A79D)],
            ),
            borderRadius: radius,
            border: Border.all(
              color: _focused
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.55),
              width: (_focused ? 3.4 : 2.2) * s,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              onTap: enabled ? widget.onPressed : null,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              onFocusChange: (v) => setState(() => _focused = v),
              focusColor: Colors.white.withValues(alpha: 0.16),
              hoverColor: Colors.white.withValues(alpha: 0.10),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12 * s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.phase.isBusy)
                      SizedBox(
                        width: height * 0.34,
                        height: height * 0.34,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.6 * s,
                          valueColor: const AlwaysStoppedAnimation(
                            Colors.white,
                          ),
                        ),
                      )
                    else
                      Icon(
                        widget.phase.isSuccess
                            ? Icons.check_circle_outline
                            : Icons.contactless_outlined,
                        color: Colors.white,
                        size: height * 0.42,
                      ),
                    SizedBox(width: 8 * s),
                    Flexible(
                      child: Text(
                        _label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: _legible(m.ctaText, s, 14) * s,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: ValleyPalette.forestDark.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 3 * s,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Decoration
// ---------------------------------------------------------------------------

/// Faint leaves and sparkles in the panel's empty corners. Deliberately very
/// low contrast so it never competes with the copy.
class _PanelDecorPainter extends CustomPainter {
  const _PanelDecorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final leaf = Paint()
      ..color = AppColors.guardianLeaf.withValues(alpha: 0.10);
    void drawLeaf(Offset at, double r, double angle) {
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, -r)
        ..quadraticBezierTo(r, -r * 0.2, 0, r)
        ..quadraticBezierTo(-r, -r * 0.2, 0, -r);
      canvas.drawPath(path, leaf);
      canvas.restore();
    }

    drawLeaf(Offset(size.width * 0.93, size.height * 0.055), 13, 0.7);
    drawLeaf(Offset(size.width * 0.06, size.height * 0.47), 10, -0.5);
    drawLeaf(Offset(size.width * 0.95, size.height * 0.78), 11, 2.2);

    final spark = Paint()..color = AppColors.coinGold.withValues(alpha: 0.18);
    for (final p in [
      Offset(size.width * 0.86, size.height * 0.30),
      Offset(size.width * 0.12, size.height * 0.20),
      Offset(size.width * 0.90, size.height * 0.60),
    ]) {
      final path = Path();
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        final rad = i.isEven ? 5.0 : 1.6;
        final q = p + Offset(math.cos(a) * rad, math.sin(a) * rad);
        i == 0 ? path.moveTo(q.dx, q.dy) : path.lineTo(q.dx, q.dy);
      }
      canvas.drawPath(path..close(), spark);
    }
  }

  @override
  bool shouldRepaint(covariant _PanelDecorPainter old) => false;
}
