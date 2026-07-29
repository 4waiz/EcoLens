import '../../core/constants/app_config.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/gamification_service.dart';
import '../mock/mock_database.dart';

/// In-memory [StudentRepository] backed by [MockDatabase].
class MockStudentRepository implements StudentRepository {
  MockStudentRepository(this._db, {GamificationService? gamification})
    : _gamification = gamification ?? const GamificationService();

  final MockDatabase _db;
  final GamificationService _gamification;

  Future<T> _delay<T>(T value) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    return value;
  }

  @override
  Future<List<Student>> getAllStudents() => _delay(List.of(_db.students));

  @override
  Future<Student?> getStudentById(String id) => _delay(_db.studentById(id));

  @override
  Future<Student?> getStudentByCardUid(String cardUid) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    final card = _db.cards
        .where((c) => c.cardUid == cardUid)
        .cast<StudentCard?>()
        .firstWhere((c) => true, orElse: () => null);
    if (card == null || !card.isUsable) return null;
    return _db.studentById(card.studentId);
  }

  @override
  Future<List<Student>> getStudentsByClass(String className) =>
      _delay(_db.students.where((s) => s.className == className).toList());

  @override
  Future<List<Student>> getStudentsByHouse(String houseId) =>
      _delay(_db.students.where((s) => s.houseId == houseId).toList());

  @override
  Future<Student> upsertStudent(Student student) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    final index = _db.students.indexWhere((s) => s.id == student.id);
    if (index >= 0) {
      _db.students[index] = student;
    } else {
      _db.students.add(student);
    }
    _db.emitStudent(student);
    return student;
  }

  @override
  Future<void> deactivateStudent(String id) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    final index = _db.students.indexWhere((s) => s.id == id);
    if (index >= 0) {
      _db.students[index] = _db.students[index].copyWith(
        accountStatus: AccountStatus.archived,
      );
    }
  }

  @override
  Future<Student> applySessionOutcome(RecyclingSession session) async {
    final current = _db.studentById(session.studentId);
    if (current == null) {
      throw StateError('Student ${session.studentId} not found');
    }

    final xpGain = session.wasCorrect ? _db.config.xpPerCorrect : 0;

    final updated = current.copyWith(
      totalXp: current.totalXp + xpGain,
      availablePoints: current.availablePoints + session.pointsAwarded,
      currentStreak: session.streakAfterSession,
      longestStreak: session.streakAfterSession > current.longestStreak
          ? session.streakAfterSession
          : current.longestStreak,
      correctRecyclingCount:
          current.correctRecyclingCount + (session.wasCorrect ? 1 : 0),
      incorrectRecyclingCount:
          current.incorrectRecyclingCount + (session.wasCorrect ? 0 : 1),
      dailyEarnedPoints: current.dailyEarnedPoints + session.pointsAwarded,
      lastActiveAt: session.completedAt ?? DateTime.now(),
    );

    // Recompute avatar level/stage from new XP.
    final avatar = _db.avatarById(current.avatarId);
    if (avatar != null) {
      final recomputed = _gamification.recomputeAvatar(
        avatar: avatar,
        totalXp: updated.totalXp,
        ladder: _db.evolutionLadder,
      );
      final ai = _db.avatars.indexWhere((a) => a.id == avatar.id);
      if (ai >= 0) _db.avatars[ai] = recomputed;
    }

    // Contribute house points.
    if (session.housePointsAwarded > 0) {
      final hi = _db.houses.indexWhere((h) => h.id == current.houseId);
      if (hi >= 0) {
        _db.houses[hi] = _db.houses[hi].copyWith(
          totalPoints: _db.houses[hi].totalPoints + session.housePointsAwarded,
          weeklyPoints:
              _db.houses[hi].weeklyPoints + session.housePointsAwarded,
        );
      }
    }

    await upsertStudent(updated);
    return updated;
  }

  @override
  Stream<Student> watchStudent(String id) => _db.watchStudent(id);
}
