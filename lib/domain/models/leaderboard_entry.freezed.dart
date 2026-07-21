// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LeaderboardEntry _$LeaderboardEntryFromJson(Map<String, dynamic> json) {
  return _LeaderboardEntry.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardEntry {
  String get entityId => throw _privateConstructorUsedError;
  String get entityName => throw _privateConstructorUsedError;
  LeaderboardEntityType get entityType => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  int get totalPoints => throw _privateConstructorUsedError;
  int get weeklyChange =>
      throw _privateConstructorUsedError; // positions gained (+) / lost (-) this week
  String get houseColour => throw _privateConstructorUsedError;
  String get subtitle =>
      throw _privateConstructorUsedError; // e.g. "Green Pioneer" or "Class 4B"
  bool get isCurrentEntity => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardEntryCopyWith<$Res> {
  factory $LeaderboardEntryCopyWith(
    LeaderboardEntry value,
    $Res Function(LeaderboardEntry) then,
  ) = _$LeaderboardEntryCopyWithImpl<$Res, LeaderboardEntry>;
  @useResult
  $Res call({
    String entityId,
    String entityName,
    LeaderboardEntityType entityType,
    int rank,
    int totalPoints,
    int weeklyChange,
    String houseColour,
    String subtitle,
    bool isCurrentEntity,
  });
}

/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res, $Val extends LeaderboardEntry>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityName = null,
    Object? entityType = null,
    Object? rank = null,
    Object? totalPoints = null,
    Object? weeklyChange = null,
    Object? houseColour = null,
    Object? subtitle = null,
    Object? isCurrentEntity = null,
  }) {
    return _then(
      _value.copyWith(
            entityId: null == entityId
                ? _value.entityId
                : entityId // ignore: cast_nullable_to_non_nullable
                      as String,
            entityName: null == entityName
                ? _value.entityName
                : entityName // ignore: cast_nullable_to_non_nullable
                      as String,
            entityType: null == entityType
                ? _value.entityType
                : entityType // ignore: cast_nullable_to_non_nullable
                      as LeaderboardEntityType,
            rank: null == rank
                ? _value.rank
                : rank // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPoints: null == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            weeklyChange: null == weeklyChange
                ? _value.weeklyChange
                : weeklyChange // ignore: cast_nullable_to_non_nullable
                      as int,
            houseColour: null == houseColour
                ? _value.houseColour
                : houseColour // ignore: cast_nullable_to_non_nullable
                      as String,
            subtitle: null == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String,
            isCurrentEntity: null == isCurrentEntity
                ? _value.isCurrentEntity
                : isCurrentEntity // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaderboardEntryImplCopyWith<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  factory _$$LeaderboardEntryImplCopyWith(
    _$LeaderboardEntryImpl value,
    $Res Function(_$LeaderboardEntryImpl) then,
  ) = __$$LeaderboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String entityId,
    String entityName,
    LeaderboardEntityType entityType,
    int rank,
    int totalPoints,
    int weeklyChange,
    String houseColour,
    String subtitle,
    bool isCurrentEntity,
  });
}

/// @nodoc
class __$$LeaderboardEntryImplCopyWithImpl<$Res>
    extends _$LeaderboardEntryCopyWithImpl<$Res, _$LeaderboardEntryImpl>
    implements _$$LeaderboardEntryImplCopyWith<$Res> {
  __$$LeaderboardEntryImplCopyWithImpl(
    _$LeaderboardEntryImpl _value,
    $Res Function(_$LeaderboardEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityName = null,
    Object? entityType = null,
    Object? rank = null,
    Object? totalPoints = null,
    Object? weeklyChange = null,
    Object? houseColour = null,
    Object? subtitle = null,
    Object? isCurrentEntity = null,
  }) {
    return _then(
      _$LeaderboardEntryImpl(
        entityId: null == entityId
            ? _value.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        entityName: null == entityName
            ? _value.entityName
            : entityName // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _value.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as LeaderboardEntityType,
        rank: null == rank
            ? _value.rank
            : rank // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPoints: null == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        weeklyChange: null == weeklyChange
            ? _value.weeklyChange
            : weeklyChange // ignore: cast_nullable_to_non_nullable
                  as int,
        houseColour: null == houseColour
            ? _value.houseColour
            : houseColour // ignore: cast_nullable_to_non_nullable
                  as String,
        subtitle: null == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String,
        isCurrentEntity: null == isCurrentEntity
            ? _value.isCurrentEntity
            : isCurrentEntity // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardEntryImpl extends _LeaderboardEntry {
  const _$LeaderboardEntryImpl({
    required this.entityId,
    required this.entityName,
    required this.entityType,
    required this.rank,
    required this.totalPoints,
    this.weeklyChange = 0,
    this.houseColour = '#2E7D46',
    this.subtitle = '',
    this.isCurrentEntity = false,
  }) : super._();

  factory _$LeaderboardEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardEntryImplFromJson(json);

  @override
  final String entityId;
  @override
  final String entityName;
  @override
  final LeaderboardEntityType entityType;
  @override
  final int rank;
  @override
  final int totalPoints;
  @override
  @JsonKey()
  final int weeklyChange;
  // positions gained (+) / lost (-) this week
  @override
  @JsonKey()
  final String houseColour;
  @override
  @JsonKey()
  final String subtitle;
  // e.g. "Green Pioneer" or "Class 4B"
  @override
  @JsonKey()
  final bool isCurrentEntity;

  @override
  String toString() {
    return 'LeaderboardEntry(entityId: $entityId, entityName: $entityName, entityType: $entityType, rank: $rank, totalPoints: $totalPoints, weeklyChange: $weeklyChange, houseColour: $houseColour, subtitle: $subtitle, isCurrentEntity: $isCurrentEntity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardEntryImpl &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityName, entityName) ||
                other.entityName == entityName) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.weeklyChange, weeklyChange) ||
                other.weeklyChange == weeklyChange) &&
            (identical(other.houseColour, houseColour) ||
                other.houseColour == houseColour) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.isCurrentEntity, isCurrentEntity) ||
                other.isCurrentEntity == isCurrentEntity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    entityId,
    entityName,
    entityType,
    rank,
    totalPoints,
    weeklyChange,
    houseColour,
    subtitle,
    isCurrentEntity,
  );

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      __$$LeaderboardEntryImplCopyWithImpl<_$LeaderboardEntryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardEntryImplToJson(this);
  }
}

abstract class _LeaderboardEntry extends LeaderboardEntry {
  const factory _LeaderboardEntry({
    required final String entityId,
    required final String entityName,
    required final LeaderboardEntityType entityType,
    required final int rank,
    required final int totalPoints,
    final int weeklyChange,
    final String houseColour,
    final String subtitle,
    final bool isCurrentEntity,
  }) = _$LeaderboardEntryImpl;
  const _LeaderboardEntry._() : super._();

  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) =
      _$LeaderboardEntryImpl.fromJson;

  @override
  String get entityId;
  @override
  String get entityName;
  @override
  LeaderboardEntityType get entityType;
  @override
  int get rank;
  @override
  int get totalPoints;
  @override
  int get weeklyChange; // positions gained (+) / lost (-) this week
  @override
  String get houseColour;
  @override
  String get subtitle; // e.g. "Green Pioneer" or "Class 4B"
  @override
  bool get isCurrentEntity;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardEntryImplCopyWith<_$LeaderboardEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
