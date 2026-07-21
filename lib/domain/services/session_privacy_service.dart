import 'dart:async';

import '../models/gamification_config.dart';

/// Guards student privacy on the shared kiosk.
///
/// Responsibilities:
/// - Track an inactivity timer that auto-logs-out a student.
/// - Clear the loaded student and any captured waste image after the session
///   or after the configured retention window.
/// - Provide a single "resetKioskState" entry point used on session end.
///
/// This service is intentionally UI-agnostic: it exposes callbacks/timers the
/// kiosk controller wires to its own state reset.
class SessionPrivacyService {
  SessionPrivacyService();

  Timer? _inactivityTimer;
  Timer? _imageRetentionTimer;
  DateTime? _sessionStartedAt;

  /// Callback invoked when the inactivity timeout elapses.
  void Function()? onInactivityTimeout;

  /// Callback invoked when a captured image must be cleared.
  void Function()? onClearImage;

  bool get hasActiveSession => _sessionStartedAt != null;

  DateTime? get sessionStartedAt => _sessionStartedAt;

  /// Begin tracking a student session.
  void startStudentSession() {
    _sessionStartedAt = DateTime.now();
  }

  /// (Re)start the inactivity countdown. Call on every student interaction.
  void scheduleAutomaticTimeout(GamificationConfig config) {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(
      Duration(seconds: config.inactivityTimeoutSeconds),
      () => onInactivityTimeout?.call(),
    );
  }

  /// Schedule (or immediately perform) clearing of the captured image based on
  /// the configured retention period. 0 seconds = clear immediately.
  void scheduleImageClear(GamificationConfig config) {
    _imageRetentionTimer?.cancel();
    if (config.imageRetentionSeconds <= 0) {
      onClearImage?.call();
      return;
    }
    _imageRetentionTimer = Timer(
      Duration(seconds: config.imageRetentionSeconds),
      () => onClearImage?.call(),
    );
  }

  /// Clear captured image immediately (e.g. after processing completes).
  void clearCapturedImage() {
    _imageRetentionTimer?.cancel();
    onClearImage?.call();
  }

  /// End the student session and clear tracking.
  void clearStudentSession() {
    _sessionStartedAt = null;
    _inactivityTimer?.cancel();
    _imageRetentionTimer?.cancel();
  }

  /// Full reset: cancels timers and clears session (called by the controller
  /// when returning to idle). The controller is responsible for wiping the
  /// in-memory student/session objects it holds.
  void resetKioskState() {
    clearCapturedImage();
    clearStudentSession();
  }

  void dispose() {
    _inactivityTimer?.cancel();
    _imageRetentionTimer?.cancel();
  }
}
