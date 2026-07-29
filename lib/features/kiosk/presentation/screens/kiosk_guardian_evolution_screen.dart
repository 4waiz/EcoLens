import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/models/models.dart';
import '../../../../shared/painters/guardian_painter.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../../../../shared/world/guardian_emotion.dart';
import '../../../../shared/world/guardian_mascot.dart';

/// SCREEN 12 — Guardian evolution.
///
/// Shows the five environmental stages (Seedling → Sprout → Eco Guardian →
/// Forest Protector → Thriving Ecosystem), the current stage, progress to next,
/// locked stages, environmental meaning, and unlocked accessories.
class KioskGuardianEvolutionScreen extends ConsumerWidget {
  const KioskGuardianEvolutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final avatar = session.avatar;
    final ladder = session.evolutionLadder;
    final student = session.student;
    if (avatar == null || student == null || ladder.isEmpty) {
      return const LoadingView();
    }

    final currentStage = ladder.firstWhere(
      (s) => s.stageIndex == avatar.stage,
      orElse: () => ladder.first,
    );
    final nextStage = ladder
        .where((s) => s.stageIndex == avatar.stage + 1)
        .cast<AvatarEvolutionStage?>()
        .firstWhere((_) => true, orElse: () => null);

    final progressToNext = nextStage == null
        ? 1.0
        : ((student.totalXp - currentStage.minimumXp) /
                  (nextStage.minimumXp - currentStage.minimumXp))
              .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.pets, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                '${avatar.name} · Your Guardian',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              KioskButton(
                label: 'Return',
                icon: Icons.arrow_back,
                filled: false,
                onPressed: controller.backFromSubScreen,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current guardian + progress.
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Expanded(
                        child: GuardianPortrait(
                          size: 260,
                          emotion: GuardianEmotion.welcome,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stage: ${currentStage.title}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentStage.environmentalMeaning,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            if (nextStage != null) ...[
                              Row(
                                children: [
                                  Text(
                                    'To ${nextStage.title}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelMedium,
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${student.totalXp} / ${nextStage.minimumXp} XP',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: LinearProgressIndicator(
                                  value: progressToNext,
                                  minHeight: 10,
                                  backgroundColor: AppColors.border,
                                  color: AppColors.primary,
                                ),
                              ),
                            ] else
                              const Text(
                                'Maximum stage reached — amazing! 🌳',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Evolution ladder + accessories.
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Evolution journey',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.separated(
                          itemCount: ladder.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final stage = ladder[i];
                            final unlocked = avatar.stage >= stage.stageIndex;
                            final isCurrent = avatar.stage == stage.stageIndex;
                            return _StageCard(
                              stage: stage,
                              unlocked: unlocked,
                              isCurrent: isCurrent,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      _AccessoriesRow(unlocked: avatar.unlockedAccessories),
                    ],
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

class _StageCard extends StatelessWidget {
  const _StageCard({
    required this.stage,
    required this.unlocked,
    required this.isCurrent,
  });

  final AvatarEvolutionStage stage;
  final bool unlocked;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.primarySurface : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.border,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: unlocked
                ? CustomPaint(
                    painter: GuardianPainter(
                      stage: stage.stageIndex,
                      showPodium: false,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      color: AppColors.inkFaint,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      stage.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: unlocked ? AppColors.ink : AppColors.inkFaint,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'You are here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  stage.environmentalMeaning,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${stage.minimumXp} XP',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: unlocked ? AppColors.primary : AppColors.inkFaint,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessoriesRow extends StatelessWidget {
  const _AccessoriesRow({required this.unlocked});
  final List<String> unlocked;

  static const _icons = {
    'leaf-hat': Icons.park,
    'eco-glasses': Icons.visibility,
    'flower-crown': Icons.local_florist,
    'eco-wings': Icons.flutter_dash,
    'sprout-antenna': Icons.grass,
    'recycled-backpack': Icons.backpack,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.checkroom, color: AppColors.xpPurple, size: 20),
          const SizedBox(width: 8),
          Text('Unlocked:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: 12),
          if (unlocked.isEmpty)
            Text(
              'Earn points to unlock accessories!',
              style: Theme.of(context).textTheme.bodySmall,
            )
          else
            Expanded(
              child: Wrap(
                spacing: 8,
                children: [
                  for (final a in unlocked)
                    Chip(
                      avatar: Icon(
                        _icons[a] ?? Icons.star,
                        size: 16,
                        color: AppColors.xpPurple,
                      ),
                      label: Text(_prettify(a)),
                      backgroundColor: AppColors.xpPurpleSurface,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _prettify(String key) => key
      .split('-')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}
