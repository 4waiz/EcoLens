// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_evolution_stage.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AvatarEvolutionStage _$AvatarEvolutionStageFromJson(Map<String, dynamic> json) {
  return _AvatarEvolutionStage.fromJson(json);
}

/// @nodoc
mixin _$AvatarEvolutionStage {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get minimumXp => throw _privateConstructorUsedError;
  String get environmentalMeaning => throw _privateConstructorUsedError;
  String get assetPath =>
      throw _privateConstructorUsedError; // procedural stage key
  int get stageIndex => throw _privateConstructorUsedError;

  /// Serializes this AvatarEvolutionStage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AvatarEvolutionStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvatarEvolutionStageCopyWith<AvatarEvolutionStage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarEvolutionStageCopyWith<$Res> {
  factory $AvatarEvolutionStageCopyWith(
    AvatarEvolutionStage value,
    $Res Function(AvatarEvolutionStage) then,
  ) = _$AvatarEvolutionStageCopyWithImpl<$Res, AvatarEvolutionStage>;
  @useResult
  $Res call({
    String id,
    String title,
    int minimumXp,
    String environmentalMeaning,
    String assetPath,
    int stageIndex,
  });
}

/// @nodoc
class _$AvatarEvolutionStageCopyWithImpl<
  $Res,
  $Val extends AvatarEvolutionStage
>
    implements $AvatarEvolutionStageCopyWith<$Res> {
  _$AvatarEvolutionStageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AvatarEvolutionStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? minimumXp = null,
    Object? environmentalMeaning = null,
    Object? assetPath = null,
    Object? stageIndex = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            minimumXp: null == minimumXp
                ? _value.minimumXp
                : minimumXp // ignore: cast_nullable_to_non_nullable
                      as int,
            environmentalMeaning: null == environmentalMeaning
                ? _value.environmentalMeaning
                : environmentalMeaning // ignore: cast_nullable_to_non_nullable
                      as String,
            assetPath: null == assetPath
                ? _value.assetPath
                : assetPath // ignore: cast_nullable_to_non_nullable
                      as String,
            stageIndex: null == stageIndex
                ? _value.stageIndex
                : stageIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvatarEvolutionStageImplCopyWith<$Res>
    implements $AvatarEvolutionStageCopyWith<$Res> {
  factory _$$AvatarEvolutionStageImplCopyWith(
    _$AvatarEvolutionStageImpl value,
    $Res Function(_$AvatarEvolutionStageImpl) then,
  ) = __$$AvatarEvolutionStageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    int minimumXp,
    String environmentalMeaning,
    String assetPath,
    int stageIndex,
  });
}

/// @nodoc
class __$$AvatarEvolutionStageImplCopyWithImpl<$Res>
    extends _$AvatarEvolutionStageCopyWithImpl<$Res, _$AvatarEvolutionStageImpl>
    implements _$$AvatarEvolutionStageImplCopyWith<$Res> {
  __$$AvatarEvolutionStageImplCopyWithImpl(
    _$AvatarEvolutionStageImpl _value,
    $Res Function(_$AvatarEvolutionStageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AvatarEvolutionStage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? minimumXp = null,
    Object? environmentalMeaning = null,
    Object? assetPath = null,
    Object? stageIndex = null,
  }) {
    return _then(
      _$AvatarEvolutionStageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        minimumXp: null == minimumXp
            ? _value.minimumXp
            : minimumXp // ignore: cast_nullable_to_non_nullable
                  as int,
        environmentalMeaning: null == environmentalMeaning
            ? _value.environmentalMeaning
            : environmentalMeaning // ignore: cast_nullable_to_non_nullable
                  as String,
        assetPath: null == assetPath
            ? _value.assetPath
            : assetPath // ignore: cast_nullable_to_non_nullable
                  as String,
        stageIndex: null == stageIndex
            ? _value.stageIndex
            : stageIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvatarEvolutionStageImpl extends _AvatarEvolutionStage {
  const _$AvatarEvolutionStageImpl({
    required this.id,
    required this.title,
    required this.minimumXp,
    required this.environmentalMeaning,
    this.assetPath = '',
    this.stageIndex = 0,
  }) : super._();

  factory _$AvatarEvolutionStageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvatarEvolutionStageImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final int minimumXp;
  @override
  final String environmentalMeaning;
  @override
  @JsonKey()
  final String assetPath;
  // procedural stage key
  @override
  @JsonKey()
  final int stageIndex;

  @override
  String toString() {
    return 'AvatarEvolutionStage(id: $id, title: $title, minimumXp: $minimumXp, environmentalMeaning: $environmentalMeaning, assetPath: $assetPath, stageIndex: $stageIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarEvolutionStageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.minimumXp, minimumXp) ||
                other.minimumXp == minimumXp) &&
            (identical(other.environmentalMeaning, environmentalMeaning) ||
                other.environmentalMeaning == environmentalMeaning) &&
            (identical(other.assetPath, assetPath) ||
                other.assetPath == assetPath) &&
            (identical(other.stageIndex, stageIndex) ||
                other.stageIndex == stageIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    minimumXp,
    environmentalMeaning,
    assetPath,
    stageIndex,
  );

  /// Create a copy of AvatarEvolutionStage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvatarEvolutionStageImplCopyWith<_$AvatarEvolutionStageImpl>
  get copyWith =>
      __$$AvatarEvolutionStageImplCopyWithImpl<_$AvatarEvolutionStageImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AvatarEvolutionStageImplToJson(this);
  }
}

abstract class _AvatarEvolutionStage extends AvatarEvolutionStage {
  const factory _AvatarEvolutionStage({
    required final String id,
    required final String title,
    required final int minimumXp,
    required final String environmentalMeaning,
    final String assetPath,
    final int stageIndex,
  }) = _$AvatarEvolutionStageImpl;
  const _AvatarEvolutionStage._() : super._();

  factory _AvatarEvolutionStage.fromJson(Map<String, dynamic> json) =
      _$AvatarEvolutionStageImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  int get minimumXp;
  @override
  String get environmentalMeaning;
  @override
  String get assetPath; // procedural stage key
  @override
  int get stageIndex;

  /// Create a copy of AvatarEvolutionStage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvatarEvolutionStageImplCopyWith<_$AvatarEvolutionStageImpl>
  get copyWith => throw _privateConstructorUsedError;
}
