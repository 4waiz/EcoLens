import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/layouts/dashboard_shell.dart';

/// Admin dashboard navigation items (shared across all admin pages).
const adminNavItems = <DashboardNavItem>[
  DashboardNavItem(
    label: 'Overview',
    icon: Icons.dashboard_outlined,
    route: AppRoutes.adminOverview,
  ),
  DashboardNavItem(
    label: 'Students',
    icon: Icons.groups_outlined,
    route: AppRoutes.adminStudents,
  ),
  DashboardNavItem(
    label: 'ID Cards',
    icon: Icons.badge_outlined,
    route: AppRoutes.adminCards,
  ),
  DashboardNavItem(
    label: 'Classes',
    icon: Icons.class_outlined,
    route: AppRoutes.adminClasses,
  ),
  DashboardNavItem(
    label: 'Houses',
    icon: Icons.shield_outlined,
    route: AppRoutes.adminHouses,
  ),
  DashboardNavItem(
    label: 'Kiosks',
    icon: Icons.devices_other_outlined,
    route: AppRoutes.adminKiosks,
  ),
  DashboardNavItem(
    label: 'Rewards',
    icon: Icons.card_giftcard_outlined,
    route: AppRoutes.adminRewards,
  ),
  DashboardNavItem(
    label: 'Gamification',
    icon: Icons.videogame_asset_outlined,
    route: AppRoutes.adminGamification,
  ),
  DashboardNavItem(
    label: 'AI Settings',
    icon: Icons.psychology_outlined,
    route: AppRoutes.adminAiSettings,
  ),
  DashboardNavItem(
    label: 'Waste Categories',
    icon: Icons.category_outlined,
    route: AppRoutes.adminWasteCategories,
  ),
  DashboardNavItem(
    label: 'Users',
    icon: Icons.manage_accounts_outlined,
    route: AppRoutes.adminUsers,
  ),
  DashboardNavItem(
    label: 'Audit Log',
    icon: Icons.receipt_long_outlined,
    route: AppRoutes.adminAuditLog,
  ),
  DashboardNavItem(
    label: 'System Health',
    icon: Icons.monitor_heart_outlined,
    route: AppRoutes.adminSystemHealth,
  ),
];

/// Wraps an admin page in the shared dashboard shell (purple accent).
class AdminScaffold extends ConsumerWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions = const [],
  });

  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authServiceProvider);
    final session = auth.getCurrentSession();
    return DashboardShell(
      title: title,
      items: adminNavItems,
      currentRoute: currentRoute,
      accent: AppColors.xpPurple,
      userName: session?.displayName ?? 'Administrator',
      userRoleLabel: 'Administrator',
      actions: actions,
      onLogout: () async {
        await auth.logout();
        if (context.mounted) context.go(AppRoutes.adminLogin);
      },
      child: child,
    );
  }
}
