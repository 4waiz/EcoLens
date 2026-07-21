// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentCard _$StudentCardFromJson(Map<String, dynamic> json) {
  return _StudentCard.fromJson(json);
}

/// @nodoc
mixin _$StudentCard {
  String get cardUid => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  DateTime get issuedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this StudentCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentCardCopyWith<StudentCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCardCopyWith<$Res> {
  factory $StudentCardCopyWith(
    StudentCard value,
    $Res Function(StudentCard) then,
  ) = _$StudentCardCopyWithImpl<$Res, StudentCard>;
  @useResult
  $Res call({
    String cardUid,
    String studentId,
    DateTime issuedAt,
    DateTime? expiresAt,
    bool isActive,
  });
}

/// @nodoc
class _$StudentCardCopyWithImpl<$Res, $Val extends StudentCard>
    implements $StudentCardCopyWith<$Res> {
  _$StudentCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardUid = null,
    Object? studentId = null,
    Object? issuedAt = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            cardUid: null == cardUid
                ? _value.cardUid
                : cardUid // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            issuedAt: null == issuedAt
                ? _value.issuedAt
                : issuedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentCardImplCopyWith<$Res>
    implements $StudentCardCopyWith<$Res> {
  factory _$$StudentCardImplCopyWith(
    _$StudentCardImpl value,
    $Res Function(_$StudentCardImpl) then,
  ) = __$$StudentCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardUid,
    String studentId,
    DateTime issuedAt,
    DateTime? expiresAt,
    bool isActive,
  });
}

/// @nodoc
class __$$StudentCardImplCopyWithImpl<$Res>
    extends _$StudentCardCopyWithImpl<$Res, _$StudentCardImpl>
    implements _$$StudentCardImplCopyWith<$Res> {
  __$$StudentCardImplCopyWithImpl(
    _$StudentCardImpl _value,
    $Res Function(_$StudentCardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardUid = null,
    Object? studentId = null,
    Object? issuedAt = null,
    Object? expiresAt = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$StudentCardImpl(
        cardUid: null == cardUid
            ? _value.cardUid
            : cardUid // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        issuedAt: null == issuedAt
            ? _value.issuedAt
            : issuedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentCardImpl extends _StudentCard {
  const _$StudentCardImpl({
    required this.cardUid,
    required this.studentId,
    required this.issuedAt,
    this.expiresAt,
    this.isActive = true,
  }) : super._();

  factory _$StudentCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentCardImplFromJson(json);

  @override
  final String cardUid;
  @override
  final String studentId;
  @override
  final DateTime issuedAt;
  @override
  final DateTime? expiresAt;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'StudentCard(cardUid: $cardUid, studentId: $studentId, issuedAt: $issuedAt, expiresAt: $expiresAt, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentCardImpl &&
            (identical(other.cardUid, cardUid) || other.cardUid == cardUid) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.issuedAt, issuedAt) ||
                other.issuedAt == issuedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardUid,
    studentId,
    issuedAt,
    expiresAt,
    isActive,
  );

  /// Create a copy of StudentCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentCardImplCopyWith<_$StudentCardImpl> get copyWith =>
      __$$StudentCardImplCopyWithImpl<_$StudentCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentCardImplToJson(this);
  }
}

abstract class _StudentCard extends StudentCard {
  const factory _StudentCard({
    required final String cardUid,
    required final String studentId,
    required final DateTime issuedAt,
    final DateTime? expiresAt,
    final bool isActive,
  }) = _$StudentCardImpl;
  const _StudentCard._() : super._();

  factory _StudentCard.fromJson(Map<String, dynamic> json) =
      _$StudentCardImpl.fromJson;

  @override
  String get cardUid;
  @override
  String get studentId;
  @override
  DateTime get issuedAt;
  @override
  DateTime? get expiresAt;
  @override
  bool get isActive;

  /// Create a copy of StudentCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentCardImplCopyWith<_$StudentCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
