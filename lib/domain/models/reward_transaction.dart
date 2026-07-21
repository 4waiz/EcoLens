import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'reward_transaction.freezed.dart';
part 'reward_transaction.g.dart';

/// A record of points earned or redeemed. Redemptions happen at the canteen
/// terminal against the physical Student ID card (no phone QR).
@freezed
class RewardTransaction with _$RewardTransaction {
  const RewardTransaction._();

  const factory RewardTransaction({
    required String id,
    required String studentId,
    required RewardTransactionType type,
    required int points, // signed: negative for redemptions/reversals
    @Default(0.0) double rewardValue, // monetary value if conversion enabled
    required String description,
    required DateTime createdAt,
    String? kioskOrTerminalId,
    String? staffId,
    String? rewardItemId,
    @Default(RewardTransactionStatus.completed) RewardTransactionStatus status,
  }) = _RewardTransaction;

  factory RewardTransaction.fromJson(Map<String, dynamic> json) =>
      _$RewardTransactionFromJson(json);

  bool get isDebit => points < 0;
}
