import 'dart:async';

import '../../domain/models/models.dart';
import 'mock_seed_data.dart';

/// A single in-memory, mutable store that every mock repository shares. This is
/// the "backend" for the demo — state changes (recycling, redemptions, config
/// edits) persist for the lifetime of the app session so the dashboards reflect
/// live kiosk activity.
class MockDatabase {
  MockDatabase() {
    _seed();
  }

  final List<Student> students = [];
  final List<StudentCard> cards = [];
  final List<House> houses = [];
  final List<SchoolClass> classes = [];
  final List<Avatar> avatars = [];
  final List<AvatarEvolutionStage> evolutionLadder = [];
  final List<RewardItem> rewardItems = [];
  final List<RewardTransaction> transactions = [];
  final List<KioskDevice> devices = [];
  final List<RecyclingSession> sessions = [];
  final List<RecyclingSession> offlineQueue = [];
  final List<AuditLogEntry> auditLog = [];

  GamificationConfig config = const GamificationConfig();

  // Per-student streams for reactive kiosk/dashboard updates.
  final Map<String, StreamController<Student>> _studentControllers = {};
  final StreamController<GamificationConfig> _configController =
      StreamController<GamificationConfig>.broadcast();

  void _seed() {
    students
      ..clear()
      ..addAll(MockSeedData.students());
    cards
      ..clear()
      ..addAll(MockSeedData.cards());
    houses
      ..clear()
      ..addAll(MockSeedData.houses());
    classes
      ..clear()
      ..addAll(MockSeedData.classes());
    avatars
      ..clear()
      ..addAll(MockSeedData.avatars());
    evolutionLadder
      ..clear()
      ..addAll(MockSeedData.evolutionLadder());
    rewardItems
      ..clear()
      ..addAll(MockSeedData.rewardItems());
    transactions
      ..clear()
      ..addAll(MockSeedData.transactions());
    devices
      ..clear()
      ..addAll(MockSeedData.devices());
    sessions
      ..clear()
      ..addAll(MockSeedData.sessions());
    auditLog
      ..clear()
      ..addAll(MockSeedData.auditLog());
    config = const GamificationConfig();
  }

  Stream<Student> watchStudent(String id) {
    final controller = _studentControllers.putIfAbsent(
      id,
      () => StreamController<Student>.broadcast(),
    );
    return controller.stream;
  }

  void emitStudent(Student student) {
    _studentControllers[student.id]?.add(student);
  }

  Stream<GamificationConfig> watchConfig() => _configController.stream;

  void emitConfig() => _configController.add(config);

  Student? studentById(String id) {
    for (final s in students) {
      if (s.id == id) return s;
    }
    return null;
  }

  House? houseById(String id) {
    for (final h in houses) {
      if (h.id == id) return h;
    }
    return null;
  }

  Avatar? avatarById(String id) {
    for (final a in avatars) {
      if (a.id == id) return a;
    }
    return null;
  }

  void dispose() {
    for (final c in _studentControllers.values) {
      c.close();
    }
    _configController.close();
  }
}
