// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentImpl _$$StudentImplFromJson(Map<String, dynamic> json) =>
    _$StudentImpl(
      id: json['id'] as String,
      studentNumber: json['studentNumber'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      grade: (json['grade'] as num).toInt(),
      className: json['className'] as String,
      houseId: json['houseId'] as String,
      avatarId: json['avatarId'] as String,
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      availablePoints: (json['availablePoints'] as num?)?.toInt() ?? 0,
      rewardBalance: (json['rewardBalance'] as num?)?.toDouble() ?? 0.0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      longestStreak: (json['longestStreak'] as num?)?.toInt() ?? 0,
      correctRecyclingCount:
          (json['correctRecyclingCount'] as num?)?.toInt() ?? 0,
      incorrectRecyclingCount:
          (json['incorrectRecyclingCount'] as num?)?.toInt() ?? 0,
      dailyEarnedPoints: (json['dailyEarnedPoints'] as num?)?.toInt() ?? 0,
      lastActiveAt: json['lastActiveAt'] == null
          ? null
          : DateTime.parse(json['lastActiveAt'] as String),
      accountStatus:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['accountStatus']) ??
          AccountStatus.active,
    );

Map<String, dynamic> _$$StudentImplToJson(_$StudentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentNumber': instance.studentNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'grade': instance.grade,
      'className': instance.className,
      'houseId': instance.houseId,
      'avatarId': instance.avatarId,
      'totalXp': instance.totalXp,
      'availablePoints': instance.availablePoints,
      'rewardBalance': instance.rewardBalance,
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'correctRecyclingCount': instance.correctRecyclingCount,
      'incorrectRecyclingCount': instance.incorrectRecyclingCount,
      'dailyEarnedPoints': instance.dailyEarnedPoints,
      'lastActiveAt': instance.lastActiveAt?.toIso8601String(),
      'accountStatus': _$AccountStatusEnumMap[instance.accountStatus]!,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
  AccountStatus.archived: 'archived',
};
