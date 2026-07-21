import 'dart:typed_data';

import '../../domain/models/waste_classification_result.dart';
import '../../domain/services/ai_classification_service.dart';

/// ============================================================================
/// REAL AI CLASSIFICATION ADAPTER (STUB — not wired in the MVP)
/// ============================================================================
///
/// Integration seam for the vision backend. Implement [classifyImage] to send
/// the captured bytes to your model and map the response into a
/// [WasteClassificationResult]. Suggested contract for a hosted classifier:
///
///   POST {baseUrl}/v1/classify   (multipart or raw image bytes)
///   → 200 {
///       "category": "plastic|paper|organic|general",
///       "object": "Plastic Water Bottle",
///       "confidence": 0.94,
///       "condition": "clean|contaminated|wet|unknown",
///       "contaminated": false,
///       "explanation": "...",
///       "fact": "..."
///     }
///
/// The 80% confidence-threshold business rule is enforced in the domain
/// ([WasteClassificationResult.routedCategory] + GamificationService), NOT here,
/// so the classifier only needs to return an honest confidence value.
///
/// Register this instead of the mock in `AppBootstrap` for production. The dev
/// override setters are no-ops because production must not be tamperable.
class RealAiClassificationAdapter implements AiClassificationService {
  RealAiClassificationAdapter({
    required this.baseUrl,
    required double confidenceThreshold,
  }) : _threshold = confidenceThreshold;

  final String baseUrl;
  final double _threshold;

  static const String _unimplemented =
      'RealAiClassificationAdapter is a stub. Provide a concrete vision '
      'backend implementation before enabling production AI.';

  @override
  Future<WasteClassificationResult> captureAndClassify() async =>
      throw UnimplementedError(_unimplemented);

  @override
  Future<WasteClassificationResult> classifyImage(Uint8List image) async =>
      throw UnimplementedError(_unimplemented);

  @override
  double getConfidenceThreshold() => _threshold;

  @override
  void setForcedItem(String? mockItemId) {}
  @override
  void setForcedConfidence(double? confidence) {}
  @override
  void setForceError(bool value) {}
  @override
  void setOfflineFallback(bool value) {}
}
