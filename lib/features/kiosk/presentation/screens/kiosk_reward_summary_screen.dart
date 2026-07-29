import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../../../../shared/world/guardian_emotion.dart';
import '../../../../shared/world/guardian_mascot.dart';

/// SCREEN 10 — Reward summary (+ session complete countdown).
///
/// Recaps XP, updated points, house contribution, streak, avatar progression
/// and weekly challenge. Offers "recycle another", leaderboard, guardian, and
/// Finish (which starts an auto-logout countdown that clears the session).
class KioskRewardSummaryScreen extends ConsumerWidget {
  const KioskRewardSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final student = session.student;
    final outcome = session.lastOutcome;
    final house = session.house;
    if (student == null || outcome == null) {
      return const LoadingView();
    }

    final finishing = session.state == KioskState.sessionComplete;

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 24),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  finishing
                      ? 'See you soon! 👋'
                      : 'Nice work, ${student.firstName}!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  finishing
                      ? 'Your progress is saved. Signing you out to keep your account private.'
                      : "Here's what you earned this session.",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: AppColors.inkMuted),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _SummaryStat(
                      icon: Icons.star_rounded,
                      value: '${student.totalXp}',
                      delta: outcome.xpAwarded > 0
                          ? '+${outcome.xpAwarded}'
                          : null,
                      label: 'Total XP',
                      accent: AppColors.xpPurple,
                      surface: AppColors.xpPurpleSurface,
                    ),
                    _SummaryStat(
                      icon: Icons.monetization_on_rounded,
                      value: '${student.availablePoints}',
                      delta: outcome.totalPoints > 0
                          ? '+${outcome.totalPoints}'
                          : null,
                      label: 'Eco Points',
                      accent: AppColors.coinGoldDark,
                      surface: AppColors.coinGoldSurface,
                    ),
                    _SummaryStat(
                      icon: Icons.local_fire_department_rounded,
                      value: '${outcome.newStreak}',
                      label: 'Day Streak',
                      accent: AppColors.error,
                      surface: AppColors.errorSurface,
                    ),
                    _SummaryStat(
                      icon: Icons.groups_rounded,
                      value: house?.name ?? '—',
                      delta: outcome.housePoints > 0
                          ? '+${outcome.housePoints}'
                          : null,
                      label: 'House points',
                      accent: AppColors.primary,
                      surface: AppColors.primarySurface,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (house != null) _WeeklyChallengeCard(house: house),
                const SizedBox(height: 24),
                if (finishing)
                  _LogoutCountdown(
                    seconds: session.logoutCountdown,
                    onNow: () => controller.endSession(),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      KioskButton(
                        label: 'Recycle Another',
                        icon: Icons.add,
                        onPressed: controller.recycleAnother,
                      ),
                      KioskButton(
                        label: 'Leaderboard',
                        icon: Icons.leaderboard,
                        filled: false,
                        onPressed: controller.viewLeaderboard,
                      ),
                      KioskButton(
                        label: 'My Guardian',
                        icon: Icons.pets,
                        filled: false,
                        onPressed: controller.viewGuardianEvolution,
                      ),
                      KioskButton(
                        label: 'Finish',
                        icon: Icons.check,
                        color: AppColors.inkMuted,
                        filled: false,
                        onPressed: controller.finishSession,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GuardianPortrait(
                  size: 300,
                  emotion: outcome.stageChanged
                      ? GuardianEmotion.levelUp
                      : GuardianEmotion.correct,
                ),
                if (outcome.stageChanged && outcome.newStage != null)
                  _EvolutionBanner(title: outcome.newStage!.title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    required this.surface,
    this.delta,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;
  final Color surface;
  final String? delta;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (delta != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        delta!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: accent,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w600,
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

class _WeeklyChallengeCard extends StatelessWidget {
  const _WeeklyChallengeCard({required this.house});
  final dynamic house;

  @override
  Widget build(BuildContext context) {
    final progress = (house.goalProgress as double).clamp(0.0, 1.0);
    final colour = AppColors.fromHex(house.colour as String);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_rounded, color: colour, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Weekly challenge · ${house.name} House',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(fontWeight: FontWeight.w800, color: colour),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            house.sustainabilityGoal as String,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(colour),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvolutionBanner extends StatelessWidget {
  const _EvolutionBanner({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.xpPurple, AppColors.xpPurpleDark],
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            'Guardian evolved to $title!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutCountdown extends StatelessWidget {
  const _LogoutCountdown({required this.seconds, required this.onNow});
  final int seconds;
  final VoidCallback onNow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 46,
          height: 46,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              Text(
                '$seconds',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Signing out to protect your account…',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(width: 16),
        OutlinedButton(onPressed: onNow, child: const Text('Sign out now')),
      ],
    );
  }
}
