import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/world/guardian_controller.dart';
import '../../../../shared/world/guardian_emotion.dart';
import '../../../../shared/world/guardian_mascot.dart';
import '../../../../shared/world/guardian_world.dart';
import '../../../../shared/world/guardian_world_stage.dart';
import '../../application/guardian_audio.dart';
import '../../application/guardian_speech.dart';
import '../../application/guardian_director.dart';
import '../../application/kiosk_controller.dart';
import '../../application/kiosk_preferences.dart';
import '../../application/kiosk_session_state.dart';
import 'valley_chrome.dart';

/// Persistent kiosk frame.
///
/// Wraps every kiosk screen in the living **Guardian Valley** world, lays the
/// heads-up display over the top, and establishes the [GameScale] that all game
/// components size themselves from. The hidden developer entry point (long-press
/// the logo) lives in the HUD and is never discoverable by a student.
///
/// Screens that are information-dense (scanning, quiz, feedback, dashboards on
/// the kiosk) get a soft veil over the world so their white cards stay legible;
/// the hero screens show the valley at full vibrancy.
class KioskChrome extends ConsumerWidget {
  const KioskChrome({
    super.key,
    required this.child,
    this.showDevAccess = false,
  });

  final Widget child;
  final bool showDevAccess;

  /// States that show the Guardian on stage. The information-dense screens
  /// (scan, quiz, reward tables) need their whole canvas for content.
  static const Set<KioskState> _guardianStates = {
    KioskState.idle,
    KioskState.waitingForCard,
    KioskState.offline,
    KioskState.readingCard,
    KioskState.studentNotFound,
    KioskState.studentRecognised,
    KioskState.sessionComplete,
  };

  /// States where the world is the star of the show. Every other screen is
  /// text-dense and gets a readability veil, so dark copy never has to fight
  /// the meadow behind it.
  static const Set<KioskState> _heroStates = {
    KioskState.idle,
    KioskState.waitingForCard,
    KioskState.offline,
    KioskState.studentRecognised,
    KioskState.guardianEvolution,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final prefs = ref.watch(kioskPreferencesProvider);
    final hero = _heroStates.contains(session.state);
    final avatar = session.avatar;

    // Drive the Guardian from the real kiosk state machine.
    //
    // Watched, not read: the director is autoDispose and holds the memory of
    // the last state it saw, so without a real subscription it would be torn
    // down and rebuilt on every frame and re-fire expressions it had already
    // played. Listened to rather than driven from build, because it writes to
    // the Guardian controller and a provider must never be modified while the
    // widget tree is building.
    final director = ref.watch(guardianDirectorProvider);
    ref.listen<KioskSessionState>(kioskControllerProvider, (previous, next) {
      director.onKioskState(next);
    });
    // The listener above only fires on change, so seed the director with the
    // state this frame is already rendering — after the frame, never during it.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => director.onKioskState(session),
    );
    // Keeps the Guardian's cue stream connected to sound for this session.
    // Watched so the bridge lives as long as the kiosk surface does.
    ref.watch(guardianAudioBridgeProvider);

    final mode = resolveWorldRenderMode(
      preference: ref.watch(worldRenderPreferenceProvider),
      reduceMotion: prefs.reduceMotion,
      artFailed: ref.watch(worldArtFailedProvider),
    );
    final surface = MediaQuery.sizeOf(context);
    final compact = surface.width < 1100;
    final guardian = ref.watch(guardianControllerProvider);
    final showGuardian = _guardianStates.contains(session.state);
    // The world stage sits outside GameStage, so give it the same scale by
    // hand — otherwise the speech bubble would ignore the bigger-text setting.
    final stageScale = GameStage.scaleFor(surface, boost: prefs.textScaleBoost);

    return GuardianValleyScene(
      mode: mode,
      compact: compact,
      // The Guardian lives in the world layer, so the foreground grass draws
      // over its feet and the speech bubble always points at its head.
      stage: !showGuardian
          ? null
          : GameScale(
              scale: stageScale,
              child: GuardianWorldStage(
                usePaintedDais: mode == GuardianWorldRenderMode.paintedFallback,
                animateDais: !prefs.reduceMotion,
                minTop: 84 * stageScale,
                guardianBuilder: (context, height) => GuardianMascot(
                  height: height,
                  emotion: guardian.emotion,
                  sequence: guardian.sequence,
                  animate: !prefs.reduceMotion,
                  fallbackStage: avatar?.stage ?? 2,
                  semanticLabel:
                      '${avatar?.name ?? 'Sprout'}, your EcoLens '
                      'Guardian. ${guardian.emotion.name}',
                  onTap: session.hasStudent
                      ? ref
                            .read(kioskControllerProvider.notifier)
                            .viewGuardianEvolution
                      : null,
                ),
                speechBuilder: (context, maxWidth) => _GuardianSpeech(
                  emotion: guardian.emotion,
                  session: session,
                  maxWidth: maxWidth,
                  animate: !prefs.reduceMotion,
                ),
              ),
            ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Readability veil for the detail-heavy screens.
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              color: Colors.white.withValues(alpha: hero ? 0.0 : 0.66),
            ),
          ),
          SafeArea(
            child: GameStage(
              boost: prefs.textScaleBoost,
              builder: (context, s) => Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(18 * s, 12 * s, 18 * s, 0),
                    child: ValleyHud(
                      schoolName: AppConfig.demoSchoolName,
                      guardianName: avatar?.name,
                      level: avatar?.level,
                      xpProgress: avatar?.levelProgress,
                      xpLabel: avatar == null
                          ? null
                          : '${avatar.currentXp}/${avatar.xpRequiredForNextLevel}',
                      coins: session.student?.availablePoints,
                      streak: session.student?.currentStreak,
                      offline: session.isOffline,
                      queuedCount: session.queuedCount,
                      showDevAccess: showDevAccess,
                    ),
                  ),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A reusable large action button styled for touch (kiosk primary CTA).
class KioskButton extends StatelessWidget {
  const KioskButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.primary,
    this.filled = true,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool filled;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 22 * s),
          SizedBox(width: 10 * s),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18 * s, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
    final padding = EdgeInsets.symmetric(horizontal: 26 * s, vertical: 16 * s);
    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18 * s),
          ),
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: Colors.white.withValues(alpha: 0.86),
        side: BorderSide(color: color.withValues(alpha: 0.6), width: 2 * s),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18 * s),
        ),
      ),
      child: child,
    );
  }
}

/// Convenience for showing the demo AppConfig env tag on kiosk (debug only).
bool get kioskDevAccessEnabled => AppConfig.devPanelEnabled;

/// The Guardian's speech bubble, fed by the emotion and the live session.
///
/// All wording comes from [GuardianSpeech] so it can be reviewed (and later
/// localised) in one place, and student data is interpolated rather than
/// hardcoded anywhere near a screen.
class _GuardianSpeech extends StatelessWidget {
  const _GuardianSpeech({
    required this.emotion,
    required this.session,
    required this.maxWidth,
    required this.animate,
  });

  final GuardianEmotion emotion;
  final KioskSessionState session;
  final double maxWidth;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final student = session.student;
    final outcome = session.lastOutcome;
    final line = GuardianSpeech.forEmotion(
      emotion,
      firstName: student?.firstName,
      guardianName: session.avatar?.name,
      houseName: session.house?.name,
      category: outcome?.correctCategory ?? session.routedCategory,
      level: session.avatar?.level,
      itemsToday: session.itemsThisSession > 0
          ? session.itemsThisSession
          : null,
    );

    return GuardianSpeechBubble(
      headline: line.headline,
      text: line.text,
      maxWidth: maxWidth / context.gameScale,
      animate: animate,
      accent: _accentFor(emotion),
    );
  }

  static Color _accentFor(GuardianEmotion emotion) => switch (emotion) {
    GuardianEmotion.correct => AppColors.success,
    GuardianEmotion.celebrate ||
    GuardianEmotion.levelUp => AppColors.coinGoldDark,
    GuardianEmotion.tryAgain || GuardianEmotion.encourage => AppColors.warning,
    GuardianEmotion.thinking => AppColors.info,
    _ => AppColors.primary,
  };
}
