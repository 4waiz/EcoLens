import 'dart:typed_data';

import '../enums/app_enums.dart';
import '../enums/waste_category.dart';
import '../models/hardware_status.dart';

/// Abstraction over the client's EXISTING bin controller.
///
/// The domain never talks to a specific protocol. A concrete implementation may
/// later use REST, WebSocket, a local HTTP service, a serial bridge, MQTT, a
/// platform channel or a vendor-provided controller API. For the MVP the
/// [MockHardwareBridgeService] provides a fully working in-memory simulation.
///
/// IMPORTANT: EcoLens does NOT fabricate the bin, actuators, motors or LEDs —
/// those are owned by the client. This bridge only sends *logical* commands
/// (open this slot, set this LED colour) and reads status/telemetry.
abstract interface class HardwareBridgeService {
  /// Establish the connection / handshake with the controller.
  Future<void> initialise();

  /// Current controller + peripheral health snapshot.
  Future<HardwareStatus> getHealth();

  /// A live stream of hardware status updates (fill levels, LED state, etc.).
  Stream<HardwareStatus> get statusStream;

  /// A stream of card UIDs read by the physical NFC/RFID reader.
  Stream<String> listenForStudentCard();

  /// Developer-only: inject a card UID as if it were physically tapped.
  Future<void> simulateStudentCard(String cardUid);

  /// Capture an image of the item in the student's hand via the kiosk camera.
  /// Returns raw bytes (mock returns a small synthetic payload).
  Future<Uint8List> captureImage();

  /// Set the LED strip colour for a specific slot.
  Future<void> setSlotLed(WasteCategory category, FeedbackColour colour);

  /// Turn off every slot LED.
  Future<void> clearAllLeds();

  /// Send the logical open-slot command to the existing controller.
  Future<HardwareCommandStatus> sendOpenSlotCommand(WasteCategory category);

  /// A stream that emits when the waste-presence sensor detects a drop.
  Stream<bool> listenForWastePresence();

  /// One-shot read of the waste-presence sensor.
  Future<bool> readWastePresenceSensor();

  /// Current bin fill levels per slot (0..1).
  Future<Map<WasteCategory, double>> getFillLevels();

  /// Overall controller health rollup.
  Future<HealthStatus> getControllerHealth();

  /// Tear down the connection.
  Future<void> disconnect();

  // ---- Developer fault-injection hooks (no-op on real adapters) ----
  void setCameraAvailable(bool available);
  void setCardReaderAvailable(bool available);
  void setControllerConnected(bool connected);
  void setFillLevel(WasteCategory category, double level);
  void setWastePresence(bool present);
}
