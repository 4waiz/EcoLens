import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/layouts/dashboard_shell.dart';

/// The teacher dashboard navigation items (shared across all teacher pages).
const teacherNavItems = <DashboardNavItem>[
  DashboardNavItem(
    label: 'Overview',
    icon: Icons.dashboard_outlined,
    route: AppRoutes.teacherOverview,
  ),
  DashboardNavItem(
    label: 'Students',
    icon: Icons.groups_outlined,
    route: AppRoutes.teacherStudents,
  ),
  DashboardNavItem(
    label: 'Classes',
    icon: Icons.class_outlined,
    route: AppRoutes.teacherClasses,
  ),
  DashboardNavItem(
    label: 'Houses',
    icon: Icons.shield_outlined,
    route: AppRoutes.teacherHouses,
  ),
  DashboardNavItem(
    label: 'Leaderboards',
    icon: Icons.leaderboard_outlined,
    route: AppRoutes.teacherLeaderboards,
  ),
  DashboardNavItem(
    label: 'Accuracy',
    icon: Icons.verified_outlined,
    route: AppRoutes.teacherAccuracy,
  ),
  DashboardNavItem(
    label: 'Rewards',
    icon: Icons.card_giftcard_outlined,
    route: AppRoutes.teacherRewards,
  ),
  DashboardNavItem(
    label: 'Reports',
    icon: Icons.description_outlined,
    route: AppRoutes.teacherReports,
  ),
  DashboardNavItem(
    label: 'Announcements',
    icon: Icons.campaign_outlined,
    route: AppRoutes.teacherAnnouncements,
  ),
];

/// Wraps a teacher page in the shared dashboard shell (nav rail + top bar).
class TeacherScaffold extends ConsumerWidget {
  const TeacherScaffold({
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
      items: teacherNavItems,
      currentRoute: currentRoute,
      accent: AppColors.info,
      userName: session?.displayName ?? 'Teacher',
      userRoleLabel: 'Teacher',
      actions: actions,
      onLogout: () async {
        await auth.logout();
        if (context.mounted) context.go(AppRoutes.teacherLogin);
      },
      child: child,
    );
  }
}
