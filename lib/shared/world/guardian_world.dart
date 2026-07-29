import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/guardian_valley.dart';
import 'guardian_valley_scene.dart';
import 'guardian_world_assets.dart';

export 'guardian_world_assets.dart' show GuardianWorldRenderMode;

/// Device-level preference for how the valley is drawn.
///
/// Defaults to the generated art. A kiosk can be pinned to the painted world
/// with `--dart-define=ECOLENS_WORLD=painted`, which is the escape hatch for
/// very weak hardware or a build that ships without the art bundle.
final worldRenderPreferenceProvider = StateProvider<GuardianWorldRenderMode>((
  ref,
) {
  const pinned = String.fromEnvironment('ECOLENS_WORLD', defaultValue: 'auto');
  return switch (pinned) {
    'painted' => GuardianWorldRenderMode.paintedFallback,
    'calm' => GuardianWorldRenderMode.reducedMotion,
    _ => GuardianWorldRenderMode.generatedArt,
  };
});

/// Set when a generated layer fails at runtime, permanently demoting this
/// session to the painted world.
final worldArtFailedProvider = StateProvider<bool>((ref) => false);

/// Resolves the preference, the accessibility settings and any asset failure
/// into the mode actually used for this frame.
GuardianWorldRenderMode resolveWorldRenderMode({
  required GuardianWorldRenderMode preference,
  required bool reduceMotion,
  required bool artFailed,
}) {
  if (artFailed || preference == GuardianWorldRenderMode.paintedFallback) {
    return GuardianWorldRenderMode.paintedFallback;
  }
  if (reduceMotion) return GuardianWorldRenderMode.reducedMotion;
  return preference;
}

/// ---------------------------------------------------------------------------
/// One valley, two renderers.
///
/// Every student-facing screen wraps its UI in this. Which world is behind the
/// UI — generated art or the procedural painter — is decided here and nowhere
/// else, so no screen is duplicated per mode.
/// ---------------------------------------------------------------------------
class GuardianValleyScene extends ConsumerWidget {
  const GuardianValleyScene({
    super.key,
    required this.child,
    required this.mode,
    this.stage,
    this.compact = false,
  });

  final Widget child;
  final GuardianWorldRenderMode mode;

  /// The Guardian, placed in world space by [GuardianWorldStage].
  final Widget? stage;

  /// Small viewport — thins decorative particle counts.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (mode == GuardianWorldRenderMode.paintedFallback) {
      // The original procedural world, kept whole.
      return GuardianValley(animate: true, stage: stage, child: child);
    }

    return GuardianValleyGeneratedWorld(
      animate: mode.animates,
      compact: compact,
      stage: stage,
      onBaseAssetFailed: () {
        // Demote for the rest of the session. Debug-only diagnostic; a student
        // just sees the drawn valley instead.
        if (kDebugMode) {
          debugPrint(
            'EcoLens: generated valley unavailable — using painted world.',
          );
        }
        Future.microtask(
          () => ref.read(worldArtFailedProvider.notifier).state = true,
        );
      },
      child: child,
    );
  }
}
