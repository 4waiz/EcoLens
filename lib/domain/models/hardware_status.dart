import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';
import '../enums/waste_category.dart';

part 'hardware_status.freezed.dart';
part 'hardware_status.g.dart';

/// Live snapshot of the (existing) bin controller and its peripherals as seen
/// through the hardware bridge. Slot maps are keyed by [WasteCategory].
@freezed
class HardwareStatus with _$HardwareStatus {
  const HardwareStatus._();

  const factory HardwareStatus({
    @Default(HealthStatus.online) HealthStatus overallStatus,
    @Default(true) bool controllerConnected,
    @Default(true) bool cameraAvailable,
    @Default(true) bool cardReaderAvailable,
    @Default({}) Map<WasteCategory, FeedbackColour> slotLedStatuses,
    @Default({}) Map<WasteCategory, PeripheralStatus> slotStatuses,
    @Default(false) bool wastePresenceDetected,
    @Default({}) Map<WasteCategory, double> binFillLevels, // 0..1 per slot
    required DateTime lastUpdatedAt,
  }) = _HardwareStatus;

  factory HardwareStatus.fromJson(Map<String, dynamic> json) =>
      _$HardwareStatusFromJson(json);

  /// A safe default status for initialisation.
  factory HardwareStatus.initial() => HardwareStatus(
    overallStatus: HealthStatus.online,
    slotLedStatuses: {
      for (final c in WasteCategory.values) c: FeedbackColour.off,
    },
    slotStatuses: {
      for (final c in WasteCategory.values) c: PeripheralStatus.ok,
    },
    binFillLevels: {
      WasteCategory.plastic: 0.35,
      WasteCategory.paper: 0.52,
      WasteCategory.organic: 0.18,
      WasteCategory.general: 0.61,
    },
    lastUpdatedAt: DateTime.now(),
  );

  bool get anySlotFull => binFillLevels.values.any((v) => v >= 0.9);
}
