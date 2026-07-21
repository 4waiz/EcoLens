import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';
import '../enums/waste_category.dart';

part 'waste_classification_result.freezed.dart';
part 'waste_classification_result.g.dart';

/// The result returned by the AI classification service for a captured item.
@freezed
class WasteClassificationResult with _$WasteClassificationResult {
  const WasteClassificationResult._();

  const factory WasteClassificationResult({
    required WasteCategory predictedCategory,
    required String detectedObjectName,
    required double confidence, // 0..1
    @Default(ItemCondition.clean) ItemCondition condition,
    @Default(false) bool contaminationDetected,
    required String explanation,
    required String educationalFact,
    String? capturedImagePath, // cleared by privacy service after processing
    required DateTime processedAt,
    @Default(false) bool isFallback, // true if produced by offline/local model
  }) = _WasteClassificationResult;

  factory WasteClassificationResult.fromJson(Map<String, dynamic> json) =>
      _$WasteClassificationResultFromJson(json);

  int get confidencePercent => (confidence * 100).round();

  /// Whether the confidence clears the given threshold (default 0.80).
  bool clearsThreshold(double threshold) => confidence >= threshold;

  /// The category the item should actually be routed to given a threshold:
  /// below threshold always routes to General Waste (safe default).
  WasteCategory routedCategory(double threshold) =>
      clearsThreshold(threshold) ? predictedCategory : WasteCategory.general;
}
