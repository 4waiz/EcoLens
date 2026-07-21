// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waste_classification_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WasteClassificationResultImpl _$$WasteClassificationResultImplFromJson(
  Map<String, dynamic> json,
) => _$WasteClassificationResultImpl(
  predictedCategory: $enumDecode(
    _$WasteCategoryEnumMap,
    json['predictedCategory'],
  ),
  detectedObjectName: json['detectedObjectName'] as String,
  confidence: (json['confidence'] as num).toDouble(),
  condition:
      $enumDecodeNullable(_$ItemConditionEnumMap, json['condition']) ??
      ItemCondition.clean,
  contaminationDetected: json['contaminationDetected'] as bool? ?? false,
  explanation: json['explanation'] as String,
  educationalFact: json['educationalFact'] as String,
  capturedImagePath: json['capturedImagePath'] as String?,
  processedAt: DateTime.parse(json['processedAt'] as String),
  isFallback: json['isFallback'] as bool? ?? false,
);

Map<String, dynamic> _$$WasteClassificationResultImplToJson(
  _$WasteClassificationResultImpl instance,
) => <String, dynamic>{
  'predictedCategory': _$WasteCategoryEnumMap[instance.predictedCategory]!,
  'detectedObjectName': instance.detectedObjectName,
  'confidence': instance.confidence,
  'condition': _$ItemConditionEnumMap[instance.condition]!,
  'contaminationDetected': instance.contaminationDetected,
  'explanation': instance.explanation,
  'educationalFact': instance.educationalFact,
  'capturedImagePath': instance.capturedImagePath,
  'processedAt': instance.processedAt.toIso8601String(),
  'isFallback': instance.isFallback,
};

const _$WasteCategoryEnumMap = {
  WasteCategory.plastic: 'plastic',
  WasteCategory.paper: 'paper',
  WasteCategory.organic: 'organic',
  WasteCategory.general: 'general',
};

const _$ItemConditionEnumMap = {
  ItemCondition.clean: 'clean',
  ItemCondition.contaminated: 'contaminated',
  ItemCondition.wet: 'wet',
  ItemCondition.unknown: 'unknown',
};
