import '../../core/constants/app_config.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../mock/mock_database.dart';

/// [SessionRepository] with a working offline queue and idempotent flush.
class MockSessionRepository implements SessionRepository {
  MockSessionRepository(this._db);
  final MockDatabase _db;

  Future<void> _tick() => Future<void>.delayed(AppConfig.mockNetworkDelay);

  @override
  Future<List<RecyclingSession>> getRecentSessions({int limit = 50}) async {
    await _tick();
    final sorted = List.of(_db.sessions)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sorted.take(limit).toList();
  }

  @override
  Future<List<RecyclingSession>> getSessionsForStudent(
    String studentId,
  ) async {
    await _tick();
    final list =
        _db.sessions.where((s) => s.studentId == studentId).toList()
          ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return list;
  }

  @override
  Future<RecyclingSession> saveSession(RecyclingSession session) async {
    await _tick();
    // Idempotency: never store the same completed session twice.
    final existing =
        _db.sessions.indexWhere((s) => s.idempotencyKey == session.idempotencyKey);
    if (existing >= 0) {
      _db.sessions[existing] = session;
    } else {
      _db.sessions.add(session);
    }
    return session;
  }

  @override
  Future<List<RecyclingSession>> getQueuedSessions() async {
    await _tick();
    return List.of(_db.offlineQueue);
  }

  @override
  Future<void> enqueueSession(RecyclingSession session) async {
    await _tick();
    // Avoid enqueuing duplicates by idempotency key.
    final already =
        _db.offlineQueue.any((s) => s.idempotencyKey == session.idempotencyKey);
    if (!already) {
      _db.offlineQueue.add(
        session.copyWith(status: SessionStatus.queuedOffline),
      );
    }
  }

  @override
  Future<int> flushQueue() async {
    await _tick();
    if (_db.offlineQueue.isEmpty) return 0;
    var synced = 0;
    final toFlush = List.of(_db.offlineQueue);
    for (final session in toFlush) {
      // Skip if this session was already committed (idempotency guard).
      final alreadyCommitted = _db.sessions
          .any((s) => s.idempotencyKey == session.idempotencyKey);
      if (!alreadyCommitted) {
        _db.sessions.add(session.copyWith(status: SessionStatus.synced));
        synced++;
      }
    }
    _db.offlineQueue.clear();
    return synced;
  }
}
