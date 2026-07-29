import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/enums/app_enums.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../widgets/kiosk_widgets.dart';
import '../../../../shared/world/guardian_emotion.dart';
import '../../../../shared/world/guardian_mascot.dart';

/// SCREEN 7 — Correct result. Positive green feedback + rewards + fact + slot.
class KioskCorrectScreen extends ConsumerWidget {
  const KioskCorrectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final outcome = session.lastOutcome;
    final student = session.student;
    if (outcome == null || student == null) {
      return const LoadingView();
    }
    return _FeedbackLayout(
      accent: AppColors.success,
      accentSurface: AppColors.successSurface,
      icon: Icons.celebration,
      title: 'Great job, ${student.firstName}! 🎉',
      subtitle: 'You sorted it right.',
      guardianEmotion: GuardianEmotion.correct,
      correctCategory: outcome.correctCategory,
      selectedCategory: outcome.selected,
      showSelectedWrong: false,
      rewardBadges: [
        _Reward(
          '+${outcome.pointsAwarded}',
          'Eco Points',
          Icons.monetization_on,
          AppColors.coinGoldDark,
        ),
        _Reward('+${outcome.xpAwarded}', 'XP', Icons.star, AppColors.xpPurple),
        _Reward(
          '+${outcome.housePoints}',
          'House',
          Icons.groups,
          AppColors.primary,
        ),
      ],
      bonusApplied: outcome.bonusApplied,
      bonusPoints: outcome.bonusPoints,
      dailyCapReached: outcome.dailyCapReached,
      fact: session.classification?.educationalFact ?? '',
      hardwareCommandStatus: session.hardwareCommandStatus,
      onContinue: controller.openSlotAndContinue,
      streak: outcome.newStreak,
    );
  }
}

/// SCREEN 8 — Incorrect result. Supportive, no points removed, explains why.
class KioskIncorrectScreen extends ConsumerWidget {
  const KioskIncorrectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final outcome = session.lastOutcome;
    final student = session.student;
    if (outcome == null || student == null) {
      return const LoadingView();
    }
    return _FeedbackLayout(
      accent: AppColors.info,
      accentSurface: const Color(0xFFE7F0FB),
      icon: Icons.emoji_objects_outlined,
      title: 'Good try, ${student.firstName}!',
      subtitle: "Let's learn where it really goes.",
      guardianEmotion: GuardianEmotion.tryAgain,
      correctCategory: outcome.correctCategory,
      selectedCategory: outcome.selected,
      showSelectedWrong: true,
      rewardBadges: const [],
      noPointsMessage:
          'No points this time — and none taken away. '
          'Every try helps you learn!',
      fact: session.classification?.explanation ?? '',
      hardwareCommandStatus: session.hardwareCommandStatus,
      onContinue: controller.openSlotAndContinue,
      streak: outcome.newStreak,
    );
  }
}

/// SCREEN 9 — Low-confidence result. Routes to General Waste (safe default).
class KioskLowConfidenceScreen extends ConsumerWidget {
  const KioskLowConfidenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final outcome = session.lastOutcome;
    final student = session.student;
    final classification = session.classification;
    if (outcome == null || student == null || classification == null) {
      return const LoadingView();
    }
    final gotItRight = outcome.wasCorrect;
    return _FeedbackLayout(
      accent: AppColors.warning,
      accentSurface: AppColors.warningSurface,
      icon: Icons.help_outline,
      title: gotItRight
          ? 'Nice — you played it safe!'
          : "Let's use General Waste",
      subtitle: 'When I\'m not sure, General Waste keeps recycling clean.',
      guardianEmotion: gotItRight
          ? GuardianEmotion.correct
          : GuardianEmotion.tryAgain,
      correctCategory: WasteCategory.general,
      selectedCategory: outcome.selected,
      showSelectedWrong: !gotItRight,
      rewardBadges: gotItRight
          ? [
              _Reward(
                '+${outcome.pointsAwarded}',
                'Eco Points',
                Icons.monetization_on,
                AppColors.coinGoldDark,
              ),
              _Reward(
                '+${outcome.xpAwarded}',
                'XP',
                Icons.star,
                AppColors.xpPurple,
              ),
            ]
          : const [],
      lowConfidenceMessage:
          "I'm only ${classification.confidencePercent}% sure what this item "
          "is. To avoid contaminating recyclable materials, please use "
          "General Waste.",
      fact: classification.educationalFact,
      hardwareCommandStatus: session.hardwareCommandStatus,
      onContinue: controller.openSlotAndContinue,
      streak: outcome.newStreak,
      confidence: classification.confidence,
      threshold: session.config.aiConfidenceThreshold,
    );
  }
}

// -----------------------------------------------------------------------------
// Shared feedback layout
// -----------------------------------------------------------------------------

class _Reward {
  const _Reward(this.value, this.label, this.icon, this.colour);
  final String value;
  final String label;
  final IconData icon;
  final Color colour;
}

class _FeedbackLayout extends StatelessWidget {
  const _FeedbackLayout({
    required this.accent,
    required this.accentSurface,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.guardianEmotion,
    required this.correctCategory,
    required this.selectedCategory,
    required this.showSelectedWrong,
    required this.rewardBadges,
    required this.fact,
    required this.hardwareCommandStatus,
    required this.onContinue,
    required this.streak,
    this.noPointsMessage,
    this.lowConfidenceMessage,
    this.bonusApplied = false,
    this.bonusPoints = 0,
    this.dailyCapReached = false,
    this.confidence,
    this.threshold,
  });

  final Color accent;
  final Color accentSurface;
  final IconData icon;
  final String title;
  final String subtitle;

  /// Which face the Guardian wears for this outcome.
  final GuardianEmotion guardianEmotion;
  final WasteCategory correctCategory;
  final WasteCategory selectedCategory;
  final bool showSelectedWrong;
  final List<_Reward> rewardBadges;
  final String fact;
  final HardwareCommandStatus hardwareCommandStatus;
  final VoidCallback onContinue;
  final int streak;
  final String? noPointsMessage;
  final String? lowConfidenceMessage;
  final bool bonusApplied;
  final int bonusPoints;
  final bool dailyCapReached;
  final double? confidence;
  final double? threshold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 4, 48, 20),
      child: Row(
        children: [
          // Left: guardian + headline.
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 220,
                  child: GuardianPortrait(size: 220, emotion: guardianEmotion),
                ),
                const SizedBox(height: 8),
                Icon(icon, color: accent, size: 40),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: accent),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 28),
          // Right: bin outcome, rewards, fact, continue.
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BinOutcomeRow(
                    correct: correctCategory,
                    selected: selectedCategory,
                    showSelectedWrong: showSelectedWrong,
                  ),
                  const SizedBox(height: 16),
                  if (confidence != null && threshold != null) ...[
                    Center(
                      child: ConfidenceMeter(
                        confidence: confidence!,
                        threshold: threshold!,
                        width: 360,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (rewardBadges.isNotEmpty) ...[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [for (final r in rewardBadges) _RewardBadge(r)],
                    ),
                    if (bonusApplied)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _BannerNote(
                          icon: Icons.bolt,
                          colour: AppColors.xpPurple,
                          text:
                              'Streak bonus! +$bonusPoints extra points for a '
                              'great run of correct recycles!',
                        ),
                      ),
                    if (dailyCapReached)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _BannerNote(
                          icon: Icons.emoji_events_outlined,
                          colour: AppColors.coinGoldDark,
                          text:
                              "You've reached today's points cap — keep "
                              'recycling, it still counts for your house!',
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                  if (noPointsMessage != null)
                    _BannerNote(
                      icon: Icons.volunteer_activism,
                      colour: AppColors.info,
                      text: noPointsMessage!,
                    ),
                  if (lowConfidenceMessage != null)
                    _BannerNote(
                      icon: Icons.info_outline,
                      colour: AppColors.warning,
                      text: lowConfidenceMessage!,
                    ),
                  const SizedBox(height: 16),
                  if (fact.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              fact,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.4,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  _SlotCommandStatus(
                    status: hardwareCommandStatus,
                    category: correctCategory,
                  ),
                  const SizedBox(height: 16),
                  KioskButton(
                    label: 'Open ${correctCategory.label} & Continue',
                    icon: Icons.open_in_full,
                    expand: true,
                    onPressed: onContinue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BinOutcomeRow extends StatelessWidget {
  const _BinOutcomeRow({
    required this.correct,
    required this.selected,
    required this.showSelectedWrong,
  });

  final WasteCategory correct;
  final WasteCategory selected;
  final bool showSelectedWrong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showSelectedWrong && selected != correct) ...[
          Expanded(
            child: _BinChip(
              category: selected,
              state: WasteButtonState.wrong,
              caption: 'You chose',
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward, color: AppColors.inkFaint),
          ),
        ],
        Expanded(
          child: _BinChip(
            category: correct,
            state: WasteButtonState.correct,
            caption: showSelectedWrong ? 'Correct bin' : 'Goes in',
          ),
        ),
      ],
    );
  }
}

class _BinChip extends StatelessWidget {
  const _BinChip({
    required this.category,
    required this.state,
    required this.caption,
  });

  final WasteCategory category;
  final WasteButtonState state;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final isCorrect = state == WasteButtonState.correct;
    final colour = isCorrect ? AppColors.success : AppColors.error;
    final surface = isCorrect
        ? AppColors.successSurface
        : AppColors.errorSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colour, width: 2),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.colour.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: category.colour, size: 26),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                caption,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colour,
                ),
              ),
              Text(
                category.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(isCorrect ? Icons.check_circle : Icons.cancel, color: colour),
        ],
      ),
    );
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge(this.reward);
  final _Reward reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: reward.colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: reward.colour.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(reward.icon, color: reward.colour, size: 26),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reward.value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: reward.colour,
                  height: 1,
                ),
              ),
              Text(
                reward.label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerNote extends StatelessWidget {
  const _BannerNote({
    required this.icon,
    required this.colour,
    required this.text,
  });
  final IconData icon;
  final Color colour;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colour, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                height: 1.35,
                color: colour == AppColors.warning
                    ? AppColors.warning
                    : AppColors.ink,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows the logical open-slot command status sent to the existing controller.
class _SlotCommandStatus extends StatelessWidget {
  const _SlotCommandStatus({required this.status, required this.category});
  final HardwareCommandStatus status;
  final WasteCategory category;

  @override
  Widget build(BuildContext context) {
    final (icon, colour, label) = switch (status) {
      HardwareCommandStatus.acknowledged => (
        Icons.check_circle,
        AppColors.success,
        'Bin opened — ${category.label} slot is ready',
      ),
      HardwareCommandStatus.sent || HardwareCommandStatus.pending => (
        Icons.sync,
        AppColors.info,
        'Sending open command to the bin…',
      ),
      HardwareCommandStatus.failed => (
        Icons.error_outline,
        AppColors.error,
        'Could not reach the bin controller',
      ),
      HardwareCommandStatus.skippedOffline => (
        Icons.cloud_off,
        AppColors.warning,
        'Offline — the bin will open locally',
      ),
    };
    return Row(
      children: [
        Icon(icon, size: 18, color: colour),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colour,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
