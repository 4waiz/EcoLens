import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/models/models.dart';
import '../../../../shared/components/guardian_avatar.dart';
import '../../../../shared/components/house_badge.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../widgets/kiosk_widgets.dart';

/// SCREEN 3 — Student recognised.
///
/// Greets the student by FIRST NAME only, shows grade/class/house, avatar, and
/// XP / points / streak. Offers "Scan My Item" and "End Session". Never shows
/// the full Student ID number.
class KioskStudentRecognisedScreen extends ConsumerWidget {
  const KioskStudentRecognisedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final student = session.student;
    final house = session.house;
    final avatar = session.avatar;

    if (student == null) {
      return const LoadingView(message: 'Loading your profile…');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 32),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi ${student.firstName}!',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(color: AppColors.primaryDark),
                    ),
                    const SizedBox(width: 12),
                    const Text('🌿', style: TextStyle(fontSize: 40)),
                  ],
                ),
                Text(
                  'Welcome back!',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(color: AppColors.ink),
                ),
                const SizedBox(height: 4),
                Text(
                  house != null
                      ? 'Ready to recycle and help ${house.name} House?'
                      : 'Ready to recycle?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                ),
                const SizedBox(height: 24),
                KioskStudentStatsRow(
                  student: student,
                  avatarLevel: avatar?.level,
                ),
                const SizedBox(height: 16),
                if (house != null)
                  _HouseRankBar(house: house),
                const SizedBox(height: 24),
                Row(
                  children: [
                    KioskButton(
                      label: 'Scan My Item',
                      icon: Icons.qr_code_scanner,
                      onPressed: controller.goToScan,
                    ),
                    const SizedBox(width: 14),
                    KioskButton(
                      label: 'My Guardian',
                      icon: Icons.pets,
                      filled: false,
                      onPressed: controller.viewGuardianEvolution,
                    ),
                    const SizedBox(width: 14),
                    KioskButton(
                      label: 'Leaderboard',
                      icon: Icons.leaderboard,
                      filled: false,
                      onPressed: controller.viewLeaderboard,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextButton.icon(
                  onPressed: () => controller.endSession(),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('End Session'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Center(
              child: GuardianAvatar(
                stage: avatar?.stage ?? 1,
                size: 320,
                glowing: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

/// A prominent house context bar (emblem + "Taurus House · Rank N") matching
/// the reference welcome-screen design.
class _HouseRankBar extends StatelessWidget {
  const _HouseRankBar({required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(house.colour);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          HouseBadge(emblem: house.emblem, colourHex: house.colour, size: 44),
          const SizedBox(width: 14),
          Text(
            '${house.name} House',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: AppColors.ink),
          ),
          const SizedBox(width: 10),
          Icon(Icons.circle, size: 6, color: colour),
          const SizedBox(width: 10),
          Text(
            'Rank ${house.leaderboardPosition}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colour,
            ),
          ),
          const Spacer(),
          Icon(Icons.emoji_events_outlined, color: colour, size: 26),
        ],
      ),
    );
  }
}
