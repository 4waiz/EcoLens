import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';
import '../enums/waste_category.dart';
import 'waste_classification_result.dart';

part 'recycling_session.freezed.dart';
part 'recycling_session.g.dart';

/// A single recycling interaction: the student scans an item, answers the
/// quiz, and receives feedback. Sessions are the unit of the offline queue and
/// the source of dashboard analytics.
@freezed
class RecyclingSession with _$RecyclingSession {
  const RecyclingSession._();

  const factory RecyclingSession({
    required String id,
    required String studentId,
    required String kioskId,
    required DateTime startedAt,
    DateTime? completedAt,
    WasteClassificationResult? classificationResult,
    WasteCategory? studentSelectedCategory,
    WasteCategory? finalCategory,
    @Default(false) bool wasCorrect,
    @Default(0) int pointsAwarded,
    @Default(0) int housePointsAwarded,
    @Default(0) int streakAfterSession,
    @Default(SessionStatus.active) SessionStatus status,
    @Default(HardwareCommandStatus.pending)
    HardwareCommandStatus hardwareCommandStatus,
    @Default(false) bool bonusApplied,
    @Default(false) bool dailyCapReached,
    // Idempotency key ensures an offline-queued session is only applied once.
    required String idempotencyKey,
  }) = _RecyclingSession;

  factory RecyclingSession.fromJson(Map<String, dynamic> json) =>
      _$RecyclingSessionFromJson(json);
}
