// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeacherAccountImpl _$$TeacherAccountImplFromJson(Map<String, dynamic> json) =>
    _$TeacherAccountImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      assignedClasses:
          (json['assignedClasses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
          UserRole.teacher,
    );

Map<String, dynamic> _$$TeacherAccountImplToJson(
  _$TeacherAccountImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'assignedClasses': instance.assignedClasses,
  'role': _$UserRoleEnumMap[instance.role]!,
};

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.teacher: 'teacher',
  UserRole.admin: 'admin',
  UserRole.canteenStaff: 'canteenStaff',
};

_$AdminAccountImpl _$$AdminAccountImplFromJson(
  Map<String, dynamic> json,
) => _$AdminAccountImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.admin,
);

Map<String, dynamic> _$$AdminAccountImplToJson(_$AdminAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'permissions': instance.permissions,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

_$CanteenStaffAccountImpl _$$CanteenStaffAccountImplFromJson(
  Map<String, dynamic> json,
) => _$CanteenStaffAccountImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  employeeNumber: json['employeeNumber'] as String,
  terminalId: json['terminalId'] as String,
  role:
      $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ??
      UserRole.canteenStaff,
);

Map<String, dynamic> _$$CanteenStaffAccountImplToJson(
  _$CanteenStaffAccountImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'employeeNumber': instance.employeeNumber,
  'terminalId': instance.terminalId,
  'role': _$UserRoleEnumMap[instance.role]!,
};

_$AuthSessionImpl _$$AuthSessionImplFromJson(Map<String, dynamic> json) =>
    _$AuthSessionImpl(
      token: json['token'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      accountId: json['accountId'] as String,
      displayName: json['displayName'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$AuthSessionImplToJson(_$AuthSessionImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'role': _$UserRoleEnumMap[instance.role]!,
      'accountId': instance.accountId,
      'displayName': instance.displayName,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
