import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../widgets/kiosk_widgets.dart';
import '../widgets/student_card_illustration.dart';

/// SCREEN 2 — Reading Student ID card (+ not-found handling).
///
/// Shows a card-reading animation with "Reading your Student ID…". When a card
/// does not resolve to a student, presents a friendly not-found state with a
/// Try Again action. Card-reader-unavailable errors surface here too.
class KioskReadingCardScreen extends ConsumerWidget {
  const KioskReadingCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final notFound = session.state == KioskState.studentNotFound;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (notFound) ...[
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.warningSurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.credit_card_off,
                    size: 46, color: AppColors.warning),
              ),
              const SizedBox(height: 24),
              Text(
                "Hmm, I don't recognise that card",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                session.errorMessage ??
                    'Please try again, or ask a teacher for help.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.inkMuted,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              KioskButton(
                label: 'Try Again',
                icon: Icons.refresh,
                onPressed: controller.retryCard,
              ),
            ] else ...[
              const StudentCardIllustration(),
              const SizedBox(height: 40),
              const SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Reading your Student ID…',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your card on the reader for a moment.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              const GuardianSpeech(
                text: "Hold tight — I'm looking you up!",
              ),
            ],
          ],
        ),
      ),
    );
  }
}
