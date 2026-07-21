// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Avatar _$AvatarFromJson(Map<String, dynamic> json) {
  return _Avatar.fromJson(json);
}

/// @nodoc
mixin _$Avatar {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get stage =>
      throw _privateConstructorUsedError; // index into the evolution ladder (0-based)
  int get level => throw _privateConstructorUsedError;
  int get currentXp => throw _privateConstructorUsedError;
  int get xpRequiredForNextLevel => throw _privateConstructorUsedError;
  List<String> get unlockedAccessories => throw _privateConstructorUsedError;
  List<String> get equippedAccessories => throw _privateConstructorUsedError;
  String get visualAssetPath => throw _privateConstructorUsedError;

  /// Serializes this Avatar to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Avatar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AvatarCopyWith<Avatar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarCopyWith<$Res> {
  factory $AvatarCopyWith(Avatar value, $Res Function(Avatar) then) =
      _$AvatarCopyWithImpl<$Res, Avatar>;
  @useResult
  $Res call({
    String id,
    String name,
    int stage,
    int level,
    int currentXp,
    int xpRequiredForNextLevel,
    List<String> unlockedAccessories,
    List<String> equippedAccessories,
    String visualAssetPath,
  });
}

/// @nodoc
class _$AvatarCopyWithImpl<$Res, $Val extends Avatar>
    implements $AvatarCopyWith<$Res> {
  _$AvatarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Avatar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stage = null,
    Object? level = null,
    Object? currentXp = null,
    Object? xpRequiredForNextLevel = null,
    Object? unlockedAccessories = null,
    Object? equippedAccessories = null,
    Object? visualAssetPath = null,
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
            stage: null == stage
                ? _value.stage
                : stage // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            currentXp: null == currentXp
                ? _value.currentXp
                : currentXp // ignore: cast_nullable_to_non_nullable
                      as int,
            xpRequiredForNextLevel: null == xpRequiredForNextLevel
                ? _value.xpRequiredForNextLevel
                : xpRequiredForNextLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            unlockedAccessories: null == unlockedAccessories
                ? _value.unlockedAccessories
                : unlockedAccessories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            equippedAccessories: null == equippedAccessories
                ? _value.equippedAccessories
                : equippedAccessories // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            visualAssetPath: null == visualAssetPath
                ? _value.visualAssetPath
                : visualAssetPath // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AvatarImplCopyWith<$Res> implements $AvatarCopyWith<$Res> {
  factory _$$AvatarImplCopyWith(
    _$AvatarImpl value,
    $Res Function(_$AvatarImpl) then,
  ) = __$$AvatarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int stage,
    int level,
    int currentXp,
    int xpRequiredForNextLevel,
    List<String> unlockedAccessories,
    List<String> equippedAccessories,
    String visualAssetPath,
  });
}

/// @nodoc
class __$$AvatarImplCopyWithImpl<$Res>
    extends _$AvatarCopyWithImpl<$Res, _$AvatarImpl>
    implements _$$AvatarImplCopyWith<$Res> {
  __$$AvatarImplCopyWithImpl(
    _$AvatarImpl _value,
    $Res Function(_$AvatarImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Avatar
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? stage = null,
    Object? level = null,
    Object? currentXp = null,
    Object? xpRequiredForNextLevel = null,
    Object? unlockedAccessories = null,
    Object? equippedAccessories = null,
    Object? visualAssetPath = null,
  }) {
    return _then(
      _$AvatarImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        stage: null == stage
            ? _value.stage
            : stage // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        currentXp: null == currentXp
            ? _value.currentXp
            : currentXp // ignore: cast_nullable_to_non_nullable
                  as int,
        xpRequiredForNextLevel: null == xpRequiredForNextLevel
            ? _value.xpRequiredForNextLevel
            : xpRequiredForNextLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        unlockedAccessories: null == unlockedAccessories
            ? _value._unlockedAccessories
            : unlockedAccessories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        equippedAccessories: null == equippedAccessories
            ? _value._equippedAccessories
            : equippedAccessories // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        visualAssetPath: null == visualAssetPath
            ? _value.visualAssetPath
            : visualAssetPath // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AvatarImpl extends _Avatar {
  const _$AvatarImpl({
    required this.id,
    required this.name,
    required this.stage,
    required this.level,
    required this.currentXp,
    required this.xpRequiredForNextLevel,
    final List<String> unlockedAccessories = const <String>[],
    final List<String> equippedAccessories = const <String>[],
    this.visualAssetPath = '',
  }) : _unlockedAccessories = unlockedAccessories,
       _equippedAccessories = equippedAccessories,
       super._();

  factory _$AvatarImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvatarImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int stage;
  // index into the evolution ladder (0-based)
  @override
  final int level;
  @override
  final int currentXp;
  @override
  final int xpRequiredForNextLevel;
  final List<String> _unlockedAccessories;
  @override
  @JsonKey()
  List<String> get unlockedAccessories {
    if (_unlockedAccessories is EqualUnmodifiableListView)
      return _unlockedAccessories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedAccessories);
  }

  final List<String> _equippedAccessories;
  @override
  @JsonKey()
  List<String> get equippedAccessories {
    if (_equippedAccessories is EqualUnmodifiableListView)
      return _equippedAccessories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equippedAccessories);
  }

  @override
  @JsonKey()
  final String visualAssetPath;

  @override
  String toString() {
    return 'Avatar(id: $id, name: $name, stage: $stage, level: $level, currentXp: $currentXp, xpRequiredForNextLevel: $xpRequiredForNextLevel, unlockedAccessories: $unlockedAccessories, equippedAccessories: $equippedAccessories, visualAssetPath: $visualAssetPath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.currentXp, currentXp) ||
                other.currentXp == currentXp) &&
            (identical(other.xpRequiredForNextLevel, xpRequiredForNextLevel) ||
                other.xpRequiredForNextLevel == xpRequiredForNextLevel) &&
            const DeepCollectionEquality().equals(
              other._unlockedAccessories,
              _unlockedAccessories,
            ) &&
            const DeepCollectionEquality().equals(
              other._equippedAccessories,
              _equippedAccessories,
            ) &&
            (identical(other.visualAssetPath, visualAssetPath) ||
                other.visualAssetPath == visualAssetPath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    stage,
    level,
    currentXp,
    xpRequiredForNextLevel,
    const DeepCollectionEquality().hash(_unlockedAccessories),
    const DeepCollectionEquality().hash(_equippedAccessories),
    visualAssetPath,
  );

  /// Create a copy of Avatar
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AvatarImplCopyWith<_$AvatarImpl> get copyWith =>
      __$$AvatarImplCopyWithImpl<_$AvatarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvatarImplToJson(this);
  }
}

abstract class _Avatar extends Avatar {
  const factory _Avatar({
    required final String id,
    required final String name,
    required final int stage,
    required final int level,
    required final int currentXp,
    required final int xpRequiredForNextLevel,
    final List<String> unlockedAccessories,
    final List<String> equippedAccessories,
    final String visualAssetPath,
  }) = _$AvatarImpl;
  const _Avatar._() : super._();

  factory _Avatar.fromJson(Map<String, dynamic> json) = _$AvatarImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get stage; // index into the evolution ladder (0-based)
  @override
  int get level;
  @override
  int get currentXp;
  @override
  int get xpRequiredForNextLevel;
  @override
  List<String> get unlockedAccessories;
  @override
  List<String> get equippedAccessories;
  @override
  String get visualAssetPath;

  /// Create a copy of Avatar
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AvatarImplCopyWith<_$AvatarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
