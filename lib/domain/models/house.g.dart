// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HouseImpl _$$HouseImplFromJson(Map<String, dynamic> json) => _$HouseImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  colour: json['colour'] as String,
  emblem: json['emblem'] as String,
  totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
  weeklyPoints: (json['weeklyPoints'] as num?)?.toInt() ?? 0,
  sustainabilityGoal: json['sustainabilityGoal'] as String,
  goalProgress: (json['goalProgress'] as num?)?.toDouble() ?? 0.0,
  leaderboardPosition: (json['leaderboardPosition'] as num?)?.toInt() ?? 0,
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$HouseImplToJson(_$HouseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colour': instance.colour,
      'emblem': instance.emblem,
      'totalPoints': instance.totalPoints,
      'weeklyPoints': instance.weeklyPoints,
      'sustainabilityGoal': instance.sustainabilityGoal,
      'goalProgress': instance.goalProgress,
      'leaderboardPosition': instance.leaderboardPosition,
      'memberCount': instance.memberCount,
    };
