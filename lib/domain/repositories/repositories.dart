/// Repository interfaces (domain contracts). The presentation and service
/// layers depend only on these; concrete mock/real implementations live in
/// `data/repositories`. This keeps UI independent from data sources.
library;

import '../models/models.dart';

/// Students, cards, classes, houses.
abstract interface class StudentRepository {
  Future<List<Student>> getAllStudents();
  Future<Student?> getStudentById(String id);
  Future<Student?> getStudentByCardUid(String cardUid);
  Future<List<Student>> getStudentsByClass(String className);
  Future<List<Student>> getStudentsByHouse(String houseId);
  Future<Student> upsertStudent(Student student);
  Future<void> deactivateStudent(String id);

  /// Apply the results of a completed recycling session to the student's
  /// aggregate counters (xp, points, streak, correct/incorrect counts).
  Future<Student> applySessionOutcome(RecyclingSession session);

  Stream<Student> watchStudent(String id);
}

abstract interface class CardRepository {
  Future<List<StudentCard>> getAllCards();
  Future<StudentCard?> getCardByUid(String uid);
  Future<StudentCard?> getCardForStudent(String studentId);
  Future<StudentCard> assignCard(StudentCard card);
  Future<StudentCard> replaceCard(String studentId, String newUid);
  Future<void> deactivateCard(String uid);
}

abstract interface class HouseRepository {
  Future<List<House>> getAllHouses();
  Future<House?> getHouseById(String id);
  Future<House> addHousePoints(String houseId, int points);
  Future<House> updateHouse(House house);
}

abstract interface class ClassRepository {
  Future<List<SchoolClass>> getAllClasses();
  Future<SchoolClass?> getClassById(String id);
  Future<SchoolClass> upsertClass(SchoolClass schoolClass);
}

abstract interface class AvatarRepository {
  Future<Avatar?> getAvatarById(String id);
  Future<Avatar> upsertAvatar(Avatar avatar);
  Future<List<AvatarEvolutionStage>> getEvolutionLadder();
}

abstract interface class SessionRepository {
  Future<List<RecyclingSession>> getRecentSessions({int limit});
  Future<List<RecyclingSession>> getSessionsForStudent(String studentId);
  Future<RecyclingSession> saveSession(RecyclingSession session);

  /// Offline queue: pending (not-yet-synced) sessions.
  Future<List<RecyclingSession>> getQueuedSessions();
  Future<void> enqueueSession(RecyclingSession session);

  /// Attempt to flush queued sessions; returns the count synced. Idempotent —
  /// sessions already applied (by idempotencyKey) are not double-counted.
  Future<int> flushQueue();
}

abstract interface class RewardRepository {
  Future<List<RewardItem>> getRewardItems();
  Future<RewardItem?> getRewardItem(String id);
  Future<RewardItem> upsertRewardItem(RewardItem item);

  Future<List<RewardTransaction>> getTransactions({String? studentId});
  Future<RewardTransaction> saveTransaction(RewardTransaction txn);

  /// Count of redemptions a student has made today (for daily limits).
  Future<int> redemptionsToday(String studentId);
}

abstract interface class DeviceRepository {
  Future<List<KioskDevice>> getDevices();
  Future<KioskDevice?> getDevice(String id);
  Future<KioskDevice> updateDevice(KioskDevice device);
  Future<KioskDevice> setMaintenance(String id, {required bool enabled});
}

abstract interface class ConfigRepository {
  Future<GamificationConfig> getConfig();
  Future<GamificationConfig> saveConfig(GamificationConfig config);
  Stream<GamificationConfig> watchConfig();
}

abstract interface class AuditRepository {
  Future<List<AuditLogEntry>> getEntries({int limit});
  Future<void> record(AuditLogEntry entry);
}

/// Aggregated analytics for teacher/admin dashboards.
abstract interface class DashboardRepository {
  Future<TeacherOverview> getTeacherOverview({String? teacherId});
  Future<AdminOverview> getAdminOverview();
  Future<AccuracyMetrics> getAccuracyMetrics({String? classFilter});
  Future<List<CommonMistake>> getCommonMistakes();
  Future<List<TrendPoint>> getParticipationTrends();
  Future<List<KioskDevice>> getDeviceHealthSummary();
  Future<List<RewardTransaction>> getRewardUsageSummary();
}
