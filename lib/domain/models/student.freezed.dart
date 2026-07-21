// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Student _$StudentFromJson(Map<String, dynamic> json) {
  return _Student.fromJson(json);
}

/// @nodoc
mixin _$Student {
  String get id => throw _privateConstructorUsedError;
  String get studentNumber => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  String get className => throw _privateConstructorUsedError;
  String get houseId => throw _privateConstructorUsedError;
  String get avatarId => throw _privateConstructorUsedError;
  int get totalXp => throw _privateConstructorUsedError;
  int get availablePoints => throw _privateConstructorUsedError;
  double get rewardBalance => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get correctRecyclingCount => throw _privateConstructorUsedError;
  int get incorrectRecyclingCount => throw _privateConstructorUsedError;
  int get dailyEarnedPoints => throw _privateConstructorUsedError;
  DateTime? get lastActiveAt => throw _privateConstructorUsedError;
  AccountStatus get accountStatus => throw _privateConstructorUsedError;

  /// Serializes this Student to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentCopyWith<Student> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentCopyWith<$Res> {
  factory $StudentCopyWith(Student value, $Res Function(Student) then) =
      _$StudentCopyWithImpl<$Res, Student>;
  @useResult
  $Res call({
    String id,
    String studentNumber,
    String firstName,
    String lastName,
    int grade,
    String className,
    String houseId,
    String avatarId,
    int totalXp,
    int availablePoints,
    double rewardBalance,
    int currentStreak,
    int longestStreak,
    int correctRecyclingCount,
    int incorrectRecyclingCount,
    int dailyEarnedPoints,
    DateTime? lastActiveAt,
    AccountStatus accountStatus,
  });
}

/// @nodoc
class _$StudentCopyWithImpl<$Res, $Val extends Student>
    implements $StudentCopyWith<$Res> {
  _$StudentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? grade = null,
    Object? className = null,
    Object? houseId = null,
    Object? avatarId = null,
    Object? totalXp = null,
    Object? availablePoints = null,
    Object? rewardBalance = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? correctRecyclingCount = null,
    Object? incorrectRecyclingCount = null,
    Object? dailyEarnedPoints = null,
    Object? lastActiveAt = freezed,
    Object? accountStatus = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            studentNumber: null == studentNumber
                ? _value.studentNumber
                : studentNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: null == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String,
            lastName: null == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String,
            grade: null == grade
                ? _value.grade
                : grade // ignore: cast_nullable_to_non_nullable
                      as int,
            className: null == className
                ? _value.className
                : className // ignore: cast_nullable_to_non_nullable
                      as String,
            houseId: null == houseId
                ? _value.houseId
                : houseId // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarId: null == avatarId
                ? _value.avatarId
                : avatarId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalXp: null == totalXp
                ? _value.totalXp
                : totalXp // ignore: cast_nullable_to_non_nullable
                      as int,
            availablePoints: null == availablePoints
                ? _value.availablePoints
                : availablePoints // ignore: cast_nullable_to_non_nullable
                      as int,
            rewardBalance: null == rewardBalance
                ? _value.rewardBalance
                : rewardBalance // ignore: cast_nullable_to_non_nullable
                      as double,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            correctRecyclingCount: null == correctRecyclingCount
                ? _value.correctRecyclingCount
                : correctRecyclingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            incorrectRecyclingCount: null == incorrectRecyclingCount
                ? _value.incorrectRecyclingCount
                : incorrectRecyclingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyEarnedPoints: null == dailyEarnedPoints
                ? _value.dailyEarnedPoints
                : dailyEarnedPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            lastActiveAt: freezed == lastActiveAt
                ? _value.lastActiveAt
                : lastActiveAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            accountStatus: null == accountStatus
                ? _value.accountStatus
                : accountStatus // ignore: cast_nullable_to_non_nullable
                      as AccountStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentImplCopyWith<$Res> implements $StudentCopyWith<$Res> {
  factory _$$StudentImplCopyWith(
    _$StudentImpl value,
    $Res Function(_$StudentImpl) then,
  ) = __$$StudentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String studentNumber,
    String firstName,
    String lastName,
    int grade,
    String className,
    String houseId,
    String avatarId,
    int totalXp,
    int availablePoints,
    double rewardBalance,
    int currentStreak,
    int longestStreak,
    int correctRecyclingCount,
    int incorrectRecyclingCount,
    int dailyEarnedPoints,
    DateTime? lastActiveAt,
    AccountStatus accountStatus,
  });
}

/// @nodoc
class __$$StudentImplCopyWithImpl<$Res>
    extends _$StudentCopyWithImpl<$Res, _$StudentImpl>
    implements _$$StudentImplCopyWith<$Res> {
  __$$StudentImplCopyWithImpl(
    _$StudentImpl _value,
    $Res Function(_$StudentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentNumber = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? grade = null,
    Object? className = null,
    Object? houseId = null,
    Object? avatarId = null,
    Object? totalXp = null,
    Object? availablePoints = null,
    Object? rewardBalance = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? correctRecyclingCount = null,
    Object? incorrectRecyclingCount = null,
    Object? dailyEarnedPoints = null,
    Object? lastActiveAt = freezed,
    Object? accountStatus = null,
  }) {
    return _then(
      _$StudentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        studentNumber: null == studentNumber
            ? _value.studentNumber
            : studentNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: null == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String,
        lastName: null == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String,
        grade: null == grade
            ? _value.grade
            : grade // ignore: cast_nullable_to_non_nullable
                  as int,
        className: null == className
            ? _value.className
            : className // ignore: cast_nullable_to_non_nullable
                  as String,
        houseId: null == houseId
            ? _value.houseId
            : houseId // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarId: null == avatarId
            ? _value.avatarId
            : avatarId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalXp: null == totalXp
            ? _value.totalXp
            : totalXp // ignore: cast_nullable_to_non_nullable
                  as int,
        availablePoints: null == availablePoints
            ? _value.availablePoints
            : availablePoints // ignore: cast_nullable_to_non_nullable
                  as int,
        rewardBalance: null == rewardBalance
            ? _value.rewardBalance
            : rewardBalance // ignore: cast_nullable_to_non_nullable
                  as double,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        correctRecyclingCount: null == correctRecyclingCount
            ? _value.correctRecyclingCount
            : correctRecyclingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        incorrectRecyclingCount: null == incorrectRecyclingCount
            ? _value.incorrectRecyclingCount
            : incorrectRecyclingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyEarnedPoints: null == dailyEarnedPoints
            ? _value.dailyEarnedPoints
            : dailyEarnedPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        lastActiveAt: freezed == lastActiveAt
            ? _value.lastActiveAt
            : lastActiveAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        accountStatus: null == accountStatus
            ? _value.accountStatus
            : accountStatus // ignore: cast_nullable_to_non_nullable
                  as AccountStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentImpl extends _Student {
  const _$StudentImpl({
    required this.id,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.grade,
    required this.className,
    required this.houseId,
    required this.avatarId,
    this.totalXp = 0,
    this.availablePoints = 0,
    this.rewardBalance = 0.0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.correctRecyclingCount = 0,
    this.incorrectRecyclingCount = 0,
    this.dailyEarnedPoints = 0,
    this.lastActiveAt,
    this.accountStatus = AccountStatus.active,
  }) : super._();

  factory _$StudentImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentImplFromJson(json);

  @override
  final String id;
  @override
  final String studentNumber;
  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int grade;
  @override
  final String className;
  @override
  final String houseId;
  @override
  final String avatarId;
  @override
  @JsonKey()
  final int totalXp;
  @override
  @JsonKey()
  final int availablePoints;
  @override
  @JsonKey()
  final double rewardBalance;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  @JsonKey()
  final int correctRecyclingCount;
  @override
  @JsonKey()
  final int incorrectRecyclingCount;
  @override
  @JsonKey()
  final int dailyEarnedPoints;
  @override
  final DateTime? lastActiveAt;
  @override
  @JsonKey()
  final AccountStatus accountStatus;

  @override
  String toString() {
    return 'Student(id: $id, studentNumber: $studentNumber, firstName: $firstName, lastName: $lastName, grade: $grade, className: $className, houseId: $houseId, avatarId: $avatarId, totalXp: $totalXp, availablePoints: $availablePoints, rewardBalance: $rewardBalance, currentStreak: $currentStreak, longestStreak: $longestStreak, correctRecyclingCount: $correctRecyclingCount, incorrectRecyclingCount: $incorrectRecyclingCount, dailyEarnedPoints: $dailyEarnedPoints, lastActiveAt: $lastActiveAt, accountStatus: $accountStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentNumber, studentNumber) ||
                other.studentNumber == studentNumber) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            (identical(other.className, className) ||
                other.className == className) &&
            (identical(other.houseId, houseId) || other.houseId == houseId) &&
            (identical(other.avatarId, avatarId) ||
                other.avatarId == avatarId) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.availablePoints, availablePoints) ||
                other.availablePoints == availablePoints) &&
            (identical(other.rewardBalance, rewardBalance) ||
                other.rewardBalance == rewardBalance) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.correctRecyclingCount, correctRecyclingCount) ||
                other.correctRecyclingCount == correctRecyclingCount) &&
            (identical(
                  other.incorrectRecyclingCount,
                  incorrectRecyclingCount,
                ) ||
                other.incorrectRecyclingCount == incorrectRecyclingCount) &&
            (identical(other.dailyEarnedPoints, dailyEarnedPoints) ||
                other.dailyEarnedPoints == dailyEarnedPoints) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    studentNumber,
    firstName,
    lastName,
    grade,
    className,
    houseId,
    avatarId,
    totalXp,
    availablePoints,
    rewardBalance,
    currentStreak,
    longestStreak,
    correctRecyclingCount,
    incorrectRecyclingCount,
    dailyEarnedPoints,
    lastActiveAt,
    accountStatus,
  );

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      __$$StudentImplCopyWithImpl<_$StudentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentImplToJson(this);
  }
}

abstract class _Student extends Student {
  const factory _Student({
    required final String id,
    required final String studentNumber,
    required final String firstName,
    required final String lastName,
    required final int grade,
    required final String className,
    required final String houseId,
    required final String avatarId,
    final int totalXp,
    final int availablePoints,
    final double rewardBalance,
    final int currentStreak,
    final int longestStreak,
    final int correctRecyclingCount,
    final int incorrectRecyclingCount,
    final int dailyEarnedPoints,
    final DateTime? lastActiveAt,
    final AccountStatus accountStatus,
  }) = _$StudentImpl;
  const _Student._() : super._();

  factory _Student.fromJson(Map<String, dynamic> json) = _$StudentImpl.fromJson;

  @override
  String get id;
  @override
  String get studentNumber;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  int get grade;
  @override
  String get className;
  @override
  String get houseId;
  @override
  String get avatarId;
  @override
  int get totalXp;
  @override
  int get availablePoints;
  @override
  double get rewardBalance;
  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  int get correctRecyclingCount;
  @override
  int get incorrectRecyclingCount;
  @override
  int get dailyEarnedPoints;
  @override
  DateTime? get lastActiveAt;
  @override
  AccountStatus get accountStatus;

  /// Create a copy of Student
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentImplCopyWith<_$StudentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
