import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../components/ecolens_logo.dart';
import '../responsive/responsive.dart';

/// Shared login layout for teacher / admin / canteen sign-in screens.
/// A split hero panel (brand) + a credential form card.
class StaffLoginScaffold extends StatelessWidget {
  const StaffLoginScaffold({
    super.key,
    required this.roleTitle,
    required this.roleSubtitle,
    required this.accent,
    required this.form,
    required this.heroIcon,
    this.demoHint,
  });

  final String roleTitle;
  final String roleSubtitle;
  final Color accent;
  final Widget form;
  final IconData heroIcon;
  final String? demoHint;

  @override
  Widget build(BuildContext context) {
    final isWide = context.screenWidth >= 900;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Row(
          children: [
            if (isWide)
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent, accent.withValues(alpha: 0.75)],
                    ),
                  ),
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EcoLensLogo(height: 48, onLight: false),
                      const SizedBox(height: 40),
                      Icon(heroIcon, size: 72, color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        roleTitle,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        roleSubtitle,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              flex: 4,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isWide) ...[
                          const Center(child: EcoLensLogo(height: 44)),
                          const SizedBox(height: 32),
                        ],
                        Text(
                          'Sign in',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          roleSubtitle,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 28),
                        form,
                        if (demoHint != null) ...[
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    demoHint!,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: AppColors.primaryDark,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
