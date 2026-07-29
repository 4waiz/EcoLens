import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/components/ecolens_logo.dart';
import '../../shared/components/game_ui.dart';
import '../../shared/components/guardian_valley.dart';
import '../../shared/painters/valley_painters.dart';
import '../../shared/world/guardian_emotion.dart';
import '../../shared/world/guardian_mascot.dart';

/// A demo launcher that routes into each EcoLens experience.
///
/// In a real deployment each device would boot straight into ONE surface (a
/// kiosk boots to /kiosk in locked full-screen; staff open a dashboard URL).
/// This picker exists purely so all four experiences are reachable from one
/// build during development and demos — so it doubles as the front door to
/// Guardian Valley.
///
/// Layout note: every card sizes to its content ([MainAxisSize.min] + capped,
/// ellipsised text) and the whole page scrolls, so the picker cannot overflow
/// at any window size.
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

                          // The Guardian introduces the valley. No fixed height —
                          // the row grows with whichever side is taller.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: GuardianSpeechBubble(
                                  headline: 'Choose an experience',
                                  text:
                                      'Students are identified only by their '
                                      'physical Student ID card — no phones.',
                                  tail: SpeechTail.right,
                                  maxWidth: 380,
                                ),
                              ),
                              SizedBox(width: 12 * s),
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
                              _ExperienceCard(
                                title: 'Recycling Kiosk',
                                subtitle: 'The student touchscreen on the bin',
                                icon: Icons.recycling,
                                accent: AppColors.primary,
                                onTap: () => context.go(AppRoutes.kiosk),
                              ),
                              _ExperienceCard(
                                title: 'Teacher Dashboard',
                                subtitle: 'Class analytics & learning insights',
                                icon: Icons.insights_outlined,
                                accent: AppColors.info,
                                onTap: () => context.go(AppRoutes.teacherLogin),
                              ),
                              _ExperienceCard(
                                title: 'Admin Dashboard',
                                subtitle: 'Students, devices, rules & rewards',
                                icon: Icons.admin_panel_settings_outlined,
                                accent: AppColors.xpPurple,
                                onTap: () => context.go(AppRoutes.adminLogin),
                              ),
                              _ExperienceCard(
                                title: 'Canteen Terminal',
                                subtitle: 'Redeem rewards with the ID card',
                                icon: Icons.storefront_outlined,
                                accent: AppColors.coinGoldDark,
                                onTap: () => context.go(AppRoutes.canteenLogin),
                              ),
                            ],
                          ),
                          SizedBox(height: 18 * s),

                          if (AppConfig.devPanelEnabled)
                            TextButton.icon(
                              onPressed: () => context.go(AppRoutes.dev),
                              icon: Icon(Icons.developer_mode, size: 17 * s),
                              label: Text(
                                'Developer / Hardware Simulator',
                                style: TextStyle(fontSize: 13 * s),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primaryDark,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.82,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16 * s,
                                  vertical: 8 * s,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
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
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.35),
          width: 2.5 * s,
        ),
        boxShadow: [
          BoxShadow(
            color: ValleyPalette.forestDark.withValues(alpha: 0.28),
            blurRadius: 18 * s,
            offset: Offset(0, 6 * s),
          ),
        ],
      ),
      child: EcoLensLogo(height: 46 * s, showTagline: true),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = context.gameScale;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Semantics(
          button: true,
          label: '${widget.title}. ${widget.subtitle}',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            width: 252 * s,
            transform: Matrix4.translationValues(0, _hover ? -6 * s : 0, 0),
            padding: EdgeInsets.all(20 * s),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24 * s),
              border: Border.all(
                color: widget.accent.withValues(alpha: _hover ? 0.85 : 0.35),
                width: 2.5 * s,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.accent.withValues(alpha: _hover ? 0.38 : 0.20),
                  blurRadius: (_hover ? 24 : 14) * s,
                  offset: Offset(0, (_hover ? 10 : 6) * s),
                ),
              ],
            ),
            // MainAxisSize.min + capped lines: the card grows to fit its text
            // instead of clipping it, so this can never overflow.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50 * s,
                  height: 50 * s,
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(15 * s),
                  ),
                  child: Icon(widget.icon, color: widget.accent, size: 27 * s),
                ),
                SizedBox(height: 14 * s),
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18 * s,
                    fontWeight: FontWeight.w900,
                    height: 1.15,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4 * s),
                Text(
                  widget.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5 * s,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
                SizedBox(height: 10 * s),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        fontSize: 14 * s,
                        color: widget.accent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 4 * s),
                    Icon(
                      Icons.arrow_forward,
                      size: 15 * s,
                      color: widget.accent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
