/// Typed failures surfaced by repositories and services. Kept deliberately
/// small; the UI maps these to friendly, non-technical, student-safe messages.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// A card was scanned but does not resolve to an active student account.
class UnknownCardFailure extends AppFailure {
  const UnknownCardFailure([super.message = 'Card not recognised']);
}

/// Authentication (teacher/admin/canteen credential) failed.
class AuthFailure extends AppFailure {
  const AuthFailure([super.message = 'Invalid credentials']);
}

/// A peripheral (camera, card reader, controller) is unavailable.
class HardwareFailure extends AppFailure {
  const HardwareFailure([super.message = 'Hardware unavailable']);
}

/// AI classification failed or timed out.
class ClassificationFailure extends AppFailure {
  const ClassificationFailure([super.message = 'Could not analyse the item']);
}

/// The device is offline and the operation cannot complete now.
class OfflineFailure extends AppFailure {
  const OfflineFailure([super.message = 'You are offline']);
}

/// A reward redemption was rejected (balance, limit, availability, auth).
class RedemptionFailure extends AppFailure {
  const RedemptionFailure(super.message);
}

/// An illegal kiosk state transition was attempted.
class InvalidStateTransitionFailure extends AppFailure {
  const InvalidStateTransitionFailure(super.message);
}

/// A generic not-found failure.
class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Not found']);
}
