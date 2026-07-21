import 'package:ecolens/domain/models/gamification_config.dart';
import 'package:ecolens/domain/services/session_privacy_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for the session privacy service: timeout scheduling + data clearing.
void main() {
  test('a session can be started and reports active', () {
    final svc = SessionPrivacyService();
    expect(svc.hasActiveSession, isFalse);
    svc.startStudentSession();
    expect(svc.hasActiveSession, isTrue);
    svc.dispose();
  });

  test('clearStudentSession ends the session', () {
    final svc = SessionPrivacyService();
    svc.startStudentSession();
    svc.clearStudentSession();
    expect(svc.hasActiveSession, isFalse);
    svc.dispose();
  });

  test('image is cleared immediately when retention is zero', () {
    final svc = SessionPrivacyService();
    var cleared = false;
    svc.onClearImage = () => cleared = true;
    svc.scheduleImageClear(const GamificationConfig(imageRetentionSeconds: 0));
    expect(cleared, isTrue);
    svc.dispose();
  });

  test('inactivity timeout fires after the configured duration', () {
    fakeAsync((async) {
      final svc = SessionPrivacyService();
      var timedOut = false;
      svc.onInactivityTimeout = () => timedOut = true;
      svc.startStudentSession();
      svc.scheduleAutomaticTimeout(
        const GamificationConfig(inactivityTimeoutSeconds: 5),
      );
      expect(timedOut, isFalse);
      async.elapse(const Duration(seconds: 6));
      expect(timedOut, isTrue);
      svc.dispose();
    });
  });

  test('resetKioskState clears session and captured image', () {
    final svc = SessionPrivacyService();
    var cleared = false;
    svc.onClearImage = () => cleared = true;
    svc.startStudentSession();
    svc.resetKioskState();
    expect(svc.hasActiveSession, isFalse);
    expect(cleared, isTrue);
    svc.dispose();
  });
}
