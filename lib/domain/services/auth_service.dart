import '../../core/utils/result.dart';
import '../models/accounts.dart';
import '../models/student.dart';

/// Credentials for staff logins (teacher / admin / canteen).
class LoginCredentials {
  const LoginCredentials({required this.identifier, required this.password});
  final String identifier; // email or employee number
  final String password;
}

/// Authentication across all EcoLens roles.
///
/// Students authenticate ONLY via their physical Student ID card
/// ([authenticateStudentCard]); there is no student password or phone login.
abstract interface class AuthService {
  /// Resolve a physical card UID to a student account.
  Future<Result<Student>> authenticateStudentCard(String cardUid);

  Future<Result<AuthSession>> authenticateTeacher(LoginCredentials creds);
  Future<Result<AuthSession>> authenticateAdmin(LoginCredentials creds);
  Future<Result<AuthSession>> authenticateCanteenStaff(LoginCredentials creds);

  Future<void> logout();

  /// The current staff session (null if none). Students do not create a
  /// persistent auth session on the shared kiosk.
  AuthSession? getCurrentSession();

  Stream<AuthSession?> get sessionStream;
}
