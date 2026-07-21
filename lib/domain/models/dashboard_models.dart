import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/waste_category.dart';

part 'dashboard_models.freezed.dart';
part 'dashboard_models.g.dart';

/// A single named metric with an optional delta, rendered as a stat tile.
@freezed
class MetricValue with _$MetricValue {
  const factory MetricValue({
    required String label,
    required String value,
    @Default('') String delta,
    @Default(true) bool deltaPositive,
    @Default('') String caption,
  }) = _MetricValue;

  factory MetricValue.fromJson(Map<String, dynamic> json) =>
      _$MetricValueFromJson(json);
}

/// A single point on a time-series trend (e.g. daily participation).
@freezed
class TrendPoint with _$TrendPoint {
  const factory TrendPoint({
    required String label, // e.g. "Mon"
    required double value,
  }) = _TrendPoint;

  factory TrendPoint.fromJson(Map<String, dynamic> json) =>
      _$TrendPointFromJson(json);
}

/// A common-mistake row: students placing category X into category Y.
@freezed
class CommonMistake with _$CommonMistake {
  const CommonMistake._();

  const factory CommonMistake({
    required WasteCategory correctCategory,
    required WasteCategory chosenCategory,
    required int occurrences,
    @Default('') String exampleItem,
  }) = _CommonMistake;

  factory CommonMistake.fromJson(Map<String, dynamic> json) =>
      _$CommonMistakeFromJson(json);
}

/// Teacher overview aggregate.
@freezed
class TeacherOverview with _$TeacherOverview {
  const factory TeacherOverview({
    required int activeStudents,
    required int recyclingSessions,
    required double correctClassificationRate, // 0..1
    required double participationRate, // 0..1
    required int xpAwarded,
    required int housePoints,
    @Default(<MetricValue>[]) List<MetricValue> headlineMetrics,
    @Default(<TrendPoint>[]) List<TrendPoint> participationTrend,
    @Default(<CommonMistake>[]) List<CommonMistake> commonMistakes,
    @Default(<LeaderboardMini>[]) List<LeaderboardMini> topClasses,
    @Default(<LeaderboardMini>[]) List<LeaderboardMini> topHouses,
  }) = _TeacherOverview;

  factory TeacherOverview.fromJson(Map<String, dynamic> json) =>
      _$TeacherOverviewFromJson(json);
}

/// Admin overview aggregate.
@freezed
class AdminOverview with _$AdminOverview {
  const factory AdminOverview({
    required int totalStudents,
    required int activeKiosks,
    required int kiosksNeedingAttention,
    required int sessionsToday,
    required double systemAccuracy, // 0..1
    required int rewardsRedeemedToday,
    @Default(<MetricValue>[]) List<MetricValue> headlineMetrics,
    @Default(<TrendPoint>[]) List<TrendPoint> weeklySessions,
    @Default(<CategoryBreakdown>[]) List<CategoryBreakdown> categoryBreakdown,
  }) = _AdminOverview;

  factory AdminOverview.fromJson(Map<String, dynamic> json) =>
      _$AdminOverviewFromJson(json);
}

/// A compact leaderboard row for overview widgets.
@freezed
class LeaderboardMini with _$LeaderboardMini {
  const factory LeaderboardMini({
    required String name,
    required int points,
    @Default('#2E7D46') String colour,
    @Default(0.0) double progress,
  }) = _LeaderboardMini;

  factory LeaderboardMini.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardMiniFromJson(json);
}

/// Volume of items processed per waste category.
@freezed
class CategoryBreakdown with _$CategoryBreakdown {
  const CategoryBreakdown._();

  const factory CategoryBreakdown({
    required WasteCategory category,
    required int count,
    required double share, // 0..1
  }) = _CategoryBreakdown;

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$CategoryBreakdownFromJson(json);
}

/// Accuracy metric bundle for the teacher accuracy screen.
@freezed
class AccuracyMetrics with _$AccuracyMetrics {
  const factory AccuracyMetrics({
    required double overallAccuracy,
    @Default(<CategoryAccuracy>[]) List<CategoryAccuracy> perCategory,
    @Default(<CommonMistake>[]) List<CommonMistake> commonMistakes,
    @Default(<TrendPoint>[]) List<TrendPoint> accuracyTrend,
  }) = _AccuracyMetrics;

  factory AccuracyMetrics.fromJson(Map<String, dynamic> json) =>
      _$AccuracyMetricsFromJson(json);
}

@freezed
class CategoryAccuracy with _$CategoryAccuracy {
  const CategoryAccuracy._();

  const factory CategoryAccuracy({
    required WasteCategory category,
    required double accuracy,
    required int attempts,
  }) = _CategoryAccuracy;

  factory CategoryAccuracy.fromJson(Map<String, dynamic> json) =>
      _$CategoryAccuracyFromJson(json);
}
