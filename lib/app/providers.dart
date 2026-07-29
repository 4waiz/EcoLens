import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_config.dart';
import '../data/datasources/mock_ai_classification_service.dart';
import '../data/datasources/mock_auth_service.dart';
import '../data/datasources/mock_hardware_bridge_service.dart';
import '../data/mock/mock_database.dart';
import '../data/repositories/mock_dashboard_repository.dart';
import '../data/repositories/mock_reward_repository.dart';
import '../data/repositories/mock_session_repository.dart';
import '../data/repositories/mock_simple_repositories.dart';
import '../data/repositories/mock_student_repository.dart';
import '../domain/models/accounts.dart';
import '../domain/models/gamification_config.dart';
import '../domain/models/hardware_status.dart';
import '../domain/repositories/repositories.dart';
import '../domain/services/ai_classification_service.dart';
import '../domain/services/auth_service.dart';
import '../domain/services/dashboard_service.dart';
import '../domain/services/gamification_service.dart';
import '../domain/services/hardware_bridge_service.dart';
import '../domain/services/leaderboard_service.dart';
import '../domain/services/reward_service.dart';
import '../domain/services/session_privacy_service.dart';

/// ---------------------------------------------------------------------------
/// EcoLens dependency-injection graph (Riverpod).
///
/// The graph is mock-backed for every non-production environment. To go to
/// production, swap the leaf providers (auth/ai/hardware/repositories) for the
/// real adapters — nothing above the data layer changes because everything
/// depends on the domain interfaces, not concrete types.
/// ---------------------------------------------------------------------------

/// The shared in-memory backend. Single instance for the app lifetime.
final mockDatabaseProvider = Provider<MockDatabase>((ref) {
  final db = MockDatabase();
  ref.onDispose(db.dispose);
  return db;
});

// ---- Pure domain services (stateless) ----

final gamificationServiceProvider = Provider<GamificationService>(
  (ref) => const GamificationService(),
);

// ---- Repositories (mock-backed) ----

final studentRepositoryProvider = Provider<StudentRepository>(
  (ref) => MockStudentRepository(
    ref.watch(mockDatabaseProvider),
    gamification: ref.watch(gamificationServiceProvider),
  ),
);

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => MockCardRepository(ref.watch(mockDatabaseProvider)),
);

final houseRepositoryProvider = Provider<HouseRepository>(
  (ref) => MockHouseRepository(ref.watch(mockDatabaseProvider)),
);

final classRepositoryProvider = Provider<ClassRepository>(
  (ref) => MockClassRepository(ref.watch(mockDatabaseProvider)),
);

final avatarRepositoryProvider = Provider<AvatarRepository>(
  (ref) => MockAvatarRepository(ref.watch(mockDatabaseProvider)),
);

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => MockSessionRepository(ref.watch(mockDatabaseProvider)),
);

final rewardRepositoryProvider = Provider<RewardRepository>(
  (ref) => MockRewardRepository(ref.watch(mockDatabaseProvider)),
);

final deviceRepositoryProvider = Provider<DeviceRepository>(
  (ref) => MockDeviceRepository(ref.watch(mockDatabaseProvider)),
);

final configRepositoryProvider = Provider<ConfigRepository>(
  (ref) => MockConfigRepository(ref.watch(mockDatabaseProvider)),
);

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => MockAuditRepository(ref.watch(mockDatabaseProvider)),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => MockDashboardRepository(ref.watch(mockDatabaseProvider)),
);

// ---- Hardware bridge (single shared instance; also used by the dev panel) ----

final hardwareBridgeProvider = Provider<HardwareBridgeService>((ref) {
  // Concrete mock type is used so the dev panel can reach fault-injection.
  final bridge = MockHardwareBridgeService();
  // For production, register RealHardwareBridgeAdapter here instead.
  ref.onDispose(bridge.dispose);
  return bridge;
});

/// Concrete mock accessor for the developer panel (fault injection lives on the
/// concrete type). Null when not running the mock bridge.
final mockHardwareBridgeProvider = Provider<MockHardwareBridgeService?>((ref) {
  final bridge = ref.watch(hardwareBridgeProvider);
  return bridge is MockHardwareBridgeService ? bridge : null;
});

/// Live hardware status snapshots (LED state, fill levels, peripheral health).
final hardwareStatusStreamProvider = StreamProvider<HardwareStatus>((ref) {
  final bridge = ref.watch(hardwareBridgeProvider);
  return bridge.statusStream;
});

// ---- AI classification ----

final aiClassificationProvider = Provider<AiClassificationService>((ref) {
  return MockAiClassificationService(
    hardware: ref.watch(hardwareBridgeProvider),
    configRepository: ref.watch(configRepositoryProvider),
    db: ref.watch(mockDatabaseProvider),
  );
  // For production, register RealAiClassificationAdapter here instead.
});

final mockAiClassificationProvider = Provider<MockAiClassificationService?>((
  ref,
) {
  final ai = ref.watch(aiClassificationProvider);
  return ai is MockAiClassificationService ? ai : null;
});

// ---- Auth ----

final authServiceProvider = Provider<AuthService>(
  (ref) =>
      MockAuthService(studentRepository: ref.watch(studentRepositoryProvider)),
);

/// The current staff auth session (null when logged out). Students never create
/// a persistent session on the shared kiosk.
final authSessionProvider = StreamProvider<AuthSession?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.sessionStream;
});

// ---- Composite services ----

final rewardServiceProvider = Provider<RewardService>(
  (ref) => RewardService(
    rewardRepository: ref.watch(rewardRepositoryProvider),
    configRepository: ref.watch(configRepositoryProvider),
  ),
);

final leaderboardServiceProvider = Provider<LeaderboardService>(
  (ref) => LeaderboardService(
    studentRepository: ref.watch(studentRepositoryProvider),
    houseRepository: ref.watch(houseRepositoryProvider),
    classRepository: ref.watch(classRepositoryProvider),
  ),
);

final dashboardServiceProvider = Provider<DashboardService>(
  (ref) => DashboardService(repository: ref.watch(dashboardRepositoryProvider)),
);

final sessionPrivacyServiceProvider = Provider<SessionPrivacyService>((ref) {
  final service = SessionPrivacyService();
  ref.onDispose(service.dispose);
  return service;
});

// ---- Live config (reactive) ----

/// The active gamification/AI config, reloaded when an admin saves changes.
final gamificationConfigProvider = FutureProvider<GamificationConfig>((
  ref,
) async {
  final repo = ref.watch(configRepositoryProvider);
  // Rebuild when the config changes.
  final sub = repo.watchConfig().listen((_) {});
  ref.onDispose(sub.cancel);
  return repo.getConfig();
});

/// Environment banner flag.
final appEnvironmentProvider = Provider((ref) => AppConfig.environment);
