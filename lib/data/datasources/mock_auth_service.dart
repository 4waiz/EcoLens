import 'dart:async';

import '../../core/constants/app_config.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/models/accounts.dart';
import '../../domain/models/student.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/auth_service.dart';
import '../mock/mock_seed_data.dart';

/// Mock authentication.
///
/// - Students authenticate ONLY by physical card UID (no password/phone).
/// - Staff logins accept the seeded demo accounts with [MockSeedData.demoPassword].
class MockAuthService implements AuthService {
  MockAuthService({required StudentRepository studentRepository})
    : _students = studentRepository;

  final StudentRepository _students;
  final _controller = StreamController<AuthSession?>.broadcast();
  AuthSession? _current;

  @override
  Future<Result<Student>> authenticateStudentCard(String cardUid) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    final student = await _students.getStudentByCardUid(cardUid);
    if (student == null) {
      return const Result.err(UnknownCardFailure());
    }
    if (student.accountStatus != AccountStatus.active) {
      return const Result.err(
        UnknownCardFailure('This account is not active.'),
      );
    }
    return Result.ok(student);
  }

  @override
  Future<Result<AuthSession>> authenticateTeacher(
    LoginCredentials creds,
  ) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    if (creds.identifier.trim().toLowerCase() == MockSeedData.teacherEmail &&
        creds.password == MockSeedData.demoPassword) {
      final account = MockSeedData.teacher();
      return Result.ok(
        _makeSession(UserRole.teacher, account.id, account.name),
      );
    }
    return const Result.err(AuthFailure());
  }

  @override
  Future<Result<AuthSession>> authenticateAdmin(LoginCredentials creds) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    if (creds.identifier.trim().toLowerCase() == MockSeedData.adminEmail &&
        creds.password == MockSeedData.demoPassword) {
      final account = MockSeedData.admin();
      return Result.ok(_makeSession(UserRole.admin, account.id, account.name));
    }
    return const Result.err(AuthFailure());
  }

  @override
  Future<Result<AuthSession>> authenticateCanteenStaff(
    LoginCredentials creds,
  ) async {
    await Future<void>.delayed(AppConfig.mockNetworkDelay);
    final id = creds.identifier.trim().toUpperCase();
    if ((id == MockSeedData.canteenEmployeeNumber ||
            creds.identifier.trim().toLowerCase() == 'canteen@oakwood.edu') &&
        creds.password == MockSeedData.demoPassword) {
      final account = MockSeedData.canteenStaff();
      return Result.ok(
        _makeSession(UserRole.canteenStaff, account.id, account.name),
      );
    }
    return const Result.err(AuthFailure());
  }

  AuthSession _makeSession(UserRole role, String accountId, String name) {
    final session = AuthSession(
      token: 'mock-${role.name}-${DateTime.now().microsecondsSinceEpoch}',
      role: role,
      accountId: accountId,
      displayName: name,
      issuedAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
    );
    _current = session;
    _controller.add(session);
    return session;
  }

  @override
  Future<void> logout() async {
    _current = null;
    _controller.add(null);
  }

  @override
  AuthSession? getCurrentSession() => _current;

  @override
  Stream<AuthSession?> get sessionStream => _controller.stream;
}
