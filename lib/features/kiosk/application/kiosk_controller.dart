import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_config.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/enums/app_enums.dart';
import '../../../domain/enums/kiosk_state.dart';
import '../../../domain/enums/waste_category.dart';
import '../../../domain/models/models.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/services/ai_classification_service.dart';
import '../../../domain/services/auth_service.dart';
import '../../../domain/services/gamification_service.dart';
import '../../../domain/services/hardware_bridge_service.dart';
import '../../../domain/services/session_privacy_service.dart';
import 'kiosk_session_state.dart';

/// The kiosk finite-state-machine controller.
///
/// Owns the full student journey: card read → profile → scan → AI → quiz →
/// feedback → open slot → reward summary → session clear. Every transition is
/// validated against [KioskStateX.allowedTransitions]; illegal transitions are
/// refused (and reported in debug) so the UI can never reach an impossible
/// state. Student data + captured image are cleared on session end via the
/// [SessionPrivacyService].
class KioskController extends StateNotifier<KioskSessionState> {
  KioskController(this._ref) : super(const KioskSessionState()) {
    _init();
  }

  final Ref _ref;
  final _uuid = const Uuid();

  AuthService get _auth => _ref.read(authServiceProvider);
  HardwareBridgeService get _hw => _ref.read(hardwareBridgeProvider);
  AiClassificationService get _ai => _ref.read(aiClassificationProvider);
  GamificationService get _game => _ref.read(gamificationServiceProvider);
  StudentRepository get _students => _ref.read(studentRepositoryProvider);
  HouseRepository get _houses => _ref.read(houseRepositoryProvider);
  AvatarRepository get _avatars => _ref.read(avatarRepositoryProvider);
  SessionRepository get _sessions => _ref.read(sessionRepositoryProvider);
  ConfigRepository get _configRepo => _ref.read(configRepositoryProvider);
  SessionPrivacyService get _privacy =>
      _ref.read(sessionPrivacyServiceProvider);

  StreamSubscription<String>? _cardSub;
  Timer? _logoutTimer;
  String? _activeIdempotencyKey;

  Future<void> _init() async {
    // Wire privacy callbacks + the card listener synchronously so a card tap
    // that arrives during async config loading is never missed.
    _privacy.onInactivityTimeout = () => endSession(reason: SessionStatus.timedOut);
    _privacy.onClearImage = _wipeCapturedImage;
    _cardSub = _hw.listenForStudentCard().listen(_onCardScanned);

    // Load config + queue depth WITHOUT touching the `state` FSM field — the
    // controller already starts at `idle`, and a session may have begun before
    // these awaits complete (do not clobber an in-progress flow).
    final config = await _configRepo.getConfig();
    state = state.copyWith(config: config);
    final queued = await _sessions.getQueuedSessions();
    state = state.copyWith(queuedCount: queued.length);
  }

  // ---------------------------------------------------------------------------
  // Transition guard
  // ---------------------------------------------------------------------------

  /// Attempt a transition to [target]. Returns false (and logs) if illegal.
  bool _transition(KioskState target) {
    if (!state.state.canTransitionTo(target)) {
      assert(() {
        debugPrint(
          'KIOSK: illegal transition ${state.state.name} → ${target.name}',
        );
        return true;
      }());
      return false;
    }
    state = state.copyWith(state: target);
    return true;
  }

  /// Public helper used by the dev panel + tests to assert legality.
  bool canTransitionTo(KioskState target) => state.state.canTransitionTo(target);

  // ---------------------------------------------------------------------------
  // Idle / attract
  // ---------------------------------------------------------------------------

  void beginWaitingForCard() {
    if (state.state == KioskState.idle) _transition(KioskState.waitingForCard);
  }

  Future<void> setOffline(bool offline) async {
    state = state.copyWith(isOffline: offline);
    if (offline && state.state == KioskState.idle) {
      _transition(KioskState.offline);
    } else if (!offline && state.state == KioskState.offline) {
      _transition(KioskState.idle);
      // Flush any queued sessions on reconnect (idempotent).
      final synced = await _sessions.flushQueue();
      if (synced > 0) {
        final remaining = await _sessions.getQueuedSessions();
        state = state.copyWith(queuedCount: remaining.length);
      }
    }
  }

  void enterMaintenance() => _transition(KioskState.maintenance);
  void exitMaintenance() => _transition(KioskState.idle);

  // ---------------------------------------------------------------------------
  // Card handling
  // ---------------------------------------------------------------------------

  Future<void> _onCardScanned(String cardUid) async {
    // Ignore taps while mid-session.
    if (state.hasStudent) return;
    await readCard(cardUid);
  }

  /// Read + resolve a card. Drives idle → readingCard → recognised/notFound.
  Future<void> readCard(String cardUid) async {
    if (state.state == KioskState.idle) {
      _transition(KioskState.waitingForCard);
    }
    if (!_transition(KioskState.readingCard)) return;

    final config = await _configRepo.getConfig();
    final result = await _auth.authenticateStudentCard(cardUid);

    await result.when(
      ok: (student) async {
        final house = await _houses.getHouseById(student.houseId);
        final avatar = await _avatars.getAvatarById(student.avatarId);
        final ladder = await _avatars.getEvolutionLadder();

        _privacy.startStudentSession();
        _privacy.scheduleAutomaticTimeout(config);

        state = state.copyWith(
          student: student,
          house: house,
          avatar: avatar,
          evolutionLadder: ladder,
          config: config,
          itemsThisSession: 0,
          clearOutcome: true,
          clearClassification: true,
          clearSelected: true,
        );
        _transition(KioskState.studentRecognised);
      },
      err: (failure) async {
        state = state.copyWith(errorMessage: failure.message);
        _transition(KioskState.studentNotFound);
      },
    );
  }

  void retryCard() {
    state = state.copyWith(clearError: true);
    _transition(KioskState.waitingForCard);
  }

  // ---------------------------------------------------------------------------
  // Scanning + AI
  // ---------------------------------------------------------------------------

  void goToScan() {
    _touch();
    _transition(KioskState.readyToScan);
  }

  /// Capture the item and run classification.
  Future<void> scanItem() async {
    _touch();
    if (!_transition(KioskState.capturingImage)) return;

    try {
      // Capture happens inside captureAndClassify via the hardware bridge.
      _transition(KioskState.analysingImage);
      final result = await _ai.captureAndClassify().timeout(
        const Duration(seconds: 8),
      );
      state = state.copyWith(classification: result, clearSelected: true);
      _transition(KioskState.classificationReady);
      _transition(KioskState.waitingForStudentAnswer);
    } on HardwareFailure catch (e) {
      state = state.copyWith(errorMessage: e.message);
      _transition(KioskState.readyToScan);
    } on ClassificationFailure catch (e) {
      // Safe fallback: if configured, staff-assist; here we route to General.
      state = state.copyWith(errorMessage: e.message);
      _transition(KioskState.readyToScan);
    } on TimeoutException {
      state = state.copyWith(
        errorMessage: 'The AI took too long. Please try again.',
      );
      _transition(KioskState.readyToScan);
    }
  }

  void cancelScan() {
    _touch();
    _wipeCapturedImage();
    state = state.copyWith(clearClassification: true, clearSelected: true);
    _transition(KioskState.readyToScan);
  }

  // ---------------------------------------------------------------------------
  // Answer + scoring
  // ---------------------------------------------------------------------------

  bool _processing = false;

  /// The student picks a bin. Guarded against double-submission.
  Future<void> submitAnswer(WasteCategory selected) async {
    _touch();
    if (_processing) return;
    if (state.state != KioskState.waitingForStudentAnswer) return;
    final classification = state.classification;
    final student = state.student;
    if (classification == null || student == null) return;

    _processing = true;
    state = state.copyWith(selectedCategory: selected);
    if (!_transition(KioskState.processingAnswer)) {
      _processing = false;
      return;
    }

    final config = state.config;
    final routed = classification.routedCategory(config.aiConfidenceThreshold);
    final isLowConfidence =
        !classification.clearsThreshold(config.aiConfidenceThreshold);
    final wasCorrect = _game.isSelectionCorrect(
      result: classification,
      selected: selected,
      config: config,
    );

    // Score it (pure).
    final outcome = _game.calculateSessionRewards(
      student: student,
      wasCorrect: wasCorrect,
      config: config,
    );

    // Build + persist the session (with idempotency for offline safety).
    _activeIdempotencyKey = _uuid.v4();
    final session = RecyclingSession(
      id: 'sess-${DateTime.now().microsecondsSinceEpoch}',
      studentId: student.id,
      kioskId: AppConfig.demoKioskId,
      startedAt: DateTime.now(),
      completedAt: DateTime.now(),
      classificationResult: classification,
      studentSelectedCategory: selected,
      finalCategory: routed,
      wasCorrect: wasCorrect,
      pointsAwarded: outcome.totalPoints,
      housePointsAwarded: outcome.housePointsAwarded,
      streakAfterSession: outcome.newStreak,
      status: state.isOffline
          ? SessionStatus.queuedOffline
          : SessionStatus.completed,
      hardwareCommandStatus: HardwareCommandStatus.pending,
      bonusApplied: outcome.bonusApplied,
      dailyCapReached: outcome.dailyCapReached,
      idempotencyKey: _activeIdempotencyKey!,
    );

    // Detect avatar stage change for the celebration.
    final oldStage = _game.unlockAvatarStage(
      totalXp: student.totalXp,
      ladder: state.evolutionLadder,
    );
    final newTotalXp = student.totalXp + outcome.xpAwarded;
    final newStage = _game.unlockAvatarStage(
      totalXp: newTotalXp,
      ladder: state.evolutionLadder,
    );
    final stageChanged = newStage.stageIndex != oldStage.stageIndex;

    // Apply to persistence (or queue offline).
    Student updatedStudent = student;
    if (state.isOffline) {
      await _sessions.enqueueSession(session);
      final queued = await _sessions.getQueuedSessions();
      state = state.copyWith(queuedCount: queued.length);
      // Optimistically reflect locally.
      updatedStudent = student.copyWith(
        totalXp: newTotalXp,
        availablePoints: student.availablePoints + outcome.totalPoints,
        currentStreak: outcome.newStreak,
      );
    } else {
      await _sessions.saveSession(session);
      updatedStudent = await _students.applySessionOutcome(session);
    }

    final outcomeView = SessionOutcomeView(
      wasCorrect: wasCorrect,
      isLowConfidence: isLowConfidence,
      selected: selected,
      correctCategory: routed,
      pointsAwarded: outcome.basePoints,
      bonusPoints: outcome.bonusPoints,
      xpAwarded: outcome.xpAwarded,
      housePoints: outcome.housePointsAwarded,
      newStreak: outcome.newStreak,
      bonusApplied: outcome.bonusApplied,
      dailyCapReached: outcome.dailyCapReached,
      newTotalXp: updatedStudent.totalXp,
      newAvailablePoints: updatedStudent.availablePoints,
      stageChanged: stageChanged,
      newStage: stageChanged ? newStage : null,
    );

    final refreshedAvatar = await _avatars.getAvatarById(student.avatarId);
    final refreshedHouse = await _houses.getHouseById(student.houseId);

    state = state.copyWith(
      student: updatedStudent,
      avatar: refreshedAvatar,
      house: refreshedHouse,
      lastOutcome: outcomeView,
      session: session,
      itemsThisSession: state.itemsThisSession + 1,
    );

    // Feedback state.
    if (isLowConfidence) {
      _transition(KioskState.lowConfidenceFeedback);
    } else if (wasCorrect) {
      _transition(KioskState.correctFeedback);
    } else {
      _transition(KioskState.incorrectFeedback);
    }

    _processing = false;

    // Drive the LEDs on the (existing) controller for feedback.
    unawaited(_driveFeedbackLeds(selected: selected, correct: routed, wasCorrect: wasCorrect));
  }

  Future<void> _driveFeedbackLeds({
    required WasteCategory selected,
    required WasteCategory correct,
    required bool wasCorrect,
  }) async {
    try {
      if (!wasCorrect) {
        await _hw.setSlotLed(selected, FeedbackColour.red);
      }
      await _hw.setSlotLed(correct, FeedbackColour.green);
    } catch (_) {
      // Non-fatal — hardware health is surfaced elsewhere.
    }
  }

  /// After feedback, send the open-slot command and move to reward summary.
  Future<void> openSlotAndContinue() async {
    _touch();
    final outcome = state.lastOutcome;
    if (outcome == null) return;
    if (!_transition(KioskState.openingSlot)) return;

    HardwareCommandStatus cmd;
    try {
      cmd = await _hw.sendOpenSlotCommand(outcome.correctCategory);
    } catch (_) {
      cmd = HardwareCommandStatus.failed;
    }
    state = state.copyWith(hardwareCommandStatus: cmd);

    // Update the persisted session's hardware status.
    final s = state.session;
    if (s != null) {
      await _sessions.saveSession(s.copyWith(hardwareCommandStatus: cmd));
    }

    _transition(KioskState.rewardSummary);
    _wipeCapturedImage();
  }

  // ---------------------------------------------------------------------------
  // Post-session navigation
  // ---------------------------------------------------------------------------

  void recycleAnother() {
    _touch();
    state = state.copyWith(
      clearClassification: true,
      clearSelected: true,
      clearOutcome: true,
    );
    _hw.clearAllLeds();
    _transition(KioskState.readyToScan);
  }

  void viewLeaderboard() async {
    _touch();
    final board = await _ref
        .read(leaderboardServiceProvider)
        .getHouseLeaderboard(currentHouseId: state.house?.id);
    state = state.copyWith(leaderboard: board);
    _transition(KioskState.houseLeaderboard);
  }

  void viewGuardianEvolution() {
    _touch();
    _transition(KioskState.guardianEvolution);
  }

  /// Return from a sub-screen (leaderboard/evolution) to the right place.
  void backFromSubScreen() {
    _touch();
    if (state.lastOutcome != null) {
      _transition(KioskState.rewardSummary);
    } else {
      _transition(KioskState.studentRecognised);
    }
  }

  // ---------------------------------------------------------------------------
  // Session end + privacy
  // ---------------------------------------------------------------------------

  /// Finish the session, start the auto-logout countdown, then clear.
  void finishSession() {
    _touch();
    _transition(KioskState.sessionComplete);
    _startLogoutCountdown();
  }

  void _startLogoutCountdown() {
    _logoutTimer?.cancel();
    var remaining = state.config.autoLogoutCountdownSeconds;
    state = state.copyWith(logoutCountdown: remaining);
    _logoutTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining--;
      state = state.copyWith(logoutCountdown: remaining);
      if (remaining <= 0) {
        t.cancel();
        endSession(reason: SessionStatus.completed);
      }
    });
  }

  /// End the session immediately, clearing ALL student data + captured image.
  void endSession({SessionStatus reason = SessionStatus.completed}) {
    _logoutTimer?.cancel();
    _privacy.resetKioskState();
    _hw.clearAllLeds();
    _wipeCapturedImage();
    _activeIdempotencyKey = null;
    // Full reset back to idle — no student details remain on the idle screen.
    state = KioskSessionState(
      config: state.config,
      isOffline: state.isOffline,
      queuedCount: state.queuedCount,
      state: state.isOffline ? KioskState.offline : KioskState.idle,
    );
  }

  void _wipeCapturedImage() {
    final c = state.classification;
    if (c?.capturedImagePath != null) {
      state = state.copyWith(
        classification: c!.copyWith(capturedImagePath: null),
      );
    }
  }

  /// Reset the inactivity timer on each interaction.
  void _touch() {
    if (state.hasStudent) {
      _privacy.scheduleAutomaticTimeout(state.config);
    }
  }

  @override
  void dispose() {
    _cardSub?.cancel();
    _logoutTimer?.cancel();
    super.dispose();
  }
}

/// Provider for the kiosk controller. autoDispose so leaving the kiosk clears
/// any loaded student (privacy) — a fresh controller starts at idle.
final kioskControllerProvider =
    StateNotifierProvider.autoDispose<KioskController, KioskSessionState>(
  (ref) {
    // Keep alive while the kiosk screen is mounted.
    final link = ref.keepAlive();
    ref.onDispose(link.close);
    return KioskController(ref);
  },
);
