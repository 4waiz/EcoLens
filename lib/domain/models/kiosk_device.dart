import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'kiosk_device.freezed.dart';
part 'kiosk_device.g.dart';

/// A managed kiosk device (bin + tablet + controller) as shown in the admin
/// device-management screen.
@freezed
class KioskDevice with _$KioskDevice {
  const KioskDevice._();

  const factory KioskDevice({
    required String id,
    required String name,
    required String schoolLocation,
    @Default(PeripheralStatus.ok) PeripheralStatus controllerStatus,
    @Default(PeripheralStatus.ok) PeripheralStatus cameraStatus,
    @Default(PeripheralStatus.ok) PeripheralStatus nfcStatus,
    @Default(PeripheralStatus.ok) PeripheralStatus sensorStatus,
    @Default(PeripheralStatus.ok) PeripheralStatus internetStatus,
    required DateTime lastHeartbeat,
    @Default('1.0.0') String softwareVersion,
    @Default(false) bool maintenanceMode,
    @Default(0) int sessionsToday,
  }) = _KioskDevice;

  factory KioskDevice.fromJson(Map<String, dynamic> json) =>
      _$KioskDeviceFromJson(json);

  HealthStatus get health {
    if (maintenanceMode) return HealthStatus.maintenance;
    final statuses = [
      controllerStatus,
      cameraStatus,
      nfcStatus,
      sensorStatus,
      internetStatus,
    ];
    if (statuses.any((s) => s == PeripheralStatus.disconnected)) {
      return HealthStatus.offline;
    }
    if (statuses.any(
      (s) => s == PeripheralStatus.error || s == PeripheralStatus.warning,
    )) {
      return HealthStatus.degraded;
    }
    return HealthStatus.online;
  }

  Duration get sinceHeartbeat => DateTime.now().difference(lastHeartbeat);
}
