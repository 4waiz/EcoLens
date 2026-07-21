import 'dart:async';
import 'dart:typed_data';

import '../../core/constants/app_config.dart';
import '../../core/errors/failures.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/enums/waste_category.dart';
import '../../domain/models/hardware_status.dart';
import '../../domain/services/hardware_bridge_service.dart';

/// Fully working in-memory simulation of the client's bin controller.
///
/// It maintains LED states, fill levels, sensor state and connection health,
/// and exposes fault-injection setters used by the developer panel. It sends no
/// real signals — a production adapter (REST/WS/serial/MQTT/platform-channel)
/// would implement this same interface and translate these logical commands.
class MockHardwareBridgeService implements HardwareBridgeService {
  MockHardwareBridgeService();

  final _statusController = StreamController<HardwareStatus>.broadcast();
  final _cardController = StreamController<String>.broadcast();
  final _wasteController = StreamController<bool>.broadcast();

  bool _cameraAvailable = true;
  bool _cardReaderAvailable = true;
  bool _controllerConnected = true;
  bool _wastePresence = false;
  bool _initialised = false;

  final Map<WasteCategory, FeedbackColour> _leds = {
    for (final c in WasteCategory.values) c: FeedbackColour.off,
  };
  final Map<WasteCategory, double> _fill = {
    WasteCategory.plastic: 0.35,
    WasteCategory.paper: 0.52,
    WasteCategory.organic: 0.18,
    WasteCategory.general: 0.61,
  };

  @override
  Future<void> initialise() async {
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    _initialised = true;
    _emit();
  }

  HardwareStatus _snapshot() {
    final overall = !_controllerConnected
        ? HealthStatus.offline
        : (!_cameraAvailable || !_cardReaderAvailable)
        ? HealthStatus.degraded
        : HealthStatus.online;
    return HardwareStatus(
      overallStatus: overall,
      controllerConnected: _controllerConnected,
      cameraAvailable: _cameraAvailable,
      cardReaderAvailable: _cardReaderAvailable,
      slotLedStatuses: Map.of(_leds),
      slotStatuses: {
        for (final c in WasteCategory.values)
          c: _controllerConnected
              ? PeripheralStatus.ok
              : PeripheralStatus.disconnected,
      },
      wastePresenceDetected: _wastePresence,
      binFillLevels: Map.of(_fill),
      lastUpdatedAt: DateTime.now(),
    );
  }

  void _emit() {
    if (!_statusController.isClosed) _statusController.add(_snapshot());
  }

  @override
  Future<HardwareStatus> getHealth() async {
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    return _snapshot();
  }

  @override
  Stream<HardwareStatus> get statusStream => _statusController.stream;

  @override
  Stream<String> listenForStudentCard() => _cardController.stream;

  @override
  Future<void> simulateStudentCard(String cardUid) async {
    if (!_cardReaderAvailable) {
      throw const HardwareFailure('Card reader is unavailable.');
    }
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    _cardController.add(cardUid);
  }

  @override
  Future<Uint8List> captureImage() async {
    if (!_cameraAvailable) {
      throw const HardwareFailure('Camera is unavailable.');
    }
    await Future<void>.delayed(AppConfig.mockCaptureDelay);
    // Synthetic payload — a real bridge returns JPEG/PNG bytes from the camera.
    return Uint8List.fromList(
      List<int>.generate(64, (i) => (i * 7 + 13) % 256),
    );
  }

  @override
  Future<void> setSlotLed(WasteCategory category, FeedbackColour colour) async {
    if (!_controllerConnected) {
      throw const HardwareFailure('Controller disconnected.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 120));
    _leds[category] = colour;
    _emit();
  }

  @override
  Future<void> clearAllLeds() async {
    for (final c in WasteCategory.values) {
      _leds[c] = FeedbackColour.off;
    }
    _emit();
  }

  @override
  Future<HardwareCommandStatus> sendOpenSlotCommand(
    WasteCategory category,
  ) async {
    if (!_controllerConnected) {
      return HardwareCommandStatus.skippedOffline;
    }
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    // Simulate a small fill increase after a successful drop.
    _fill[category] = ((_fill[category] ?? 0) + 0.03).clamp(0.0, 1.0);
    _emit();
    return HardwareCommandStatus.acknowledged;
  }

  @override
  Stream<bool> listenForWastePresence() => _wasteController.stream;

  @override
  Future<bool> readWastePresenceSensor() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _wastePresence;
  }

  @override
  Future<Map<WasteCategory, double>> getFillLevels() async {
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    return Map.of(_fill);
  }

  @override
  Future<HealthStatus> getControllerHealth() async {
    await Future<void>.delayed(AppConfig.mockHardwareDelay);
    return _snapshot().overallStatus;
  }

  @override
  Future<void> disconnect() async {
    _controllerConnected = false;
    _emit();
  }

  // ---- Fault-injection setters (dev panel) ----

  @override
  void setCameraAvailable(bool available) {
    _cameraAvailable = available;
    _emit();
  }

  @override
  void setCardReaderAvailable(bool available) {
    _cardReaderAvailable = available;
    _emit();
  }

  @override
  void setControllerConnected(bool connected) {
    _controllerConnected = connected;
    _emit();
  }

  @override
  void setFillLevel(WasteCategory category, double level) {
    _fill[category] = level.clamp(0.0, 1.0);
    _emit();
  }

  @override
  void setWastePresence(bool present) {
    _wastePresence = present;
    if (!_wasteController.isClosed) _wasteController.add(present);
    _emit();
  }

  bool get isInitialised => _initialised;

  void dispose() {
    _statusController.close();
    _cardController.close();
    _wasteController.close();
  }
}
