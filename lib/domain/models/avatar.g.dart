// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvatarImpl _$$AvatarImplFromJson(Map<String, dynamic> json) => _$AvatarImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  stage: (json['stage'] as num).toInt(),
  level: (json['level'] as num).toInt(),
  currentXp: (json['currentXp'] as num).toInt(),
  xpRequiredForNextLevel: (json['xpRequiredForNextLevel'] as num).toInt(),
  unlockedAccessories:
      (json['unlockedAccessories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  equippedAccessories:
      (json['equippedAccessories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  visualAssetPath: json['visualAssetPath'] as String? ?? '',
);

Map<String, dynamic> _$$AvatarImplToJson(_$AvatarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'stage': instance.stage,
      'level': instance.level,
      'currentXp': instance.currentXp,
      'xpRequiredForNextLevel': instance.xpRequiredForNextLevel,
      'unlockedAccessories': instance.unlockedAccessories,
      'equippedAccessories': instance.equippedAccessories,
      'visualAssetPath': instance.visualAssetPath,
    };
