// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MetricValueImpl _$$MetricValueImplFromJson(Map<String, dynamic> json) =>
    _$MetricValueImpl(
      label: json['label'] as String,
      value: json['value'] as String,
      delta: json['delta'] as String? ?? '',
      deltaPositive: json['deltaPositive'] as bool? ?? true,
      caption: json['caption'] as String? ?? '',
    );

Map<String, dynamic> _$$MetricValueImplToJson(_$MetricValueImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'delta': instance.delta,
      'deltaPositive': instance.deltaPositive,
      'caption': instance.caption,
    };

_$TrendPointImpl _$$TrendPointImplFromJson(Map<String, dynamic> json) =>
    _$TrendPointImpl(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$TrendPointImplToJson(_$TrendPointImpl instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};

_$CommonMistakeImpl _$$CommonMistakeImplFromJson(
  Map<String, dynamic> json,
) => _$CommonMistakeImpl(
  correctCategory: $enumDecode(_$WasteCategoryEnumMap, json['correctCategory']),
  chosenCategory: $enumDecode(_$WasteCategoryEnumMap, json['chosenCategory']),
  occurrences: (json['occurrences'] as num).toInt(),
  exampleItem: json['exampleItem'] as String? ?? '',
);

Map<String, dynamic> _$$CommonMistakeImplToJson(_$CommonMistakeImpl instance) =>
    <String, dynamic>{
      'correctCategory': _$WasteCategoryEnumMap[instance.correctCategory]!,
      'chosenCategory': _$WasteCategoryEnumMap[instance.chosenCategory]!,
      'occurrences': instance.occurrences,
      'exampleItem': instance.exampleItem,
    };

const _$WasteCategoryEnumMap = {
  WasteCategory.plastic: 'plastic',
  WasteCategory.paper: 'paper',
  WasteCategory.organic: 'organic',
  WasteCategory.general: 'general',
};

_$TeacherOverviewImpl _$$TeacherOverviewImplFromJson(
  Map<String, dynamic> json,
) => _$TeacherOverviewImpl(
  activeStudents: (json['activeStudents'] as num).toInt(),
  recyclingSessions: (json['recyclingSessions'] as num).toInt(),
  correctClassificationRate: (json['correctClassificationRate'] as num)
      .toDouble(),
  participationRate: (json['participationRate'] as num).toDouble(),
  xpAwarded: (json['xpAwarded'] as num).toInt(),
  housePoints: (json['housePoints'] as num).toInt(),
  headlineMetrics:
      (json['headlineMetrics'] as List<dynamic>?)
          ?.map((e) => MetricValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MetricValue>[],
  participationTrend:
      (json['participationTrend'] as List<dynamic>?)
          ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TrendPoint>[],
  commonMistakes:
      (json['commonMistakes'] as List<dynamic>?)
          ?.map((e) => CommonMistake.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CommonMistake>[],
  topClasses:
      (json['topClasses'] as List<dynamic>?)
          ?.map((e) => LeaderboardMini.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LeaderboardMini>[],
  topHouses:
      (json['topHouses'] as List<dynamic>?)
          ?.map((e) => LeaderboardMini.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LeaderboardMini>[],
);

Map<String, dynamic> _$$TeacherOverviewImplToJson(
  _$TeacherOverviewImpl instance,
) => <String, dynamic>{
  'activeStudents': instance.activeStudents,
  'recyclingSessions': instance.recyclingSessions,
  'correctClassificationRate': instance.correctClassificationRate,
  'participationRate': instance.participationRate,
  'xpAwarded': instance.xpAwarded,
  'housePoints': instance.housePoints,
  'headlineMetrics': instance.headlineMetrics,
  'participationTrend': instance.participationTrend,
  'commonMistakes': instance.commonMistakes,
  'topClasses': instance.topClasses,
  'topHouses': instance.topHouses,
};

_$AdminOverviewImpl _$$AdminOverviewImplFromJson(Map<String, dynamic> json) =>
    _$AdminOverviewImpl(
      totalStudents: (json['totalStudents'] as num).toInt(),
      activeKiosks: (json['activeKiosks'] as num).toInt(),
      kiosksNeedingAttention: (json['kiosksNeedingAttention'] as num).toInt(),
      sessionsToday: (json['sessionsToday'] as num).toInt(),
      systemAccuracy: (json['systemAccuracy'] as num).toDouble(),
      rewardsRedeemedToday: (json['rewardsRedeemedToday'] as num).toInt(),
      headlineMetrics:
          (json['headlineMetrics'] as List<dynamic>?)
              ?.map((e) => MetricValue.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MetricValue>[],
      weeklySessions:
          (json['weeklySessions'] as List<dynamic>?)
              ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TrendPoint>[],
      categoryBreakdown:
          (json['categoryBreakdown'] as List<dynamic>?)
              ?.map(
                (e) => CategoryBreakdown.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CategoryBreakdown>[],
    );

Map<String, dynamic> _$$AdminOverviewImplToJson(_$AdminOverviewImpl instance) =>
    <String, dynamic>{
      'totalStudents': instance.totalStudents,
      'activeKiosks': instance.activeKiosks,
      'kiosksNeedingAttention': instance.kiosksNeedingAttention,
      'sessionsToday': instance.sessionsToday,
      'systemAccuracy': instance.systemAccuracy,
      'rewardsRedeemedToday': instance.rewardsRedeemedToday,
      'headlineMetrics': instance.headlineMetrics,
      'weeklySessions': instance.weeklySessions,
      'categoryBreakdown': instance.categoryBreakdown,
    };

_$LeaderboardMiniImpl _$$LeaderboardMiniImplFromJson(
  Map<String, dynamic> json,
) => _$LeaderboardMiniImpl(
  name: json['name'] as String,
  points: (json['points'] as num).toInt(),
  colour: json['colour'] as String? ?? '#2E7D46',
  progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$$LeaderboardMiniImplToJson(
  _$LeaderboardMiniImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'points': instance.points,
  'colour': instance.colour,
  'progress': instance.progress,
};

_$CategoryBreakdownImpl _$$CategoryBreakdownImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryBreakdownImpl(
  category: $enumDecode(_$WasteCategoryEnumMap, json['category']),
  count: (json['count'] as num).toInt(),
  share: (json['share'] as num).toDouble(),
);

Map<String, dynamic> _$$CategoryBreakdownImplToJson(
  _$CategoryBreakdownImpl instance,
) => <String, dynamic>{
  'category': _$WasteCategoryEnumMap[instance.category]!,
  'count': instance.count,
  'share': instance.share,
};

_$AccuracyMetricsImpl _$$AccuracyMetricsImplFromJson(
  Map<String, dynamic> json,
) => _$AccuracyMetricsImpl(
  overallAccuracy: (json['overallAccuracy'] as num).toDouble(),
  perCategory:
      (json['perCategory'] as List<dynamic>?)
          ?.map((e) => CategoryAccuracy.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CategoryAccuracy>[],
  commonMistakes:
      (json['commonMistakes'] as List<dynamic>?)
          ?.map((e) => CommonMistake.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CommonMistake>[],
  accuracyTrend:
      (json['accuracyTrend'] as List<dynamic>?)
          ?.map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TrendPoint>[],
);

Map<String, dynamic> _$$AccuracyMetricsImplToJson(
  _$AccuracyMetricsImpl instance,
) => <String, dynamic>{
  'overallAccuracy': instance.overallAccuracy,
  'perCategory': instance.perCategory,
  'commonMistakes': instance.commonMistakes,
  'accuracyTrend': instance.accuracyTrend,
};

_$CategoryAccuracyImpl _$$CategoryAccuracyImplFromJson(
  Map<String, dynamic> json,
) => _$CategoryAccuracyImpl(
  category: $enumDecode(_$WasteCategoryEnumMap, json['category']),
  accuracy: (json['accuracy'] as num).toDouble(),
  attempts: (json['attempts'] as num).toInt(),
);

Map<String, dynamic> _$$CategoryAccuracyImplToJson(
  _$CategoryAccuracyImpl instance,
) => <String, dynamic>{
  'category': _$WasteCategoryEnumMap[instance.category]!,
  'accuracy': instance.accuracy,
  'attempts': instance.attempts,
};
