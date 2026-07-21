// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recycling_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RecyclingSession _$RecyclingSessionFromJson(Map<String, dynamic> json) {
  return _RecyclingSession.fromJson(json);
}

/// @nodoc
mixin _$RecyclingSession {
  String get id => throw _privateConstructorUsedError;
  String get studentId => throw _privateConstructorUsedError;
  String get kioskId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  WasteClassificationResult? get classificationResult =>
      throw _privateConstructorUsedError;
  WasteCategory? get studentSelectedCategory =>
      throw _privateConstructorUsedError;
  WasteCategory? get finalCategory => throw _privateConstructorUsedError;
  bool get wasCorrect => throw _privateConstructorUsedError;
  int get pointsAwarded => throw _privateConstructorUsedError;
  int get housePointsAwarded => throw _privateConstructorUsedError;
  int get streakAfterSession => throw _privateConstructorUsedError;
  SessionStatus get status => throw _privateConstructorUsedError;
  HardwareCommandStatus get hardwareCommandStatus =>
      throw _privateConstructorUsedError;
  bool get bonusApplied => throw _privateConstructorUsedError;
  bool get dailyCapReached =>
      throw _privateConstructorUsedError; // Idempotency key ensures an offline-queued session is only applied once.
  String get idempotencyKey => throw _privateConstructorUsedError;

  /// Serializes this RecyclingSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecyclingSessionCopyWith<RecyclingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecyclingSessionCopyWith<$Res> {
  factory $RecyclingSessionCopyWith(
    RecyclingSession value,
    $Res Function(RecyclingSession) then,
  ) = _$RecyclingSessionCopyWithImpl<$Res, RecyclingSession>;
  @useResult
  $Res call({
    String id,
    String studentId,
    String kioskId,
    DateTime startedAt,
    DateTime? completedAt,
    WasteClassificationResult? classificationResult,
    WasteCategory? studentSelectedCategory,
    WasteCategory? finalCategory,
    bool wasCorrect,
    int pointsAwarded,
    int housePointsAwarded,
    int streakAfterSession,
    SessionStatus status,
    HardwareCommandStatus hardwareCommandStatus,
    bool bonusApplied,
    bool dailyCapReached,
    String idempotencyKey,
  });

  $WasteClassificationResultCopyWith<$Res>? get classificationResult;
}

/// @nodoc
class _$RecyclingSessionCopyWithImpl<$Res, $Val extends RecyclingSession>
    implements $RecyclingSessionCopyWith<$Res> {
  _$RecyclingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? kioskId = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? classificationResult = freezed,
    Object? studentSelectedCategory = freezed,
    Object? finalCategory = freezed,
    Object? wasCorrect = null,
    Object? pointsAwarded = null,
    Object? housePointsAwarded = null,
    Object? streakAfterSession = null,
    Object? status = null,
    Object? hardwareCommandStatus = null,
    Object? bonusApplied = null,
    Object? dailyCapReached = null,
    Object? idempotencyKey = null,
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
            kioskId: null == kioskId
                ? _value.kioskId
                : kioskId // ignore: cast_nullable_to_non_nullable
                      as String,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            classificationResult: freezed == classificationResult
                ? _value.classificationResult
                : classificationResult // ignore: cast_nullable_to_non_nullable
                      as WasteClassificationResult?,
            studentSelectedCategory: freezed == studentSelectedCategory
                ? _value.studentSelectedCategory
                : studentSelectedCategory // ignore: cast_nullable_to_non_nullable
                      as WasteCategory?,
            finalCategory: freezed == finalCategory
                ? _value.finalCategory
                : finalCategory // ignore: cast_nullable_to_non_nullable
                      as WasteCategory?,
            wasCorrect: null == wasCorrect
                ? _value.wasCorrect
                : wasCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            pointsAwarded: null == pointsAwarded
                ? _value.pointsAwarded
                : pointsAwarded // ignore: cast_nullable_to_non_nullable
                      as int,
            housePointsAwarded: null == housePointsAwarded
                ? _value.housePointsAwarded
                : housePointsAwarded // ignore: cast_nullable_to_non_nullable
                      as int,
            streakAfterSession: null == streakAfterSession
                ? _value.streakAfterSession
                : streakAfterSession // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SessionStatus,
            hardwareCommandStatus: null == hardwareCommandStatus
                ? _value.hardwareCommandStatus
                : hardwareCommandStatus // ignore: cast_nullable_to_non_nullable
                      as HardwareCommandStatus,
            bonusApplied: null == bonusApplied
                ? _value.bonusApplied
                : bonusApplied // ignore: cast_nullable_to_non_nullable
                      as bool,
            dailyCapReached: null == dailyCapReached
                ? _value.dailyCapReached
                : dailyCapReached // ignore: cast_nullable_to_non_nullable
                      as bool,
            idempotencyKey: null == idempotencyKey
                ? _value.idempotencyKey
                : idempotencyKey // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WasteClassificationResultCopyWith<$Res>? get classificationResult {
    if (_value.classificationResult == null) {
      return null;
    }

    return $WasteClassificationResultCopyWith<$Res>(
      _value.classificationResult!,
      (value) {
        return _then(_value.copyWith(classificationResult: value) as $Val);
      },
    );
  }
}

/// @nodoc
abstract class _$$RecyclingSessionImplCopyWith<$Res>
    implements $RecyclingSessionCopyWith<$Res> {
  factory _$$RecyclingSessionImplCopyWith(
    _$RecyclingSessionImpl value,
    $Res Function(_$RecyclingSessionImpl) then,
  ) = __$$RecyclingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentId,
    String kioskId,
    DateTime startedAt,
    DateTime? completedAt,
    WasteClassificationResult? classificationResult,
    WasteCategory? studentSelectedCategory,
    WasteCategory? finalCategory,
    bool wasCorrect,
    int pointsAwarded,
    int housePointsAwarded,
    int streakAfterSession,
    SessionStatus status,
    HardwareCommandStatus hardwareCommandStatus,
    bool bonusApplied,
    bool dailyCapReached,
    String idempotencyKey,
  });

  @override
  $WasteClassificationResultCopyWith<$Res>? get classificationResult;
}

/// @nodoc
class __$$RecyclingSessionImplCopyWithImpl<$Res>
    extends _$RecyclingSessionCopyWithImpl<$Res, _$RecyclingSessionImpl>
    implements _$$RecyclingSessionImplCopyWith<$Res> {
  __$$RecyclingSessionImplCopyWithImpl(
    _$RecyclingSessionImpl _value,
    $Res Function(_$RecyclingSessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? kioskId = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? classificationResult = freezed,
    Object? studentSelectedCategory = freezed,
    Object? finalCategory = freezed,
    Object? wasCorrect = null,
    Object? pointsAwarded = null,
    Object? housePointsAwarded = null,
    Object? streakAfterSession = null,
    Object? status = null,
    Object? hardwareCommandStatus = null,
    Object? bonusApplied = null,
    Object? dailyCapReached = null,
    Object? idempotencyKey = null,
  }) {
    return _then(
      _$RecyclingSessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        kioskId: null == kioskId
            ? _value.kioskId
            : kioskId // ignore: cast_nullable_to_non_nullable
                  as String,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        classificationResult: freezed == classificationResult
            ? _value.classificationResult
            : classificationResult // ignore: cast_nullable_to_non_nullable
                  as WasteClassificationResult?,
        studentSelectedCategory: freezed == studentSelectedCategory
            ? _value.studentSelectedCategory
            : studentSelectedCategory // ignore: cast_nullable_to_non_nullable
                  as WasteCategory?,
        finalCategory: freezed == finalCategory
            ? _value.finalCategory
            : finalCategory // ignore: cast_nullable_to_non_nullable
                  as WasteCategory?,
        wasCorrect: null == wasCorrect
            ? _value.wasCorrect
            : wasCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        pointsAwarded: null == pointsAwarded
            ? _value.pointsAwarded
            : pointsAwarded // ignore: cast_nullable_to_non_nullable
                  as int,
        housePointsAwarded: null == housePointsAwarded
            ? _value.housePointsAwarded
            : housePointsAwarded // ignore: cast_nullable_to_non_nullable
                  as int,
        streakAfterSession: null == streakAfterSession
            ? _value.streakAfterSession
            : streakAfterSession // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SessionStatus,
        hardwareCommandStatus: null == hardwareCommandStatus
            ? _value.hardwareCommandStatus
            : hardwareCommandStatus // ignore: cast_nullable_to_non_nullable
                  as HardwareCommandStatus,
        bonusApplied: null == bonusApplied
            ? _value.bonusApplied
            : bonusApplied // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyCapReached: null == dailyCapReached
            ? _value.dailyCapReached
            : dailyCapReached // ignore: cast_nullable_to_non_nullable
                  as bool,
        idempotencyKey: null == idempotencyKey
            ? _value.idempotencyKey
            : idempotencyKey // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecyclingSessionImpl extends _RecyclingSession {
  const _$RecyclingSessionImpl({
    required this.id,
    required this.studentId,
    required this.kioskId,
    required this.startedAt,
    this.completedAt,
    this.classificationResult,
    this.studentSelectedCategory,
    this.finalCategory,
    this.wasCorrect = false,
    this.pointsAwarded = 0,
    this.housePointsAwarded = 0,
    this.streakAfterSession = 0,
    this.status = SessionStatus.active,
    this.hardwareCommandStatus = HardwareCommandStatus.pending,
    this.bonusApplied = false,
    this.dailyCapReached = false,
    required this.idempotencyKey,
  }) : super._();

  factory _$RecyclingSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecyclingSessionImplFromJson(json);

  @override
  final String id;
  @override
  final String studentId;
  @override
  final String kioskId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final WasteClassificationResult? classificationResult;
  @override
  final WasteCategory? studentSelectedCategory;
  @override
  final WasteCategory? finalCategory;
  @override
  @JsonKey()
  final bool wasCorrect;
  @override
  @JsonKey()
  final int pointsAwarded;
  @override
  @JsonKey()
  final int housePointsAwarded;
  @override
  @JsonKey()
  final int streakAfterSession;
  @override
  @JsonKey()
  final SessionStatus status;
  @override
  @JsonKey()
  final HardwareCommandStatus hardwareCommandStatus;
  @override
  @JsonKey()
  final bool bonusApplied;
  @override
  @JsonKey()
  final bool dailyCapReached;
  // Idempotency key ensures an offline-queued session is only applied once.
  @override
  final String idempotencyKey;

  @override
  String toString() {
    return 'RecyclingSession(id: $id, studentId: $studentId, kioskId: $kioskId, startedAt: $startedAt, completedAt: $completedAt, classificationResult: $classificationResult, studentSelectedCategory: $studentSelectedCategory, finalCategory: $finalCategory, wasCorrect: $wasCorrect, pointsAwarded: $pointsAwarded, housePointsAwarded: $housePointsAwarded, streakAfterSession: $streakAfterSession, status: $status, hardwareCommandStatus: $hardwareCommandStatus, bonusApplied: $bonusApplied, dailyCapReached: $dailyCapReached, idempotencyKey: $idempotencyKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecyclingSessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.kioskId, kioskId) || other.kioskId == kioskId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.classificationResult, classificationResult) ||
                other.classificationResult == classificationResult) &&
            (identical(
                  other.studentSelectedCategory,
                  studentSelectedCategory,
                ) ||
                other.studentSelectedCategory == studentSelectedCategory) &&
            (identical(other.finalCategory, finalCategory) ||
                other.finalCategory == finalCategory) &&
            (identical(other.wasCorrect, wasCorrect) ||
                other.wasCorrect == wasCorrect) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                other.pointsAwarded == pointsAwarded) &&
            (identical(other.housePointsAwarded, housePointsAwarded) ||
                other.housePointsAwarded == housePointsAwarded) &&
            (identical(other.streakAfterSession, streakAfterSession) ||
                other.streakAfterSession == streakAfterSession) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hardwareCommandStatus, hardwareCommandStatus) ||
                other.hardwareCommandStatus == hardwareCommandStatus) &&
            (identical(other.bonusApplied, bonusApplied) ||
                other.bonusApplied == bonusApplied) &&
            (identical(other.dailyCapReached, dailyCapReached) ||
                other.dailyCapReached == dailyCapReached) &&
            (identical(other.idempotencyKey, idempotencyKey) ||
                other.idempotencyKey == idempotencyKey));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentId,
    kioskId,
    startedAt,
    completedAt,
    classificationResult,
    studentSelectedCategory,
    finalCategory,
    wasCorrect,
    pointsAwarded,
    housePointsAwarded,
    streakAfterSession,
    status,
    hardwareCommandStatus,
    bonusApplied,
    dailyCapReached,
    idempotencyKey,
  );

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecyclingSessionImplCopyWith<_$RecyclingSessionImpl> get copyWith =>
      __$$RecyclingSessionImplCopyWithImpl<_$RecyclingSessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecyclingSessionImplToJson(this);
  }
}

abstract class _RecyclingSession extends RecyclingSession {
  const factory _RecyclingSession({
    required final String id,
    required final String studentId,
    required final String kioskId,
    required final DateTime startedAt,
    final DateTime? completedAt,
    final WasteClassificationResult? classificationResult,
    final WasteCategory? studentSelectedCategory,
    final WasteCategory? finalCategory,
    final bool wasCorrect,
    final int pointsAwarded,
    final int housePointsAwarded,
    final int streakAfterSession,
    final SessionStatus status,
    final HardwareCommandStatus hardwareCommandStatus,
    final bool bonusApplied,
    final bool dailyCapReached,
    required final String idempotencyKey,
  }) = _$RecyclingSessionImpl;
  const _RecyclingSession._() : super._();

  factory _RecyclingSession.fromJson(Map<String, dynamic> json) =
      _$RecyclingSessionImpl.fromJson;

  @override
  String get id;
  @override
  String get studentId;
  @override
  String get kioskId;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  WasteClassificationResult? get classificationResult;
  @override
  WasteCategory? get studentSelectedCategory;
  @override
  WasteCategory? get finalCategory;
  @override
  bool get wasCorrect;
  @override
  int get pointsAwarded;
  @override
  int get housePointsAwarded;
  @override
  int get streakAfterSession;
  @override
  SessionStatus get status;
  @override
  HardwareCommandStatus get hardwareCommandStatus;
  @override
  bool get bonusApplied;
  @override
  bool get dailyCapReached; // Idempotency key ensures an offline-queued session is only applied once.
  @override
  String get idempotencyKey;

  /// Create a copy of RecyclingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecyclingSessionImplCopyWith<_$RecyclingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
