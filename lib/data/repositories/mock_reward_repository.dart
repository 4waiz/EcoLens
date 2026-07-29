import '../../core/constants/app_config.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../mock/mock_database.dart';

/// [RewardRepository] over the shared mock database. Redemption transactions
/// also debit the student's available points so balances stay consistent
/// across the canteen terminal and the dashboards.
class MockRewardRepository implements RewardRepository {
  MockRewardRepository(this._db);
  final MockDatabase _db;

  Future<void> _tick() => Future<void>.delayed(AppConfig.mockNetworkDelay);

  @override
  Future<List<RewardItem>> getRewardItems() async {
    await _tick();
    return List.of(_db.rewardItems);
  }

  @override
  Future<RewardItem?> getRewardItem(String id) async {
    await _tick();
    for (final r in _db.rewardItems) {
      if (r.id == id) return r;
    }
    return null;
  }

  @override
  Future<RewardItem> upsertRewardItem(RewardItem item) async {
    await _tick();
    final index = _db.rewardItems.indexWhere((r) => r.id == item.id);
    if (index >= 0) {
      _db.rewardItems[index] = item;
    } else {
      _db.rewardItems.add(item);
    }
    return item;
  }

  @override
  Future<List<RewardTransaction>> getTransactions({String? studentId}) async {
    await _tick();
    final list =
        _db.transactions
            .where((t) => studentId == null || t.studentId == studentId)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<RewardTransaction> saveTransaction(RewardTransaction txn) async {
    await _tick();
    final index = _db.transactions.indexWhere((t) => t.id == txn.id);
    if (index >= 0) {
      _db.transactions[index] = txn;
    } else {
      _db.transactions.insert(0, txn);
    }

    // Apply a completed debit to the student's balance exactly once.
    if (txn.status == RewardTransactionStatus.completed && txn.isDebit) {
      final si = _db.students.indexWhere((s) => s.id == txn.studentId);
      if (si >= 0) {
        final s = _db.students[si];
        final newPoints = (s.availablePoints + txn.points).clamp(0, 1 << 30);
        _db.students[si] = s.copyWith(availablePoints: newPoints);
        _db.emitStudent(_db.students[si]);
      }
    }
    return txn;
  }

  @override
  Future<int> redemptionsToday(String studentId) async {
    await _tick();
    final now = DateTime.now();
    return _db.transactions
        .where(
          (t) =>
              t.studentId == studentId &&
              t.type == RewardTransactionType.redemption &&
              t.createdAt.year == now.year &&
              t.createdAt.month == now.month &&
              t.createdAt.day == now.day,
        )
        .length;
  }
}
