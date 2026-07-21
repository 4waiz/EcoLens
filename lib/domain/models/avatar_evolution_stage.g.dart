// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_evolution_stage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvatarEvolutionStageImpl _$$AvatarEvolutionStageImplFromJson(
  Map<String, dynamic> json,
) => _$AvatarEvolutionStageImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  minimumXp: (json['minimumXp'] as num).toInt(),
  environmentalMeaning: json['environmentalMeaning'] as String,
  assetPath: json['assetPath'] as String? ?? '',
  stageIndex: (json['stageIndex'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$AvatarEvolutionStageImplToJson(
  _$AvatarEvolutionStageImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'minimumXp': instance.minimumXp,
  'environmentalMeaning': instance.environmentalMeaning,
  'assetPath': instance.assetPath,
  'stageIndex': instance.stageIndex,
};
