import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../enums/app_enums.dart';
import '../models/gamification_config.dart';
import '../models/reward_item.dart';
import '../models/reward_transaction.dart';
import '../models/student.dart';
import '../repositories/repositories.dart';

/// A validated, ready-to-commit redemption request.
class RedemptionRequest {
  const RedemptionRequest({
    required this.student,
    required this.item,
    required this.staffId,
    required this.terminalId,
  });
  final Student student;
  final RewardItem item;
  final String staffId;
  final String terminalId;
}

/// Handles reward catalogue queries and the canteen redemption flow (against
/// the physical Student ID card — never a phone QR).
class RewardService {
  RewardService({
    required RewardRepository rewardRepository,
    required ConfigRepository configRepository,
  }) : _rewards = rewardRepository,
       _config = configRepository;

  final RewardRepository _rewards;
  final ConfigRepository _config;

  Future<List<RewardItem>> getAvailableRewards() async {
    final items = await _rewards.getRewardItems();
    return items.where((i) => i.isActive).toList();
  }

  Future<int> getStudentRewardBalance(Student student) async =>
      student.availablePoints;

  /// Validate a redemption without committing it. Checks balance, daily limit,
  /// availability and (implicitly) that staff context is present.
  Future<Result<RedemptionRequest>> validateRedemption({
    required Student student,
    required RewardItem item,
    required String staffId,
    required String terminalId,
  }) async {
    if (!item.isActive) {
      return const Result.err(RedemptionFailure('This reward is not available.'));
    }
    if (!item.stockStatus.isAvailable) {
      return const Result.err(RedemptionFailure('This reward is out of stock.'));
    }
    if (student.availablePoints < item.pointCost) {
      return Result.err(
        RedemptionFailure(
          'Not enough points. Needs ${item.pointCost}, has '
          '${student.availablePoints}.',
        ),
      );
    }
    if (staffId.isEmpty) {
      return const Result.err(
        RedemptionFailure('Staff authorisation required.'),
      );
    }
    if (item.dailyRedemptionLimit > 0) {
      final today = await _rewards.redemptionsToday(student.id);
      if (today >= item.dailyRedemptionLimit) {
        return const Result.err(
          RedemptionFailure('Daily redemption limit reached for this reward.'),
        );
      }
    }
    return Result.ok(
      RedemptionRequest(
        student: student,
        item: item,
        staffId: staffId,
        terminalId: terminalId,
      ),
    );
  }

  /// Commit a validated redemption: records a debit transaction and returns it.
  /// The caller is responsible for persisting the student's reduced balance.
  Future<RewardTransaction> createRedemption(RedemptionRequest request) async {
    final config = await _config.getConfig();
    final txn = RewardTransaction(
      id: 'txn-${DateTime.now().microsecondsSinceEpoch}',
      studentId: request.student.id,
      type: RewardTransactionType.redemption,
      points: -request.item.pointCost,
      rewardValue: config.pointsToCurrency(request.item.pointCost),
      description: 'Redeemed ${request.item.name}',
      createdAt: DateTime.now(),
      kioskOrTerminalId: request.terminalId,
      staffId: request.staffId,
      rewardItemId: request.item.id,
      status: request.item.requiresStaffApproval
          ? RewardTransactionStatus.pending
          : RewardTransactionStatus.completed,
    );
    return _rewards.saveTransaction(txn);
  }

  Future<RewardTransaction> approveRedemption(RewardTransaction txn) async {
    final approved = txn.copyWith(status: RewardTransactionStatus.completed);
    return _rewards.saveTransaction(approved);
  }

  Future<RewardTransaction> cancelRedemption(RewardTransaction txn) async {
    final cancelled = txn.copyWith(status: RewardTransactionStatus.cancelled);
    return _rewards.saveTransaction(cancelled);
  }

  Future<List<RewardTransaction>> getRedemptionHistory({String? studentId}) =>
      _rewards.getTransactions(studentId: studentId);

  /// Format a point cost as currency using the active config (empty if
  /// monetary conversion is disabled school-wide).
  String formatCost(int points, GamificationConfig config) =>
      config.formatCurrency(points);
}
