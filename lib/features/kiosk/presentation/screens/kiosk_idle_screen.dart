import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/mock/mock_seed_data.dart';
import '../../../../shared/components/game_ui.dart';
import '../../../../shared/painters/valley_painters.dart';
import '../../application/kiosk_controller.dart';
import '../../application/kiosk_preferences.dart';
import '../widgets/student_mission_panel.dart';
import '../widgets/valley_chrome.dart';

/// SCREEN 1 — Idle / attract: the entrance to **Guardian Valley**.
///
/// The Guardian greets the valley and invites the student to tap their PHYSICAL
/// Student ID card. No phone imagery anywhere, and — critically — no trace of
/// the previous student: the left panel shows the card and the house rules, not
/// anybody's stats. Personal data only appears after a card is read.
class KioskIdleScreen extends ConsumerWidget {
  const KioskIdleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = context.gameScale;
    final prefs = ref.watch(kioskPreferencesProvider);
    final session = ref.watch(kioskControllerProvider);
    final animate = !prefs.reduceMotion;

    // One phase drives the whole attract screen: the Student ID panel, the
    // Guardian's mood and what she says. It is derived from the real kiosk FSM
    // — the panel owns none of the scanning logic.
    final phase = StudentScanPhase.fromKiosk(session);
    final firstName = phase.revealsStudent ? session.student?.firstName : null;

    // Demo convenience: in mock/demo builds, tapping the card (or the prompt)
    // simulates tapping Liam's physical Student ID card so the flow can be
    // walked without the hardware simulator. On a real kiosk the physical
    // NFC/RFID reader drives this instead.
    void simulateTap() {
      ref.read(kioskPreferencesProvider.notifier).click();
      final controller = ref.read(kioskControllerProvider.notifier);
      // A card that failed to read is retried through the existing FSM path.
      if (phase == StudentScanPhase.invalidCard) {
        controller.retryCard();
        return;
      }
      if (AppConfig.useMockServices) {
        controller.readCard(MockSeedData.liamCardUid);
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(18 * s, 10 * s, 18 * s, 14 * s),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Left: start your eco mission (physical card) --------
                Expanded(
                  flex: 26,
                  child: StudentMissionPanel(
                    phase: phase,
                    studentFirstName: firstName,
                    animate: animate,
                    onTapCard: simulateTap,
                  ),
                ),
                SizedBox(width: 14 * s),

                // ---- Centre: the Guardian on the valley dais -------------
                Expanded(
                  flex: 48,
                  child: _CentreStage(animate: animate, onTapCard: simulateTap),
                ),
                SizedBox(width: 14 * s),

                // ---- Right: what the whole school has achieved -----------
                const Expanded(
                  flex: 26,
                  child: ValleyImpactPanel(
                    rankings: [
                      ValleyRanking(
                        name: 'Taurus House',
                        points: 4850,
                        colour: AppColors.houseTaurus,
                      ),
                      ValleyRanking(
                        name: 'Leo House',
                        points: 4310,
                        colour: AppColors.houseLeo,
                      ),
                      ValleyRanking(
                        name: 'Aquarius House',
                        points: 3980,
                        colour: AppColors.houseAquarius,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12 * s),

          // ---- Bottom: the four world portals -------------------------
          const WorldPortalRow(
            caption: 'EVERY ITEM HAS ITS OWN PORTAL — WE SORT THEM TOGETHER',
          ),
        ],
      ),
    );
  }
}

/// Centre column. The Guardian and its speech bubble are drawn in the *world*
/// layer (see [KioskChrome]), so this only reserves their space and carries the
/// call to action beneath them.
class _CentreStage extends StatelessWidget {
  const _CentreStage({required this.animate, required this.onTapCard});

  final bool animate;
  final VoidCallback onTapCard;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Column(
      children: [
        // Space occupied by the Guardian standing on the painted dais.
        const Expanded(child: SizedBox.expand()),
        SizedBox(height: 10 * s),
        _TapCardButton(onTap: onTapCard),
      ],
    );
  }
}

/// The primary call to action — deliberately card-shaped language and imagery,
/// never a phone or a QR code.
class _TapCardButton extends StatefulWidget {
  const _TapCardButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_TapCardButton> createState() => _TapCardButtonState();
}

class _TapCardButtonState extends State<_TapCardButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return Semantics(
      button: true,
      label: 'Tap your Student ID card to begin',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final glow = 0.35 + _pulse.value * 0.45;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22 * s),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: glow * 0.6),
                      blurRadius: (18 + _pulse.value * 16) * s,
                      offset: Offset(0, 6 * s),
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24 * s,
                vertical: 14 * s,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.heroGreenGradient,
                ),
                borderRadius: BorderRadius.circular(22 * s),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2.5 * s,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.contactless_outlined,
                    color: Colors.white,
                    size: 26 * s,
                  ),
                  SizedBox(width: 12 * s),
                  Flexible(
                    child: Text(
                      'Tap your Student ID card to begin',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 19 * s,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: ValleyPalette.forestDark.withValues(
                              alpha: 0.45,
                            ),
                            blurRadius: 4 * s,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
