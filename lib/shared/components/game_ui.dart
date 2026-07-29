import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// LogicalKeyboardKey: portals are activatable from the keyboard.
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/valley_tokens.dart';
import '../painters/valley_painters.dart';
import '../world/guardian_face_badge.dart';
import 'game_scale.dart';
import 'valley_ui.dart';

export 'game_scale.dart';

/// ---------------------------------------------------------------------------
/// The EcoLens game UI kit — the pieces that are specific to the *kiosk*.
///
/// The generic Guardian Valley language (panels, tiles, medallions, trails,
/// badges) lives in `valley_ui.dart`; this file holds the surfaces that only
/// the kiosk has: the HUD chips, the Guardian's dialogue bubble and the four
/// world portals. The older component names are kept and now delegate to the
/// Valley kit, so every existing screen picks up the new look without a rename.
///
/// Everything sizes off [GameScale] — one factor derived from the available
/// height — so the whole interface shrinks gracefully on a small window and
/// grows on a 4K kiosk WITHOUT any layout ever overflowing.
/// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Panels
// ---------------------------------------------------------------------------

/// A Guardian Valley information panel.
///
/// Retained as the kiosk's panel entry point; the layered surface itself is
/// [ValleyGamePanel]. Pass [theme] for one of the designed palettes, or leave it
/// null and a palette is derived from [accent] (for colours that are data, like
/// a house colour).
class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.accent = AppColors.primary,
    this.theme,
    this.trailing,
    this.footer,
    this.padding,
    this.compact = false,
    this.decorate = true,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final Color accent;
  final ValleyTheme? theme;
  final Widget? trailing;
  final Widget? footer;
  final EdgeInsets? padding;
  final bool compact;
  final bool decorate;

  @override
  Widget build(BuildContext context) {
    return ValleyGamePanel(
      theme: theme ?? ValleyTheme.forest,
      colours: theme == null ? ValleyThemeColours.fromAccent(accent) : null,
      title: title,
      subtitle: subtitle,
      icon: icon,
      trailing: trailing,
      footer: footer,
      padding: padding,
      compact: compact,
      decorate: decorate,
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Stat tiles
// ---------------------------------------------------------------------------

/// A single game stat: a small caps label above a big bold value, in a tinted
/// rounded tile with an icon medallion.
class GameStatTile extends StatelessWidget {
  const GameStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon,
    this.dense = false,
    this.hero = false,
    this.count,
    this.footnote,
  });

  final String label;
  final String value;
  final Color accent;
  final IconData? icon;
  final bool dense;

  /// Makes this the loudest tile in its column.
  final bool hero;

  /// When the value is a plain integer, pass it here too so it counts up.
  final int? count;

  final String? footnote;

  @override
  Widget build(BuildContext context) => ValleyStatTile(
    label: label,
    value: value,
    count: count,
    accent: accent,
    icon: icon,
    dense: dense,
    hero: hero,
    footnote: footnote,
  );
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
        padding: EdgeInsets.symmetric(horizontal: 11 * s, vertical: 6 * s),
        decoration: BoxDecoration(
          gradient: filled
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.lerp(accent, Colors.white, 0.24)!,
                    Color.lerp(accent, Colors.black, 0.1)!,
                  ],
                )
              : null,
          color: filled
              ? null
              : const Color(0xFFFBFEF8).withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
          border: Border.all(
            color: filled
                ? Colors.white.withValues(alpha: 0.72)
                : accent.withValues(alpha: 0.5),
            width: 1.9 * s,
          ),
          boxShadow: [
            BoxShadow(
              color: ValleyPalette.forestDark.withValues(alpha: 0.2),
              blurRadius: 8 * s,
              offset: Offset(0, 3 * s),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: valleyLegible(15, s, 13) * s,
                color: filled ? Colors.white : accent,
              ),
              SizedBox(width: 5 * s),
            ],
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: valleyLegible(13.5, s, 12) * s,
                fontWeight: FontWeight.w900,
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
    this.height = 15,
    this.animate = true,
  });

  /// 0..1.
  final double value;
  final String? label;
  final String? trailing;
  final Color accent;
  final double? width;
  final double height;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final bar = ValleyProgressBar(
      value: value,
      label: label,
      trailing: trailing,
      accent: accent,
      height: height,
      animate: animate,
    );
    if (width == null) return bar;
    return SizedBox(width: width! * s, child: bar);
  }
}

/// A round, chunky icon button (sound, accessibility, help…).
class GameIconButton extends StatefulWidget {
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
  State<GameIconButton> createState() => _GameIconButtonState();
}

class _GameIconButtonState extends State<GameIconButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    // Floored at 40 logical pixels: these controls sit in a dense HUD row, and
    // the kiosk's primary actions carry the 48px target.
    final size = math.max(40 * s, 40.0);
    return Tooltip(
      message: widget.tooltip,
      child: Semantics(
        button: true,
        label: widget.tooltip,
        toggled: widget.active,
        child: Material(
          color: widget.active
              ? const Color(0xFFFBFEF8).withValues(alpha: 0.94)
              : const Color(0xFFF0F4EE).withValues(alpha: 0.9),
          shape: CircleBorder(
            side: BorderSide(
              color: _focused
                  ? widget.accent
                  : widget.accent.withValues(alpha: widget.active ? 0.6 : 0.25),
              width: (_focused ? 3.2 : 2) * s,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onPressed,
            onFocusChange: (v) => setState(() => _focused = v),
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                widget.icon,
                size: size * 0.5,
                color: widget.active ? widget.accent : AppColors.inkFaint,
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

/// ---------------------------------------------------------------------------
/// The Guardian's dialogue bubble.
///
/// A game dialogue box, not a caption: cream body, forest-green rim, a small
/// drawn Sprout portrait, a pointer aimed at the character, and — when a voice
/// is available — a speaker control to hear the line again plus a talking
/// indicator while it plays.
///
/// It animates in with a friendly pop so it reads as the dragon *saying*
/// something. Width is capped and every string wraps rather than clipping, so a
/// long name or the bigger-text setting can never cut a sentence off.
/// ---------------------------------------------------------------------------
class GuardianSpeechBubble extends StatefulWidget {
  const GuardianSpeechBubble({
    super.key,
    required this.text,
    this.headline,
    this.tail = SpeechTail.bottom,
    this.accent = AppColors.primary,
    this.theme,
    this.maxWidth = 460,
    this.footer,
    this.animate = true,
    this.showPortrait = true,
    this.onReplay,
    this.speaking,
    this.replayLabel = 'Hear that again',
  });

  final String text;

  /// Optional bold first line (e.g. "Hi there, young Guardian!").
  final String? headline;
  final SpeechTail tail;

  /// Legacy accent. Ignored when [theme] is supplied.
  final Color accent;

  /// The bubble's mood. Neutral cream/green by default; pale blue for thinking,
  /// green/gold for a correct sort, warm amber for a gentle retry, purple for a
  /// level-up.
  final ValleyTheme? theme;

  final double maxWidth;

  /// Optional widget under the message (a chip, a hint, a countdown…).
  final Widget? footer;
  final bool animate;

  /// The small Sprout portrait at the left of the bubble.
  final bool showPortrait;

  /// Speak the current line again. Null hides the control entirely — which is
  /// what happens on a device with no speech engine.
  final VoidCallback? onReplay;

  /// True while the line is being spoken. Drives the talking indicator.
  final ValueListenable<bool>? speaking;

  final String replayLabel;

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
    final c =
        widget.theme?.colours ?? ValleyThemeColours.fromAccent(widget.accent);
    final portrait = 34.0 * s;

    final message = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headline != null) ...[
          Text(
            widget.headline!,
            style: TextStyle(
              fontSize: valleyLegible(19, s, 16) * s,
              height: 1.2,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3 * s,
              color: c.accentDeep,
            ),
          ),
          SizedBox(height: 3 * s),
        ],
        Text(
          widget.text,
          style: TextStyle(
            fontSize: valleyLegible(16, s, 14) * s,
            height: 1.34,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        if (widget.footer != null) ...[SizedBox(height: 9 * s), widget.footer!],
      ],
    );

    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth * s),
      child: CustomPaint(
        painter: _BubblePainter(tail: widget.tail, colours: c, scale: s),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            widget.tail == SpeechTail.left ? 24 * s : 15 * s,
            13 * s,
            widget.tail == SpeechTail.right ? 24 * s : 15 * s,
            widget.tail == SpeechTail.bottom ||
                    widget.tail == SpeechTail.bottomLeft
                ? 24 * s
                : 13 * s,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showPortrait) ...[
                // Fixed box, so the talking indicator appearing cannot reflow
                // a single word of the message.
                SizedBox(
                  width: portrait,
                  height: portrait,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GuardianFaceBadge(
                        size: portrait,
                        animate: widget.animate,
                      ),
                      if (widget.speaking != null)
                        Positioned(
                          right: -2 * s,
                          bottom: -1 * s,
                          child: _TalkingWaves(
                            speaking: widget.speaking!,
                            colour: c.accentDeep,
                            size: portrait * 0.44,
                            animate: widget.animate,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 9 * s),
              ],
              Expanded(child: message),
              if (widget.onReplay != null) ...[
                SizedBox(width: 8 * s),
                _BubbleSpeakerButton(
                  onPressed: widget.onReplay!,
                  speaking: widget.speaking,
                  colours: c,
                  label: widget.replayLabel,
                  animate: widget.animate,
                ),
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

/// Three little bars that rise and fall while a line is being spoken.
///
/// Deliberately *beside* the portrait rather than distorting it: stretching the
/// Guardian's face to fake a mouth looks like a rendering bug.
class _TalkingWaves extends StatefulWidget {
  const _TalkingWaves({
    required this.speaking,
    required this.colour,
    required this.size,
    required this.animate,
  });

  final ValueListenable<bool> speaking;
  final Color colour;
  final double size;
  final bool animate;

  @override
  State<_TalkingWaves> createState() => _TalkingWavesState();
}

class _TalkingWavesState extends State<_TalkingWaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController _wave = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );

  @override
  void initState() {
    super.initState();
    widget.speaking.addListener(_onSpeakingChanged);
    if (widget.speaking.value) _onSpeakingChanged();
  }

  @override
  void didUpdateWidget(covariant _TalkingWaves old) {
    super.didUpdateWidget(old);
    if (old.speaking == widget.speaking) return;
    old.speaking.removeListener(_onSpeakingChanged);
    widget.speaking.addListener(_onSpeakingChanged);
  }

  void _onSpeakingChanged() {
    if (!mounted) return;
    if (widget.speaking.value && widget.animate) {
      if (!_wave.isAnimating) _wave.repeat(reverse: true);
    } else {
      _wave.stop();
      _wave.value = 0;
    }
  }

  @override
  void dispose() {
    widget.speaking.removeListener(_onSpeakingChanged);
    _wave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.speaking,
      builder: (context, speaking, _) {
        if (!speaking) return SizedBox.square(dimension: widget.size);
        return ExcludeSemantics(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _wave,
              builder: (context, _) => CustomPaint(
                size: Size.square(widget.size),
                painter: _TalkingWavesPainter(
                  t: _wave.value,
                  colour: widget.colour,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TalkingWavesPainter extends CustomPainter {
  const _TalkingWavesPainter({required this.t, required this.colour});

  final double t;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    // A soft disc so the bars stay legible over the Guardian's cheek.
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.5,
      Paint()..color = Colors.white.withValues(alpha: 0.92),
    );
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * 0.5,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, size.width * 0.07)
        ..color = colour.withValues(alpha: 0.5),
    );

    final barW = size.width * 0.12;
    final cy = size.height * 0.5;
    final paint = Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barW
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 3; i++) {
      final phase = (t + i * 0.28) % 1.0;
      final h = size.height * (0.14 + 0.20 * math.sin(phase * math.pi));
      final x = size.width * (0.30 + i * 0.20);
      canvas.drawLine(Offset(x, cy - h), Offset(x, cy + h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TalkingWavesPainter old) =>
      old.t != t || old.colour != colour;
}

/// The "hear that again" control inside the bubble.
class _BubbleSpeakerButton extends StatelessWidget {
  const _BubbleSpeakerButton({
    required this.onPressed,
    required this.colours,
    required this.label,
    required this.animate,
    this.speaking,
  });

  final VoidCallback onPressed;
  final ValleyThemeColours colours;
  final String label;
  final bool animate;
  final ValueListenable<bool>? speaking;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    // Never below the 48px accessible minimum, whatever the game scale does.
    final d = math.max(40 * s, 48.0);

    Widget button(bool isSpeaking) => Semantics(
      button: true,
      label: isSpeaking ? 'Sprout is speaking. $label' : label,
      excludeSemantics: true,
      child: Tooltip(
        message: label,
        child: Material(
          color: isSpeaking
              ? colours.accent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.86),
          shape: CircleBorder(
            side: BorderSide(
              color: colours.accent.withValues(alpha: isSpeaking ? 0.85 : 0.45),
              width: 2 * s,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: d,
              height: d,
              child: Icon(
                isSpeaking ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                size: d * 0.46,
                color: colours.accentDeep,
              ),
            ),
          ),
        ),
      ),
    );

    if (speaking == null) return button(false);
    return ValueListenableBuilder<bool>(
      valueListenable: speaking!,
      builder: (context, isSpeaking, _) => button(isSpeaking && animate),
    );
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter({
    required this.tail,
    required this.colours,
    required this.scale,
  });

  final SpeechTail tail;
  final ValleyThemeColours colours;
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
      ..addRRect(RRect.fromRectAndRadius(body, Radius.circular(22 * s)));

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

    // Two-part shadow, matching the panels.
    canvas.drawPath(
      path.shift(Offset(0, 6 * s)),
      Paint()
        ..color = ValleyPalette.forestDark.withValues(alpha: 0.24)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * s),
    );

    // Cream / pale-tint body rather than flat white.
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colours.surfaceTop, colours.surfaceBottom],
        ).createShader(Offset.zero & size),
    );

    // Inner top highlight, clipped to the bubble.
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.32),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.55),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.32)),
    );
    canvas.restore();

    canvas.drawPath(
      path,
      Paint()
        ..color = colours.accent.withValues(alpha: 0.78)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * s,
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter old) =>
      old.tail != tail ||
      old.colours.accent != colours.accent ||
      old.colours.surfaceTop != colours.surfaceTop ||
      old.scale != scale;
}

// ---------------------------------------------------------------------------
// World portal buttons (waste categories)
// ---------------------------------------------------------------------------

/// What a portal is currently doing. Every state carries a non-colour signal
/// too — a glyph, a word or a shape — so it never depends on hue alone.
enum PortalState {
  /// Open and waiting.
  idle,

  /// The student's current choice.
  selected,

  /// The right portal for this item.
  correct,

  /// Not this one — gentle, never an error.
  incorrect,

  /// Temporarily unavailable (full bin, hardware fault).
  locked,
}

extension PortalStateX on PortalState {
  bool get isInteractive => this != PortalState.locked;
}

/// A large, colourful "world portal" tile — how the four waste categories are
/// presented on the kiosk.
///
/// A portal, not a card: the icon medallion sits inside a glowing ring on a
/// painted base, and the whole tile lifts toward the student on hover. Big touch
/// target, and every feedback state is drawn rather than merely tinted.
class WorldPortalButton extends StatefulWidget {
  const WorldPortalButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colour,
    this.hint,
    this.onTap,
    this.selected = false,
    this.state = PortalState.idle,
    this.rewardLabel,
    this.width = 168,
    this.animate = true,
  });

  final String label;
  final IconData icon;
  final Color colour;
  final String? hint;
  final VoidCallback? onTap;

  /// Legacy flag, folded into [state].
  final bool selected;

  final PortalState state;

  /// Shown rising out of the portal on a correct sort ("+10 XP").
  final String? rewardLabel;

  final double width;
  final bool animate;

  PortalState get effectiveState =>
      state == PortalState.idle && selected ? PortalState.selected : state;

  @override
  State<WorldPortalButton> createState() => _WorldPortalButtonState();
}

class _WorldPortalButtonState extends State<WorldPortalButton>
    with TickerProviderStateMixin {
  bool _hover = false;
  bool _down = false;
  bool _focus = false;

  /// One-shot celebration: expanding ring, leaf burst, rising reward label.
  late final AnimationController _cheer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  /// One-shot "not this one": a single damped sway. Never a harsh shake.
  late final AnimationController _nudge = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
  );

  @override
  void initState() {
    super.initState();
    // A portal can be BUILT already showing feedback (a rebuilt subtree, a
    // resumed session, a screenshot test). Without this the celebration would
    // only ever play on a transition, so the reward would silently never appear.
    _playFeedback(widget.effectiveState);
  }

  @override
  void didUpdateWidget(covariant WorldPortalButton old) {
    super.didUpdateWidget(old);
    final now = widget.effectiveState;
    if (now == old.effectiveState) return;
    _playFeedback(now);
  }

  void _playFeedback(PortalState state) {
    switch (state) {
      case PortalState.correct:
        widget.animate ? _cheer.forward(from: 0) : _cheer.value = 0.5;
      case PortalState.incorrect:
        widget.animate ? _nudge.forward(from: 0) : _nudge.value = 1;
      case PortalState.idle:
      case PortalState.selected:
      case PortalState.locked:
        _cheer.value = 0;
        _nudge.value = 0;
    }
  }

  @override
  void dispose() {
    _cheer.dispose();
    _nudge.dispose();
    super.dispose();
  }

  /// The colour the portal actually paints in. Feedback overrides the category
  /// colour, and a locked portal drains toward stone.
  Color get _colour => switch (widget.effectiveState) {
    PortalState.correct => AppColors.success,
    PortalState.incorrect => const Color(0xFFE8935A),
    PortalState.locked => Color.lerp(
      widget.colour,
      const Color(0xFF9AA79E),
      0.7,
    )!,
    _ => widget.colour,
  };

  /// The badge drawn in the corner. This is the non-colour signal.
  IconData? get _stateGlyph => switch (widget.effectiveState) {
    PortalState.correct => Icons.check_rounded,
    PortalState.incorrect => Icons.lightbulb_outline_rounded,
    PortalState.locked => Icons.lock_outline_rounded,
    PortalState.selected => Icons.adjust_rounded,
    PortalState.idle => null,
  };

  String get _semanticSuffix => switch (widget.effectiveState) {
    PortalState.correct => ' Correct portal.',
    PortalState.incorrect => ' Not this portal — try another.',
    PortalState.locked => ' Currently unavailable.',
    PortalState.selected => ' Selected.',
    PortalState.idle => '',
  };

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final st = widget.effectiveState;
    final enabled = widget.onTap != null && st.isInteractive;
    final lifted = (_hover || _focus) && enabled;
    final emphasised =
        lifted || st == PortalState.selected || st == PortalState.correct;
    final colour = _colour;
    final light = Color.lerp(colour, Colors.white, 0.86)!;
    final radius = BorderRadius.circular(ValleyTokens.radiusPanel * s);

    return Semantics(
      button: true,
      selected: st == PortalState.selected,
      enabled: enabled,
      label:
          '${widget.label} portal.'
          '${widget.hint == null ? '' : ' ${widget.hint}.'}'
          '$_semanticSuffix',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: FocusableActionDetector(
          enabled: enabled,
          onShowFocusHighlight: (v) => setState(() => _focus = v),
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap?.call();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTapDown: (_) => setState(() => _down = true),
            onTapUp: (_) => setState(() => _down = false),
            onTapCancel: () => setState(() => _down = false),
            onTap: enabled ? widget.onTap : null,
            child: AnimatedBuilder(
              animation: Listenable.merge([_cheer, _nudge]),
              builder: (context, child) {
                // A single damped sway for "not this one" — the whole point is
                // that it reads as a shrug, not an alarm.
                final n = _nudge.value;
                final sway = n > 0 && n < 1
                    ? math.sin(n * math.pi * 3) * (1 - n) * 5 * s
                    : 0.0;
                return Transform.translate(
                  offset: Offset(sway, 0),
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: ValleyTokens.fast,
                curve: Curves.easeOut,
                width: widget.width * s,
                transform: Matrix4.translationValues(
                  0,
                  _down ? 3 * s : (lifted ? -6 * s : 0),
                  0,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [const Color(0xFFFDFEFA), light],
                  ),
                  borderRadius: radius,
                  border: Border.all(
                    color: _focus
                        ? Color.lerp(colour, Colors.black, 0.25)!
                        : colour.withValues(alpha: emphasised ? 1 : 0.55),
                    width: (_focus ? 4 : (emphasised ? 3.6 : 2.8)) * s,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colour.withValues(alpha: emphasised ? 0.45 : 0.22),
                      blurRadius: (emphasised ? 22 : 12) * s,
                      offset: Offset(0, (emphasised ? 10 : 5) * s),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 9 * s,
                          vertical: 11 * s,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // The portal itself: a base ring with the medallion
                            // floating in it.
                            SizedBox(
                              width: 60 * s,
                              height: 52 * s,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned.fill(
                                    child: RepaintBoundary(
                                      child: AnimatedBuilder(
                                        animation: _cheer,
                                        builder: (context, _) => CustomPaint(
                                          painter: _PortalRingPainter(
                                            colour: colour,
                                            glow: emphasised ? 1 : 0.55,
                                            cheer: st == PortalState.correct
                                                ? _cheer.value
                                                : 0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  AnimatedScale(
                                    duration: ValleyTokens.fast,
                                    scale: lifted ? 1.06 : 1,
                                    child: ValleyIconMedallion(
                                      icon: widget.icon,
                                      accent: colour,
                                      size: 42,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 6 * s),
                            Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: valleyLegible(15, s, 13) * s,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                letterSpacing: -0.2 * s,
                                color: Color.lerp(colour, Colors.black, 0.46),
                              ),
                            ),
                            if (widget.hint != null) ...[
                              SizedBox(height: 1 * s),
                              Text(
                                widget.hint!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: valleyLegible(10.5, s, 9.5) * s,
                                  fontWeight: FontWeight.w600,
                                  height: 1.15,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // State badge — the signal that is not colour.
                      if (_stateGlyph != null)
                        Positioned(
                          top: 5 * s,
                          right: 5 * s,
                          child: Container(
                            width: 19 * s,
                            height: 19 * s,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colour,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.9),
                                width: 1.6 * s,
                              ),
                            ),
                            child: Icon(
                              _stateGlyph,
                              size: 11 * s,
                              color: Colors.white,
                            ),
                          ),
                        ),

                      // The reward rising out of a correct portal.
                      if (widget.rewardLabel != null &&
                          st == PortalState.correct)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: AnimatedBuilder(
                              animation: _cheer,
                              builder: (context, _) {
                                final t = _cheer.value;
                                if (t <= 0 || t >= 1) {
                                  return const SizedBox.shrink();
                                }
                                final rise = Curves.easeOut.transform(t);
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - rise) * 26 * s),
                                    child: Opacity(
                                      opacity: (1 - t * t).clamp(0.0, 1.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 4 * s),
                                        child: ValleyBadge(
                                          label: widget.rewardLabel!,
                                          icon: Icons.auto_awesome,
                                          accent: AppColors.coinGold,
                                          filled: true,
                                          dense: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
      ),
    );
  }
}

/// The portal's base ring and glow, plus the leaf burst on a correct sort.
class _PortalRingPainter extends CustomPainter {
  const _PortalRingPainter({
    required this.colour,
    required this.glow,
    required this.cheer,
  });

  final Color colour;

  /// 0..1 emphasis.
  final double glow;

  /// 0..1 one-shot celebration; 0 draws nothing extra.
  final double cheer;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width * 0.5, size.height * 0.56);
    final rx = size.width * 0.46;
    final ry = size.height * 0.30;

    // The portal mouth: a soft elliptical well the medallion sits in.
    canvas.drawOval(
      Rect.fromCenter(center: c, width: rx * 2, height: ry * 2),
      Paint()
        ..shader =
            RadialGradient(
              colors: [
                colour.withValues(alpha: 0.34 * glow),
                colour.withValues(alpha: 0.06 * glow),
                colour.withValues(alpha: 0),
              ],
              stops: const [0, 0.62, 1],
            ).createShader(
              Rect.fromCenter(center: c, width: rx * 2, height: ry * 2),
            ),
    );

    // Its rim.
    canvas.drawOval(
      Rect.fromCenter(center: c, width: rx * 1.72, height: ry * 1.62),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, size.width * 0.028)
        ..color = colour.withValues(alpha: 0.34 + 0.28 * glow),
    );

    if (cheer <= 0 || cheer >= 1) return;

    // Expanding confirmation ring.
    final t = Curves.easeOut.transform(cheer);
    canvas.drawCircle(
      c,
      size.width * (0.30 + 0.42 * t),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.5, size.width * 0.05 * (1 - t))
        ..color = AppColors.coinGold.withValues(alpha: (1 - t) * 0.9),
    );

    // Leaf burst.
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi * 2 / 6 - 0.5;
      final d = size.width * (0.22 + 0.44 * t);
      final p = c + Offset(math.cos(a) * d, math.sin(a) * d * 0.7);
      final r = size.width * 0.07 * (1 - t * 0.6);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(a + t * 2);
      canvas.drawPath(
        Path()
          ..moveTo(0, -r)
          ..quadraticBezierTo(r, 0, 0, r)
          ..quadraticBezierTo(-r, 0, 0, -r),
        Paint()..color = AppColors.guardianLeaf.withValues(alpha: 1 - t),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _PortalRingPainter old) =>
      old.colour != colour || old.glow != glow || old.cheer != cheer;
}

// ---------------------------------------------------------------------------
// Impact rows
// ---------------------------------------------------------------------------

/// One line of the impact panel: medallion + value + caption.
class ImpactRow extends StatelessWidget {
  const ImpactRow({
    super.key,
    required this.icon,
    required this.value,
    required this.caption,
    required this.accent,
    this.count,
    this.suffix = '',
    this.cheer,
  });

  final IconData icon;
  final String value;
  final String caption;
  final Color accent;

  /// When the value is a plain integer, pass it here too so it counts up.
  final int? count;
  final String suffix;

  /// Short positive microcopy under the caption.
  final String? cheer;

  @override
  Widget build(BuildContext context) => ValleyImpactStat(
    icon: icon,
    value: value,
    count: count,
    suffix: suffix,
    caption: caption,
    accent: accent,
    cheer: cheer,
  );
}
