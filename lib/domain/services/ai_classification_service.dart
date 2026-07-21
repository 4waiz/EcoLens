import 'dart:typed_data';

import '../models/waste_classification_result.dart';

/// Abstraction over the AI waste-classification backend.
///
/// A concrete implementation will POST the captured image to a vision model
/// (e.g. a hosted classifier or an on-device model). The MVP ships a
/// [MockAiClassificationService] that returns realistic, deterministic-ish
/// results and honours a developer-set confidence override.
abstract interface class AiClassificationService {
  /// Capture (via the hardware bridge) and classify in one call.
  Future<WasteClassificationResult> captureAndClassify();

  /// Classify already-captured image bytes.
  Future<WasteClassificationResult> classifyImage(Uint8List image);

  /// The confidence threshold below which items route to General Waste.
  double getConfidenceThreshold();

  // ---- Developer overrides (no-op on real adapters) ----

  /// Force the next classification to a specific mock item id.
  void setForcedItem(String? mockItemId);

  /// Force the next classification's confidence (0..1); null clears.
  void setForcedConfidence(double? confidence);

  /// Force the classifier into an error/timeout state for the next call.
  void setForceError(bool value);

  /// Switch to the offline/local fallback model.
  void setOfflineFallback(bool value);
}
