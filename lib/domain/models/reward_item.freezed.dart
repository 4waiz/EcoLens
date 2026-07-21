// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reward_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RewardItem _$RewardItemFromJson(Map<String, dynamic> json) {
  return _RewardItem.fromJson(json);
}

/// @nodoc
mixin _$RewardItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get pointCost => throw _privateConstructorUsedError;
  RewardCategory get category => throw _privateConstructorUsedError;
  String get imagePath =>
      throw _privateConstructorUsedError; // procedural icon key
  StockStatus get stockStatus => throw _privateConstructorUsedError;
  bool get requiresStaffApproval => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get dailyRedemptionLimit => throw _privateConstructorUsedError;

  /// Serializes this RewardItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RewardItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RewardItemCopyWith<RewardItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RewardItemCopyWith<$Res> {
  factory $RewardItemCopyWith(
    RewardItem value,
    $Res Function(RewardItem) then,
  ) = _$RewardItemCopyWithImpl<$Res, RewardItem>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int pointCost,
    RewardCategory category,
    String imagePath,
    StockStatus stockStatus,
    bool requiresStaffApproval,
    bool isActive,
    int dailyRedemptionLimit,
  });
}

/// @nodoc
class _$RewardItemCopyWithImpl<$Res, $Val extends RewardItem>
    implements $RewardItemCopyWith<$Res> {
  _$RewardItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RewardItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? pointCost = null,
    Object? category = null,
    Object? imagePath = null,
    Object? stockStatus = null,
    Object? requiresStaffApproval = null,
    Object? isActive = null,
    Object? dailyRedemptionLimit = null,
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
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            pointCost: null == pointCost
                ? _value.pointCost
                : pointCost // ignore: cast_nullable_to_non_nullable
                      as int,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as RewardCategory,
            imagePath: null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                      as String,
            stockStatus: null == stockStatus
                ? _value.stockStatus
                : stockStatus // ignore: cast_nullable_to_non_nullable
                      as StockStatus,
            requiresStaffApproval: null == requiresStaffApproval
                ? _value.requiresStaffApproval
                : requiresStaffApproval // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            dailyRedemptionLimit: null == dailyRedemptionLimit
                ? _value.dailyRedemptionLimit
                : dailyRedemptionLimit // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RewardItemImplCopyWith<$Res>
    implements $RewardItemCopyWith<$Res> {
  factory _$$RewardItemImplCopyWith(
    _$RewardItemImpl value,
    $Res Function(_$RewardItemImpl) then,
  ) = __$$RewardItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    int pointCost,
    RewardCategory category,
    String imagePath,
    StockStatus stockStatus,
    bool requiresStaffApproval,
    bool isActive,
    int dailyRedemptionLimit,
  });
}

/// @nodoc
class __$$RewardItemImplCopyWithImpl<$Res>
    extends _$RewardItemCopyWithImpl<$Res, _$RewardItemImpl>
    implements _$$RewardItemImplCopyWith<$Res> {
  __$$RewardItemImplCopyWithImpl(
    _$RewardItemImpl _value,
    $Res Function(_$RewardItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RewardItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? pointCost = null,
    Object? category = null,
    Object? imagePath = null,
    Object? stockStatus = null,
    Object? requiresStaffApproval = null,
    Object? isActive = null,
    Object? dailyRedemptionLimit = null,
  }) {
    return _then(
      _$RewardItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        pointCost: null == pointCost
            ? _value.pointCost
            : pointCost // ignore: cast_nullable_to_non_nullable
                  as int,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as RewardCategory,
        imagePath: null == imagePath
            ? _value.imagePath
            : imagePath // ignore: cast_nullable_to_non_nullable
                  as String,
        stockStatus: null == stockStatus
            ? _value.stockStatus
            : stockStatus // ignore: cast_nullable_to_non_nullable
                  as StockStatus,
        requiresStaffApproval: null == requiresStaffApproval
            ? _value.requiresStaffApproval
            : requiresStaffApproval // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyRedemptionLimit: null == dailyRedemptionLimit
            ? _value.dailyRedemptionLimit
            : dailyRedemptionLimit // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RewardItemImpl extends _RewardItem {
  const _$RewardItemImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.pointCost,
    required this.category,
    this.imagePath = '',
    this.stockStatus = StockStatus.inStock,
    this.requiresStaffApproval = false,
    this.isActive = true,
    this.dailyRedemptionLimit = 0,
  }) : super._();

  factory _$RewardItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RewardItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final int pointCost;
  @override
  final RewardCategory category;
  @override
  @JsonKey()
  final String imagePath;
  // procedural icon key
  @override
  @JsonKey()
  final StockStatus stockStatus;
  @override
  @JsonKey()
  final bool requiresStaffApproval;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int dailyRedemptionLimit;

  @override
  String toString() {
    return 'RewardItem(id: $id, name: $name, description: $description, pointCost: $pointCost, category: $category, imagePath: $imagePath, stockStatus: $stockStatus, requiresStaffApproval: $requiresStaffApproval, isActive: $isActive, dailyRedemptionLimit: $dailyRedemptionLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RewardItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.pointCost, pointCost) ||
                other.pointCost == pointCost) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.stockStatus, stockStatus) ||
                other.stockStatus == stockStatus) &&
            (identical(other.requiresStaffApproval, requiresStaffApproval) ||
                other.requiresStaffApproval == requiresStaffApproval) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.dailyRedemptionLimit, dailyRedemptionLimit) ||
                other.dailyRedemptionLimit == dailyRedemptionLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    pointCost,
    category,
    imagePath,
    stockStatus,
    requiresStaffApproval,
    isActive,
    dailyRedemptionLimit,
  );

  /// Create a copy of RewardItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RewardItemImplCopyWith<_$RewardItemImpl> get copyWith =>
      __$$RewardItemImplCopyWithImpl<_$RewardItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RewardItemImplToJson(this);
  }
}

abstract class _RewardItem extends RewardItem {
  const factory _RewardItem({
    required final String id,
    required final String name,
    required final String description,
    required final int pointCost,
    required final RewardCategory category,
    final String imagePath,
    final StockStatus stockStatus,
    final bool requiresStaffApproval,
    final bool isActive,
    final int dailyRedemptionLimit,
  }) = _$RewardItemImpl;
  const _RewardItem._() : super._();

  factory _RewardItem.fromJson(Map<String, dynamic> json) =
      _$RewardItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get pointCost;
  @override
  RewardCategory get category;
  @override
  String get imagePath; // procedural icon key
  @override
  StockStatus get stockStatus;
  @override
  bool get requiresStaffApproval;
  @override
  bool get isActive;
  @override
  int get dailyRedemptionLimit;

  /// Create a copy of RewardItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RewardItemImplCopyWith<_$RewardItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
