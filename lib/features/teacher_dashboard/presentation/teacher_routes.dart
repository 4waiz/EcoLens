import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import 'teacher_login_screen.dart';
import 'teacher_overview_screen.dart';
import 'teacher_sections.dart';
import 'teacher_student_detail_screen.dart';
import 'teacher_students_screen.dart';

/// Builds the teacher dashboard route subtree. The [guard] enforces a valid
/// teacher session for every route except the login page.
List<RouteBase> buildTeacherRoutes({
  required String? Function(dynamic, dynamic) guard,
}) {
  GoRouterRedirect wrap() =>
      (context, state) => guard(context, state);

  return [
    GoRoute(
      path: AppRoutes.teacherLogin,
      redirect: wrap(),
      builder: (context, state) => const TeacherLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherOverview,
      redirect: wrap(),
      builder: (context, state) => const TeacherOverviewScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherStudents,
      redirect: wrap(),
      builder: (context, state) => const TeacherStudentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherStudentDetail,
      redirect: wrap(),
      builder: (context, state) => TeacherStudentDetailScreen(
        studentId: state.pathParameters['studentId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.teacherClasses,
      redirect: wrap(),
      builder: (context, state) => const TeacherClassesScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherHouses,
      redirect: wrap(),
      builder: (context, state) => const TeacherHousesScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherLeaderboards,
      redirect: wrap(),
      builder: (context, state) => const TeacherLeaderboardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherAccuracy,
      redirect: wrap(),
      builder: (context, state) => const TeacherAccuracyScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherRewards,
      redirect: wrap(),
      builder: (context, state) => const TeacherRewardsScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherReports,
      redirect: wrap(),
      builder: (context, state) => const TeacherReportsScreen(),
    ),
    GoRoute(
      path: AppRoutes.teacherAnnouncements,
      redirect: wrap(),
      builder: (context, state) => const TeacherAnnouncementsScreen(),
    ),
  ];
}
