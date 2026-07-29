import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/result.dart';
import '../../../domain/models/models.dart';
import '../../../domain/services/reward_service.dart';

/// Immutable state for the canteen redemption flow.
///
/// The flow spans several screens (scan → student → rewards → confirm →
/// success), so the scanned student, their house, the selected reward and the
/// last committed transaction all live here rather than being threaded through
/// route arguments. The student is a shared-terminal customer — it is wiped by
/// [CanteenController.clearSession] on Done / timeout so the next person in the
/// queue never sees the previous student's balance.
class CanteenState {
  const CanteenState({
    this.student,
    this.house,
    this.selectedReward,
    this.lastTransaction,
    this.loading = false,
    this.error,
  });

  /// The student resolved from the tapped physical ID card (null = none).
  final Student? student;

  /// The scanned student's house (for the coloured [HouseChip]); may be null if
  /// the house lookup fails but the student still resolved.
  final House? house;

  /// The reward the student chose to redeem (null until one is picked).
  final RewardItem? selectedReward;

  /// The transaction produced by the most recent successful redemption.
  final RewardTransaction? lastTransaction;

  /// True while an async action (scan / confirm) is in flight.
  final bool loading;

  /// A user-facing failure message from the most recent action (null = none).
  final String? error;

  bool get hasStudent => student != null;

  CanteenState copyWith({
    Student? student,
    House? house,
    RewardItem? selectedReward,
    RewardTransaction? lastTransaction,
    bool? loading,
    String? error,
    bool clearStudent = false,
    bool clearHouse = false,
    bool clearSelectedReward = false,
    bool clearLastTransaction = false,
    bool clearError = false,
  }) {
    return CanteenState(
      student: clearStudent ? null : (student ?? this.student),
      house: clearHouse ? null : (house ?? this.house),
      selectedReward: clearSelectedReward
          ? null
          : (selectedReward ?? this.selectedReward),
      lastTransaction: clearLastTransaction
          ? null
          : (lastTransaction ?? this.lastTransaction),
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Drives the canteen terminal flow: resolving a tapped Student ID card,
/// selecting a reward, and committing a validated redemption.
///
/// Students are never authenticated by phone or QR here — only by the physical
/// card UID passed to [scanCard]. All validation goes through [RewardService]
/// so balance / stock / daily-limit / staff-authorisation rules are enforced in
/// one place, and the reward repository performs the points debit itself on a
/// completed transaction (we never hand-roll deduction).
class CanteenController extends StateNotifier<CanteenState> {
  CanteenController(this._ref) : super(const CanteenState());

  final Ref _ref;

  /// Resolve a physical card UID to a student and load their house.
  ///
  /// On success the student + house are stored and any stale selection /
  /// transaction from a previous customer is cleared. On failure (unknown or
  /// inactive card) [CanteenState.error] is set and no student is stored.
  Future<bool> scanCard(String cardUid) async {
    state = state.copyWith(loading: true, clearError: true);
    final result = await _ref
        .read(authServiceProvider)
        .authenticateStudentCard(cardUid);
    return result.when(
      ok: (student) async {
        House? house;
        try {
          house = await _ref
              .read(houseRepositoryProvider)
              .getHouseById(student.houseId);
        } catch (_) {
          house = null;
        }
        state = CanteenState(student: student, house: house);
        return true;
      },
      err: (failure) {
        state = state.copyWith(loading: false, error: failure.message);
        return false;
      },
    );
  }

  /// Store the reward the student picked (advances to the confirm screen).
  void selectReward(RewardItem item) {
    state = state.copyWith(selectedReward: item, clearError: true);
  }

  /// Validate the current student + selected reward without committing. Surfaces
  /// balance / stock / daily-limit / staff-authorisation failures.
  Future<Result<RedemptionRequest>> validateSelection({
    required String staffId,
    required String terminalId,
  }) async {
    final student = state.student;
    final item = state.selectedReward;
    if (student == null || item == null) {
      return const Result.err(
        RedemptionFailure('No student or reward selected.'),
      );
    }
    return _ref
        .read(rewardServiceProvider)
        .validateRedemption(
          student: student,
          item: item,
          staffId: staffId,
          terminalId: terminalId,
        );
  }

  /// Validate and commit the redemption under the staff member's authorisation.
  ///
  /// Re-fetches the student afterwards so the new balance (debited by the reward
  /// repository for completed transactions) is reflected on the success screen.
  /// Returns true on success; sets [CanteenState.error] and returns false on any
  /// validation or commit failure.
  Future<bool> confirmRedemption({
    required String staffId,
    required String terminalId,
  }) async {
    final student = state.student;
    final item = state.selectedReward;
    if (student == null || item == null) {
      state = state.copyWith(error: 'No student or reward selected.');
      return false;
    }

    state = state.copyWith(loading: true, clearError: true);

    final rewardService = _ref.read(rewardServiceProvider);
    final validation = await rewardService.validateRedemption(
      student: student,
      item: item,
      staffId: staffId,
      terminalId: terminalId,
    );

    return validation.when(
      ok: (request) async {
        final txn = await rewardService.createRedemption(request);
        // The reward repository debits points on a completed transaction, so the
        // held student is now stale — reload for an accurate new balance.
        final refreshed = await _ref
            .read(studentRepositoryProvider)
            .getStudentById(student.id);
        state = state.copyWith(
          student: refreshed ?? student,
          lastTransaction: txn,
          loading: false,
          clearError: true,
        );
        return true;
      },
      err: (failure) {
        state = state.copyWith(loading: false, error: failure.message);
        return false;
      },
    );
  }

  /// Clear any transient error message (e.g. before retrying a scan).
  void clearError() {
    if (state.error != null) state = state.copyWith(clearError: true);
  }

  /// Wipe the entire customer session (student, house, selection, receipt).
  /// Called on Done and on the privacy auto-timeout.
  void clearSession() {
    state = const CanteenState();
  }
}

/// Shared canteen-flow state for every terminal screen.
final canteenControllerProvider =
    StateNotifierProvider<CanteenController, CanteenState>(
      CanteenController.new,
    );
