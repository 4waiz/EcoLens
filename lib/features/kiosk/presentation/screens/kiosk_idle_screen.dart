import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/mock/mock_seed_data.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../../../shared/components/guardian_avatar.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/student_card_illustration.dart';

/// SCREEN 1 — Idle / attract.
///
/// Invites the student to tap their PHYSICAL Student ID card. No phone imagery
/// anywhere. Shows the Guardian, the card illustration with an NFC pulse, the
/// four waste categories, and a school-wide environmental impact strip. No
/// previous student details are ever shown here (privacy).
class KioskIdleScreen extends ConsumerWidget {
  const KioskIdleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Demo convenience: in mock/demo builds, tapping the card (or the prompt)
    // simulates tapping Liam's physical Student ID card so the flow can be
    // walked without the hardware simulator. On a real kiosk the physical
    // NFC/RFID reader drives this instead.
    void simulateTap() {
      if (AppConfig.useMockServices) {
        ref
            .read(kioskControllerProvider.notifier)
            .readCard(MockSeedData.liamCardUid);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 32),
      child: Row(
        children: [
          // Left: welcome + card prompt.
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to EcoLens',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Recycle right, earn rewards, grow your Guardian.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.inkMuted,
                      ),
                ),
                const SizedBox(height: 36),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: simulateTap,
                    child: const StudentCardIllustration(),
                  ),
                ),
                const SizedBox(height: 28),
                Semantics(
                  button: true,
                  label: 'Tap your Student ID card to begin',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: simulateTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 18),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.contactless_outlined,
                                color: Colors.white, size: 30),
                            SizedBox(width: 14),
                            Text(
                              'Tap your Student ID card to begin',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const _CategoryStrip(),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right: Guardian + school impact.
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: Center(
                    child: GuardianAvatar(stage: 2, size: 300, glowing: true),
                  ),
                ),
                const _SchoolImpactCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final c in WasteCategory.values) _CategoryDot(category: c),
      ],
    );
  }
}

class _CategoryDot extends StatelessWidget {
  const _CategoryDot({required this.category});
  final WasteCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, color: category.colour, size: 20),
          const SizedBox(width: 8),
          Text(
            category.label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolImpactCard extends StatelessWidget {
  const _SchoolImpactCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                "Today's school-wide impact",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                child: _ImpactStat(
                  value: '312',
                  label: 'Items recycled',
                  icon: Icons.recycling,
                  colour: AppColors.primary,
                ),
              ),
              Expanded(
                child: _ImpactStat(
                  value: '48 kg',
                  label: 'CO₂ saved',
                  icon: Icons.cloud_outlined,
                  colour: AppColors.info,
                ),
              ),
              Expanded(
                child: _ImpactStat(
                  value: '86%',
                  label: 'Recycled right',
                  icon: Icons.verified_outlined,
                  colour: AppColors.coinGoldDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  const _ImpactStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.colour,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: colour, size: 26),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: colour,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
        ),
      ],
    );
  }
}
