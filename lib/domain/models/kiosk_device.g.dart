// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kiosk_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KioskDeviceImpl _$$KioskDeviceImplFromJson(
  Map<String, dynamic> json,
) => _$KioskDeviceImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  schoolLocation: json['schoolLocation'] as String,
  controllerStatus:
      $enumDecodeNullable(
        _$PeripheralStatusEnumMap,
        json['controllerStatus'],
      ) ??
      PeripheralStatus.ok,
  cameraStatus:
      $enumDecodeNullable(_$PeripheralStatusEnumMap, json['cameraStatus']) ??
      PeripheralStatus.ok,
  nfcStatus:
      $enumDecodeNullable(_$PeripheralStatusEnumMap, json['nfcStatus']) ??
      PeripheralStatus.ok,
  sensorStatus:
      $enumDecodeNullable(_$PeripheralStatusEnumMap, json['sensorStatus']) ??
      PeripheralStatus.ok,
  internetStatus:
      $enumDecodeNullable(_$PeripheralStatusEnumMap, json['internetStatus']) ??
      PeripheralStatus.ok,
  lastHeartbeat: DateTime.parse(json['lastHeartbeat'] as String),
  softwareVersion: json['softwareVersion'] as String? ?? '1.0.0',
  maintenanceMode: json['maintenanceMode'] as bool? ?? false,
  sessionsToday: (json['sessionsToday'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$KioskDeviceImplToJson(_$KioskDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'schoolLocation': instance.schoolLocation,
      'controllerStatus': _$PeripheralStatusEnumMap[instance.controllerStatus]!,
      'cameraStatus': _$PeripheralStatusEnumMap[instance.cameraStatus]!,
      'nfcStatus': _$PeripheralStatusEnumMap[instance.nfcStatus]!,
      'sensorStatus': _$PeripheralStatusEnumMap[instance.sensorStatus]!,
      'internetStatus': _$PeripheralStatusEnumMap[instance.internetStatus]!,
      'lastHeartbeat': instance.lastHeartbeat.toIso8601String(),
      'softwareVersion': instance.softwareVersion,
      'maintenanceMode': instance.maintenanceMode,
      'sessionsToday': instance.sessionsToday,
    };

const _$PeripheralStatusEnumMap = {
  PeripheralStatus.ok: 'ok',
  PeripheralStatus.warning: 'warning',
  PeripheralStatus.error: 'error',
  PeripheralStatus.disconnected: 'disconnected',
};
