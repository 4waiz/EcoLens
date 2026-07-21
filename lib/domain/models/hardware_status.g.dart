// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HardwareStatusImpl _$$HardwareStatusImplFromJson(Map<String, dynamic> json) =>
    _$HardwareStatusImpl(
      overallStatus:
          $enumDecodeNullable(_$HealthStatusEnumMap, json['overallStatus']) ??
          HealthStatus.online,
      controllerConnected: json['controllerConnected'] as bool? ?? true,
      cameraAvailable: json['cameraAvailable'] as bool? ?? true,
      cardReaderAvailable: json['cardReaderAvailable'] as bool? ?? true,
      slotLedStatuses:
          (json['slotLedStatuses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$WasteCategoryEnumMap, k),
              $enumDecode(_$FeedbackColourEnumMap, e),
            ),
          ) ??
          const {},
      slotStatuses:
          (json['slotStatuses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$WasteCategoryEnumMap, k),
              $enumDecode(_$PeripheralStatusEnumMap, e),
            ),
          ) ??
          const {},
      wastePresenceDetected: json['wastePresenceDetected'] as bool? ?? false,
      binFillLevels:
          (json['binFillLevels'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              $enumDecode(_$WasteCategoryEnumMap, k),
              (e as num).toDouble(),
            ),
          ) ??
          const {},
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );

Map<String, dynamic> _$$HardwareStatusImplToJson(
  _$HardwareStatusImpl instance,
) => <String, dynamic>{
  'overallStatus': _$HealthStatusEnumMap[instance.overallStatus]!,
  'controllerConnected': instance.controllerConnected,
  'cameraAvailable': instance.cameraAvailable,
  'cardReaderAvailable': instance.cardReaderAvailable,
  'slotLedStatuses': instance.slotLedStatuses.map(
    (k, e) => MapEntry(_$WasteCategoryEnumMap[k]!, _$FeedbackColourEnumMap[e]!),
  ),
  'slotStatuses': instance.slotStatuses.map(
    (k, e) =>
        MapEntry(_$WasteCategoryEnumMap[k]!, _$PeripheralStatusEnumMap[e]!),
  ),
  'wastePresenceDetected': instance.wastePresenceDetected,
  'binFillLevels': instance.binFillLevels.map(
    (k, e) => MapEntry(_$WasteCategoryEnumMap[k]!, e),
  ),
  'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
};

const _$HealthStatusEnumMap = {
  HealthStatus.online: 'online',
  HealthStatus.degraded: 'degraded',
  HealthStatus.offline: 'offline',
  HealthStatus.maintenance: 'maintenance',
  HealthStatus.unknown: 'unknown',
};

const _$FeedbackColourEnumMap = {
  FeedbackColour.off: 'off',
  FeedbackColour.green: 'green',
  FeedbackColour.red: 'red',
  FeedbackColour.houseColour: 'houseColour',
  FeedbackColour.amber: 'amber',
};

const _$WasteCategoryEnumMap = {
  WasteCategory.plastic: 'plastic',
  WasteCategory.paper: 'paper',
  WasteCategory.organic: 'organic',
  WasteCategory.general: 'general',
};

const _$PeripheralStatusEnumMap = {
  PeripheralStatus.ok: 'ok',
  PeripheralStatus.warning: 'warning',
  PeripheralStatus.error: 'error',
  PeripheralStatus.disconnected: 'disconnected',
};
