import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/components/game_ui.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../widgets/valley_chrome.dart';

/// SCREEN 3 — Student recognised.
///
/// The valley now knows who is standing there. The Guardian greets the student
/// by FIRST NAME only, the left panel fills in with their game profile, and the
/// impact panel shows their personal contribution to the school goal. The full
/// Student ID number is never displayed on this shared screen.
class KioskStudentRecognisedScreen extends ConsumerWidget {
  const KioskStudentRecognisedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = context.gameScale;
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final student = session.student;
    final house = session.house;
    final avatar = session.avatar;

    if (student == null) {
      return const LoadingView(message: 'Loading your profile…');
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(18 * s, 10 * s, 18 * s, 14 * s),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Left: the student's game profile --------------------
                Expanded(
                  flex: 26,
                  child: StudentValleyPanel(
                    student: student,
                    config: session.config,
                    avatar: avatar,
                    house: house,
                  ),
                ),
                SizedBox(width: 14 * s),

                // ---- Centre: the Guardian welcomes them back -------------
                Expanded(
                  flex: 48,
                  child: Column(
                    children: [
                      // The Guardian and its speech bubble are staged in the
                      // world layer; this column only reserves their space.
                      const Expanded(child: SizedBox.expand()),
                      SizedBox(height: 10 * s),
                      _ActionBar(
                        onScan: controller.goToScan,
                        onGuardian: controller.viewGuardianEvolution,
                        onLeaderboard: controller.viewLeaderboard,
                        onEnd: controller.endSession,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 14 * s),

                // ---- Right: impact + this student's contribution ---------
                Expanded(
                  flex: 26,
                  child: ValleyImpactPanel(
                    studentContribution:
                        "You've sorted ${student.correctRecyclingCount} items "
                        'correctly — thank you!',
                    rankings: [
                      const ValleyRanking(
                        name: 'Taurus House',
                        points: 4850,
                        colour: AppColors.houseTaurus,
                      ),
                      const ValleyRanking(
                        name: 'Leo House',
                        points: 4310,
                        colour: AppColors.houseLeo,
                      ),
                      ValleyRanking(
                        name: 'Class ${student.className}',
                        points: student.totalXp * 3,
                        colour: AppColors.primary,
                        isMine: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12 * s),
          const WorldPortalRow(
            caption: 'FOUR PORTALS, ONE PLANET — SHOW ME AN ITEM AND PICK ONE',
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.onScan,
    required this.onGuardian,
    required this.onLeaderboard,
    required this.onEnd,
  });

  final VoidCallback onScan;
  final VoidCallback onGuardian;
  final VoidCallback onLeaderboard;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10 * s,
          runSpacing: 8 * s,
          children: [
            KioskButton(
              label: 'Scan My Item',
              icon: Icons.center_focus_strong,
              onPressed: onScan,
            ),
            KioskButton(
              label: 'My Guardian',
              icon: Icons.pets,
              filled: false,
              onPressed: onGuardian,
            ),
            KioskButton(
              label: 'Leaderboard',
              icon: Icons.leaderboard,
              filled: false,
              onPressed: onLeaderboard,
            ),
          ],
        ),
        SizedBox(height: 4 * s),
        TextButton.icon(
          onPressed: onEnd,
          icon: Icon(Icons.logout, size: 16 * s),
          label: Text(
            'End Session',
            style: TextStyle(fontSize: 13 * s, fontWeight: FontWeight.w700),
          ),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black.withValues(alpha: 0.28),
            padding: EdgeInsets.symmetric(horizontal: 14 * s, vertical: 6 * s),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ],
    );
  }
}
