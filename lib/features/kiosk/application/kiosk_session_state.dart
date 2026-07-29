import '../../../domain/enums/app_enums.dart';
import '../../../domain/enums/kiosk_state.dart';
import '../../../domain/enums/waste_category.dart';
import '../../../domain/models/models.dart';

/// Immutable snapshot of the kiosk at a point in time. The controller emits new
/// instances; the UI renders whichever [KioskState] is active.
class KioskSessionState {
  const KioskSessionState({
    this.state = KioskState.idle,
    this.student,
    this.house,
    this.avatar,
    this.classification,
    this.selectedCategory,
    this.lastOutcome,
    this.session,
    this.errorMessage,
    this.hardwareCommandStatus = HardwareCommandStatus.pending,
    this.evolutionLadder = const [],
    this.leaderboard = const [],
    this.isOffline = false,
    this.queuedCount = 0,
    this.logoutCountdown = 0,
    this.itemsThisSession = 0,
    this.config = const GamificationConfig(),
  });

  final KioskState state;

  // Loaded student context (cleared on session end for privacy).
  final Student? student;
  final House? house;
  final Avatar? avatar;

  // Current scan/answer.
  final WasteClassificationResult? classification;
  final WasteCategory? selectedCategory;

  // Outcome of the processed answer.
  final SessionOutcomeView? lastOutcome;
  final RecyclingSession? session;

  final String? errorMessage;
  final HardwareCommandStatus hardwareCommandStatus;

  final List<AvatarEvolutionStage> evolutionLadder;
  final List<LeaderboardEntry> leaderboard;

  final bool isOffline;
  final int queuedCount;
  final int logoutCountdown;
  final int itemsThisSession;
  final GamificationConfig config;

  bool get hasStudent => student != null;

  /// The category the item should actually route to given the confidence rule.
  WasteCategory? get routedCategory =>
      classification?.routedCategory(config.aiConfidenceThreshold);

  KioskSessionState copyWith({
    KioskState? state,
    Student? student,
    House? house,
    Avatar? avatar,
    WasteClassificationResult? classification,
    WasteCategory? selectedCategory,
    SessionOutcomeView? lastOutcome,
    RecyclingSession? session,
    String? errorMessage,
    HardwareCommandStatus? hardwareCommandStatus,
    List<AvatarEvolutionStage>? evolutionLadder,
    List<LeaderboardEntry>? leaderboard,
    bool? isOffline,
    int? queuedCount,
    int? logoutCountdown,
    int? itemsThisSession,
    GamificationConfig? config,
    bool clearStudent = false,
    bool clearClassification = false,
    bool clearSelected = false,
    bool clearOutcome = false,
    bool clearError = false,
  }) {
    return KioskSessionState(
      state: state ?? this.state,
      student: clearStudent ? null : (student ?? this.student),
      house: clearStudent ? null : (house ?? this.house),
      avatar: clearStudent ? null : (avatar ?? this.avatar),
      classification: clearClassification
          ? null
          : (classification ?? this.classification),
      selectedCategory: clearSelected
          ? null
          : (selectedCategory ?? this.selectedCategory),
      lastOutcome: clearOutcome ? null : (lastOutcome ?? this.lastOutcome),
      session: session ?? this.session,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      hardwareCommandStatus:
          hardwareCommandStatus ?? this.hardwareCommandStatus,
      evolutionLadder: evolutionLadder ?? this.evolutionLadder,
      leaderboard: leaderboard ?? this.leaderboard,
      isOffline: isOffline ?? this.isOffline,
      queuedCount: queuedCount ?? this.queuedCount,
      logoutCountdown: logoutCountdown ?? this.logoutCountdown,
      itemsThisSession: itemsThisSession ?? this.itemsThisSession,
      config: config ?? this.config,
    );
  }
}

/// A UI-friendly view of a scored attempt (kept separate from the persisted
/// session so the reward/feedback screens have exactly what they render).
class SessionOutcomeView {
  const SessionOutcomeView({
    required this.wasCorrect,
    required this.isLowConfidence,
    required this.selected,
    required this.correctCategory,
    required this.pointsAwarded,
    required this.bonusPoints,
    required this.xpAwarded,
    required this.housePoints,
    required this.newStreak,
    required this.bonusApplied,
    required this.dailyCapReached,
    required this.newTotalXp,
    required this.newAvailablePoints,
    required this.stageChanged,
    required this.newStage,
  });

  final bool wasCorrect;
  final bool isLowConfidence;
  final WasteCategory selected;
  final WasteCategory correctCategory;
  final int pointsAwarded;
  final int bonusPoints;
  final int xpAwarded;
  final int housePoints;
  final int newStreak;
  final bool bonusApplied;
  final bool dailyCapReached;
  final int newTotalXp;
  final int newAvailablePoints;
  final bool stageChanged;
  final AvatarEvolutionStage? newStage;

  int get totalPoints => pointsAwarded + bonusPoints;
}
