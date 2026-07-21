import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import 'admin_login_screen.dart';
import 'admin_overview_screen.dart';
import 'admin_sections.dart';

/// Builds the admin dashboard route subtree. The [guard] enforces a valid admin
/// session for every route except the login page.
List<RouteBase> buildAdminRoutes({
  required String? Function(dynamic, dynamic) guard,
}) {
  GoRouterRedirect wrap() => (context, state) => guard(context, state);

  return [
    GoRoute(
      path: AppRoutes.adminLogin,
      redirect: wrap(),
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminOverview,
      redirect: wrap(),
      builder: (context, state) => const AdminOverviewScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminStudents,
      redirect: wrap(),
      builder: (context, state) => const AdminStudentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminCards,
      redirect: wrap(),
      builder: (context, state) => const AdminCardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminClasses,
      redirect: wrap(),
      builder: (context, state) => const AdminClassesScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminHouses,
      redirect: wrap(),
      builder: (context, state) => const AdminHousesScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminKiosks,
      redirect: wrap(),
      builder: (context, state) => const AdminKiosksScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminRewards,
      redirect: wrap(),
      builder: (context, state) => const AdminRewardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminGamification,
      redirect: wrap(),
      builder: (context, state) => const AdminGamificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminAiSettings,
      redirect: wrap(),
      builder: (context, state) => const AdminAiSettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminWasteCategories,
      redirect: wrap(),
      builder: (context, state) => const AdminWasteCategoriesScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminUsers,
      redirect: wrap(),
      builder: (context, state) => const AdminUsersScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminAuditLog,
      redirect: wrap(),
      builder: (context, state) => const AdminAuditLogScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminSystemHealth,
      redirect: wrap(),
      builder: (context, state) => const AdminSystemHealthScreen(),
    ),
  ];
}
