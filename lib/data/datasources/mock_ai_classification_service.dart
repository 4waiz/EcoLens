import 'dart:typed_data';

import '../../core/constants/app_config.dart';
import '../../core/errors/failures.dart';
import '../../domain/models/waste_classification_result.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/ai_classification_service.dart';
import '../../domain/services/hardware_bridge_service.dart';
import '../mock/mock_database.dart';
import '../mock/mock_seed_data.dart';

/// Mock AI classifier.
///
/// Returns realistic results drawn from [MockSeedData.aiCatalogue]. Developers
/// can force a specific item, override confidence, force an error/timeout, or
/// switch to an "offline fallback" model — all via the dev panel.
///
/// A real implementation would replace this class with an adapter that POSTs
/// the captured bytes to a vision model and maps the response into a
/// [WasteClassificationResult] (see `// REAL-AI:` marker below).
class MockAiClassificationService implements AiClassificationService {
  MockAiClassificationService({
    required HardwareBridgeService hardware,
    required ConfigRepository configRepository,
    required MockDatabase db,
  }) : _hardware = hardware,
       _config = configRepository,
       _db = db;

  final HardwareBridgeService _hardware;
  final ConfigRepository _config;
  final MockDatabase _db;

  String? _forcedItemId;
  double? _forcedConfidence;
  bool _forceError = false;
  bool _offlineFallback = false;

  // Rotates through the catalogue so repeated demo scans vary naturally.
  int _rotation = 0;

  @override
  Future<WasteClassificationResult> captureAndClassify() async {
    final bytes = await _hardware.captureImage();
    return classifyImage(bytes);
  }

  @override
  Future<WasteClassificationResult> classifyImage(Uint8List image) async {
    await Future<void>.delayed(AppConfig.mockClassifyDelay);

    if (_forceError) {
      throw const ClassificationFailure(
        'The AI service did not respond in time.',
      );
    }

    // REAL-AI: replace everything below with a call to the vision backend, e.g.
    //   final resp = await _dio.post('/classify', data: image);
    //   return WasteClassificationResult.fromJson(resp.data);

    final catalogue = MockSeedData.aiCatalogue();
    final item = _forcedItemId != null
        ? catalogue.firstWhere(
            (c) => c.id == _forcedItemId,
            orElse: () => catalogue.first,
          )
        : catalogue[_rotation++ % catalogue.length];

    // Confidence: forced override wins, else the item's base confidence with a
    // small deterministic wobble so it isn't suspiciously static.
    final wobble = ((_rotation * 7) % 5 - 2) / 100.0; // -0.02..0.02
    var confidence = _forcedConfidence ?? (item.baseConfidence + wobble);
    if (_offlineFallback) {
      // The lightweight offline model is less confident.
      confidence = (confidence - 0.15).clamp(0.30, 0.99);
    }
    confidence = confidence.clamp(0.0, 1.0);

    return WasteClassificationResult(
      predictedCategory: item.category,
      detectedObjectName: item.name,
      confidence: confidence,
      condition: item.condition,
      contaminationDetected: item.contamination,
      explanation: item.explanation,
      educationalFact: item.fact,
      capturedImagePath: 'mock://capture/${item.id}.jpg',
      processedAt: DateTime.now(),
      isFallback: _offlineFallback,
    );
  }

  @override
  double getConfidenceThreshold() => _db.config.aiConfidenceThreshold;

  @override
  void setForcedItem(String? mockItemId) => _forcedItemId = mockItemId;

  @override
  void setForcedConfidence(double? confidence) =>
      _forcedConfidence = confidence;

  @override
  void setForceError(bool value) => _forceError = value;

  @override
  void setOfflineFallback(bool value) => _offlineFallback = value;

  // Kept for parity with the interface note; config drives the live threshold.
  // ignore: unused_element
  Future<double> _liveThreshold() async =>
      (await _config.getConfig()).aiConfidenceThreshold;
}
