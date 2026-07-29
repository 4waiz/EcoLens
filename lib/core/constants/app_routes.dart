/// Centralised route path + name constants for GoRouter.
///
/// Note: there is deliberately NO student mobile app route. The student
/// experience lives entirely inside the shared kiosk ("/").
abstract final class AppRoutes {
  // ---- Landing / role picker (demo convenience only) ----
  static const home = '/';
  static const roleSelect = '/select';

  // ---- Kiosk (student experience — shared device) ----
  static const kiosk = '/kiosk';

  // ---- Developer / hardware simulation panel (hidden, non-production) ----
  static const dev = '/dev';

  // ---- Teacher dashboard ----
  static const teacherLogin = '/teacher/login';
  static const teacherOverview = '/teacher/overview';
  static const teacherStudents = '/teacher/students';
  static const teacherStudentDetail = '/teacher/students/:studentId';
  static const teacherClasses = '/teacher/classes';
  static const teacherHouses = '/teacher/houses';
  static const teacherLeaderboards = '/teacher/leaderboards';
  static const teacherAccuracy = '/teacher/accuracy';
  static const teacherRewards = '/teacher/rewards';
  static const teacherReports = '/teacher/reports';
  static const teacherAnnouncements = '/teacher/announcements';

  static String teacherStudentDetailPath(String id) => '/teacher/students/$id';

  // ---- Admin dashboard ----
  static const adminLogin = '/admin/login';
  static const adminOverview = '/admin/overview';
  static const adminStudents = '/admin/students';
  static const adminCards = '/admin/cards';
  static const adminClasses = '/admin/classes';
  static const adminHouses = '/admin/houses';
  static const adminKiosks = '/admin/kiosks';
  static const adminRewards = '/admin/rewards';
  static const adminGamification = '/admin/gamification';
  static const adminAiSettings = '/admin/ai-settings';
  static const adminWasteCategories = '/admin/waste-categories';
  static const adminUsers = '/admin/users';
  static const adminAuditLog = '/admin/audit-log';
  static const adminSystemHealth = '/admin/system-health';

  // ---- Canteen redemption terminal ----
  static const canteenLogin = '/canteen/login';
  static const canteenScanCard = '/canteen/scan-card';
  static const canteenStudent = '/canteen/student';
  static const canteenRewards = '/canteen/rewards';
  static const canteenConfirm = '/canteen/confirm';
  static const canteenSuccess = '/canteen/success';
  static const canteenHistory = '/canteen/history';
}
