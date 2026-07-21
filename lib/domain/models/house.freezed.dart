// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'house.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

House _$HouseFromJson(Map<String, dynamic> json) {
  return _House.fromJson(json);
}

/// @nodoc
mixin _$House {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get colour =>
      throw _privateConstructorUsedError; // hex string, e.g. "#E0A400"
  String get emblem =>
      throw _privateConstructorUsedError; // symbolic emblem key (see HouseEmblem)
  int get totalPoints => throw _privateConstructorUsedError;
  int get weeklyPoints => throw _privateConstructorUsedError;
  String get sustainabilityGoal => throw _privateConstructorUsedError;
  double get goalProgress =>
      throw _privateConstructorUsedError; // 0..1 toward the sustainability goal
  int get leaderboardPosition => throw _privateConstructorUsedError;
  int get memberCount => throw _privateConstructorUsedError;

  /// Serializes this House to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of House
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HouseCopyWith<House> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HouseCopyWith<$Res> {
  factory $HouseCopyWith(House value, $Res Function(House) then) =
      _$HouseCopyWithImpl<$Res, House>;
  @useResult
  $Res call({
    String id,
    String name,
    String colour,
    String emblem,
    int totalPoints,
    int weeklyPoints,
    String sustainabilityGoal,
    double goalProgress,
    int leaderboardPosition,
    int memberCount,
  });
}

/// @nodoc
class _$HouseCopyWithImpl<$Res, $Val extends House>
    implements $HouseCopyWith<$Res> {
  _$HouseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of House
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colour = null,
    Object? emblem = null,
    Object? totalPoints = null,
    Object? weeklyPoints = null,
    Object? sustainabilityGoal = null,
    Object? goalProgress = null,
    Object? leaderboardPosition = null,
    Object? memberCount = null,
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
            colour: null == colour
                ? _value.colour
                : colour // ignore: cast_nullable_to_non_nullable
                      as String,
            emblem: null == emblem
                ? _value.emblem
                : emblem // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            weeklyPoints: null == weeklyPoints
                ? _value.weeklyPoints
                : weeklyPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            sustainabilityGoal: null == sustainabilityGoal
                ? _value.sustainabilityGoal
                : sustainabilityGoal // ignore: cast_nullable_to_non_nullable
                      as String,
            goalProgress: null == goalProgress
                ? _value.goalProgress
                : goalProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            leaderboardPosition: null == leaderboardPosition
                ? _value.leaderboardPosition
                : leaderboardPosition // ignore: cast_nullable_to_non_nullable
                      as int,
            memberCount: null == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HouseImplCopyWith<$Res> implements $HouseCopyWith<$Res> {
  factory _$$HouseImplCopyWith(
    _$HouseImpl value,
    $Res Function(_$HouseImpl) then,
  ) = __$$HouseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String colour,
    String emblem,
    int totalPoints,
    int weeklyPoints,
    String sustainabilityGoal,
    double goalProgress,
    int leaderboardPosition,
    int memberCount,
  });
}

/// @nodoc
class __$$HouseImplCopyWithImpl<$Res>
    extends _$HouseCopyWithImpl<$Res, _$HouseImpl>
    implements _$$HouseImplCopyWith<$Res> {
  __$$HouseImplCopyWithImpl(
    _$HouseImpl _value,
    $Res Function(_$HouseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of House
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? colour = null,
    Object? emblem = null,
    Object? totalPoints = null,
    Object? weeklyPoints = null,
    Object? sustainabilityGoal = null,
    Object? goalProgress = null,
    Object? leaderboardPosition = null,
    Object? memberCount = null,
  }) {
    return _then(
      _$HouseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        colour: null == colour
            ? _value.colour
            : colour // ignore: cast_nullable_to_non_nullable
                  as String,
        emblem: null == emblem
            ? _value.emblem
            : emblem // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyPoints: null == weeklyPoints
            ? _value.weeklyPoints
            : weeklyPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        sustainabilityGoal: null == sustainabilityGoal
            ? _value.sustainabilityGoal
            : sustainabilityGoal // ignore: cast_nullable_to_non_nullable
                  as String,
        goalProgress: null == goalProgress
            ? _value.goalProgress
            : goalProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        leaderboardPosition: null == leaderboardPosition
            ? _value.leaderboardPosition
            : leaderboardPosition // ignore: cast_nullable_to_non_nullable
                  as int,
        memberCount: null == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HouseImpl extends _House {
  const _$HouseImpl({
    required this.id,
    required this.name,
    required this.colour,
    required this.emblem,
    this.totalPoints = 0,
    this.weeklyPoints = 0,
    required this.sustainabilityGoal,
    this.goalProgress = 0.0,
    this.leaderboardPosition = 0,
    this.memberCount = 0,
  }) : super._();

  factory _$HouseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HouseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String colour;
  // hex string, e.g. "#E0A400"
  @override
  final String emblem;
  // symbolic emblem key (see HouseEmblem)
  @override
  @JsonKey()
  final int totalPoints;
  @override
  @JsonKey()
  final int weeklyPoints;
  @override
  final String sustainabilityGoal;
  @override
  @JsonKey()
  final double goalProgress;
  // 0..1 toward the sustainability goal
  @override
  @JsonKey()
  final int leaderboardPosition;
  @override
  @JsonKey()
  final int memberCount;

  @override
  String toString() {
    return 'House(id: $id, name: $name, colour: $colour, emblem: $emblem, totalPoints: $totalPoints, weeklyPoints: $weeklyPoints, sustainabilityGoal: $sustainabilityGoal, goalProgress: $goalProgress, leaderboardPosition: $leaderboardPosition, memberCount: $memberCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HouseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.colour, colour) || other.colour == colour) &&
            (identical(other.emblem, emblem) || other.emblem == emblem) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.weeklyPoints, weeklyPoints) ||
                other.weeklyPoints == weeklyPoints) &&
            (identical(other.sustainabilityGoal, sustainabilityGoal) ||
                other.sustainabilityGoal == sustainabilityGoal) &&
            (identical(other.goalProgress, goalProgress) ||
                other.goalProgress == goalProgress) &&
            (identical(other.leaderboardPosition, leaderboardPosition) ||
                other.leaderboardPosition == leaderboardPosition) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    colour,
    emblem,
    totalPoints,
    weeklyPoints,
    sustainabilityGoal,
    goalProgress,
    leaderboardPosition,
    memberCount,
  );

  /// Create a copy of House
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HouseImplCopyWith<_$HouseImpl> get copyWith =>
      __$$HouseImplCopyWithImpl<_$HouseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HouseImplToJson(this);
  }
}

abstract class _House extends House {
  const factory _House({
    required final String id,
    required final String name,
    required final String colour,
    required final String emblem,
    final int totalPoints,
    final int weeklyPoints,
    required final String sustainabilityGoal,
    final double goalProgress,
    final int leaderboardPosition,
    final int memberCount,
  }) = _$HouseImpl;
  const _House._() : super._();

  factory _House.fromJson(Map<String, dynamic> json) = _$HouseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get colour; // hex string, e.g. "#E0A400"
  @override
  String get emblem; // symbolic emblem key (see HouseEmblem)
  @override
  int get totalPoints;
  @override
  int get weeklyPoints;
  @override
  String get sustainabilityGoal;
  @override
  double get goalProgress; // 0..1 toward the sustainability goal
  @override
  int get leaderboardPosition;
  @override
  int get memberCount;

  /// Create a copy of House
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HouseImplCopyWith<_$HouseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
