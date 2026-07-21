// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RewardTransactionImpl _$$RewardTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$RewardTransactionImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  type: $enumDecode(_$RewardTransactionTypeEnumMap, json['type']),
  points: (json['points'] as num).toInt(),
  rewardValue: (json['rewardValue'] as num?)?.toDouble() ?? 0.0,
  description: json['description'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  kioskOrTerminalId: json['kioskOrTerminalId'] as String?,
  staffId: json['staffId'] as String?,
  rewardItemId: json['rewardItemId'] as String?,
  status:
      $enumDecodeNullable(_$RewardTransactionStatusEnumMap, json['status']) ??
      RewardTransactionStatus.completed,
);

Map<String, dynamic> _$$RewardTransactionImplToJson(
  _$RewardTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'type': _$RewardTransactionTypeEnumMap[instance.type]!,
  'points': instance.points,
  'rewardValue': instance.rewardValue,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
  'kioskOrTerminalId': instance.kioskOrTerminalId,
  'staffId': instance.staffId,
  'rewardItemId': instance.rewardItemId,
  'status': _$RewardTransactionStatusEnumMap[instance.status]!,
};

const _$RewardTransactionTypeEnumMap = {
  RewardTransactionType.redemption: 'redemption',
  RewardTransactionType.earn: 'earn',
  RewardTransactionType.bonus: 'bonus',
  RewardTransactionType.raffleEntry: 'raffleEntry',
  RewardTransactionType.reversal: 'reversal',
};

const _$RewardTransactionStatusEnumMap = {
  RewardTransactionStatus.pending: 'pending',
  RewardTransactionStatus.approved: 'approved',
  RewardTransactionStatus.completed: 'completed',
  RewardTransactionStatus.cancelled: 'cancelled',
  RewardTransactionStatus.failed: 'failed',
};
