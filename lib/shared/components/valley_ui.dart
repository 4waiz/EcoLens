import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/valley_tokens.dart';
import '../painters/valley_painters.dart';
import 'game_scale.dart';

/// ---------------------------------------------------------------------------
/// The Guardian Valley UI kit.
///
/// Every information container in the student experience is built from these
/// pieces, so the kiosk reads as one game rather than a set of dashboards that
/// happen to share a background. The rules the kit encodes:
///
///   * no plain white rectangles — a panel is a layered surface with a coloured
///     top band, a warm cream/mint body gradient, an inner highlight, leaf
///     corner accents and a two-part shadow;
///   * colour means something (see [ValleyTheme]) and is never the ONLY signal:
///     an icon, a number or a word always carries the same information;
///   * every size comes from [ValleyTokens] multiplied by the surface's
///     [GameScale], so the whole language shrinks and grows as one unit;
///   * decoration is the first thing sacrificed on a small screen, and the
///     primary action is the last.
///
/// Motion: every animating component takes an `animate` flag AND respects
/// [MediaQuery.disableAnimations], so kiosk calm mode and the platform's own
/// accessibility setting both land.
/// ---------------------------------------------------------------------------

/// Raises a design-space font size so that, once multiplied by the game scale,
/// it never renders below [floorPx] logical pixels. Small kiosks give up
/// decoration, never legibility.
double valleyLegible(double designSize, double scale, double floorPx) =>
    scale <= 0 ? designSize : math.max(designSize, floorPx / scale);

/// True when this subtree must not animate.
bool valleyReduceMotion(BuildContext context, {bool animate = true}) =>
    !animate || (MediaQuery.maybeOf(context)?.disableAnimations ?? false);

// ---------------------------------------------------------------------------
// Entrance
// ---------------------------------------------------------------------------

/// Fades and lifts a child in once, with an optional stagger by [index].
///
/// The stagger is baked into the curve rather than a delayed timer, so nothing
/// is left pending if the widget is disposed mid-entrance.
class ValleyEntrance extends StatefulWidget {
  const ValleyEntrance({
    super.key,
    required this.child,
    this.index = 0,
    this.animate = true,
    this.rise = 12,
  });

  final Widget child;
  final int index;
  final bool animate;

  /// How far the child travels upward, in design pixels.
  final double rise;

  @override
  State<ValleyEntrance> createState() => _ValleyEntranceState();
}

class _ValleyEntranceState extends State<ValleyEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _in;
  late final CurvedAnimation _curve;

  @override
  void initState() {
    super.initState();
    final delay = ValleyTokens.stagger.inMilliseconds * widget.index;
    final total = ValleyTokens.entry.inMilliseconds + delay;
    _in = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: total),
      value: widget.animate ? 0 : 1,
    );
    _curve = CurvedAnimation(
      parent: _in,
      curve: Interval(delay / total, 1, curve: Curves.easeOutCubic),
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
    if (valleyReduceMotion(context, animate: widget.animate)) {
      return widget.child;
    }
    final s = context.gameScale;
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        final t = _curve.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * widget.rise * s),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

// ---------------------------------------------------------------------------
// Medallions
// ---------------------------------------------------------------------------

/// A round, gently glowing icon disc — the kit's basic "this is worth looking
/// at" mark. Used in panel headers, stat tiles, portals and rankings.
class ValleyIconMedallion extends StatelessWidget {
  const ValleyIconMedallion({
    super.key,
    required this.icon,
    required this.accent,
    this.size = ValleyTokens.medallionMd,
    this.ring = true,
    this.glow = true,
    this.badge,
    this.semanticLabel,
  });

  final IconData icon;
  final Color accent;

  /// Design-space diameter.
  final double size;

  /// A white ring around the disc — what lifts it off a tinted tile.
  final bool ring;
  final bool glow;

  /// Optional tiny overlay (a rank number, a step number, a check).
  final Widget? badge;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final d = size * s;

    final disc = Container(
      width: d,
      height: d,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.25, -0.4),
          radius: 1.1,
          colors: [
            Color.lerp(accent, Colors.white, 0.45)!,
            accent,
            Color.lerp(accent, Colors.black, 0.14)!,
          ],
          stops: const [0, 0.62, 1],
        ),
        border: ring
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.82),
                width: math.max(1.2, d * 0.055),
              )
            : null,
        boxShadow: glow ? ValleyTokens.tileShadow(s, accent) : null,
      ),
      child: Icon(icon, size: d * 0.5, color: Colors.white),
    );

    final content = badge == null
        ? disc
        : SizedBox(
            width: d,
            height: d,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                disc,
                Positioned(left: -2 * s, top: -2 * s, child: badge!),
              ],
            ),
          );

    if (semanticLabel == null) return ExcludeSemantics(child: content);
    return Semantics(label: semanticLabel, image: true, child: content);
  }
}

/// The small white counter that sits on the corner of a medallion.
class ValleyMedallionBadge extends StatelessWidget {
  const ValleyMedallionBadge({
    super.key,
    required this.text,
    required this.accent,
    this.diameter = 16,
  });

  final String text;
  final Color accent;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final d = diameter * s;
    return Container(
      width: d,
      height: d,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: accent.withValues(alpha: 0.6),
          width: math.max(1, d * 0.09),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            fontSize: d * 0.58,
            fontWeight: FontWeight.w900,
            height: 1,
            color: Color.lerp(accent, Colors.black, 0.35),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Labels, badges and chips
// ---------------------------------------------------------------------------

/// A small-caps divider inside a panel, with a leaf tick so it reads as part of
/// the world rather than a form fieldset.
class ValleySectionLabel extends StatelessWidget {
  const ValleySectionLabel({
    super.key,
    required this.label,
    this.accent = AppColors.primary,
    this.icon,
    this.trailing,
  });

  final String label;
  final Color accent;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Row(
      children: [
        Icon(
          icon ?? Icons.eco,
          size: valleyLegible(ValleyTokens.iconSm, s, 11) * s,
          color: accent.withValues(alpha: 0.85),
        ),
        SizedBox(width: ValleyTokens.space4 * s),
        Flexible(
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize:
                  valleyLegible(ValleyTokens.textSectionLabel, s, 9.5) * s,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.9 * s,
              height: 1.1,
              color: Color.lerp(accent, Colors.black, 0.3),
            ),
          ),
        ),
        if (trailing != null) ...[SizedBox(width: 6 * s), trailing!],
      ],
    );
  }
}

/// A compact pill: icon + text, tinted by [accent]. The kit's badge for
/// "No phone needed", "Rank 2", "YOU" and friends.
class ValleyBadge extends StatelessWidget {
  const ValleyBadge({
    super.key,
    required this.label,
    this.icon,
    this.accent = AppColors.primary,
    this.filled = false,
    this.dense = false,
    this.semanticsLabel,
  });

  final String label;
  final IconData? icon;
  final Color accent;

  /// Filled badges read as a reward; outlined ones as information.
  final bool filled;
  final bool dense;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final fg = filled ? Colors.white : Color.lerp(accent, Colors.black, 0.32)!;

    return Semantics(
      label: semanticsLabel ?? label,
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (dense ? 7 : 9) * s,
          vertical: (dense ? 3 : 5) * s,
        ),
        decoration: BoxDecoration(
          gradient: filled
              ? LinearGradient(
                  colors: [
                    Color.lerp(accent, Colors.white, 0.22)!,
                    Color.lerp(accent, Colors.black, 0.1)!,
                  ],
                )
              : null,
          color: filled ? null : accent.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
          border: Border.all(
            color: filled
                ? Colors.white.withValues(alpha: 0.7)
                : accent.withValues(alpha: 0.42),
            width: 1.4 * s,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: valleyLegible(dense ? 11 : 12.5, s, 10) * s,
                color: fg,
              ),
              SizedBox(width: 4 * s),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: valleyLegible(dense ? 10 : 11, s, 9.5) * s,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                  color: fg,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A gold reward chip — coins, XP earned, a redeemed treat.
class ValleyRewardChip extends StatelessWidget {
  const ValleyRewardChip({
    super.key,
    required this.value,
    required this.label,
    this.icon = Icons.monetization_on_rounded,
    this.accent = AppColors.coinGold,
    this.animate = true,
  });

  final int value;
  final String label;
  final IconData icon;
  final Color accent;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Semantics(
      label: '$value $label',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 6 * s),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.lerp(accent, Colors.white, 0.42)!,
              accent,
              Color.lerp(accent, Colors.black, 0.12)!,
            ],
          ),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
            width: 1.8 * s,
          ),
          boxShadow: ValleyTokens.tileShadow(s, accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: valleyLegible(15, s, 13) * s, color: Colors.white),
            SizedBox(width: 5 * s),
            ValleyCountUp(
              value: value,
              animate: animate,
              style: TextStyle(
                fontSize: valleyLegible(15, s, 13) * s,
                fontWeight: FontWeight.w900,
                height: 1.1,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 5 * s),
            Text(
              label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: valleyLegible(9.5, s, 8.5) * s,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5 * s,
                height: 1.1,
                color: Colors.white.withValues(alpha: 0.92),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Numbers
// ---------------------------------------------------------------------------

/// An integer that counts up to its new value instead of snapping.
///
/// Rewards feel earned when you watch them arrive. Built on Flutter's implicit
/// [TweenAnimationBuilder], so the animation runs when the *value* changes and
/// a plain rebuild never re-plays it.
class ValleyCountUp extends StatelessWidget {
  const ValleyCountUp({
    super.key,
    required this.value,
    required this.style,
    this.suffix = '',
    this.animate = true,
  });

  final int value;
  final TextStyle style;

  /// Appended verbatim ("kg", "%", " pts").
  final String suffix;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final target = value.toDouble();
    if (valleyReduceMotion(context, animate: animate)) {
      return Text('$value$suffix', maxLines: 1, style: style);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: target),
      duration: ValleyTokens.count,
      curve: Curves.easeOutCubic,
      builder: (context, shown, _) =>
          Text('${shown.round()}$suffix', maxLines: 1, style: style),
    );
  }
}

// ---------------------------------------------------------------------------
// Stat tiles
// ---------------------------------------------------------------------------

/// One collectible-looking stat: a medallion, a small label and a big value.
///
/// [hero] makes the tile the loudest thing in its column — used for the handful
/// of numbers a student actually cares about (level, XP, coins, streak).
class ValleyStatTile extends StatelessWidget {
  const ValleyStatTile({
    super.key,
    required this.label,
    required this.value,
    required this.accent,
    this.icon,
    this.hero = false,
    this.dense = false,
    this.count,
    this.animate = true,
    this.footnote,
  });

  final String label;

  /// Pre-formatted value. Prefer [count] where the value is a plain integer, so
  /// it can count up.
  final String value;
  final int? count;

  final Color accent;
  final IconData? icon;
  final bool hero;
  final bool dense;
  final bool animate;

  /// A tiny line under the value ("best yet", "keep going").
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final valueSize = hero
        ? ValleyTokens.textValueHero
        : (dense ? 18.0 : ValleyTokens.textValue);
    final medallion = hero
        ? ValleyTokens.medallionMd
        : (dense ? 22.0 : ValleyTokens.medallionSm);

    final valueStyle = TextStyle(
      fontSize: valleyLegible(valueSize, s, hero ? 22 : 16) * s,
      fontWeight: FontWeight.w900,
      height: 1.02,
      letterSpacing: -0.4 * s,
      color: Color.lerp(accent, Colors.black, 0.34),
    );

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (dense ? 8 : 10) * s,
          vertical: (dense ? 6 : 8) * s,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accent.withValues(alpha: hero ? 0.2 : 0.13),
              accent.withValues(alpha: hero ? 0.09 : 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusTile * s),
          border: Border.all(
            color: accent.withValues(alpha: hero ? 0.52 : 0.34),
            width: (hero ? 2.1 : ValleyTokens.borderTile) * s,
          ),
          boxShadow: hero ? ValleyTokens.tileShadow(s, accent) : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              ValleyIconMedallion(
                icon: icon!,
                accent: accent,
                size: medallion,
                glow: hero,
              ),
              SizedBox(width: (dense ? 6 : 8) * s),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: valleyLegible(ValleyTokens.textLabel, s, 9) * s,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7 * s,
                      height: 1.1,
                      color: Color.lerp(accent, Colors.black, 0.3),
                    ),
                  ),
                  SizedBox(height: 1 * s),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: count == null
                        ? Text(value, maxLines: 1, style: valueStyle)
                        : ValleyCountUp(
                            value: count!,
                            animate: animate,
                            style: valueStyle,
                          ),
                  ),
                  if (footnote != null)
                    Text(
                      footnote!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: valleyLegible(8.5, s, 8) * s,
                        fontWeight: FontWeight.w700,
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

/// One line of the impact board: a big illustrated medallion, a counting value
/// and a caption, plus an optional line of encouragement.
class ValleyImpactStat extends StatelessWidget {
  const ValleyImpactStat({
    super.key,
    required this.icon,
    required this.value,
    required this.caption,
    required this.accent,
    this.count,
    this.suffix = '',
    this.cheer,
    this.animate = true,
  });

  final IconData icon;

  /// Pre-formatted fallback used when [count] is null.
  final String value;
  final int? count;
  final String suffix;

  final String caption;
  final Color accent;

  /// Short positive microcopy ("that's a whole class!").
  final String? cheer;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final valueStyle = TextStyle(
      fontSize: valleyLegible(21, s, 17) * s,
      fontWeight: FontWeight.w900,
      height: 1.05,
      letterSpacing: -0.3 * s,
      color: Color.lerp(accent, Colors.black, 0.3),
    );

    return Semantics(
      label: '$value$suffix $caption',
      excludeSemantics: true,
      child: Row(
        children: [
          ValleyIconMedallion(
            icon: icon,
            accent: accent,
            size: ValleyTokens.medallionMd,
          ),
          SizedBox(width: ValleyTokens.space8 * s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: count == null
                      ? Text(value, maxLines: 1, style: valueStyle)
                      : ValleyCountUp(
                          value: count!,
                          suffix: suffix,
                          animate: animate,
                          style: valueStyle,
                        ),
                ),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        valleyLegible(ValleyTokens.textCaption, s, 10) * s,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.inkMuted,
                  ),
                ),
                if (cheer != null)
                  Text(
                    cheer!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: valleyLegible(9, s, 8.5) * s,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      color: accent.withValues(alpha: 0.9),
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

// ---------------------------------------------------------------------------
// Progress
// ---------------------------------------------------------------------------

/// A chunky game progress track: rounded, glossy, with an animated fill.
class ValleyProgressBar extends StatelessWidget {
  const ValleyProgressBar({
    super.key,
    required this.value,
    this.label,
    this.trailing,
    this.accent = AppColors.primary,
    this.height = 15,
    this.animate = true,
    this.semanticsLabel,
  });

  /// 0..1.
  final double value;
  final String? label;
  final String? trailing;
  final Color accent;
  final double height;
  final bool animate;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final v = value.clamp(0.0, 1.0);
    final reduce = valleyReduceMotion(context, animate: animate);

    Widget fillFor(double fill) => FractionallySizedBox(
      widthFactor: fill <= 0 ? 0.0001 : fill,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.lerp(accent, Colors.white, 0.42)!,
              accent,
              Color.lerp(accent, Colors.black, 0.1)!,
            ],
          ),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
        ),
        // Inner top highlight: the "glossy" read.
        child: Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            heightFactor: 0.4,
            widthFactor: 0.93,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
              ),
            ),
          ),
        ),
      ),
    );

    final track = Container(
      height: height * s,
      decoration: BoxDecoration(
        color: ValleyPalette.forestDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.62),
          width: 1.5 * s,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
        child: Align(
          alignment: Alignment.centerLeft,
          child: reduce
              ? fillFor(v)
              : TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: v),
                  duration: ValleyTokens.count,
                  curve: Curves.easeOutCubic,
                  builder: (context, fill, _) => fillFor(fill),
                ),
        ),
      ),
    );

    final bar = Semantics(
      label: semanticsLabel ?? label,
      value: '${(v * 100).round()} percent',
      child: track,
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
                  label!.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:
                        valleyLegible(ValleyTokens.textSectionLabel, s, 9.5) *
                        s,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7 * s,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
            if (trailing != null) ...[
              SizedBox(width: 6 * s),
              Flexible(
                child: Text(
                  trailing!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: valleyLegible(10.5, s, 9.5) * s,
                    fontWeight: FontWeight.w900,
                    color: Color.lerp(accent, Colors.black, 0.28),
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: ValleyTokens.space4 * s),
        bar,
      ],
    );
  }
}

/// A shared-goal progress **trail**: the track plus milestone nodes that light
/// up as the school passes them, so the goal reads as a journey rather than a
/// KPI. Reached milestones gain a filled star, so the state never depends on
/// colour alone.
class ValleyQuestTrail extends StatelessWidget {
  const ValleyQuestTrail({
    super.key,
    required this.value,
    required this.label,
    this.caption,
    this.accent = AppColors.success,
    this.milestones = const [0.25, 0.5, 0.75, 1.0],
    this.animate = true,
  });

  /// 0..1.
  final double value;
  final String label;
  final String? caption;
  final Color accent;
  final List<double> milestones;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final v = value.clamp(0.0, 1.0);
    final reduce = valleyReduceMotion(context, animate: animate);

    Widget trail(double fill) => CustomPaint(
      size: Size(double.infinity, 22 * s),
      painter: _QuestTrailPainter(
        progress: fill,
        accent: accent,
        milestones: milestones,
        scale: s,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ValleySectionLabel(
                label: label,
                accent: accent,
                icon: Icons.flag_rounded,
              ),
            ),
            if (caption != null)
              Flexible(
                child: Text(
                  caption!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: valleyLegible(10.5, s, 9.5) * s,
                    fontWeight: FontWeight.w900,
                    color: Color.lerp(accent, Colors.black, 0.28),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ValleyTokens.space6 * s),
        Semantics(
          label: '$label. ${caption ?? ''}',
          value: '${(v * 100).round()} percent complete',
          excludeSemantics: true,
          child: RepaintBoundary(
            child: reduce
                ? trail(v)
                : TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: v),
                    duration: ValleyTokens.count,
                    curve: Curves.easeOutCubic,
                    builder: (context, fill, _) => trail(fill),
                  ),
          ),
        ),
      ],
    );
  }
}

/// The trail: a sunken track, a filled path, and milestone nodes.
class _QuestTrailPainter extends CustomPainter {
  const _QuestTrailPainter({
    required this.progress,
    required this.accent,
    required this.milestones,
    required this.scale,
  });

  final double progress;
  final Color accent;
  final List<double> milestones;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = scale;
    final trackH = 11 * s;
    final cy = size.height * 0.5;
    final left = 3 * s;
    final right = size.width - 3 * s;
    final span = math.max(1.0, right - left);
    final radius = Radius.circular(trackH);

    // Sunken track.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, cy - trackH / 2, right, cy + trackH / 2),
        radius,
      ),
      Paint()..color = ValleyPalette.forestDark.withValues(alpha: 0.28),
    );

    // Filled path.
    final end = left + span * progress.clamp(0.0, 1.0);
    if (end > left + 1) {
      final fill = Rect.fromLTRB(left, cy - trackH / 2, end, cy + trackH / 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(fill, radius),
        Paint()
          ..shader = LinearGradient(
            colors: [Color.lerp(accent, Colors.white, 0.4)!, accent],
          ).createShader(fill),
      );
      // Gloss.
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            left + 1.5 * s,
            cy - trackH * 0.4,
            math.max(left + 2 * s, end - 1.5 * s),
            cy - trackH * 0.06,
          ),
          Radius.circular(trackH),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.32),
      );
    }

    // Milestone nodes.
    for (final m in milestones) {
      final x = left + span * m.clamp(0.0, 1.0);
      final reached = progress >= m - 0.001;
      final r = 7.0 * s;
      canvas.drawCircle(
        Offset(x, cy),
        r,
        Paint()..color = reached ? accent : const Color(0xFFEFF4EE),
      );
      canvas.drawCircle(
        Offset(x, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 * s
          ..color = reached
              ? Colors.white.withValues(alpha: 0.95)
              : ValleyPalette.forestDark.withValues(alpha: 0.35),
      );
      if (reached) {
        _star(canvas, Offset(x, cy), r * 0.62, Paint()..color = Colors.white);
      }
    }
  }

  void _star(Canvas canvas, Offset c, double r, Paint paint) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final a = i * math.pi / 5 - math.pi / 2;
      final rad = i.isEven ? r : r * 0.44;
      final p = c + Offset(math.cos(a) * rad, math.sin(a) * rad);
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path..close(), paint);
  }

  @override
  bool shouldRepaint(covariant _QuestTrailPainter old) =>
      old.progress != progress ||
      old.accent != accent ||
      old.scale != scale ||
      old.milestones.length != milestones.length;
}

// ---------------------------------------------------------------------------
// Rankings
// ---------------------------------------------------------------------------

/// One row of a leaderboard, presented as a podium shield rather than a table
/// row: rank shield, house dot, name, a share-of-leader bar and the points.
class ValleyRankRow extends StatelessWidget {
  const ValleyRankRow({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.colour,
    this.leaderPoints,
    this.isMine = false,
    this.animate = true,
  });

  final int rank;
  final String name;
  final int points;
  final Color colour;

  /// The top score, used to size the share bar. Falls back to [points].
  final int? leaderPoints;

  /// Highlights the row belonging to the student standing at the kiosk.
  final bool isMine;
  final bool animate;

  /// Podium metal for the top three, the entry's own colour after that. The
  /// rank NUMBER is always drawn as well, so this is never the only signal.
  Color get _shield => switch (rank) {
    1 => const Color(0xFFE3A81C),
    2 => const Color(0xFF9FAEB8),
    3 => const Color(0xFFC0793D),
    _ => colour,
  };

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final leader = math.max(1, leaderPoints ?? points);
    final share = (points / leader).clamp(0.0, 1.0);

    return Semantics(
      label: isMine
          ? 'Rank $rank, $name, $points points. This is your team.'
          : 'Rank $rank, $name, $points points',
      excludeSemantics: true,
      child: Container(
        padding: EdgeInsets.fromLTRB(6 * s, 5 * s, 8 * s, 5 * s),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: isMine
                ? [
                    colour.withValues(alpha: 0.22),
                    colour.withValues(alpha: 0.08),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.66),
                    Colors.white.withValues(alpha: 0.34),
                  ],
          ),
          borderRadius: BorderRadius.circular(ValleyTokens.radiusInner * s),
          border: Border.all(
            color: isMine
                ? colour.withValues(alpha: 0.6)
                : ValleyPalette.forestDark.withValues(alpha: 0.14),
            width: (isMine ? 2 : 1.2) * s,
          ),
        ),
        child: Row(
          children: [
            // Rank shield.
            SizedBox(
              width: 20 * s,
              height: 23 * s,
              child: CustomPaint(
                painter: _RankShieldPainter(colour: _shield, scale: s),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: valleyLegible(10.5, s, 9) * s,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 7 * s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: valleyLegible(12, s, 10.5) * s,
                            fontWeight: isMine
                                ? FontWeight.w900
                                : FontWeight.w700,
                            height: 1.15,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      if (isMine) ...[
                        SizedBox(width: 5 * s),
                        ValleyBadge(
                          label: 'YOU',
                          accent: colour,
                          filled: true,
                          dense: true,
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 3 * s),
                  // Share of the leader's score — how far behind the front the
                  // house is, at a glance.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ValleyTokens.radiusPill,
                    ),
                    child: SizedBox(
                      height: 4 * s,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          color: ValleyPalette.forestDark.withValues(
                            alpha: 0.14,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: share <= 0 ? 0.0001 : share,
                              child: Container(
                                height: 4 * s,
                                decoration: BoxDecoration(
                                  color: colour,
                                  borderRadius: BorderRadius.circular(
                                    ValleyTokens.radiusPill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 7 * s),
            ValleyCountUp(
              value: points,
              animate: animate,
              style: TextStyle(
                fontSize: valleyLegible(12.5, s, 11) * s,
                fontWeight: FontWeight.w900,
                height: 1.1,
                color: Color.lerp(colour, Colors.black, 0.22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small heraldic shield behind a rank number.
class _RankShieldPainter extends CustomPainter {
  const _RankShieldPainter({required this.colour, required this.scale});

  final Color colour;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, h)
      ..cubicTo(w * 0.06, h * 0.72, 0, h * 0.5, 0, h * 0.14)
      ..lineTo(w * 0.5, 0)
      ..lineTo(w, h * 0.14)
      ..cubicTo(w, h * 0.5, w * 0.94, h * 0.72, w * 0.5, h)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(colour, Colors.white, 0.34)!,
            colour,
            Color.lerp(colour, Colors.black, 0.16)!,
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1, 1.4 * scale)
        ..color = Colors.white.withValues(alpha: 0.82),
    );
  }

  @override
  bool shouldRepaint(covariant _RankShieldPainter old) =>
      old.colour != colour || old.scale != scale;
}

// ---------------------------------------------------------------------------
// Panels
// ---------------------------------------------------------------------------

/// The kit's information container: a layered game surface.
///
/// Structure, outside in — a two-part shadow, a coloured border, a warm body
/// gradient, then inside the clip: faint leaf/sparkle corner decoration, a
/// coloured header band with an icon medallion, and the body.
class ValleyGamePanel extends StatelessWidget {
  const ValleyGamePanel({
    super.key,
    required this.child,
    this.theme = ValleyTheme.forest,
    this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.footer,
    this.padding,
    this.compact = false,
    this.animate = true,
    this.decorate = true,
    this.colours,
  });

  final Widget child;
  final ValleyTheme theme;

  /// Overrides [theme] when the colour is data rather than a design choice —
  /// see [ValleyThemeColours.fromAccent].
  final ValleyThemeColours? colours;

  /// Upper-cased into the header band. Omit for a band-less surface.
  final String? title;

  /// One friendly sentence under the header ("Your school is helping!").
  final String? subtitle;

  final IconData? icon;

  /// Sits at the right of the header band — a badge, a count, a live chip.
  final Widget? trailing;

  /// Pinned under the body, outside the scrolling content.
  final Widget? footer;

  final EdgeInsets? padding;
  final bool compact;
  final bool animate;

  /// False drops the leaf/sparkle corner art — used on the tightest layouts.
  final bool decorate;

  /// The vertical space the panel's own chrome costs, in real pixels.
  ///
  /// A panel hands its body an UNBOUNDED height (it is a `Column`), so a caller
  /// that needs to fit content into a fixed slot has to work out its budget
  /// before the chrome. Exposed here so no screen has to guess with a magic
  /// number that drifts when the header changes.
  static double chromeHeight({
    required double scale,
    bool compact = false,
    bool hasTitle = true,
    bool hasSubtitle = false,
  }) {
    var chrome = 2 * (compact ? 10 : 13) * scale; // body padding
    if (hasTitle) {
      chrome +=
          (compact
                  ? ValleyTokens.headerHeightCompact
                  : ValleyTokens.headerHeight) *
              scale +
          1.4 * scale; // band + its hairline
    }
    if (hasSubtitle) {
      // One line of subtitle plus the gap under it.
      chrome +=
          (ValleyTokens.textSubtitle * 1.25 + ValleyTokens.space8) * scale;
    }
    return chrome;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final c = colours ?? theme.colours;
    final border = ValleyTokens.borderPanel * s;
    final outer = BorderRadius.circular(ValleyTokens.radiusPanel * s);
    final inner = BorderRadius.circular(
      math.max(0, ValleyTokens.radiusPanel * s - border),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: outer,
        gradient: c.surfaceGradient,
        border: Border.all(
          color: c.accent.withValues(alpha: 0.6),
          width: border,
        ),
        boxShadow: ValleyTokens.panelShadow(s, tint: c.accentDeep),
      ),
      child: ClipRRect(
        borderRadius: inner,
        child: Stack(
          children: [
            if (decorate)
              Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _PanelDecorationPainter(accent: c.accent),
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  ValleyPanelHeader(
                    title: title!,
                    icon: icon,
                    theme: theme,
                    colours: colours,
                    trailing: trailing,
                    compact: compact,
                  ),
                Padding(
                  padding:
                      padding ??
                      EdgeInsets.symmetric(
                        horizontal: (compact ? 11 : 14) * s,
                        vertical: (compact ? 10 : 13) * s,
                      ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (subtitle != null) ...[
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                                valleyLegible(
                                  ValleyTokens.textSubtitle,
                                  s,
                                  10,
                                ) *
                                s,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            color: c.accentDeep.withValues(alpha: 0.86),
                          ),
                        ),
                        SizedBox(height: ValleyTokens.space8 * s),
                      ],
                      child,
                    ],
                  ),
                ),
                ?footer,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Fits a panel's body into the height it actually has.
///
/// Two stages, in this order:
///   1. the caller **tiers** its content down using the budget this widget is
///      given — denser tiles, tighter gaps, less optional microcopy. This is the
///      plan, and it is what should happen at every supported size;
///   2. anything still over budget scrolls.
///
/// Stage 2 is deliberately a scroll and NOT a `FittedBox`. Scaling the whole
/// composition down looks like a tidy safety net and is a trap: it silences the
/// overflow assertion, so the tests go green while the panel renders content too
/// small to read — and once the ratio gets bad enough, effectively not at all.
/// A scroll keeps every value at its designed size and tells the truth.
class ValleyPanelBody extends StatelessWidget {
  const ValleyPanelBody({super.key, required this.budget, required this.child});

  /// Real pixels available for the body, chrome already subtracted.
  final double budget;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!budget.isFinite) return child;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: math.max(0, budget)),
      child: SingleChildScrollView(
        // A kiosk panel should never need to scroll — the tiers above are sized
        // so it does not. This exists so a host that hands the panel less room
        // than any tier assumed degrades to "scrollable" instead of "clipped".
        physics: const ClampingScrollPhysics(),
        child: child,
      ),
    );
  }
}

/// The coloured band across the top of a [ValleyGamePanel].
class ValleyPanelHeader extends StatelessWidget {
  const ValleyPanelHeader({
    super.key,
    required this.title,
    this.theme = ValleyTheme.forest,
    this.colours,
    this.icon,
    this.trailing,
    this.compact = false,
  });

  final String title;
  final ValleyTheme theme;
  final ValleyThemeColours? colours;
  final IconData? icon;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final c = colours ?? theme.colours;
    final h =
        (compact
            ? ValleyTokens.headerHeightCompact
            : ValleyTokens.headerHeight) *
        s;
    final glyph = h * 0.62;

    return Container(
      constraints: BoxConstraints(minHeight: h),
      padding: EdgeInsets.symmetric(horizontal: 10 * s, vertical: 5 * s),
      decoration: BoxDecoration(
        gradient: c.bandGradient,
        // A bright hairline under the band: the "carved edge" that stops the
        // band and the body reading as two unrelated rectangles.
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1.4 * s,
          ),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: glyph,
              height: glyph,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                  width: 1.2 * s,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: glyph * 0.6),
            ),
            SizedBox(width: 8 * s),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: valleyLegible(ValleyTokens.textHeader, s, 11.5) * s,
                fontWeight: FontWeight.w900,
                letterSpacing: 1 * s,
                height: 1.1,
                shadows: [
                  Shadow(
                    color: c.accentDeep.withValues(alpha: 0.6),
                    blurRadius: 2 * s,
                  ),
                ],
              ),
            ),
          ),
          if (trailing != null) ...[SizedBox(width: 6 * s), trailing!],
        ],
      ),
    );
  }
}

/// Faint leaves, vines and sparkles in a panel's empty corners, plus the inner
/// top highlight. Deliberately very low contrast: this is texture, not content.
class _PanelDecorationPainter extends CustomPainter {
  const _PanelDecorationPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    // Inner top highlight — one soft band, cheaper and calmer than a blur.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height * 0.10),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.34),
            Colors.white.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.1)),
    );

    final leaf = Paint()..color = accent.withValues(alpha: 0.09);
    void drawLeaf(Offset at, double r, double angle) {
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(angle);
      canvas.drawPath(
        Path()
          ..moveTo(0, -r)
          ..quadraticBezierTo(r, -r * 0.2, 0, r)
          ..quadraticBezierTo(-r, -r * 0.2, 0, -r),
        leaf,
      );
      canvas.restore();
    }

    drawLeaf(Offset(size.width * 0.94, size.height * 0.14), 14, 0.7);
    drawLeaf(Offset(size.width * 0.05, size.height * 0.52), 11, -0.5);
    drawLeaf(Offset(size.width * 0.96, size.height * 0.8), 12, 2.2);

    // A short vine curling out of the bottom-left corner.
    canvas.drawPath(
      Path()
        ..moveTo(-2, size.height + 2)
        ..quadraticBezierTo(
          size.width * 0.10,
          size.height * 0.90,
          size.width * 0.05,
          size.height * 0.74,
        ),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = accent.withValues(alpha: 0.10),
    );

    final spark = Paint()..color = AppColors.coinGold.withValues(alpha: 0.16);
    for (final p in [
      Offset(size.width * 0.87, size.height * 0.34),
      Offset(size.width * 0.11, size.height * 0.24),
      Offset(size.width * 0.91, size.height * 0.62),
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
  bool shouldRepaint(covariant _PanelDecorationPainter old) =>
      old.accent != accent;
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------

/// A chunky game action button: gradient body, white rim, hover lift, press
/// sink, visible focus ring and a 48px minimum height.
class ValleyActionButton extends StatefulWidget {
  const ValleyActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.theme = ValleyTheme.forest,
    this.filled = true,
    this.height = 50,
    this.expand = false,
    this.semanticsLabel,
    this.animate = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ValleyTheme theme;

  /// Outlined buttons are the secondary rung of the same language.
  final bool filled;
  final double height;
  final bool expand;
  final String? semanticsLabel;
  final bool animate;

  @override
  State<ValleyActionButton> createState() => _ValleyActionButtonState();
}

class _ValleyActionButtonState extends State<ValleyActionButton> {
  bool _hover = false;
  bool _down = false;
  bool _focus = false;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final c = widget.theme.colours;
    final enabled = widget.onPressed != null;
    final h = math.max(widget.height * s, 48.0);
    final radius = BorderRadius.circular(h * 0.4);
    final lift = _hover && enabled && widget.animate;

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticsLabel ?? widget.label,
      excludeSemantics: true,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: AnimatedContainer(
          duration: ValleyTokens.fast,
          curve: Curves.easeOut,
          height: h,
          transform: Matrix4.translationValues(
            0,
            _down ? 2 * s : (lift ? -3 * s : 0),
            0,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: widget.filled
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: enabled
                        ? [
                            Color.lerp(c.accent, Colors.white, 0.16)!,
                            c.accentDeep,
                          ]
                        : const [Color(0xFFB6C4BB), Color(0xFF97A79D)],
                  )
                : null,
            color: widget.filled ? null : Colors.white.withValues(alpha: 0.88),
            border: Border.all(
              color: _focus
                  ? Colors.white
                  : widget.filled
                  ? Colors.white.withValues(alpha: 0.6)
                  : c.accent.withValues(alpha: 0.55),
              width: (_focus ? 3.2 : 2.2) * s,
            ),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: c.accentDeep.withValues(alpha: lift ? 0.42 : 0.26),
                      blurRadius: (lift ? 18 : 11) * s,
                      offset: Offset(0, (lift ? 8 : 4) * s),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: radius,
              onTap: widget.onPressed,
              onHighlightChanged: (v) => setState(() => _down = v),
              onFocusChange: (v) => setState(() => _focus = v),
              focusColor: Colors.white.withValues(alpha: 0.16),
              hoverColor: Colors.white.withValues(alpha: 0.1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18 * s),
                child: Row(
                  mainAxisSize: widget.expand
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(
                        widget.icon,
                        size: h * 0.4,
                        color: widget.filled ? Colors.white : c.accentDeep,
                      ),
                      SizedBox(width: 9 * s),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: valleyLegible(15, s, 13.5) * s,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                          color: widget.filled ? Colors.white : c.accentDeep,
                          shadows: widget.filled
                              ? [
                                  Shadow(
                                    color: c.accentDeep.withValues(alpha: 0.45),
                                    blurRadius: 3 * s,
                                  ),
                                ]
                              : null,
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
// Destination cards (the experience selector)
// ---------------------------------------------------------------------------

/// A "world destination" — how each EcoLens experience is offered on the front
/// door. A big illustrated medallion, its own accent, a short line of text and
/// a strong game-style action label, with hover, focus and press responses.
class ValleyDestinationCard extends StatefulWidget {
  const ValleyDestinationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.action,
    required this.icon,
    required this.theme,
    required this.onTap,
    this.width = 252,
    this.animate = true,
  });

  final String title;
  final String subtitle;

  /// The game-style call to action ("Enter Kiosk", "Open Reward Shop").
  final String action;

  final IconData icon;
  final ValleyTheme theme;
  final VoidCallback onTap;
  final double width;
  final bool animate;

  @override
  State<ValleyDestinationCard> createState() => _ValleyDestinationCardState();
}

class _ValleyDestinationCardState extends State<ValleyDestinationCard>
    with SingleTickerProviderStateMixin {
  bool _hover = false;
  bool _down = false;
  bool _focus = false;

  /// One-shot sparkle played when the card is pointed at.
  late final AnimationController _spark = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 720),
  );

  @override
  void dispose() {
    _spark.dispose();
    super.dispose();
  }

  void _setHover(bool on) {
    if (_hover == on) return;
    setState(() => _hover = on);
    if (on && widget.animate && !valleyReduceMotion(context)) {
      _spark.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final c = widget.theme.colours;
    final lifted = (_hover || _focus) && widget.animate;
    final radius = BorderRadius.circular(ValleyTokens.radiusPanel * s);

    return Semantics(
      button: true,
      label: '${widget.title}. ${widget.subtitle}. ${widget.action}',
      excludeSemantics: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _setHover(true),
        onExit: (_) => _setHover(false),
        child: AnimatedContainer(
          duration: ValleyTokens.fast,
          curve: Curves.easeOut,
          width: widget.width * s,
          transform: Matrix4.translationValues(
            0,
            _down ? 3 * s : (lifted ? -7 * s : 0),
            0,
          ),
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: c.surfaceGradient,
            border: Border.all(
              color: _focus
                  ? c.accentDeep
                  : c.accent.withValues(alpha: lifted ? 0.9 : 0.48),
              width: (_focus ? 3.4 : ValleyTokens.borderPanel) * s,
            ),
            boxShadow: lifted
                ? ValleyTokens.liftShadow(s, c.accentDeep)
                : ValleyTokens.panelShadow(s, tint: c.accentDeep),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              borderRadius: radius,
              onTap: widget.onTap,
              onHighlightChanged: (v) => setState(() => _down = v),
              onFocusChange: (v) => setState(() => _focus = v),
              hoverColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: IgnorePointer(
                        child: RepaintBoundary(
                          child: AnimatedBuilder(
                            animation: _spark,
                            builder: (context, _) => CustomPaint(
                              painter: _DestinationDecorPainter(
                                accent: c.accent,
                                sparkle: _spark.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16 * s),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValleyIconMedallion(
                            icon: widget.icon,
                            accent: c.accent,
                            size: ValleyTokens.medallionHero,
                          ),
                          SizedBox(height: 12 * s),
                          Text(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: valleyLegible(18, s, 15) * s,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                              letterSpacing: -0.3 * s,
                              color: c.ink,
                            ),
                          ),
                          SizedBox(height: 3 * s),
                          Text(
                            widget.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: valleyLegible(12, s, 11) * s,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          SizedBox(height: 11 * s),
                          // The action label as a solid pill — a destination you
                          // travel to, not a link you click.
                          AnimatedContainer(
                            duration: ValleyTokens.fast,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12 * s,
                              vertical: 7 * s,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.lerp(c.accent, Colors.white, 0.16)!,
                                  c.accentDeep,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                ValleyTokens.radiusPill,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: lifted ? 0.85 : 0.55,
                                ),
                                width: 1.8 * s,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: c.accentDeep.withValues(
                                    alpha: lifted ? 0.4 : 0.22,
                                  ),
                                  blurRadius: (lifted ? 14 : 8) * s,
                                  offset: Offset(0, 3 * s),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Flexible, not bare: a long action label
                                // ("Open Reward Shop") must ellipsise inside the
                                // pill rather than push the arrow off the card.
                                Flexible(
                                  child: Text(
                                    widget.action,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          valleyLegible(12.5, s, 11.5) * s,
                                      fontWeight: FontWeight.w900,
                                      height: 1.1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5 * s),
                                AnimatedSlide(
                                  duration: ValleyTokens.fast,
                                  offset: Offset(lifted ? 0.22 : 0, 0),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    size: valleyLegible(13, s, 12) * s,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

/// Corner foliage for a destination card, plus a short leaf burst on hover.
class _DestinationDecorPainter extends CustomPainter {
  const _DestinationDecorPainter({required this.accent, required this.sparkle});

  final Color accent;

  /// 0..1 one-shot; 0 draws no burst.
  final double sparkle;

  @override
  void paint(Canvas canvas, Size size) {
    final vine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..color = accent.withValues(alpha: 0.13);
    canvas.drawPath(
      Path()
        ..moveTo(size.width + 4, size.height * 0.16)
        ..quadraticBezierTo(
          size.width * 0.78,
          size.height * 0.06,
          size.width * 0.66,
          size.height * 0.2,
        ),
      vine,
    );

    final leaf = Paint()..color = accent.withValues(alpha: 0.11);
    void drawLeaf(Offset at, double r, double angle) {
      canvas.save();
      canvas.translate(at.dx, at.dy);
      canvas.rotate(angle);
      canvas.drawPath(
        Path()
          ..moveTo(0, -r)
          ..quadraticBezierTo(r, -r * 0.2, 0, r)
          ..quadraticBezierTo(-r, -r * 0.2, 0, -r),
        leaf,
      );
      canvas.restore();
    }

    drawLeaf(Offset(size.width * 0.9, size.height * 0.86), 15, 2.4);
    drawLeaf(Offset(size.width * 0.08, size.height * 0.92), 11, -0.6);

    if (sparkle <= 0 || sparkle >= 1) return;
    // A few leaves lifting off the medallion when the card is pointed at.
    final t = Curves.easeOut.transform(sparkle);
    final origin = Offset(size.width * 0.22, size.height * 0.24);
    for (var i = 0; i < 5; i++) {
      final a = -math.pi * 0.75 + i * 0.32;
      final d = size.width * (0.06 + 0.26 * t);
      final p = origin + Offset(math.cos(a) * d, math.sin(a) * d);
      drawLeaf(p, 6 * (1 - t * 0.5), a + t * 2);
    }
  }

  @override
  bool shouldRepaint(covariant _DestinationDecorPainter old) =>
      old.accent != accent || old.sparkle != sparkle;
}
