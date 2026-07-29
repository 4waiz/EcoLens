import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/valley_tokens.dart';
import '../../shared/components/ecolens_logo.dart';
import '../../shared/components/game_ui.dart';
import '../../shared/components/guardian_valley.dart';
import '../../shared/components/valley_ui.dart';
import '../../shared/painters/valley_painters.dart';
import '../../shared/world/guardian_emotion.dart';
import '../../shared/world/guardian_mascot.dart';

/// The front door to Guardian Valley — a map of places you can travel to.
///
/// In a real deployment each device boots straight into ONE surface (a kiosk
/// boots to /kiosk in locked full-screen; staff open a dashboard URL). This
/// picker exists so all four experiences are reachable from one build during
/// development and demos, which makes it the first thing anyone sees — so it is
/// dressed as part of the game rather than as a launcher.
///
/// The four destinations keep the names adults need ("Teacher Dashboard") and
/// gain the action language a child understands ("View Class Quest"). Routing
/// and permissions are unchanged.
///
/// Layout note: every card sizes to its content ([MainAxisSize.min] + capped,
/// ellipsised text) and the whole page scrolls, so the picker cannot overflow at
/// any window size.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GuardianValley(
        child: SafeArea(
          child: GameStage(
            designHeight: 820,
            minScale: 0.62,
            maxScale: 1.15,
            builder: (context, s) => LayoutBuilder(
              builder: (context, viewport) => SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24 * s,
                  vertical: 16 * s,
                ),
                // Vertically centred when it fits, scrollable when it does not.
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: math.max(0, viewport.maxHeight - 32 * s),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1180 * s),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _BrandCapsule(scale: s),
                          SizedBox(height: 14 * s),

                          // The Guardian invites you in. No fixed height — the
                          // row grows with whichever side is taller.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                  // Nudged down so the bubble's tail lands on
                                  // Sprout's head rather than its tail.
                                  padding: EdgeInsets.only(top: 26 * s),
                                  child: GuardianSpeechBubble(
                                    headline: 'Where are we exploring today?',
                                    text:
                                        'Students enter Guardian Valley with '
                                        'their school ID card.',
                                    tail: SpeechTail.right,
                                    theme: ValleyTheme.forest,
                                    maxWidth: 400,
                                    footer: const ValleyBadge(
                                      label: 'No phone needed',
                                      icon: Icons.contactless_outlined,
                                      accent: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10 * s),
                              GuardianPortrait(
                                size: 180 * s,
                                emotion: GuardianEmotion.welcome,
                                semanticLabel: 'The EcoLens Guardian',
                              ),
                            ],
                          ),
                          SizedBox(height: 18 * s),

                          Wrap(
                            spacing: 16 * s,
                            runSpacing: 16 * s,
                            alignment: WrapAlignment.center,
                            children: [
                              ValleyDestinationCard(
                                title: 'Recycling Kiosk',
                                subtitle: 'The student touchscreen on the bin',
                                action: 'Enter Kiosk',
                                icon: Icons.recycling,
                                theme: ValleyTheme.forest,
                                onTap: () => context.go(AppRoutes.kiosk),
                              ),
                              ValleyDestinationCard(
                                title: 'Teacher Dashboard',
                                subtitle: 'Class analytics & learning insights',
                                action: 'View Class Quest',
                                icon: Icons.insights_outlined,
                                theme: ValleyTheme.adventure,
                                onTap: () => context.go(AppRoutes.teacherLogin),
                              ),
                              ValleyDestinationCard(
                                title: 'Admin Dashboard',
                                subtitle: 'Students, devices, rules & rewards',
                                action: 'Manage Valley',
                                icon: Icons.admin_panel_settings_outlined,
                                theme: ValleyTheme.arcane,
                                onTap: () => context.go(AppRoutes.adminLogin),
                              ),
                              ValleyDestinationCard(
                                title: 'Canteen Terminal',
                                subtitle: 'Redeem rewards with the ID card',
                                action: 'Open Reward Shop',
                                icon: Icons.storefront_outlined,
                                theme: ValleyTheme.treasure,
                                onTap: () => context.go(AppRoutes.canteenLogin),
                              ),
                            ],
                          ),
                          SizedBox(height: 18 * s),

                          if (AppConfig.devPanelEnabled)
                            ValleyActionButton(
                              label: 'Developer / Hardware Simulator',
                              icon: Icons.developer_mode,
                              theme: ValleyTheme.tide,
                              filled: false,
                              height: 44,
                              onPressed: () => context.go(AppRoutes.dev),
                            ),
                          SizedBox(height: 10 * s),
                          Text(
                            'EcoLens ${AppConfig.appVersion} · '
                            '${AppConfig.environment.label} mode · '
                            '${AppConfig.worldName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12 * s,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: ValleyPalette.forestDark.withValues(
                                    alpha: 0.75,
                                  ),
                                  blurRadius: 6 * s,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCapsule extends StatelessWidget {
  const _BrandCapsule({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22 * s, vertical: 12 * s),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFDFEFA), Color(0xFFEAF5E9)],
        ),
        borderRadius: BorderRadius.circular(ValleyTokens.radiusPill),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 2.5 * s,
        ),
        boxShadow: ValleyTokens.panelShadow(s),
      ),
      child: EcoLensLogo(height: 46 * s, showTagline: true),
    );
  }
}
