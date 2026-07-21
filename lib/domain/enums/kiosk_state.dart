/// Explicit kiosk state machine states.
///
/// The kiosk is modelled as a strict finite state machine. Only the
/// transitions declared in [KioskStateX.canTransitionTo] are permitted;
/// everything else is rejected by the controller to avoid the UI ending up in
/// an impossible state (e.g. showing a reward summary with no student loaded).
enum KioskState {
  idle,
  waitingForCard,
  readingCard,
  studentRecognised,
  studentNotFound,
  readyToScan,
  capturingImage,
  analysingImage,
  classificationReady,
  waitingForStudentAnswer,
  processingAnswer,
  correctFeedback,
  incorrectFeedback,
  lowConfidenceFeedback,
  openingSlot,
  waitingForWasteDrop,
  rewardSummary,
  houseLeaderboard,
  guardianEvolution,
  sessionComplete,
  offline,
  maintenance,
  error;

  String get label => switch (this) {
    KioskState.idle => 'Idle',
    KioskState.waitingForCard => 'Waiting for card',
    KioskState.readingCard => 'Reading card',
    KioskState.studentRecognised => 'Student recognised',
    KioskState.studentNotFound => 'Student not found',
    KioskState.readyToScan => 'Ready to scan',
    KioskState.capturingImage => 'Capturing image',
    KioskState.analysingImage => 'Analysing image',
    KioskState.classificationReady => 'Classification ready',
    KioskState.waitingForStudentAnswer => 'Waiting for answer',
    KioskState.processingAnswer => 'Processing answer',
    KioskState.correctFeedback => 'Correct',
    KioskState.incorrectFeedback => 'Incorrect',
    KioskState.lowConfidenceFeedback => 'Low confidence',
    KioskState.openingSlot => 'Opening slot',
    KioskState.waitingForWasteDrop => 'Waiting for waste drop',
    KioskState.rewardSummary => 'Reward summary',
    KioskState.houseLeaderboard => 'House leaderboard',
    KioskState.guardianEvolution => 'Guardian evolution',
    KioskState.sessionComplete => 'Session complete',
    KioskState.offline => 'Offline',
    KioskState.maintenance => 'Maintenance',
    KioskState.error => 'Error',
  };
}

extension KioskStateX on KioskState {
  /// Whether a student is currently loaded in this state (used to decide
  /// whether the privacy service must clear student data on exit).
  bool get hasStudentLoaded => switch (this) {
    KioskState.idle ||
    KioskState.waitingForCard ||
    KioskState.readingCard ||
    KioskState.studentNotFound ||
    KioskState.offline ||
    KioskState.maintenance => false,
    _ => true,
  };

  /// Whether this state represents a terminal feedback outcome.
  bool get isFeedback => switch (this) {
    KioskState.correctFeedback ||
    KioskState.incorrectFeedback ||
    KioskState.lowConfidenceFeedback => true,
    _ => false,
  };

  /// Allowed target states from the current state. This is the single source
  /// of truth for the kiosk FSM.
  Set<KioskState> get allowedTransitions => switch (this) {
    KioskState.idle => {
      KioskState.waitingForCard,
      KioskState.readingCard, // dev panel can inject a card directly
      KioskState.offline,
      KioskState.maintenance,
      KioskState.error,
    },
    KioskState.waitingForCard => {
      KioskState.readingCard,
      KioskState.idle,
      KioskState.offline,
      KioskState.maintenance,
      KioskState.error,
    },
    KioskState.readingCard => {
      KioskState.studentRecognised,
      KioskState.studentNotFound,
      KioskState.idle,
      KioskState.error,
    },
    KioskState.studentNotFound => {
      KioskState.waitingForCard,
      KioskState.idle,
    },
    KioskState.studentRecognised => {
      KioskState.readyToScan,
      KioskState.houseLeaderboard,
      KioskState.guardianEvolution,
      KioskState.sessionComplete, // end session early
      KioskState.idle,
    },
    KioskState.readyToScan => {
      KioskState.capturingImage,
      KioskState.houseLeaderboard,
      KioskState.guardianEvolution,
      KioskState.sessionComplete,
      KioskState.error,
    },
    KioskState.capturingImage => {
      KioskState.analysingImage,
      KioskState.readyToScan, // retake / camera error
      KioskState.error,
    },
    KioskState.analysingImage => {
      KioskState.classificationReady,
      KioskState.readyToScan, // timeout / retry
      KioskState.error,
    },
    KioskState.classificationReady => {KioskState.waitingForStudentAnswer},
    KioskState.waitingForStudentAnswer => {
      KioskState.processingAnswer,
      KioskState.readyToScan, // cancel
      KioskState.sessionComplete,
    },
    KioskState.processingAnswer => {
      KioskState.correctFeedback,
      KioskState.incorrectFeedback,
      KioskState.lowConfidenceFeedback,
      KioskState.error,
    },
    KioskState.correctFeedback => {KioskState.openingSlot},
    KioskState.incorrectFeedback => {KioskState.openingSlot},
    KioskState.lowConfidenceFeedback => {KioskState.openingSlot},
    KioskState.openingSlot => {
      KioskState.waitingForWasteDrop,
      KioskState.rewardSummary,
      KioskState.error,
    },
    KioskState.waitingForWasteDrop => {KioskState.rewardSummary},
    KioskState.rewardSummary => {
      KioskState.readyToScan, // recycle another item
      KioskState.houseLeaderboard,
      KioskState.guardianEvolution,
      KioskState.sessionComplete,
    },
    KioskState.houseLeaderboard => {
      KioskState.studentRecognised,
      KioskState.readyToScan,
      KioskState.rewardSummary,
      KioskState.sessionComplete,
      KioskState.idle,
    },
    KioskState.guardianEvolution => {
      KioskState.studentRecognised,
      KioskState.readyToScan,
      KioskState.rewardSummary,
      KioskState.sessionComplete,
      KioskState.idle,
    },
    KioskState.sessionComplete => {KioskState.idle},
    KioskState.offline => {
      KioskState.idle,
      KioskState.waitingForCard,
      KioskState.maintenance,
    },
    KioskState.maintenance => {KioskState.idle, KioskState.offline},
    KioskState.error => {
      KioskState.idle,
      KioskState.sessionComplete,
      KioskState.maintenance,
    },
  };

  bool canTransitionTo(KioskState target) =>
      target == this || allowedTransitions.contains(target);
}
