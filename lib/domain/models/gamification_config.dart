import 'package:freezed_annotation/freezed_annotation.dart';

part 'gamification_config.freezed.dart';
part 'gamification_config.g.dart';

/// Admin-configurable gamification and AI rules. Nothing here is hardcoded in
/// the UI — every screen reads from this config so schools can retune points,
/// caps, streak policy, conversion and the AI confidence threshold.
@freezed
class GamificationConfig with _$GamificationConfig {
  const GamificationConfig._();

  const factory GamificationConfig({
    // ---- Points ----
    @Default(5) int pointsPerCorrect,
    @Default(0) int pointsPerIncorrect,
    @Default(50) int dailyPointsCap,
    @Default(5) int xpPerCorrect,

    // ---- Streak / bonus ----
    @Default(20) int bonusStreakThreshold,
    @Default(25)
    int bonusPoints, // AED 5 -> 25 points at 5pts=AED1... configurable
    @Default(true) bool weekendsCountAsActive,
    @Default(true) bool holidaysCountAsActive,
    @Default(1) int streakGraceDays, // extra approved-absence tolerance
    // ---- Monetary conversion ----
    @Default(true) bool monetaryConversionEnabled,
    @Default(50) int pointsPerCurrencyUnit, // 50 points = 1 AED
    @Default('AED') String currencyCode,

    // ---- AI ----
    @Default(0.80) double aiConfidenceThreshold,

    // ---- Privacy ----
    @Default(45) int inactivityTimeoutSeconds,
    @Default(0) int imageRetentionSeconds, // 0 = clear immediately
    @Default(8) int autoLogoutCountdownSeconds,
  }) = _GamificationConfig;

  factory GamificationConfig.fromJson(Map<String, dynamic> json) =>
      _$GamificationConfigFromJson(json);

  /// Converts points to a monetary value (0 if conversion disabled).
  double pointsToCurrency(int points) {
    if (!monetaryConversionEnabled || pointsPerCurrencyUnit <= 0) return 0;
    return points / pointsPerCurrencyUnit;
  }

  /// Formats a point amount as currency, e.g. "AED 1.50", or an empty string
  /// when monetary conversion is disabled.
  String formatCurrency(int points) {
    if (!monetaryConversionEnabled) return '';
    return '$currencyCode ${pointsToCurrency(points).toStringAsFixed(2)}';
  }
}
