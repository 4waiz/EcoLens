import 'package:ecolens/data/datasources/mock_auth_service.dart';
import 'package:ecolens/data/mock/mock_database.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/data/repositories/mock_student_repository.dart';
import 'package:ecolens/domain/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for student-card + staff authentication.
void main() {
  late MockDatabase db;
  late MockAuthService auth;

  setUp(() {
    db = MockDatabase();
    auth = MockAuthService(studentRepository: MockStudentRepository(db));
  });

  group('student card authentication', () {
    test("Liam's card resolves to Liam's profile", () async {
      final result = await auth.authenticateStudentCard(
        MockSeedData.liamCardUid,
      );
      expect(result.isOk, isTrue);
      expect(result.valueOrNull?.firstName, 'Liam');
      expect(result.valueOrNull?.className, '4B');
    });

    test('an unknown card is rejected with UnknownCardFailure', () async {
      final result = await auth.authenticateStudentCard('DEADBEEF00');
      expect(result.isErr, isTrue);
      expect(result.failureOrNull, isNotNull);
    });
  });

  group('staff authentication', () {
    test('valid teacher credentials succeed', () async {
      final result = await auth.authenticateTeacher(
        const LoginCredentials(
          identifier: MockSeedData.teacherEmail,
          password: MockSeedData.demoPassword,
        ),
      );
      expect(result.isOk, isTrue);
      expect(auth.getCurrentSession(), isNotNull);
    });

    test('wrong teacher password fails', () async {
      final result = await auth.authenticateTeacher(
        const LoginCredentials(
          identifier: MockSeedData.teacherEmail,
          password: 'wrong',
        ),
      );
      expect(result.isErr, isTrue);
    });

    test('valid admin credentials succeed', () async {
      final result = await auth.authenticateAdmin(
        const LoginCredentials(
          identifier: MockSeedData.adminEmail,
          password: MockSeedData.demoPassword,
        ),
      );
      expect(result.isOk, isTrue);
    });

    test('canteen staff can authenticate by employee number', () async {
      final result = await auth.authenticateCanteenStaff(
        const LoginCredentials(
          identifier: MockSeedData.canteenEmployeeNumber,
          password: MockSeedData.demoPassword,
        ),
      );
      expect(result.isOk, isTrue);
    });

    test('logout clears the current session', () async {
      await auth.authenticateAdmin(
        const LoginCredentials(
          identifier: MockSeedData.adminEmail,
          password: MockSeedData.demoPassword,
        ),
      );
      expect(auth.getCurrentSession(), isNotNull);
      await auth.logout();
      expect(auth.getCurrentSession(), isNull);
    });
  });
}
