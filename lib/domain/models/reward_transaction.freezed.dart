// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RewardTransaction _$RewardTransactionFromJson(Map<String, dynamic> json) {
  return _RewardTransaction.fromJson(json);
}

/// @nodoc
mixin _$RewardTransaction {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  RewardTransactionType get type => throw _privateConstructorUsedError;
  int get points =>
      throw _privateConstructorUsedError; // signed: negative for redemptions/reversals
  double get rewardValue =>
      throw _privateConstructorUsedError; // monetary value if conversion enabled
  String get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get kioskOrTerminalId => throw _privateConstructorUsedError;
  String? get staffId => throw _privateConstructorUsedError;
  String? get rewardItemId => throw _privateConstructorUsedError;
  RewardTransactionStatus get status => throw _privateConstructorUsedError;

  /// Serializes this RewardTransaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RewardTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RewardTransactionCopyWith<RewardTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RewardTransactionCopyWith<$Res> {
  factory $RewardTransactionCopyWith(
    RewardTransaction value,
    $Res Function(RewardTransaction) then,
  ) = _$RewardTransactionCopyWithImpl<$Res, RewardTransaction>;
  @useResult
  $Res call({
    String id,
    String studentId,
    RewardTransactionType type,
    int points,
    double rewardValue,
    String description,
    DateTime createdAt,
    String? kioskOrTerminalId,
    String? staffId,
    String? rewardItemId,
    RewardTransactionStatus status,
  });
}

/// @nodoc
class _$RewardTransactionCopyWithImpl<$Res, $Val extends RewardTransaction>
    implements $RewardTransactionCopyWith<$Res> {
  _$RewardTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RewardTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? type = null,
    Object? points = null,
    Object? rewardValue = null,
    Object? description = null,
    Object? createdAt = null,
    Object? kioskOrTerminalId = freezed,
    Object? staffId = freezed,
    Object? rewardItemId = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as RewardTransactionType,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            rewardValue: null == rewardValue
                ? _value.rewardValue
                : rewardValue // ignore: cast_nullable_to_non_nullable
                      as double,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            kioskOrTerminalId: freezed == kioskOrTerminalId
                ? _value.kioskOrTerminalId
                : kioskOrTerminalId // ignore: cast_nullable_to_non_nullable
                      as String?,
            staffId: freezed == staffId
                ? _value.staffId
                : staffId // ignore: cast_nullable_to_non_nullable
                      as String?,
            rewardItemId: freezed == rewardItemId
                ? _value.rewardItemId
                : rewardItemId // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as RewardTransactionStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RewardTransactionImplCopyWith<$Res>
    implements $RewardTransactionCopyWith<$Res> {
  factory _$$RewardTransactionImplCopyWith(
    _$RewardTransactionImpl value,
    $Res Function(_$RewardTransactionImpl) then,
  ) = __$$RewardTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    RewardTransactionType type,
    int points,
    double rewardValue,
    String description,
    DateTime createdAt,
    String? kioskOrTerminalId,
    String? staffId,
    String? rewardItemId,
    RewardTransactionStatus status,
  });
}

/// @nodoc
class __$$RewardTransactionImplCopyWithImpl<$Res>
    extends _$RewardTransactionCopyWithImpl<$Res, _$RewardTransactionImpl>
    implements _$$RewardTransactionImplCopyWith<$Res> {
  __$$RewardTransactionImplCopyWithImpl(
    _$RewardTransactionImpl _value,
    $Res Function(_$RewardTransactionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RewardTransaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? type = null,
    Object? points = null,
    Object? rewardValue = null,
    Object? description = null,
    Object? createdAt = null,
    Object? kioskOrTerminalId = freezed,
    Object? staffId = freezed,
    Object? rewardItemId = freezed,
    Object? status = null,
  }) {
    return _then(
      _$RewardTransactionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as RewardTransactionType,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        rewardValue: null == rewardValue
            ? _value.rewardValue
            : rewardValue // ignore: cast_nullable_to_non_nullable
                  as double,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        kioskOrTerminalId: freezed == kioskOrTerminalId
            ? _value.kioskOrTerminalId
            : kioskOrTerminalId // ignore: cast_nullable_to_non_nullable
                  as String?,
        staffId: freezed == staffId
            ? _value.staffId
            : staffId // ignore: cast_nullable_to_non_nullable
                  as String?,
        rewardItemId: freezed == rewardItemId
            ? _value.rewardItemId
            : rewardItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as RewardTransactionStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RewardTransactionImpl extends _RewardTransaction {
  const _$RewardTransactionImpl({
    required this.id,
    required this.studentId,
    required this.type,
    required this.points,
    this.rewardValue = 0.0,
    required this.description,
    required this.createdAt,
    this.kioskOrTerminalId,
    this.staffId,
    this.rewardItemId,
    this.status = RewardTransactionStatus.completed,
  }) : super._();

  factory _$RewardTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RewardTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final RewardTransactionType type;
  @override
  final int points;
  // signed: negative for redemptions/reversals
  @override
  @JsonKey()
  final double rewardValue;
  // monetary value if conversion enabled
  @override
  final String description;
  @override
  final DateTime createdAt;
  @override
  final String? kioskOrTerminalId;
  @override
  final String? staffId;
  @override
  final String? rewardItemId;
  @override
  @JsonKey()
  final RewardTransactionStatus status;

  @override
  String toString() {
    return 'RewardTransaction(id: $id, studentId: $studentId, type: $type, points: $points, rewardValue: $rewardValue, description: $description, createdAt: $createdAt, kioskOrTerminalId: $kioskOrTerminalId, staffId: $staffId, rewardItemId: $rewardItemId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RewardTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.rewardValue, rewardValue) ||
                other.rewardValue == rewardValue) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.kioskOrTerminalId, kioskOrTerminalId) ||
                other.kioskOrTerminalId == kioskOrTerminalId) &&
            (identical(other.staffId, staffId) || other.staffId == staffId) &&
            (identical(other.rewardItemId, rewardItemId) ||
                other.rewardItemId == rewardItemId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    type,
    points,
    rewardValue,
    description,
    createdAt,
    kioskOrTerminalId,
    staffId,
    rewardItemId,
    status,
  );

  /// Create a copy of RewardTransaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RewardTransactionImplCopyWith<_$RewardTransactionImpl> get copyWith =>
      __$$RewardTransactionImplCopyWithImpl<_$RewardTransactionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RewardTransactionImplToJson(this);
  }
}

abstract class _RewardTransaction extends RewardTransaction {
  const factory _RewardTransaction({
    required final String id,
    required final String studentId,
    required final RewardTransactionType type,
    required final int points,
    final double rewardValue,
    required final String description,
    required final DateTime createdAt,
    final String? kioskOrTerminalId,
    final String? staffId,
    final String? rewardItemId,
    final RewardTransactionStatus status,
  }) = _$RewardTransactionImpl;
  const _RewardTransaction._() : super._();

  factory _RewardTransaction.fromJson(Map<String, dynamic> json) =
      _$RewardTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  RewardTransactionType get type;
  @override
  int get points; // signed: negative for redemptions/reversals
  @override
  double get rewardValue; // monetary value if conversion enabled
  @override
  String get description;
  @override
  DateTime get createdAt;
  @override
  String? get kioskOrTerminalId;
  @override
  String? get staffId;
  @override
  String? get rewardItemId;
  @override
  RewardTransactionStatus get status;

  /// Create a copy of RewardTransaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RewardTransactionImplCopyWith<_$RewardTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
