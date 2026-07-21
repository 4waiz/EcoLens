import 'package:ecolens/data/mock/mock_database.dart';
import 'package:ecolens/data/repositories/mock_session_repository.dart';
import 'package:ecolens/domain/enums/app_enums.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:ecolens/domain/models/recycling_session.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the offline session queue + idempotent flush (no duplicates).
void main() {
  late MockDatabase db;
  late MockSessionRepository repo;

  setUp(() {
    db = MockDatabase();
    repo = MockSessionRepository(db);
  });

  RecyclingSession session(String key) => RecyclingSession(
        id: 'sess-$key',
        studentId: 'stu-liam',
        kioskId: 'KIOSK-OAK-01',
        startedAt: DateTime(2026, 7, 21),
        finalCategory: WasteCategory.plastic,
        wasCorrect: true,
        pointsAwarded: 5,
        status: SessionStatus.queuedOffline,
        idempotencyKey: key,
      );

  test('sessions can be enqueued while offline', () async {
    await repo.enqueueSession(session('a'));
    await repo.enqueueSession(session('b'));
    final queued = await repo.getQueuedSessions();
    expect(queued.length, 2);
  });

  test('enqueue is idempotent by key (no duplicate queue entries)', () async {
    await repo.enqueueSession(session('a'));
    await repo.enqueueSession(session('a')); // same key
    final queued = await repo.getQueuedSessions();
    expect(queued.length, 1);
  });

  test('flush syncs all queued sessions and clears the queue', () async {
    await repo.enqueueSession(session('a'));
    await repo.enqueueSession(session('b'));
    final synced = await repo.flushQueue();
    expect(synced, 2);
    expect((await repo.getQueuedSessions()).isEmpty, isTrue);
  });

  test('flush does not double-apply an already-committed session', () async {
    // Commit "a" directly first.
    await repo.saveSession(session('a'));
    await repo.enqueueSession(session('a')); // same idempotency key queued
    final synced = await repo.flushQueue();
    // "a" was already committed → not counted again.
    expect(synced, 0);
  });

  test('flushing an empty queue returns zero', () async {
    expect(await repo.flushQueue(), 0);
  });
}
