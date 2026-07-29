import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'accounts.freezed.dart';
part 'accounts.g.dart';

/// A teacher account with secure school login and assigned classes.
@freezed
class TeacherAccount with _$TeacherAccount {
  const TeacherAccount._();

  const factory TeacherAccount({
    required String id,
    required String name,
    required String email,
    @Default(<String>[]) List<String> assignedClasses,
    @Default(UserRole.teacher) UserRole role,
  }) = _TeacherAccount;

  factory TeacherAccount.fromJson(Map<String, dynamic> json) =>
      _$TeacherAccountFromJson(json);
}

/// An administrator account with fine-grained permissions.
@freezed
class AdminAccount with _$AdminAccount {
  const AdminAccount._();

  const factory AdminAccount({
    required String id,
    required String name,
    required String email,
    @Default(<String>[]) List<String> permissions,
    @Default(UserRole.admin) UserRole role,
  }) = _AdminAccount;

  factory AdminAccount.fromJson(Map<String, dynamic> json) =>
      _$AdminAccountFromJson(json);
}

/// A canteen staff account tied to a redemption terminal.
@freezed
class CanteenStaffAccount with _$CanteenStaffAccount {
  const CanteenStaffAccount._();

  const factory CanteenStaffAccount({
    required String id,
    required String name,
    required String employeeNumber,
    required String terminalId,
    @Default(UserRole.canteenStaff) UserRole role,
  }) = _CanteenStaffAccount;

  factory CanteenStaffAccount.fromJson(Map<String, dynamic> json) =>
      _$CanteenStaffAccountFromJson(json);
}

/// A lightweight authenticated session (mock token + role) used by route
/// guards. Real deployments would carry a JWT and refresh token here.
@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    required String token,
    required UserRole role,
    required String accountId,
    required String displayName,
    required DateTime issuedAt,
    DateTime? expiresAt,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  bool get isValid => expiresAt == null || DateTime.now().isBefore(expiresAt!);
}
