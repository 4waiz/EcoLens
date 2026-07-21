import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import 'canteen_screens.dart';

/// Builds the canteen redemption terminal route subtree. The [guard] enforces a
/// valid canteen-staff session for every route except the login page.
///
/// There is NO phone QR workflow anywhere — redemption uses the student's
/// physical ID card, read by the terminal's card reader.
List<RouteBase> buildCanteenRoutes({
  required String? Function(dynamic, dynamic) guard,
}) {
  GoRouterRedirect wrap() => (context, state) => guard(context, state);

  return [
    GoRoute(
      path: AppRoutes.canteenLogin,
      redirect: wrap(),
      builder: (context, state) => const CanteenLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenScanCard,
      redirect: wrap(),
      builder: (context, state) => const CanteenScanCardScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenStudent,
      redirect: wrap(),
      builder: (context, state) => const CanteenStudentScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenRewards,
      redirect: wrap(),
      builder: (context, state) => const CanteenRewardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenConfirm,
      redirect: wrap(),
      builder: (context, state) => const CanteenConfirmScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenSuccess,
      redirect: wrap(),
      builder: (context, state) => const CanteenSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.canteenHistory,
      redirect: wrap(),
      builder: (context, state) => const CanteenHistoryScreen(),
    ),
  ];
}
