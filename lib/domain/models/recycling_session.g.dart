// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecyclingSessionImpl _$$RecyclingSessionImplFromJson(
  Map<String, dynamic> json,
) => _$RecyclingSessionImpl(
  id: json['id'] as String,
  studentId: json['studentId'] as String,
  kioskId: json['kioskId'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  classificationResult: json['classificationResult'] == null
      ? null
      : WasteClassificationResult.fromJson(
          json['classificationResult'] as Map<String, dynamic>,
        ),
  studentSelectedCategory: $enumDecodeNullable(
    _$WasteCategoryEnumMap,
    json['studentSelectedCategory'],
  ),
  finalCategory: $enumDecodeNullable(
    _$WasteCategoryEnumMap,
    json['finalCategory'],
  ),
  wasCorrect: json['wasCorrect'] as bool? ?? false,
  pointsAwarded: (json['pointsAwarded'] as num?)?.toInt() ?? 0,
  housePointsAwarded: (json['housePointsAwarded'] as num?)?.toInt() ?? 0,
  streakAfterSession: (json['streakAfterSession'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
      SessionStatus.active,
  hardwareCommandStatus:
      $enumDecodeNullable(
        _$HardwareCommandStatusEnumMap,
        json['hardwareCommandStatus'],
      ) ??
      HardwareCommandStatus.pending,
  bonusApplied: json['bonusApplied'] as bool? ?? false,
  dailyCapReached: json['dailyCapReached'] as bool? ?? false,
  idempotencyKey: json['idempotencyKey'] as String,
);

Map<String, dynamic> _$$RecyclingSessionImplToJson(
  _$RecyclingSessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'studentId': instance.studentId,
  'kioskId': instance.kioskId,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'classificationResult': instance.classificationResult,
  'studentSelectedCategory':
      _$WasteCategoryEnumMap[instance.studentSelectedCategory],
  'finalCategory': _$WasteCategoryEnumMap[instance.finalCategory],
  'wasCorrect': instance.wasCorrect,
  'pointsAwarded': instance.pointsAwarded,
  'housePointsAwarded': instance.housePointsAwarded,
  'streakAfterSession': instance.streakAfterSession,
  'status': _$SessionStatusEnumMap[instance.status]!,
  'hardwareCommandStatus':
      _$HardwareCommandStatusEnumMap[instance.hardwareCommandStatus]!,
  'bonusApplied': instance.bonusApplied,
  'dailyCapReached': instance.dailyCapReached,
  'idempotencyKey': instance.idempotencyKey,
};

const _$WasteCategoryEnumMap = {
  WasteCategory.plastic: 'plastic',
  WasteCategory.paper: 'paper',
  WasteCategory.organic: 'organic',
  WasteCategory.general: 'general',
};

const _$SessionStatusEnumMap = {
  SessionStatus.active: 'active',
  SessionStatus.completed: 'completed',
  SessionStatus.abandoned: 'abandoned',
  SessionStatus.timedOut: 'timedOut',
  SessionStatus.queuedOffline: 'queuedOffline',
  SessionStatus.synced: 'synced',
};

const _$HardwareCommandStatusEnumMap = {
  HardwareCommandStatus.pending: 'pending',
  HardwareCommandStatus.sent: 'sent',
  HardwareCommandStatus.acknowledged: 'acknowledged',
  HardwareCommandStatus.failed: 'failed',
  HardwareCommandStatus.skippedOffline: 'skippedOffline',
};
