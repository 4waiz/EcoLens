import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/camera_frame.dart';
import '../widgets/kiosk_widgets.dart';
import '../../../../shared/components/guardian_avatar.dart';

/// SCREEN 6 — Category quiz.
///
/// The active-learning mini-quiz: the student decides which bin the item goes
/// into. Shows the captured item + detected name + AI confidence, then four
/// LARGE touch targets. Double submission is prevented (buttons disable during
/// processing). Includes an accessibility audio button.
class KioskQuizScreen extends ConsumerWidget {
  const KioskQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final classification = session.classification;
    final processing = session.state == KioskState.processingAnswer;

    if (classification == null) {
      return const LoadingView(message: 'Preparing your question…');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 4, 48, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: the item + AI read-out.
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 240,
                  child: CameraFrame(
                    itemLabel: classification.detectedObjectName,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'I see a ${classification.detectedObjectName}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ConfidenceMeter(
                  confidence: classification.confidence,
                  threshold: session.config.aiConfidenceThreshold,
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right: the question + four bins.
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 72,
                      height: 72,
                      child: GuardianAvatar(stage: 1, size: 72, bob: false),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Which bin should it go into?',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Read the question aloud',
                      onPressed: () => _announce(context, classification),
                      icon: const Icon(Icons.volume_up),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap the bin you think is correct — this helps you learn!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    for (final c in WasteCategory.values)
                      WasteCategoryButton(
                        category: c,
                        enabled: !processing,
                        onTap: () => controller.submitAnswer(c),
                      ),
                  ],
                ),
                if (processing) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text('Checking your answer…'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _announce(BuildContext context, classification) {
    // Accessibility hook: in production, route to TTS. For the MVP we surface
    // the prompt via a snackbar and a screen-reader announcement.
    final message =
        'Which bin should the ${classification.detectedObjectName} go into? '
        'Choose plastic, paper, organic, or general waste.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
