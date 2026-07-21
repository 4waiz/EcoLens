import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/enums/kiosk_state.dart';
import '../application/kiosk_controller.dart';
import 'screens/kiosk_analysis_screen.dart';
import 'screens/kiosk_feedback_screens.dart';
import 'screens/kiosk_guardian_evolution_screen.dart';
import 'screens/kiosk_idle_screen.dart';
import 'screens/kiosk_leaderboard_screen.dart';
import 'screens/kiosk_maintenance_screen.dart';
import 'screens/kiosk_quiz_screen.dart';
import 'screens/kiosk_reading_card_screen.dart';
import 'screens/kiosk_reward_summary_screen.dart';
import 'screens/kiosk_scan_screen.dart';
import 'screens/kiosk_student_recognised_screen.dart';
import 'widgets/kiosk_chrome.dart';

/// The single kiosk surface. Renders whichever screen matches the current
/// [KioskState]; the [KioskController] owns all transitions. Locked to a
/// landscape composition and never shows phone-based workflows.
class KioskScreen extends ConsumerWidget {
  const KioskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);

    final body = AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(session.state),
        child: _screenFor(session.state),
      ),
    );

    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.escape): _ExitKioskIntent(),
      },
      child: Actions(
        actions: {
          _ExitKioskIntent: CallbackAction<_ExitKioskIntent>(
            onInvoke: (_) {
              // Escape returns to the demo launcher (kiosk devices disable this).
              context.go(AppRoutes.home);
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            backgroundColor: AppColors.scaffoldBg,
            body: KioskChrome(
              showDevAccess: AppConfig.devPanelEnabled,
              child: body,
            ),
          ),
        ),
      ),
    );
  }

  Widget _screenFor(KioskState state) {
    switch (state) {
      case KioskState.idle:
      case KioskState.waitingForCard:
      case KioskState.offline:
        return const KioskIdleScreen();
      case KioskState.readingCard:
      case KioskState.studentNotFound:
        return const KioskReadingCardScreen();
      case KioskState.studentRecognised:
        return const KioskStudentRecognisedScreen();
      case KioskState.readyToScan:
      case KioskState.capturingImage:
        return const KioskScanScreen();
      case KioskState.analysingImage:
      case KioskState.classificationReady:
        return const KioskAnalysisScreen();
      case KioskState.waitingForStudentAnswer:
      case KioskState.processingAnswer:
        return const KioskQuizScreen();
      case KioskState.correctFeedback:
        return const KioskCorrectScreen();
      case KioskState.incorrectFeedback:
        return const KioskIncorrectScreen();
      case KioskState.lowConfidenceFeedback:
        return const KioskLowConfidenceScreen();
      case KioskState.openingSlot:
      case KioskState.waitingForWasteDrop:
      case KioskState.rewardSummary:
      case KioskState.sessionComplete:
        return const KioskRewardSummaryScreen();
      case KioskState.houseLeaderboard:
        return const KioskLeaderboardScreen();
      case KioskState.guardianEvolution:
        return const KioskGuardianEvolutionScreen();
      case KioskState.maintenance:
      case KioskState.error:
        return const KioskMaintenanceScreen();
    }
  }
}

class _ExitKioskIntent extends Intent {
  const _ExitKioskIntent();
}
