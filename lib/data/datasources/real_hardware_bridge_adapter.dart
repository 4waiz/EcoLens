import 'dart:async';
import 'dart:typed_data';

import '../../domain/enums/app_enums.dart';
import '../../domain/enums/waste_category.dart';
import '../../domain/models/hardware_status.dart';
import '../../domain/services/hardware_bridge_service.dart';

/// ============================================================================
/// REAL HARDWARE INTEGRATION ADAPTER (STUB — not wired in the MVP)
/// ============================================================================
///
/// This is the integration seam for the client's EXISTING bin controller.
/// EcoLens never fabricates hardware; it only sends logical commands and reads
/// telemetry through [HardwareBridgeService].
///
/// To integrate a real controller, implement each method against the vendor's
/// transport. Common options and where to plug them in:
///
///  • REST         → POST /slots/{category}/open, GET /health, GET /fill
///  • WebSocket    → subscribe to a status channel; send {cmd:"openSlot",...}
///  • Local HTTP   → a small service on the kiosk device bridging to serial
///  • Serial       → a native side channel (see platform-channel option)
///  • MQTT         → publish `ecolens/bin/<id>/openSlot`, subscribe `.../status`
///  • Platform ch. → MethodChannel('ecolens/hardware') to a native plugin
///
/// The domain and UI depend ONLY on the interface, so swapping this in requires
/// no changes above the data layer — register it instead of the mock in
/// `AppBootstrap` for [AppEnvironment.production].
class RealHardwareBridgeAdapter implements HardwareBridgeService {
  RealHardwareBridgeAdapter({required this.endpoint});

  /// e.g. "ws://localhost:8081/bin-controller" or "http://127.0.0.1:8080".
  final String endpoint;

  static const String _unimplemented =
      'RealHardwareBridgeAdapter is a stub. Provide a concrete transport '
      'implementation before enabling production hardware.';

  @override
  Future<void> initialise() async => throw UnimplementedError(_unimplemented);

  @override
  Future<HardwareStatus> getHealth() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Stream<HardwareStatus> get statusStream =>
      throw UnimplementedError(_unimplemented);

  @override
  Stream<String> listenForStudentCard() =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<void> simulateStudentCard(String cardUid) async {
    // No-op on real hardware: cards are read by the physical NFC/RFID reader.
  }

  @override
  Future<Uint8List> captureImage() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<void> setSlotLed(WasteCategory category, FeedbackColour colour) async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<void> clearAllLeds() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<HardwareCommandStatus> sendOpenSlotCommand(
    WasteCategory category,
  ) async =>
      throw UnimplementedError(_unimplemented);

  @override
  Stream<bool> listenForWastePresence() =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<bool> readWastePresenceSensor() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<Map<WasteCategory, double>> getFillLevels() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<HealthStatus> getControllerHealth() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<void> disconnect() async {}

  // Fault-injection setters are developer-only no-ops on real hardware.
  @override
  void setCameraAvailable(bool available) {}
  @override
  void setCardReaderAvailable(bool available) {}
  @override
  void setControllerConnected(bool connected) {}
  @override
  void setFillLevel(WasteCategory category, double level) {}
  @override
  void setWastePresence(bool present) {}
}
