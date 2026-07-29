import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../painters/valley_painters.dart';

/// ---------------------------------------------------------------------------
/// The EcoLens game UI kit.
///
/// Chunky, high-contrast, touch-first components designed to sit on top of the
/// Guardian Valley world: wooden-edged panels, HUD pills, XP meters, speech
/// bubbles and world-portal buttons.
///
/// Everything sizes off [GameScale] — one factor derived from the available
/// height — so the whole interface shrinks gracefully on a small window and
/// grows on a 4K kiosk WITHOUT any layout ever overflowing.
/// ---------------------------------------------------------------------------

/// Provides the current UI scale to the whole game subtree.
class GameScale extends InheritedWidget {
  const GameScale({super.key, required this.scale, required super.child});

  final double scale;

  static double of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GameScale>()?.scale ?? 1.0;

  @override
  bool updateShouldNotify(GameScale oldWidget) => oldWidget.scale != scale;
}

extension GameScaleX on BuildContext {
  /// The current game UI scale factor.
  double get gameScale => GameScale.of(this);

  /// Scales a design-space value into the current surface.
  double gs(double designValue) => designValue * GameScale.of(this);
}

/// Wraps [child] in a [GameScale] derived from the surface size.
///
/// The design canvas is 1440 x 860 logical pixels (a 16:10 kiosk). The scale is
/// clamped so text stays legible on small dev windows and does not become
/// cartoonishly large on very tall displays.
class GameStage extends StatelessWidget {
  const GameStage({
    super.key,
    required this.builder,
    this.designHeight = 860,
    this.designWidth = 1440,
    this.minScale = 0.52,
    // Generous ceiling: the hero layouts absorb extra scale in their flexible
    // centre stage, so a large kiosk (and the "bigger text" boost) can grow the
    // UI without the fixed chrome ever exceeding the surface.
    this.maxScale = 1.55,
    this.boost = 1.0,
  });

  final Widget Function(BuildContext context, double scale) builder;
  final double designHeight;
  final double designWidth;
  final double minScale;
  final double maxScale;

  /// Accessibility multiplier (e.g. the kiosk "bigger text" toggle). Applied
  /// before clamping so it can never push the layout past [maxScale].
  final double boost;

  /// The scale this stage would resolve for [surface].
  ///
  /// Exposed so subtrees rendered *outside* the stage — the Guardian and its
  /// speech bubble, which live in the world layer — can size themselves
  /// identically instead of silently falling back to 1.0.
  static double scaleFor(
    Size surface, {
    double boost = 1.0,
    double designHeight = 860,
    double designWidth = 1440,
    double minScale = 0.52,
    double maxScale = 1.55,
  }) {
    final raw =
        math.min(
          surface.height / designHeight,
          (surface.width / designWidth) * 1.25,
        ) *
        boost;
    return raw.clamp(minScale, maxScale);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : designHeight;
        final w = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : designWidth;
        // Height drives the scale (kiosks are height-constrained); width acts
        // as a ceiling so a short-and-narrow window still fits.
        final raw =
            math.min(h / designHeight, (w / designWidth) * 1.25) * boost;
        final scale = raw.clamp(minScale, maxScale);
        return GameScale(
          scale: scale,
          child: Builder(builder: (context) => builder(context, scale)),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Panels
// ---------------------------------------------------------------------------

/// A frosted "carved wood + leaf" panel used for every HUD surface.
class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.title,
    this.icon,
    this.accent = AppColors.primary,
    this.padding,
    this.compact = false,
  });

  final Widget child;
  final String? title;
  final IconData? icon;
  final Color accent;
  final EdgeInsets? padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final radius = BorderRadius.circular(26 * s);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: ValleyPalette.forestDark.withValues(alpha: 0.28),
            blurRadius: 22 * s,
            offset: Offset(0, 8 * s),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.93),
            borderRadius: radius,
            border: Border.all(
              color: accent.withValues(alpha: 0.55),
              width: 3 * s,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                _PanelHeader(title: title!, icon: icon, accent: accent),
              Padding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(
                      horizontal: (compact ? 12 : 16) * s,
                      vertical: (compact ? 10 : 14) * s,
                    ),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.title, required this.accent, this.icon});

  final String title;
  final IconData? icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 9 * s),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, Color.lerp(accent, Colors.black, 0.18)!],
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 19 * s),
            SizedBox(width: 8 * s),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13 * s,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1 * s,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat tiles
// ---------------------------------------------------------------------------

/// A single game stat: small caps label above a big bold value, in a tinted
/// rounded tile (the layout used across the student panel).
class GameStatTile extends StatelessWidget {
  const GameStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon,
    this.dense = false,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * s,
        vertical: (dense ? 6 : 8) * s,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(14 * s),
        border: Border.all(
          color: accent.withValues(alpha: 0.35),
          width: 1.5 * s,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 12 * s, color: accent),
                SizedBox(width: 4 * s),
              ],
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10 * s,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8 * s,
                    color: Color.lerp(accent, Colors.black, 0.25),
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2 * s),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: (dense ? 20 : 24) * s,
                fontWeight: FontWeight.w900,
                color: Color.lerp(accent, Colors.black, 0.30),
                height: 1.05,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// HUD
// ---------------------------------------------------------------------------

/// A rounded HUD chip (level badge, coin balance, streak…).
class HudPill extends StatelessWidget {
  const HudPill({
    super.key,
    required this.label,
    this.icon,
    this.accent = AppColors.primary,
    this.filled = true,
    this.semanticsLabel,
  });

  final String label;
  final IconData? icon;
  final Color accent;
  final bool filled;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Semantics(
      label: semanticsLabel,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 7 * s),
        decoration: BoxDecoration(
          color: filled ? accent : Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: filled
                ? Color.lerp(accent, Colors.black, 0.22)!
                : accent.withValues(alpha: 0.5),
            width: 2 * s,
          ),
          boxShadow: [
            BoxShadow(
              color: ValleyPalette.forestDark.withValues(alpha: 0.20),
              blurRadius: 8 * s,
              offset: Offset(0, 3 * s),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16 * s, color: filled ? Colors.white : accent),
              SizedBox(width: 6 * s),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14 * s,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: filled
                    ? Colors.white
                    : Color.lerp(accent, Colors.black, 0.28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A glossy XP / progress meter.
class GameMeter extends StatelessWidget {
  const GameMeter({
    super.key,
    required this.value,
    this.label,
    this.trailing,
    this.accent = AppColors.xpPurple,
    this.width,
    this.height = 16,
  });

  /// 0..1.
  final double value;
  final String? label;
  final String? trailing;
  final Color accent;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final v = value.clamp(0.0, 1.0);
    final bar = Container(
      width: width == null ? null : width! * s,
      height: height * s,
      decoration: BoxDecoration(
        color: ValleyPalette.forestDark.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.55),
          width: 1.5 * s,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: v == 0 ? 0.0001 : v,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.lerp(accent, Colors.white, 0.35)!, accent],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.42,
                  widthFactor: 0.92,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.34),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (label == null && trailing == null) return bar;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (label != null)
              Flexible(
                child: Text(
                  label!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11 * s,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6 * s,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            if (trailing != null) ...[
              const Spacer(),
              Text(
                trailing!,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11 * s,
                  fontWeight: FontWeight.w900,
                  color: Color.lerp(accent, Colors.black, 0.25),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 4 * s),
        bar,
      ],
    );
  }
}

/// A round, chunky icon button (sound, accessibility, help…).
class GameIconButton extends StatelessWidget {
  const GameIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.accent = AppColors.primary,
    this.active = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color accent;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final size = 40 * s;
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        toggled: active,
        child: Material(
          color: active ? Colors.white.withValues(alpha: 0.92) : Colors.white70,
          shape: CircleBorder(
            side: BorderSide(
              color: accent.withValues(alpha: active ? 0.6 : 0.25),
              width: 2 * s,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                icon,
                size: 20 * s,
                color: active ? accent : AppColors.inkFaint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Speech bubble
// ---------------------------------------------------------------------------

/// Where the bubble's tail points.
enum SpeechTail { bottom, bottomLeft, left, right, none }

/// The Guardian's speech bubble. Animates in with a friendly pop so it reads as
/// the dragon *saying* something rather than a static caption.
class GuardianSpeechBubble extends StatefulWidget {
  const GuardianSpeechBubble({
    super.key,
    required this.text,
    this.headline,
    this.tail = SpeechTail.bottom,
    this.accent = AppColors.primary,
    this.maxWidth = 460,
    this.footer,
    this.animate = true,
  });

  final String text;

  /// Optional bold first line (e.g. "Hi there, young Guardian!").
  final String? headline;
  final SpeechTail tail;
  final Color accent;
  final double maxWidth;

  /// Optional widget under the message (a chip, a hint, a countdown…).
  final Widget? footer;
  final bool animate;

  @override
  State<GuardianSpeechBubble> createState() => _GuardianSpeechBubbleState();
}

class _GuardianSpeechBubbleState extends State<GuardianSpeechBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pop;

  @override
  void initState() {
    super.initState();
    _pop = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
      value: widget.animate ? 0 : 1,
    );
    if (widget.animate) _pop.forward();
  }

  @override
  void didUpdateWidget(covariant GuardianSpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate &&
        (widget.text != oldWidget.text ||
            widget.headline != oldWidget.headline)) {
      _pop.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;

    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth * s),
      child: CustomPaint(
        painter: _BubblePainter(
          tail: widget.tail,
          accent: widget.accent,
          scale: s,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widget.tail == SpeechTail.left ? 26 * s : 20 * s,
            16 * s,
            widget.tail == SpeechTail.right ? 26 * s : 20 * s,
            widget.tail == SpeechTail.bottom ||
                    widget.tail == SpeechTail.bottomLeft
                ? 26 * s
                : 16 * s,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.headline != null) ...[
                Text(
                  widget.headline!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21 * s,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                    color: Color.lerp(widget.accent, Colors.black, 0.35),
                  ),
                ),
                SizedBox(height: 4 * s),
              ],
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17 * s,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              if (widget.footer != null) ...[
                SizedBox(height: 10 * s),
                widget.footer!,
              ],
            ],
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _pop,
      builder: (context, child) {
        final t = Curves.easeOutBack.transform(_pop.value.clamp(0.0, 1.0));
        return Opacity(
          opacity: _pop.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: 0.86 + 0.14 * t,
            alignment: switch (widget.tail) {
              SpeechTail.bottom => Alignment.bottomCenter,
              SpeechTail.bottomLeft => Alignment.bottomLeft,
              SpeechTail.left => Alignment.centerLeft,
              SpeechTail.right => Alignment.centerRight,
              SpeechTail.none => Alignment.center,
            },
            child: child,
          ),
        );
      },
      child: content,
    );
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter({
    required this.tail,
    required this.accent,
    required this.scale,
  });

  final SpeechTail tail;
  final Color accent;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scale;
    final tailSize = 16.0 * s;
    final body = Rect.fromLTWH(
      tail == SpeechTail.left ? tailSize : 0,
      0,
      size.width -
          (tail == SpeechTail.left || tail == SpeechTail.right ? tailSize : 0),
      size.height -
          (tail == SpeechTail.bottom || tail == SpeechTail.bottomLeft
              ? tailSize
              : 0),
    );

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(24 * s)));

    switch (tail) {
      case SpeechTail.bottom:
        final cx = body.center.dx;
        path.addPolygon([
          Offset(cx - tailSize, body.bottom - 2),
          Offset(cx + tailSize * 0.35, body.bottom - 2),
          Offset(cx - tailSize * 0.35, body.bottom + tailSize),
        ], true);
      case SpeechTail.bottomLeft:
        final cx = body.left + body.width * 0.22;
        path.addPolygon([
          Offset(cx - tailSize * 0.4, body.bottom - 2),
          Offset(cx + tailSize, body.bottom - 2),
          Offset(cx - tailSize * 0.2, body.bottom + tailSize),
        ], true);
      case SpeechTail.left:
        final cy = body.center.dy;
        path.addPolygon([
          Offset(body.left + 2, cy - tailSize * 0.7),
          Offset(body.left + 2, cy + tailSize * 0.7),
          Offset(body.left - tailSize, cy + tailSize * 0.1),
        ], true);
      case SpeechTail.right:
        final cy = body.center.dy;
        path.addPolygon([
          Offset(body.right - 2, cy - tailSize * 0.7),
          Offset(body.right - 2, cy + tailSize * 0.7),
          Offset(body.right + tailSize, cy + tailSize * 0.1),
        ], true);
      case SpeechTail.none:
        break;
    }

    canvas.drawPath(
      path.shift(Offset(0, 5 * s)),
      Paint()
        ..color = ValleyPalette.forestDark.withValues(alpha: 0.26)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * s),
    );
    canvas.drawPath(
      path,
      Paint()..color = Colors.white.withValues(alpha: 0.96),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = accent.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * s,
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter old) =>
      old.tail != tail || old.accent != accent || old.scale != scale;
}

// ---------------------------------------------------------------------------
// World portal buttons (waste categories)
// ---------------------------------------------------------------------------

/// A large, colourful "world portal" tile — how the four waste categories are
/// presented on the kiosk. Big touch target, animated hover/press lift.
class WorldPortalButton extends StatefulWidget {
  const WorldPortalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colour,
    this.hint,
    this.onTap,
    this.selected = false,
    this.width = 168,
  });

  final String label;
  final IconData icon;
  final Color colour;
  final String? hint;
  final VoidCallback? onTap;
  final bool selected;
  final double width;

  @override
  State<WorldPortalButton> createState() => _WorldPortalButtonState();
}

class _WorldPortalButtonState extends State<WorldPortalButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final lifted = _hover || widget.selected;
    final light = Color.lerp(widget.colour, Colors.white, 0.82)!;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.hint == null
          ? '${widget.label} bin'
          : '${widget.label} bin. ${widget.hint}',
      child: MouseRegion(
        cursor: widget.onTap == null
            ? MouseCursor.defer
            : SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _down = true),
          onTapUp: (_) => setState(() => _down = false),
          onTapCancel: () => setState(() => _down = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: widget.width * s,
            transform: Matrix4.translationValues(
              0,
              _down ? 3 * s : (lifted ? -5 * s : 0),
              0,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 12 * s),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, light],
              ),
              borderRadius: BorderRadius.circular(22 * s),
              border: Border.all(
                color: widget.colour.withValues(alpha: lifted ? 1.0 : 0.55),
                width: (widget.selected ? 4 : 3) * s,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.colour.withValues(alpha: lifted ? 0.45 : 0.24),
                  blurRadius: (lifted ? 20 : 12) * s,
                  offset: Offset(0, (lifted ? 9 : 5) * s),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46 * s,
                  height: 46 * s,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.lerp(widget.colour, Colors.white, 0.35)!,
                        widget.colour,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.colour.withValues(alpha: 0.5),
                        blurRadius: 10 * s,
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, size: 25 * s, color: Colors.white),
                ),
                SizedBox(height: 7 * s),
                Text(
                  widget.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15 * s,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                    color: Color.lerp(widget.colour, Colors.black, 0.42),
                  ),
                ),
                if (widget.hint != null) ...[
                  SizedBox(height: 2 * s),
                  Text(
                    widget.hint!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10.5 * s,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Impact / goal rows
// ---------------------------------------------------------------------------

/// One line of the impact panel: icon + value + caption.
class ImpactRow extends StatelessWidget {
  const ImpactRow({
    super.key,
    required this.icon,
    required this.value,
    required this.caption,
    required this.accent,
  });

  final IconData icon;
  final String value;
  final String caption;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Row(
      children: [
        Container(
          width: 32 * s,
          height: 32 * s,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10 * s),
          ),
          child: Icon(icon, size: 18 * s, color: accent),
        ),
        SizedBox(width: 9 * s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18 * s,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  color: Color.lerp(accent, Colors.black, 0.28),
                ),
              ),
              Text(
                caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11 * s,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
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
