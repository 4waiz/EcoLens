// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeacherAccount _$TeacherAccountFromJson(Map<String, dynamic> json) {
  return _TeacherAccount.fromJson(json);
}

/// @nodoc
mixin _$TeacherAccount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get assignedClasses => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;

  /// Serializes this TeacherAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherAccountCopyWith<TeacherAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherAccountCopyWith<$Res> {
  factory $TeacherAccountCopyWith(
    TeacherAccount value,
    $Res Function(TeacherAccount) then,
  ) = _$TeacherAccountCopyWithImpl<$Res, TeacherAccount>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    List<String> assignedClasses,
    UserRole role,
  });
}

/// @nodoc
class _$TeacherAccountCopyWithImpl<$Res, $Val extends TeacherAccount>
    implements $TeacherAccountCopyWith<$Res> {
  _$TeacherAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? assignedClasses = null,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            assignedClasses: null == assignedClasses
                ? _value.assignedClasses
                : assignedClasses // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeacherAccountImplCopyWith<$Res>
    implements $TeacherAccountCopyWith<$Res> {
  factory _$$TeacherAccountImplCopyWith(
    _$TeacherAccountImpl value,
    $Res Function(_$TeacherAccountImpl) then,
  ) = __$$TeacherAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    List<String> assignedClasses,
    UserRole role,
  });
}

/// @nodoc
class __$$TeacherAccountImplCopyWithImpl<$Res>
    extends _$TeacherAccountCopyWithImpl<$Res, _$TeacherAccountImpl>
    implements _$$TeacherAccountImplCopyWith<$Res> {
  __$$TeacherAccountImplCopyWithImpl(
    _$TeacherAccountImpl _value,
    $Res Function(_$TeacherAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeacherAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? assignedClasses = null,
    Object? role = null,
  }) {
    return _then(
      _$TeacherAccountImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        assignedClasses: null == assignedClasses
            ? _value._assignedClasses
            : assignedClasses // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherAccountImpl extends _TeacherAccount {
  const _$TeacherAccountImpl({
    required this.id,
    required this.name,
    required this.email,
    final List<String> assignedClasses = const <String>[],
    this.role = UserRole.teacher,
  }) : _assignedClasses = assignedClasses,
       super._();

  factory _$TeacherAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  final List<String> _assignedClasses;
  @override
  @JsonKey()
  List<String> get assignedClasses {
    if (_assignedClasses is EqualUnmodifiableListView) return _assignedClasses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignedClasses);
  }

  @override
  @JsonKey()
  final UserRole role;

  @override
  String toString() {
    return 'TeacherAccount(id: $id, name: $name, email: $email, assignedClasses: $assignedClasses, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._assignedClasses,
              _assignedClasses,
            ) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    const DeepCollectionEquality().hash(_assignedClasses),
    role,
  );

  /// Create a copy of TeacherAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherAccountImplCopyWith<_$TeacherAccountImpl> get copyWith =>
      __$$TeacherAccountImplCopyWithImpl<_$TeacherAccountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherAccountImplToJson(this);
  }
}

abstract class _TeacherAccount extends TeacherAccount {
  const factory _TeacherAccount({
    required final String id,
    required final String name,
    required final String email,
    final List<String> assignedClasses,
    final UserRole role,
  }) = _$TeacherAccountImpl;
  const _TeacherAccount._() : super._();

  factory _TeacherAccount.fromJson(Map<String, dynamic> json) =
      _$TeacherAccountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  List<String> get assignedClasses;
  @override
  UserRole get role;

  /// Create a copy of TeacherAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherAccountImplCopyWith<_$TeacherAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminAccount _$AdminAccountFromJson(Map<String, dynamic> json) {
  return _AdminAccount.fromJson(json);
}

/// @nodoc
mixin _$AdminAccount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get permissions => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;

  /// Serializes this AdminAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminAccountCopyWith<AdminAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminAccountCopyWith<$Res> {
  factory $AdminAccountCopyWith(
    AdminAccount value,
    $Res Function(AdminAccount) then,
  ) = _$AdminAccountCopyWithImpl<$Res, AdminAccount>;
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    List<String> permissions,
    UserRole role,
  });
}

/// @nodoc
class _$AdminAccountCopyWithImpl<$Res, $Val extends AdminAccount>
    implements $AdminAccountCopyWith<$Res> {
  _$AdminAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? permissions = null,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            permissions: null == permissions
                ? _value.permissions
                : permissions // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminAccountImplCopyWith<$Res>
    implements $AdminAccountCopyWith<$Res> {
  factory _$$AdminAccountImplCopyWith(
    _$AdminAccountImpl value,
    $Res Function(_$AdminAccountImpl) then,
  ) = __$$AdminAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String email,
    List<String> permissions,
    UserRole role,
  });
}

/// @nodoc
class __$$AdminAccountImplCopyWithImpl<$Res>
    extends _$AdminAccountCopyWithImpl<$Res, _$AdminAccountImpl>
    implements _$$AdminAccountImplCopyWith<$Res> {
  __$$AdminAccountImplCopyWithImpl(
    _$AdminAccountImpl _value,
    $Res Function(_$AdminAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? permissions = null,
    Object? role = null,
  }) {
    return _then(
      _$AdminAccountImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        permissions: null == permissions
            ? _value._permissions
            : permissions // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminAccountImpl extends _AdminAccount {
  const _$AdminAccountImpl({
    required this.id,
    required this.name,
    required this.email,
    final List<String> permissions = const <String>[],
    this.role = UserRole.admin,
  }) : _permissions = permissions,
       super._();

  factory _$AdminAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  final List<String> _permissions;
  @override
  @JsonKey()
  List<String> get permissions {
    if (_permissions is EqualUnmodifiableListView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissions);
  }

  @override
  @JsonKey()
  final UserRole role;

  @override
  String toString() {
    return 'AdminAccount(id: $id, name: $name, email: $email, permissions: $permissions, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            const DeepCollectionEquality().equals(
              other._permissions,
              _permissions,
            ) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    const DeepCollectionEquality().hash(_permissions),
    role,
  );

  /// Create a copy of AdminAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminAccountImplCopyWith<_$AdminAccountImpl> get copyWith =>
      __$$AdminAccountImplCopyWithImpl<_$AdminAccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminAccountImplToJson(this);
  }
}

abstract class _AdminAccount extends AdminAccount {
  const factory _AdminAccount({
    required final String id,
    required final String name,
    required final String email,
    final List<String> permissions,
    final UserRole role,
  }) = _$AdminAccountImpl;
  const _AdminAccount._() : super._();

  factory _AdminAccount.fromJson(Map<String, dynamic> json) =
      _$AdminAccountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  List<String> get permissions;
  @override
  UserRole get role;

  /// Create a copy of AdminAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminAccountImplCopyWith<_$AdminAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CanteenStaffAccount _$CanteenStaffAccountFromJson(Map<String, dynamic> json) {
  return _CanteenStaffAccount.fromJson(json);
}

/// @nodoc
mixin _$CanteenStaffAccount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get employeeNumber => throw _privateConstructorUsedError;
  String get terminalId => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;

  /// Serializes this CanteenStaffAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CanteenStaffAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CanteenStaffAccountCopyWith<CanteenStaffAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CanteenStaffAccountCopyWith<$Res> {
  factory $CanteenStaffAccountCopyWith(
    CanteenStaffAccount value,
    $Res Function(CanteenStaffAccount) then,
  ) = _$CanteenStaffAccountCopyWithImpl<$Res, CanteenStaffAccount>;
  @useResult
  $Res call({
    String id,
    String name,
    String employeeNumber,
    String terminalId,
    UserRole role,
  });
}

/// @nodoc
class _$CanteenStaffAccountCopyWithImpl<$Res, $Val extends CanteenStaffAccount>
    implements $CanteenStaffAccountCopyWith<$Res> {
  _$CanteenStaffAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CanteenStaffAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? employeeNumber = null,
    Object? terminalId = null,
    Object? role = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            employeeNumber: null == employeeNumber
                ? _value.employeeNumber
                : employeeNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            terminalId: null == terminalId
                ? _value.terminalId
                : terminalId // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CanteenStaffAccountImplCopyWith<$Res>
    implements $CanteenStaffAccountCopyWith<$Res> {
  factory _$$CanteenStaffAccountImplCopyWith(
    _$CanteenStaffAccountImpl value,
    $Res Function(_$CanteenStaffAccountImpl) then,
  ) = __$$CanteenStaffAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String employeeNumber,
    String terminalId,
    UserRole role,
  });
}

/// @nodoc
class __$$CanteenStaffAccountImplCopyWithImpl<$Res>
    extends _$CanteenStaffAccountCopyWithImpl<$Res, _$CanteenStaffAccountImpl>
    implements _$$CanteenStaffAccountImplCopyWith<$Res> {
  __$$CanteenStaffAccountImplCopyWithImpl(
    _$CanteenStaffAccountImpl _value,
    $Res Function(_$CanteenStaffAccountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CanteenStaffAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? employeeNumber = null,
    Object? terminalId = null,
    Object? role = null,
  }) {
    return _then(
      _$CanteenStaffAccountImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        employeeNumber: null == employeeNumber
            ? _value.employeeNumber
            : employeeNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        terminalId: null == terminalId
            ? _value.terminalId
            : terminalId // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CanteenStaffAccountImpl extends _CanteenStaffAccount {
  const _$CanteenStaffAccountImpl({
    required this.id,
    required this.name,
    required this.employeeNumber,
    required this.terminalId,
    this.role = UserRole.canteenStaff,
  }) : super._();

  factory _$CanteenStaffAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$CanteenStaffAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String employeeNumber;
  @override
  final String terminalId;
  @override
  @JsonKey()
  final UserRole role;

  @override
  String toString() {
    return 'CanteenStaffAccount(id: $id, name: $name, employeeNumber: $employeeNumber, terminalId: $terminalId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CanteenStaffAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.employeeNumber, employeeNumber) ||
                other.employeeNumber == employeeNumber) &&
            (identical(other.terminalId, terminalId) ||
                other.terminalId == terminalId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, employeeNumber, terminalId, role);

  /// Create a copy of CanteenStaffAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CanteenStaffAccountImplCopyWith<_$CanteenStaffAccountImpl> get copyWith =>
      __$$CanteenStaffAccountImplCopyWithImpl<_$CanteenStaffAccountImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CanteenStaffAccountImplToJson(this);
  }
}

abstract class _CanteenStaffAccount extends CanteenStaffAccount {
  const factory _CanteenStaffAccount({
    required final String id,
    required final String name,
    required final String employeeNumber,
    required final String terminalId,
    final UserRole role,
  }) = _$CanteenStaffAccountImpl;
  const _CanteenStaffAccount._() : super._();

  factory _CanteenStaffAccount.fromJson(Map<String, dynamic> json) =
      _$CanteenStaffAccountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get employeeNumber;
  @override
  String get terminalId;
  @override
  UserRole get role;

  /// Create a copy of CanteenStaffAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CanteenStaffAccountImplCopyWith<_$CanteenStaffAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) {
  return _AuthSession.fromJson(json);
}

/// @nodoc
mixin _$AuthSession {
  String get token => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  DateTime get issuedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this AuthSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthSessionCopyWith<AuthSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthSessionCopyWith<$Res> {
  factory $AuthSessionCopyWith(
    AuthSession value,
    $Res Function(AuthSession) then,
  ) = _$AuthSessionCopyWithImpl<$Res, AuthSession>;
  @useResult
  $Res call({
    String token,
    UserRole role,
    String accountId,
    String displayName,
    DateTime issuedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class _$AuthSessionCopyWithImpl<$Res, $Val extends AuthSession>
    implements $AuthSessionCopyWith<$Res> {
  _$AuthSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? role = null,
    Object? accountId = null,
    Object? displayName = null,
    Object? issuedAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            token: null == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as UserRole,
            accountId: null == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            issuedAt: null == issuedAt
                ? _value.issuedAt
                : issuedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthSessionImplCopyWith<$Res>
    implements $AuthSessionCopyWith<$Res> {
  factory _$$AuthSessionImplCopyWith(
    _$AuthSessionImpl value,
    $Res Function(_$AuthSessionImpl) then,
  ) = __$$AuthSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String token,
    UserRole role,
    String accountId,
    String displayName,
    DateTime issuedAt,
    DateTime? expiresAt,
  });
}

/// @nodoc
class __$$AuthSessionImplCopyWithImpl<$Res>
    extends _$AuthSessionCopyWithImpl<$Res, _$AuthSessionImpl>
    implements _$$AuthSessionImplCopyWith<$Res> {
  __$$AuthSessionImplCopyWithImpl(
    _$AuthSessionImpl _value,
    $Res Function(_$AuthSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? role = null,
    Object? accountId = null,
    Object? displayName = null,
    Object? issuedAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(
      _$AuthSessionImpl(
        token: null == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as UserRole,
        accountId: null == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        issuedAt: null == issuedAt
            ? _value.issuedAt
            : issuedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthSessionImpl extends _AuthSession {
  const _$AuthSessionImpl({
    required this.token,
    required this.role,
    required this.accountId,
    required this.displayName,
    required this.issuedAt,
    this.expiresAt,
  }) : super._();

  factory _$AuthSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthSessionImplFromJson(json);

  @override
  final String token;
  @override
  final UserRole role;
  @override
  final String accountId;
  @override
  final String displayName;
  @override
  final DateTime issuedAt;
  @override
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'AuthSession(token: $token, role: $role, accountId: $accountId, displayName: $displayName, issuedAt: $issuedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthSessionImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    token,
    role,
    accountId,
    displayName,
    issuedAt,
    expiresAt,
  );

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthSessionImplCopyWith<_$AuthSessionImpl> get copyWith =>
      __$$AuthSessionImplCopyWithImpl<_$AuthSessionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthSessionImplToJson(this);
  }
}

abstract class _AuthSession extends AuthSession {
  const factory _AuthSession({
    required final String token,
    required final UserRole role,
    required final String accountId,
    required final String displayName,
    required final DateTime issuedAt,
    final DateTime? expiresAt,
  }) = _$AuthSessionImpl;
  const _AuthSession._() : super._();

  factory _AuthSession.fromJson(Map<String, dynamic> json) =
      _$AuthSessionImpl.fromJson;

  @override
  String get token;
  @override
  UserRole get role;
  @override
  String get accountId;
  @override
  String get displayName;
  @override
  DateTime get issuedAt;
  @override
  DateTime? get expiresAt;

  /// Create a copy of AuthSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthSessionImplCopyWith<_$AuthSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
