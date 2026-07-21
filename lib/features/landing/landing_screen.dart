import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/components/ecolens_logo.dart';
import '../../shared/components/guardian_avatar.dart';
import '../../shared/responsive/responsive.dart';

/// A demo launcher that routes into each EcoLens experience.
///
/// In a real deployment each device would boot straight into ONE surface (a
/// kiosk boots to /kiosk in locked full-screen; staff open a dashboard URL).
/// This picker exists purely so all four experiences are reachable from one
/// build during development and demos.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.attractGradient,
          ),
        ),
        child: SafeArea(
          child: ContentBounds(
            maxWidth: 1100,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const EcoLensLogo(height: 56, showTagline: true),
                  const SizedBox(height: 8),
                  const SizedBox(height: 140, child: GuardianAvatar(stage: 2, size: 160)),
                  Text(
                    'Choose an experience',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Students are identified only by their physical Student ID card — no phones.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.inkMuted,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
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
                  const SizedBox(height: 24),
                  if (AppConfig.devPanelEnabled)
                    TextButton.icon(
                      onPressed: () => context.go(AppRoutes.dev),
                      icon: const Icon(Icons.developer_mode, size: 18),
                      label: const Text('Developer / Hardware Simulator'),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    'EcoLens ${AppConfig.appVersion} · ${AppConfig.environment.label} mode',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 180,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent, size: 28),
                ),
                const Spacer(),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'Open',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(Icons.arrow_forward, size: 16, color: accent),
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
