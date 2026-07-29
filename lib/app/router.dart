import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_routes.dart';
import '../domain/enums/app_enums.dart';
import '../features/admin_dashboard/presentation/admin_routes.dart';
import '../features/canteen_terminal/presentation/canteen_routes.dart';
import '../features/dev_panel/presentation/dev_panel_screen.dart';
import '../features/kiosk/presentation/kiosk_screen.dart';
import '../features/landing/landing_screen.dart';
import '../features/teacher_dashboard/presentation/teacher_routes.dart';
import 'providers.dart';

/// Builds the app's GoRouter with role-based guards.
///
/// - The kiosk ("/kiosk") is the student experience; it needs no auth (identity
///   comes from the physical ID card at runtime) but is a locked full-screen
///   surface.
/// - Teacher/admin/canteen sections require a valid session of the matching
///   role; unauthenticated access redirects to that section's login.
/// - The developer panel is only reachable when [AppConfig.devPanelEnabled].
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authServiceProvider);

  String? guard(
    BuildContext context,
    GoRouterState state,
    UserRole required,
    String loginPath,
  ) {
    final session = auth.getCurrentSession();
    final authed =
        session != null && session.isValid && session.role == required;
    final atLogin = state.matchedLocation == loginPath;
    if (!authed && !atLogin) return loginPath;
    if (authed && atLogin) {
      // Already logged in → send to that role's landing.
      return switch (required) {
        UserRole.teacher => AppRoutes.teacherOverview,
        UserRole.admin => AppRoutes.adminOverview,
        UserRole.canteenStaff => AppRoutes.canteenScanCard,
        UserRole.student => AppRoutes.kiosk,
      };
    }
    return null;
  }

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: AppRoutes.kiosk,
        name: 'kiosk',
        builder: (context, state) => const KioskScreen(),
      ),
      if (AppConfig.devPanelEnabled)
        GoRoute(
          path: AppRoutes.dev,
          name: 'dev',
          builder: (context, state) => const DevPanelScreen(),
        ),

      // Teacher
      ...buildTeacherRoutes(
        guard: (c, s) => guard(c, s, UserRole.teacher, AppRoutes.teacherLogin),
      ),

      // Admin
      ...buildAdminRoutes(
        guard: (c, s) => guard(c, s, UserRole.admin, AppRoutes.adminLogin),
      ),

      // Canteen
      ...buildCanteenRoutes(
        guard: (c, s) =>
            guard(c, s, UserRole.canteenStaff, AppRoutes.canteenLogin),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text('Route not found: ${state.uri}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Signature for a per-section route guard passed into the section builders.
typedef RouteGuard = String? Function(BuildContext, GoRouterState);
