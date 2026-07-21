// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaderboardEntryImpl _$$LeaderboardEntryImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardEntryImpl(
  entityId: json['entityId'] as String,
  entityName: json['entityName'] as String,
  entityType: $enumDecode(_$LeaderboardEntityTypeEnumMap, json['entityType']),
  rank: (json['rank'] as num).toInt(),
  totalPoints: (json['totalPoints'] as num).toInt(),
  weeklyChange: (json['weeklyChange'] as num?)?.toInt() ?? 0,
  houseColour: json['houseColour'] as String? ?? '#2E7D46',
  subtitle: json['subtitle'] as String? ?? '',
  isCurrentEntity: json['isCurrentEntity'] as bool? ?? false,
);

Map<String, dynamic> _$$LeaderboardEntryImplToJson(
  _$LeaderboardEntryImpl instance,
) => <String, dynamic>{
  'entityId': instance.entityId,
  'entityName': instance.entityName,
  'entityType': _$LeaderboardEntityTypeEnumMap[instance.entityType]!,
  'rank': instance.rank,
  'totalPoints': instance.totalPoints,
  'weeklyChange': instance.weeklyChange,
  'houseColour': instance.houseColour,
  'subtitle': instance.subtitle,
  'isCurrentEntity': instance.isCurrentEntity,
};

const _$LeaderboardEntityTypeEnumMap = {
  LeaderboardEntityType.student: 'student',
  LeaderboardEntityType.house: 'house',
  LeaderboardEntityType.className: 'className',
};
