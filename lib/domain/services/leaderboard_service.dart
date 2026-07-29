import '../enums/app_enums.dart';
import '../models/house.dart';
import '../models/leaderboard_entry.dart';
import '../models/school_class.dart';
import '../models/student.dart';
import '../repositories/repositories.dart';

/// Builds ranked leaderboards for students, classes and houses.
class LeaderboardService {
  LeaderboardService({
    required StudentRepository studentRepository,
    required HouseRepository houseRepository,
    required ClassRepository classRepository,
  }) : _students = studentRepository,
       _houses = houseRepository,
       _classes = classRepository;

  final StudentRepository _students;
  final HouseRepository _houses;
  final ClassRepository _classes;

  Future<List<LeaderboardEntry>> getStudentLeaderboard({
    String? currentStudentId,
    int limit = 50,
  }) async {
    final students = await _students.getAllStudents();
    final houses = {for (final h in await _houses.getAllHouses()) h.id: h};
    final ranked = [...students]
      ..sort((a, b) => b.totalXp.compareTo(a.totalXp));
    return ranked.take(limit).toList().asMap().entries.map((e) {
      final s = e.value;
      final house = houses[s.houseId];
      return LeaderboardEntry(
        entityId: s.id,
        entityName: s.firstName,
        entityType: LeaderboardEntityType.student,
        rank: e.key + 1,
        totalPoints: s.totalXp,
        weeklyChange: _pseudoWeeklyMovement(s.id),
        houseColour: house?.colour ?? '#2E7D46',
        subtitle: 'Class ${s.className}',
        isCurrentEntity: s.id == currentStudentId,
      );
    }).toList();
  }

  Future<List<LeaderboardEntry>> getClassLeaderboard() async {
    final students = await _students.getAllStudents();
    final classes = await _classes.getAllClasses();
    final byClass = <String, int>{};
    for (final s in students) {
      byClass[s.className] = (byClass[s.className] ?? 0) + s.totalXp;
    }
    final ranked =
        classes.map((c) => MapEntry(c, byClass[c.name] ?? 0)).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    return ranked.asMap().entries.map((e) {
      final SchoolClass c = e.value.key;
      return LeaderboardEntry(
        entityId: c.id,
        entityName: c.name,
        entityType: LeaderboardEntityType.className,
        rank: e.key + 1,
        totalPoints: e.value.value,
        weeklyChange: _pseudoWeeklyMovement(c.id),
        subtitle: 'Grade ${c.grade}',
      );
    }).toList();
  }

  Future<List<LeaderboardEntry>> getHouseLeaderboard({
    String? currentHouseId,
  }) async {
    final houses = await _houses.getAllHouses();
    final ranked = [...houses]
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    return ranked.asMap().entries.map((e) {
      final House h = e.value;
      return LeaderboardEntry(
        entityId: h.id,
        entityName: h.name,
        entityType: LeaderboardEntityType.house,
        rank: e.key + 1,
        totalPoints: h.totalPoints,
        weeklyChange: _pseudoWeeklyMovement(h.id),
        houseColour: h.colour,
        subtitle: h.sustainabilityGoal,
        isCurrentEntity: h.id == currentHouseId,
      );
    }).toList();
  }

  /// Weekly movement for a house: change in rank position vs last week.
  int calculateWeeklyMovement(House house, List<House> lastWeekRanking) {
    final lastIndex = lastWeekRanking.indexWhere((h) => h.id == house.id);
    if (lastIndex < 0) return 0;
    final current = [...lastWeekRanking]
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    final currentIndex = current.indexWhere((h) => h.id == house.id);
    return lastIndex - currentIndex;
  }

  /// Deterministic pseudo-movement so the demo shows varied +/- arrows without
  /// requiring historical data. Real deployments compute from snapshots.
  int _pseudoWeeklyMovement(String id) {
    final h = id.codeUnits.fold<int>(0, (a, b) => a + b);
    return (h % 5) - 2; // range -2..2
  }
}

/// A House with its resolved student membership (used by leaderboard screens).
class HouseWithMembers {
  const HouseWithMembers({required this.house, required this.members});
  final House house;
  final List<Student> members;
}
