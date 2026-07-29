import 'package:ecolens/data/datasources/mock_hardware_bridge_service.dart';
import 'package:ecolens/domain/enums/app_enums.dart';
import 'package:ecolens/domain/enums/waste_category.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the mock hardware bridge: logical commands + fault injection +
/// controller-disconnection behaviour.
void main() {
  late MockHardwareBridgeService hw;

  setUp(() => hw = MockHardwareBridgeService());
  tearDown(() => hw.dispose());

  test('initialise brings the controller online', () async {
    await hw.initialise();
    expect(hw.isInitialised, isTrue);
    final health = await hw.getControllerHealth();
    expect(health, HealthStatus.online);
  });

  test('open-slot command is acknowledged when connected', () async {
    await hw.initialise();
    final status = await hw.sendOpenSlotCommand(WasteCategory.plastic);
    expect(status, HardwareCommandStatus.acknowledged);
  });

  test(
    'open-slot command is queued when the controller is disconnected',
    () async {
      await hw.initialise();
      hw.setControllerConnected(false);
      final status = await hw.sendOpenSlotCommand(WasteCategory.paper);
      expect(status, HardwareCommandStatus.skippedOffline);
    },
  );

  test('capture throws when the camera is unavailable', () async {
    await hw.initialise();
    hw.setCameraAvailable(false);
    expect(hw.captureImage(), throwsA(isA<Exception>()));
  });

  test('simulating a card throws when the reader is unavailable', () async {
    await hw.initialise();
    hw.setCardReaderAvailable(false);
    expect(hw.simulateStudentCard('04A1B2C3D4'), throwsA(isA<Exception>()));
  });

  test('setting an LED updates the reported status', () async {
    await hw.initialise();
    await hw.setSlotLed(WasteCategory.organic, FeedbackColour.green);
    final status = await hw.getHealth();
    expect(status.slotLedStatuses[WasteCategory.organic], FeedbackColour.green);
  });

  test('clearAllLeds turns every slot off', () async {
    await hw.initialise();
    await hw.setSlotLed(WasteCategory.plastic, FeedbackColour.red);
    await hw.clearAllLeds();
    final status = await hw.getHealth();
    expect(
      status.slotLedStatuses.values.every((c) => c == FeedbackColour.off),
      isTrue,
    );
  });

  test('disconnect reports the controller offline', () async {
    await hw.initialise();
    await hw.disconnect();
    final health = await hw.getControllerHealth();
    expect(health, HealthStatus.offline);
  });

  test('fill levels can be injected and read back', () async {
    await hw.initialise();
    hw.setFillLevel(WasteCategory.general, 0.95);
    final levels = await hw.getFillLevels();
    expect(levels[WasteCategory.general], closeTo(0.95, 0.001));
  });
}
