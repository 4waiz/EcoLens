// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MetricValue _$MetricValueFromJson(Map<String, dynamic> json) {
  return _MetricValue.fromJson(json);
}

/// @nodoc
mixin _$MetricValue {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  String get delta => throw _privateConstructorUsedError;
  bool get deltaPositive => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;

  /// Serializes this MetricValue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MetricValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MetricValueCopyWith<MetricValue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetricValueCopyWith<$Res> {
  factory $MetricValueCopyWith(
    MetricValue value,
    $Res Function(MetricValue) then,
  ) = _$MetricValueCopyWithImpl<$Res, MetricValue>;
  @useResult
  $Res call({
    String label,
    String value,
    String delta,
    bool deltaPositive,
    String caption,
  });
}

/// @nodoc
class _$MetricValueCopyWithImpl<$Res, $Val extends MetricValue>
    implements $MetricValueCopyWith<$Res> {
  _$MetricValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MetricValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? delta = null,
    Object? deltaPositive = null,
    Object? caption = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            delta: null == delta
                ? _value.delta
                : delta // ignore: cast_nullable_to_non_nullable
                      as String,
            deltaPositive: null == deltaPositive
                ? _value.deltaPositive
                : deltaPositive // ignore: cast_nullable_to_non_nullable
                      as bool,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MetricValueImplCopyWith<$Res>
    implements $MetricValueCopyWith<$Res> {
  factory _$$MetricValueImplCopyWith(
    _$MetricValueImpl value,
    $Res Function(_$MetricValueImpl) then,
  ) = __$$MetricValueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String label,
    String value,
    String delta,
    bool deltaPositive,
    String caption,
  });
}

/// @nodoc
class __$$MetricValueImplCopyWithImpl<$Res>
    extends _$MetricValueCopyWithImpl<$Res, _$MetricValueImpl>
    implements _$$MetricValueImplCopyWith<$Res> {
  __$$MetricValueImplCopyWithImpl(
    _$MetricValueImpl _value,
    $Res Function(_$MetricValueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MetricValue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? delta = null,
    Object? deltaPositive = null,
    Object? caption = null,
  }) {
    return _then(
      _$MetricValueImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        delta: null == delta
            ? _value.delta
            : delta // ignore: cast_nullable_to_non_nullable
                  as String,
        deltaPositive: null == deltaPositive
            ? _value.deltaPositive
            : deltaPositive // ignore: cast_nullable_to_non_nullable
                  as bool,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MetricValueImpl implements _MetricValue {
  const _$MetricValueImpl({
    required this.label,
    required this.value,
    this.delta = '',
    this.deltaPositive = true,
    this.caption = '',
  });

  factory _$MetricValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$MetricValueImplFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  @JsonKey()
  final String delta;
  @override
  @JsonKey()
  final bool deltaPositive;
  @override
  @JsonKey()
  final String caption;

  @override
  String toString() {
    return 'MetricValue(label: $label, value: $value, delta: $delta, deltaPositive: $deltaPositive, caption: $caption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MetricValueImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.delta, delta) || other.delta == delta) &&
            (identical(other.deltaPositive, deltaPositive) ||
                other.deltaPositive == deltaPositive) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, value, delta, deltaPositive, caption);

  /// Create a copy of MetricValue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MetricValueImplCopyWith<_$MetricValueImpl> get copyWith =>
      __$$MetricValueImplCopyWithImpl<_$MetricValueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MetricValueImplToJson(this);
  }
}

abstract class _MetricValue implements MetricValue {
  const factory _MetricValue({
    required final String label,
    required final String value,
    final String delta,
    final bool deltaPositive,
    final String caption,
  }) = _$MetricValueImpl;

  factory _MetricValue.fromJson(Map<String, dynamic> json) =
      _$MetricValueImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  String get delta;
  @override
  bool get deltaPositive;
  @override
  String get caption;

  /// Create a copy of MetricValue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MetricValueImplCopyWith<_$MetricValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrendPoint _$TrendPointFromJson(Map<String, dynamic> json) {
  return _TrendPoint.fromJson(json);
}

/// @nodoc
mixin _$TrendPoint {
  String get label => throw _privateConstructorUsedError; // e.g. "Mon"
  double get value => throw _privateConstructorUsedError;

  /// Serializes this TrendPoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrendPointCopyWith<TrendPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendPointCopyWith<$Res> {
  factory $TrendPointCopyWith(
    TrendPoint value,
    $Res Function(TrendPoint) then,
  ) = _$TrendPointCopyWithImpl<$Res, TrendPoint>;
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class _$TrendPointCopyWithImpl<$Res, $Val extends TrendPoint>
    implements $TrendPointCopyWith<$Res> {
  _$TrendPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrendPointImplCopyWith<$Res>
    implements $TrendPointCopyWith<$Res> {
  factory _$$TrendPointImplCopyWith(
    _$TrendPointImpl value,
    $Res Function(_$TrendPointImpl) then,
  ) = __$$TrendPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value});
}

/// @nodoc
class __$$TrendPointImplCopyWithImpl<$Res>
    extends _$TrendPointCopyWithImpl<$Res, _$TrendPointImpl>
    implements _$$TrendPointImplCopyWith<$Res> {
  __$$TrendPointImplCopyWithImpl(
    _$TrendPointImpl _value,
    $Res Function(_$TrendPointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? value = null}) {
    return _then(
      _$TrendPointImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendPointImpl implements _TrendPoint {
  const _$TrendPointImpl({required this.label, required this.value});

  factory _$TrendPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendPointImplFromJson(json);

  @override
  final String label;
  // e.g. "Mon"
  @override
  final double value;

  @override
  String toString() {
    return 'TrendPoint(label: $label, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendPointImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value);

  /// Create a copy of TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendPointImplCopyWith<_$TrendPointImpl> get copyWith =>
      __$$TrendPointImplCopyWithImpl<_$TrendPointImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendPointImplToJson(this);
  }
}

abstract class _TrendPoint implements TrendPoint {
  const factory _TrendPoint({
    required final String label,
    required final double value,
  }) = _$TrendPointImpl;

  factory _TrendPoint.fromJson(Map<String, dynamic> json) =
      _$TrendPointImpl.fromJson;

  @override
  String get label; // e.g. "Mon"
  @override
  double get value;

  /// Create a copy of TrendPoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrendPointImplCopyWith<_$TrendPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommonMistake _$CommonMistakeFromJson(Map<String, dynamic> json) {
  return _CommonMistake.fromJson(json);
}

/// @nodoc
mixin _$CommonMistake {
  WasteCategory get correctCategory => throw _privateConstructorUsedError;
  WasteCategory get chosenCategory => throw _privateConstructorUsedError;
  int get occurrences => throw _privateConstructorUsedError;
  String get exampleItem => throw _privateConstructorUsedError;

  /// Serializes this CommonMistake to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommonMistake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommonMistakeCopyWith<CommonMistake> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMistakeCopyWith<$Res> {
  factory $CommonMistakeCopyWith(
    CommonMistake value,
    $Res Function(CommonMistake) then,
  ) = _$CommonMistakeCopyWithImpl<$Res, CommonMistake>;
  @useResult
  $Res call({
    WasteCategory correctCategory,
    WasteCategory chosenCategory,
    int occurrences,
    String exampleItem,
  });
}

/// @nodoc
class _$CommonMistakeCopyWithImpl<$Res, $Val extends CommonMistake>
    implements $CommonMistakeCopyWith<$Res> {
  _$CommonMistakeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommonMistake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correctCategory = null,
    Object? chosenCategory = null,
    Object? occurrences = null,
    Object? exampleItem = null,
  }) {
    return _then(
      _value.copyWith(
            correctCategory: null == correctCategory
                ? _value.correctCategory
                : correctCategory // ignore: cast_nullable_to_non_nullable
                      as WasteCategory,
            chosenCategory: null == chosenCategory
                ? _value.chosenCategory
                : chosenCategory // ignore: cast_nullable_to_non_nullable
                      as WasteCategory,
            occurrences: null == occurrences
                ? _value.occurrences
                : occurrences // ignore: cast_nullable_to_non_nullable
                      as int,
            exampleItem: null == exampleItem
                ? _value.exampleItem
                : exampleItem // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CommonMistakeImplCopyWith<$Res>
    implements $CommonMistakeCopyWith<$Res> {
  factory _$$CommonMistakeImplCopyWith(
    _$CommonMistakeImpl value,
    $Res Function(_$CommonMistakeImpl) then,
  ) = __$$CommonMistakeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WasteCategory correctCategory,
    WasteCategory chosenCategory,
    int occurrences,
    String exampleItem,
  });
}

/// @nodoc
class __$$CommonMistakeImplCopyWithImpl<$Res>
    extends _$CommonMistakeCopyWithImpl<$Res, _$CommonMistakeImpl>
    implements _$$CommonMistakeImplCopyWith<$Res> {
  __$$CommonMistakeImplCopyWithImpl(
    _$CommonMistakeImpl _value,
    $Res Function(_$CommonMistakeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CommonMistake
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? correctCategory = null,
    Object? chosenCategory = null,
    Object? occurrences = null,
    Object? exampleItem = null,
  }) {
    return _then(
      _$CommonMistakeImpl(
        correctCategory: null == correctCategory
            ? _value.correctCategory
            : correctCategory // ignore: cast_nullable_to_non_nullable
                  as WasteCategory,
        chosenCategory: null == chosenCategory
            ? _value.chosenCategory
            : chosenCategory // ignore: cast_nullable_to_non_nullable
                  as WasteCategory,
        occurrences: null == occurrences
            ? _value.occurrences
            : occurrences // ignore: cast_nullable_to_non_nullable
                  as int,
        exampleItem: null == exampleItem
            ? _value.exampleItem
            : exampleItem // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMistakeImpl extends _CommonMistake {
  const _$CommonMistakeImpl({
    required this.correctCategory,
    required this.chosenCategory,
    required this.occurrences,
    this.exampleItem = '',
  }) : super._();

  factory _$CommonMistakeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMistakeImplFromJson(json);

  @override
  final WasteCategory correctCategory;
  @override
  final WasteCategory chosenCategory;
  @override
  final int occurrences;
  @override
  @JsonKey()
  final String exampleItem;

  @override
  String toString() {
    return 'CommonMistake(correctCategory: $correctCategory, chosenCategory: $chosenCategory, occurrences: $occurrences, exampleItem: $exampleItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMistakeImpl &&
            (identical(other.correctCategory, correctCategory) ||
                other.correctCategory == correctCategory) &&
            (identical(other.chosenCategory, chosenCategory) ||
                other.chosenCategory == chosenCategory) &&
            (identical(other.occurrences, occurrences) ||
                other.occurrences == occurrences) &&
            (identical(other.exampleItem, exampleItem) ||
                other.exampleItem == exampleItem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    correctCategory,
    chosenCategory,
    occurrences,
    exampleItem,
  );

  /// Create a copy of CommonMistake
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMistakeImplCopyWith<_$CommonMistakeImpl> get copyWith =>
      __$$CommonMistakeImplCopyWithImpl<_$CommonMistakeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMistakeImplToJson(this);
  }
}

abstract class _CommonMistake extends CommonMistake {
  const factory _CommonMistake({
    required final WasteCategory correctCategory,
    required final WasteCategory chosenCategory,
    required final int occurrences,
    final String exampleItem,
  }) = _$CommonMistakeImpl;
  const _CommonMistake._() : super._();

  factory _CommonMistake.fromJson(Map<String, dynamic> json) =
      _$CommonMistakeImpl.fromJson;

  @override
  WasteCategory get correctCategory;
  @override
  WasteCategory get chosenCategory;
  @override
  int get occurrences;
  @override
  String get exampleItem;

  /// Create a copy of CommonMistake
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommonMistakeImplCopyWith<_$CommonMistakeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeacherOverview _$TeacherOverviewFromJson(Map<String, dynamic> json) {
  return _TeacherOverview.fromJson(json);
}

/// @nodoc
mixin _$TeacherOverview {
  int get activeStudents => throw _privateConstructorUsedError;
  int get recyclingSessions => throw _privateConstructorUsedError;
  double get correctClassificationRate =>
      throw _privateConstructorUsedError; // 0..1
  double get participationRate => throw _privateConstructorUsedError; // 0..1
  int get xpAwarded => throw _privateConstructorUsedError;
  int get housePoints => throw _privateConstructorUsedError;
  List<MetricValue> get headlineMetrics => throw _privateConstructorUsedError;
  List<TrendPoint> get participationTrend => throw _privateConstructorUsedError;
  List<CommonMistake> get commonMistakes => throw _privateConstructorUsedError;
  List<LeaderboardMini> get topClasses => throw _privateConstructorUsedError;
  List<LeaderboardMini> get topHouses => throw _privateConstructorUsedError;

  /// Serializes this TeacherOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeacherOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeacherOverviewCopyWith<TeacherOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeacherOverviewCopyWith<$Res> {
  factory $TeacherOverviewCopyWith(
    TeacherOverview value,
    $Res Function(TeacherOverview) then,
  ) = _$TeacherOverviewCopyWithImpl<$Res, TeacherOverview>;
  @useResult
  $Res call({
    int activeStudents,
    int recyclingSessions,
    double correctClassificationRate,
    double participationRate,
    int xpAwarded,
    int housePoints,
    List<MetricValue> headlineMetrics,
    List<TrendPoint> participationTrend,
    List<CommonMistake> commonMistakes,
    List<LeaderboardMini> topClasses,
    List<LeaderboardMini> topHouses,
  });
}

/// @nodoc
class _$TeacherOverviewCopyWithImpl<$Res, $Val extends TeacherOverview>
    implements $TeacherOverviewCopyWith<$Res> {
  _$TeacherOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeacherOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeStudents = null,
    Object? recyclingSessions = null,
    Object? correctClassificationRate = null,
    Object? participationRate = null,
    Object? xpAwarded = null,
    Object? housePoints = null,
    Object? headlineMetrics = null,
    Object? participationTrend = null,
    Object? commonMistakes = null,
    Object? topClasses = null,
    Object? topHouses = null,
  }) {
    return _then(
      _value.copyWith(
            activeStudents: null == activeStudents
                ? _value.activeStudents
                : activeStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            recyclingSessions: null == recyclingSessions
                ? _value.recyclingSessions
                : recyclingSessions // ignore: cast_nullable_to_non_nullable
                      as int,
            correctClassificationRate: null == correctClassificationRate
                ? _value.correctClassificationRate
                : correctClassificationRate // ignore: cast_nullable_to_non_nullable
                      as double,
            participationRate: null == participationRate
                ? _value.participationRate
                : participationRate // ignore: cast_nullable_to_non_nullable
                      as double,
            xpAwarded: null == xpAwarded
                ? _value.xpAwarded
                : xpAwarded // ignore: cast_nullable_to_non_nullable
                      as int,
            housePoints: null == housePoints
                ? _value.housePoints
                : housePoints // ignore: cast_nullable_to_non_nullable
                      as int,
            headlineMetrics: null == headlineMetrics
                ? _value.headlineMetrics
                : headlineMetrics // ignore: cast_nullable_to_non_nullable
                      as List<MetricValue>,
            participationTrend: null == participationTrend
                ? _value.participationTrend
                : participationTrend // ignore: cast_nullable_to_non_nullable
                      as List<TrendPoint>,
            commonMistakes: null == commonMistakes
                ? _value.commonMistakes
                : commonMistakes // ignore: cast_nullable_to_non_nullable
                      as List<CommonMistake>,
            topClasses: null == topClasses
                ? _value.topClasses
                : topClasses // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardMini>,
            topHouses: null == topHouses
                ? _value.topHouses
                : topHouses // ignore: cast_nullable_to_non_nullable
                      as List<LeaderboardMini>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeacherOverviewImplCopyWith<$Res>
    implements $TeacherOverviewCopyWith<$Res> {
  factory _$$TeacherOverviewImplCopyWith(
    _$TeacherOverviewImpl value,
    $Res Function(_$TeacherOverviewImpl) then,
  ) = __$$TeacherOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int activeStudents,
    int recyclingSessions,
    double correctClassificationRate,
    double participationRate,
    int xpAwarded,
    int housePoints,
    List<MetricValue> headlineMetrics,
    List<TrendPoint> participationTrend,
    List<CommonMistake> commonMistakes,
    List<LeaderboardMini> topClasses,
    List<LeaderboardMini> topHouses,
  });
}

/// @nodoc
class __$$TeacherOverviewImplCopyWithImpl<$Res>
    extends _$TeacherOverviewCopyWithImpl<$Res, _$TeacherOverviewImpl>
    implements _$$TeacherOverviewImplCopyWith<$Res> {
  __$$TeacherOverviewImplCopyWithImpl(
    _$TeacherOverviewImpl _value,
    $Res Function(_$TeacherOverviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeacherOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeStudents = null,
    Object? recyclingSessions = null,
    Object? correctClassificationRate = null,
    Object? participationRate = null,
    Object? xpAwarded = null,
    Object? housePoints = null,
    Object? headlineMetrics = null,
    Object? participationTrend = null,
    Object? commonMistakes = null,
    Object? topClasses = null,
    Object? topHouses = null,
  }) {
    return _then(
      _$TeacherOverviewImpl(
        activeStudents: null == activeStudents
            ? _value.activeStudents
            : activeStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        recyclingSessions: null == recyclingSessions
            ? _value.recyclingSessions
            : recyclingSessions // ignore: cast_nullable_to_non_nullable
                  as int,
        correctClassificationRate: null == correctClassificationRate
            ? _value.correctClassificationRate
            : correctClassificationRate // ignore: cast_nullable_to_non_nullable
                  as double,
        participationRate: null == participationRate
            ? _value.participationRate
            : participationRate // ignore: cast_nullable_to_non_nullable
                  as double,
        xpAwarded: null == xpAwarded
            ? _value.xpAwarded
            : xpAwarded // ignore: cast_nullable_to_non_nullable
                  as int,
        housePoints: null == housePoints
            ? _value.housePoints
            : housePoints // ignore: cast_nullable_to_non_nullable
                  as int,
        headlineMetrics: null == headlineMetrics
            ? _value._headlineMetrics
            : headlineMetrics // ignore: cast_nullable_to_non_nullable
                  as List<MetricValue>,
        participationTrend: null == participationTrend
            ? _value._participationTrend
            : participationTrend // ignore: cast_nullable_to_non_nullable
                  as List<TrendPoint>,
        commonMistakes: null == commonMistakes
            ? _value._commonMistakes
            : commonMistakes // ignore: cast_nullable_to_non_nullable
                  as List<CommonMistake>,
        topClasses: null == topClasses
            ? _value._topClasses
            : topClasses // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardMini>,
        topHouses: null == topHouses
            ? _value._topHouses
            : topHouses // ignore: cast_nullable_to_non_nullable
                  as List<LeaderboardMini>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TeacherOverviewImpl implements _TeacherOverview {
  const _$TeacherOverviewImpl({
    required this.activeStudents,
    required this.recyclingSessions,
    required this.correctClassificationRate,
    required this.participationRate,
    required this.xpAwarded,
    required this.housePoints,
    final List<MetricValue> headlineMetrics = const <MetricValue>[],
    final List<TrendPoint> participationTrend = const <TrendPoint>[],
    final List<CommonMistake> commonMistakes = const <CommonMistake>[],
    final List<LeaderboardMini> topClasses = const <LeaderboardMini>[],
    final List<LeaderboardMini> topHouses = const <LeaderboardMini>[],
  }) : _headlineMetrics = headlineMetrics,
       _participationTrend = participationTrend,
       _commonMistakes = commonMistakes,
       _topClasses = topClasses,
       _topHouses = topHouses;

  factory _$TeacherOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeacherOverviewImplFromJson(json);

  @override
  final int activeStudents;
  @override
  final int recyclingSessions;
  @override
  final double correctClassificationRate;
  // 0..1
  @override
  final double participationRate;
  // 0..1
  @override
  final int xpAwarded;
  @override
  final int housePoints;
  final List<MetricValue> _headlineMetrics;
  @override
  @JsonKey()
  List<MetricValue> get headlineMetrics {
    if (_headlineMetrics is EqualUnmodifiableListView) return _headlineMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_headlineMetrics);
  }

  final List<TrendPoint> _participationTrend;
  @override
  @JsonKey()
  List<TrendPoint> get participationTrend {
    if (_participationTrend is EqualUnmodifiableListView)
      return _participationTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participationTrend);
  }

  final List<CommonMistake> _commonMistakes;
  @override
  @JsonKey()
  List<CommonMistake> get commonMistakes {
    if (_commonMistakes is EqualUnmodifiableListView) return _commonMistakes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonMistakes);
  }

  final List<LeaderboardMini> _topClasses;
  @override
  @JsonKey()
  List<LeaderboardMini> get topClasses {
    if (_topClasses is EqualUnmodifiableListView) return _topClasses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topClasses);
  }

  final List<LeaderboardMini> _topHouses;
  @override
  @JsonKey()
  List<LeaderboardMini> get topHouses {
    if (_topHouses is EqualUnmodifiableListView) return _topHouses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topHouses);
  }

  @override
  String toString() {
    return 'TeacherOverview(activeStudents: $activeStudents, recyclingSessions: $recyclingSessions, correctClassificationRate: $correctClassificationRate, participationRate: $participationRate, xpAwarded: $xpAwarded, housePoints: $housePoints, headlineMetrics: $headlineMetrics, participationTrend: $participationTrend, commonMistakes: $commonMistakes, topClasses: $topClasses, topHouses: $topHouses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeacherOverviewImpl &&
            (identical(other.activeStudents, activeStudents) ||
                other.activeStudents == activeStudents) &&
            (identical(other.recyclingSessions, recyclingSessions) ||
                other.recyclingSessions == recyclingSessions) &&
            (identical(
                  other.correctClassificationRate,
                  correctClassificationRate,
                ) ||
                other.correctClassificationRate == correctClassificationRate) &&
            (identical(other.participationRate, participationRate) ||
                other.participationRate == participationRate) &&
            (identical(other.xpAwarded, xpAwarded) ||
                other.xpAwarded == xpAwarded) &&
            (identical(other.housePoints, housePoints) ||
                other.housePoints == housePoints) &&
            const DeepCollectionEquality().equals(
              other._headlineMetrics,
              _headlineMetrics,
            ) &&
            const DeepCollectionEquality().equals(
              other._participationTrend,
              _participationTrend,
            ) &&
            const DeepCollectionEquality().equals(
              other._commonMistakes,
              _commonMistakes,
            ) &&
            const DeepCollectionEquality().equals(
              other._topClasses,
              _topClasses,
            ) &&
            const DeepCollectionEquality().equals(
              other._topHouses,
              _topHouses,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    activeStudents,
    recyclingSessions,
    correctClassificationRate,
    participationRate,
    xpAwarded,
    housePoints,
    const DeepCollectionEquality().hash(_headlineMetrics),
    const DeepCollectionEquality().hash(_participationTrend),
    const DeepCollectionEquality().hash(_commonMistakes),
    const DeepCollectionEquality().hash(_topClasses),
    const DeepCollectionEquality().hash(_topHouses),
  );

  /// Create a copy of TeacherOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeacherOverviewImplCopyWith<_$TeacherOverviewImpl> get copyWith =>
      __$$TeacherOverviewImplCopyWithImpl<_$TeacherOverviewImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TeacherOverviewImplToJson(this);
  }
}

abstract class _TeacherOverview implements TeacherOverview {
  const factory _TeacherOverview({
    required final int activeStudents,
    required final int recyclingSessions,
    required final double correctClassificationRate,
    required final double participationRate,
    required final int xpAwarded,
    required final int housePoints,
    final List<MetricValue> headlineMetrics,
    final List<TrendPoint> participationTrend,
    final List<CommonMistake> commonMistakes,
    final List<LeaderboardMini> topClasses,
    final List<LeaderboardMini> topHouses,
  }) = _$TeacherOverviewImpl;

  factory _TeacherOverview.fromJson(Map<String, dynamic> json) =
      _$TeacherOverviewImpl.fromJson;

  @override
  int get activeStudents;
  @override
  int get recyclingSessions;
  @override
  double get correctClassificationRate; // 0..1
  @override
  double get participationRate; // 0..1
  @override
  int get xpAwarded;
  @override
  int get housePoints;
  @override
  List<MetricValue> get headlineMetrics;
  @override
  List<TrendPoint> get participationTrend;
  @override
  List<CommonMistake> get commonMistakes;
  @override
  List<LeaderboardMini> get topClasses;
  @override
  List<LeaderboardMini> get topHouses;

  /// Create a copy of TeacherOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeacherOverviewImplCopyWith<_$TeacherOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminOverview _$AdminOverviewFromJson(Map<String, dynamic> json) {
  return _AdminOverview.fromJson(json);
}

/// @nodoc
mixin _$AdminOverview {
  int get totalStudents => throw _privateConstructorUsedError;
  int get activeKiosks => throw _privateConstructorUsedError;
  int get kiosksNeedingAttention => throw _privateConstructorUsedError;
  int get sessionsToday => throw _privateConstructorUsedError;
  double get systemAccuracy => throw _privateConstructorUsedError; // 0..1
  int get rewardsRedeemedToday => throw _privateConstructorUsedError;
  List<MetricValue> get headlineMetrics => throw _privateConstructorUsedError;
  List<TrendPoint> get weeklySessions => throw _privateConstructorUsedError;
  List<CategoryBreakdown> get categoryBreakdown =>
      throw _privateConstructorUsedError;

  /// Serializes this AdminOverview to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminOverviewCopyWith<AdminOverview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminOverviewCopyWith<$Res> {
  factory $AdminOverviewCopyWith(
    AdminOverview value,
    $Res Function(AdminOverview) then,
  ) = _$AdminOverviewCopyWithImpl<$Res, AdminOverview>;
  @useResult
  $Res call({
    int totalStudents,
    int activeKiosks,
    int kiosksNeedingAttention,
    int sessionsToday,
    double systemAccuracy,
    int rewardsRedeemedToday,
    List<MetricValue> headlineMetrics,
    List<TrendPoint> weeklySessions,
    List<CategoryBreakdown> categoryBreakdown,
  });
}

/// @nodoc
class _$AdminOverviewCopyWithImpl<$Res, $Val extends AdminOverview>
    implements $AdminOverviewCopyWith<$Res> {
  _$AdminOverviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStudents = null,
    Object? activeKiosks = null,
    Object? kiosksNeedingAttention = null,
    Object? sessionsToday = null,
    Object? systemAccuracy = null,
    Object? rewardsRedeemedToday = null,
    Object? headlineMetrics = null,
    Object? weeklySessions = null,
    Object? categoryBreakdown = null,
  }) {
    return _then(
      _value.copyWith(
            totalStudents: null == totalStudents
                ? _value.totalStudents
                : totalStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            activeKiosks: null == activeKiosks
                ? _value.activeKiosks
                : activeKiosks // ignore: cast_nullable_to_non_nullable
                      as int,
            kiosksNeedingAttention: null == kiosksNeedingAttention
                ? _value.kiosksNeedingAttention
                : kiosksNeedingAttention // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionsToday: null == sessionsToday
                ? _value.sessionsToday
                : sessionsToday // ignore: cast_nullable_to_non_nullable
                      as int,
            systemAccuracy: null == systemAccuracy
                ? _value.systemAccuracy
                : systemAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            rewardsRedeemedToday: null == rewardsRedeemedToday
                ? _value.rewardsRedeemedToday
                : rewardsRedeemedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            headlineMetrics: null == headlineMetrics
                ? _value.headlineMetrics
                : headlineMetrics // ignore: cast_nullable_to_non_nullable
                      as List<MetricValue>,
            weeklySessions: null == weeklySessions
                ? _value.weeklySessions
                : weeklySessions // ignore: cast_nullable_to_non_nullable
                      as List<TrendPoint>,
            categoryBreakdown: null == categoryBreakdown
                ? _value.categoryBreakdown
                : categoryBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<CategoryBreakdown>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminOverviewImplCopyWith<$Res>
    implements $AdminOverviewCopyWith<$Res> {
  factory _$$AdminOverviewImplCopyWith(
    _$AdminOverviewImpl value,
    $Res Function(_$AdminOverviewImpl) then,
  ) = __$$AdminOverviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalStudents,
    int activeKiosks,
    int kiosksNeedingAttention,
    int sessionsToday,
    double systemAccuracy,
    int rewardsRedeemedToday,
    List<MetricValue> headlineMetrics,
    List<TrendPoint> weeklySessions,
    List<CategoryBreakdown> categoryBreakdown,
  });
}

/// @nodoc
class __$$AdminOverviewImplCopyWithImpl<$Res>
    extends _$AdminOverviewCopyWithImpl<$Res, _$AdminOverviewImpl>
    implements _$$AdminOverviewImplCopyWith<$Res> {
  __$$AdminOverviewImplCopyWithImpl(
    _$AdminOverviewImpl _value,
    $Res Function(_$AdminOverviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStudents = null,
    Object? activeKiosks = null,
    Object? kiosksNeedingAttention = null,
    Object? sessionsToday = null,
    Object? systemAccuracy = null,
    Object? rewardsRedeemedToday = null,
    Object? headlineMetrics = null,
    Object? weeklySessions = null,
    Object? categoryBreakdown = null,
  }) {
    return _then(
      _$AdminOverviewImpl(
        totalStudents: null == totalStudents
            ? _value.totalStudents
            : totalStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        activeKiosks: null == activeKiosks
            ? _value.activeKiosks
            : activeKiosks // ignore: cast_nullable_to_non_nullable
                  as int,
        kiosksNeedingAttention: null == kiosksNeedingAttention
            ? _value.kiosksNeedingAttention
            : kiosksNeedingAttention // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionsToday: null == sessionsToday
            ? _value.sessionsToday
            : sessionsToday // ignore: cast_nullable_to_non_nullable
                  as int,
        systemAccuracy: null == systemAccuracy
            ? _value.systemAccuracy
            : systemAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        rewardsRedeemedToday: null == rewardsRedeemedToday
            ? _value.rewardsRedeemedToday
            : rewardsRedeemedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        headlineMetrics: null == headlineMetrics
            ? _value._headlineMetrics
            : headlineMetrics // ignore: cast_nullable_to_non_nullable
                  as List<MetricValue>,
        weeklySessions: null == weeklySessions
            ? _value._weeklySessions
            : weeklySessions // ignore: cast_nullable_to_non_nullable
                  as List<TrendPoint>,
        categoryBreakdown: null == categoryBreakdown
            ? _value._categoryBreakdown
            : categoryBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<CategoryBreakdown>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminOverviewImpl implements _AdminOverview {
  const _$AdminOverviewImpl({
    required this.totalStudents,
    required this.activeKiosks,
    required this.kiosksNeedingAttention,
    required this.sessionsToday,
    required this.systemAccuracy,
    required this.rewardsRedeemedToday,
    final List<MetricValue> headlineMetrics = const <MetricValue>[],
    final List<TrendPoint> weeklySessions = const <TrendPoint>[],
    final List<CategoryBreakdown> categoryBreakdown =
        const <CategoryBreakdown>[],
  }) : _headlineMetrics = headlineMetrics,
       _weeklySessions = weeklySessions,
       _categoryBreakdown = categoryBreakdown;

  factory _$AdminOverviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminOverviewImplFromJson(json);

  @override
  final int totalStudents;
  @override
  final int activeKiosks;
  @override
  final int kiosksNeedingAttention;
  @override
  final int sessionsToday;
  @override
  final double systemAccuracy;
  // 0..1
  @override
  final int rewardsRedeemedToday;
  final List<MetricValue> _headlineMetrics;
  @override
  @JsonKey()
  List<MetricValue> get headlineMetrics {
    if (_headlineMetrics is EqualUnmodifiableListView) return _headlineMetrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_headlineMetrics);
  }

  final List<TrendPoint> _weeklySessions;
  @override
  @JsonKey()
  List<TrendPoint> get weeklySessions {
    if (_weeklySessions is EqualUnmodifiableListView) return _weeklySessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklySessions);
  }

  final List<CategoryBreakdown> _categoryBreakdown;
  @override
  @JsonKey()
  List<CategoryBreakdown> get categoryBreakdown {
    if (_categoryBreakdown is EqualUnmodifiableListView)
      return _categoryBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryBreakdown);
  }

  @override
  String toString() {
    return 'AdminOverview(totalStudents: $totalStudents, activeKiosks: $activeKiosks, kiosksNeedingAttention: $kiosksNeedingAttention, sessionsToday: $sessionsToday, systemAccuracy: $systemAccuracy, rewardsRedeemedToday: $rewardsRedeemedToday, headlineMetrics: $headlineMetrics, weeklySessions: $weeklySessions, categoryBreakdown: $categoryBreakdown)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminOverviewImpl &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(other.activeKiosks, activeKiosks) ||
                other.activeKiosks == activeKiosks) &&
            (identical(other.kiosksNeedingAttention, kiosksNeedingAttention) ||
                other.kiosksNeedingAttention == kiosksNeedingAttention) &&
            (identical(other.sessionsToday, sessionsToday) ||
                other.sessionsToday == sessionsToday) &&
            (identical(other.systemAccuracy, systemAccuracy) ||
                other.systemAccuracy == systemAccuracy) &&
            (identical(other.rewardsRedeemedToday, rewardsRedeemedToday) ||
                other.rewardsRedeemedToday == rewardsRedeemedToday) &&
            const DeepCollectionEquality().equals(
              other._headlineMetrics,
              _headlineMetrics,
            ) &&
            const DeepCollectionEquality().equals(
              other._weeklySessions,
              _weeklySessions,
            ) &&
            const DeepCollectionEquality().equals(
              other._categoryBreakdown,
              _categoryBreakdown,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalStudents,
    activeKiosks,
    kiosksNeedingAttention,
    sessionsToday,
    systemAccuracy,
    rewardsRedeemedToday,
    const DeepCollectionEquality().hash(_headlineMetrics),
    const DeepCollectionEquality().hash(_weeklySessions),
    const DeepCollectionEquality().hash(_categoryBreakdown),
  );

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminOverviewImplCopyWith<_$AdminOverviewImpl> get copyWith =>
      __$$AdminOverviewImplCopyWithImpl<_$AdminOverviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminOverviewImplToJson(this);
  }
}

abstract class _AdminOverview implements AdminOverview {
  const factory _AdminOverview({
    required final int totalStudents,
    required final int activeKiosks,
    required final int kiosksNeedingAttention,
    required final int sessionsToday,
    required final double systemAccuracy,
    required final int rewardsRedeemedToday,
    final List<MetricValue> headlineMetrics,
    final List<TrendPoint> weeklySessions,
    final List<CategoryBreakdown> categoryBreakdown,
  }) = _$AdminOverviewImpl;

  factory _AdminOverview.fromJson(Map<String, dynamic> json) =
      _$AdminOverviewImpl.fromJson;

  @override
  int get totalStudents;
  @override
  int get activeKiosks;
  @override
  int get kiosksNeedingAttention;
  @override
  int get sessionsToday;
  @override
  double get systemAccuracy; // 0..1
  @override
  int get rewardsRedeemedToday;
  @override
  List<MetricValue> get headlineMetrics;
  @override
  List<TrendPoint> get weeklySessions;
  @override
  List<CategoryBreakdown> get categoryBreakdown;

  /// Create a copy of AdminOverview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminOverviewImplCopyWith<_$AdminOverviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LeaderboardMini _$LeaderboardMiniFromJson(Map<String, dynamic> json) {
  return _LeaderboardMini.fromJson(json);
}

/// @nodoc
mixin _$LeaderboardMini {
  String get name => throw _privateConstructorUsedError;
  int get points => throw _privateConstructorUsedError;
  String get colour => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;

  /// Serializes this LeaderboardMini to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LeaderboardMini
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaderboardMiniCopyWith<LeaderboardMini> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaderboardMiniCopyWith<$Res> {
  factory $LeaderboardMiniCopyWith(
    LeaderboardMini value,
    $Res Function(LeaderboardMini) then,
  ) = _$LeaderboardMiniCopyWithImpl<$Res, LeaderboardMini>;
  @useResult
  $Res call({String name, int points, String colour, double progress});
}

/// @nodoc
class _$LeaderboardMiniCopyWithImpl<$Res, $Val extends LeaderboardMini>
    implements $LeaderboardMiniCopyWith<$Res> {
  _$LeaderboardMiniCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LeaderboardMini
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? points = null,
    Object? colour = null,
    Object? progress = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as int,
            colour: null == colour
                ? _value.colour
                : colour // ignore: cast_nullable_to_non_nullable
                      as String,
            progress: null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaderboardMiniImplCopyWith<$Res>
    implements $LeaderboardMiniCopyWith<$Res> {
  factory _$$LeaderboardMiniImplCopyWith(
    _$LeaderboardMiniImpl value,
    $Res Function(_$LeaderboardMiniImpl) then,
  ) = __$$LeaderboardMiniImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int points, String colour, double progress});
}

/// @nodoc
class __$$LeaderboardMiniImplCopyWithImpl<$Res>
    extends _$LeaderboardMiniCopyWithImpl<$Res, _$LeaderboardMiniImpl>
    implements _$$LeaderboardMiniImplCopyWith<$Res> {
  __$$LeaderboardMiniImplCopyWithImpl(
    _$LeaderboardMiniImpl _value,
    $Res Function(_$LeaderboardMiniImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LeaderboardMini
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? points = null,
    Object? colour = null,
    Object? progress = null,
  }) {
    return _then(
      _$LeaderboardMiniImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as int,
        colour: null == colour
            ? _value.colour
            : colour // ignore: cast_nullable_to_non_nullable
                  as String,
        progress: null == progress
            ? _value.progress
            : progress // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaderboardMiniImpl implements _LeaderboardMini {
  const _$LeaderboardMiniImpl({
    required this.name,
    required this.points,
    this.colour = '#2E7D46',
    this.progress = 0.0,
  });

  factory _$LeaderboardMiniImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaderboardMiniImplFromJson(json);

  @override
  final String name;
  @override
  final int points;
  @override
  @JsonKey()
  final String colour;
  @override
  @JsonKey()
  final double progress;

  @override
  String toString() {
    return 'LeaderboardMini(name: $name, points: $points, colour: $colour, progress: $progress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaderboardMiniImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.colour, colour) || other.colour == colour) &&
            (identical(other.progress, progress) ||
                other.progress == progress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, points, colour, progress);

  /// Create a copy of LeaderboardMini
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaderboardMiniImplCopyWith<_$LeaderboardMiniImpl> get copyWith =>
      __$$LeaderboardMiniImplCopyWithImpl<_$LeaderboardMiniImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaderboardMiniImplToJson(this);
  }
}

abstract class _LeaderboardMini implements LeaderboardMini {
  const factory _LeaderboardMini({
    required final String name,
    required final int points,
    final String colour,
    final double progress,
  }) = _$LeaderboardMiniImpl;

  factory _LeaderboardMini.fromJson(Map<String, dynamic> json) =
      _$LeaderboardMiniImpl.fromJson;

  @override
  String get name;
  @override
  int get points;
  @override
  String get colour;
  @override
  double get progress;

  /// Create a copy of LeaderboardMini
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaderboardMiniImplCopyWith<_$LeaderboardMiniImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryBreakdown _$CategoryBreakdownFromJson(Map<String, dynamic> json) {
  return _CategoryBreakdown.fromJson(json);
}

/// @nodoc
mixin _$CategoryBreakdown {
  WasteCategory get category => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  double get share => throw _privateConstructorUsedError;

  /// Serializes this CategoryBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryBreakdownCopyWith<CategoryBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryBreakdownCopyWith<$Res> {
  factory $CategoryBreakdownCopyWith(
    CategoryBreakdown value,
    $Res Function(CategoryBreakdown) then,
  ) = _$CategoryBreakdownCopyWithImpl<$Res, CategoryBreakdown>;
  @useResult
  $Res call({WasteCategory category, int count, double share});
}

/// @nodoc
class _$CategoryBreakdownCopyWithImpl<$Res, $Val extends CategoryBreakdown>
    implements $CategoryBreakdownCopyWith<$Res> {
  _$CategoryBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? count = null,
    Object? share = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as WasteCategory,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            share: null == share
                ? _value.share
                : share // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryBreakdownImplCopyWith<$Res>
    implements $CategoryBreakdownCopyWith<$Res> {
  factory _$$CategoryBreakdownImplCopyWith(
    _$CategoryBreakdownImpl value,
    $Res Function(_$CategoryBreakdownImpl) then,
  ) = __$$CategoryBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WasteCategory category, int count, double share});
}

/// @nodoc
class __$$CategoryBreakdownImplCopyWithImpl<$Res>
    extends _$CategoryBreakdownCopyWithImpl<$Res, _$CategoryBreakdownImpl>
    implements _$$CategoryBreakdownImplCopyWith<$Res> {
  __$$CategoryBreakdownImplCopyWithImpl(
    _$CategoryBreakdownImpl _value,
    $Res Function(_$CategoryBreakdownImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? count = null,
    Object? share = null,
  }) {
    return _then(
      _$CategoryBreakdownImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as WasteCategory,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        share: null == share
            ? _value.share
            : share // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryBreakdownImpl extends _CategoryBreakdown {
  const _$CategoryBreakdownImpl({
    required this.category,
    required this.count,
    required this.share,
  }) : super._();

  factory _$CategoryBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryBreakdownImplFromJson(json);

  @override
  final WasteCategory category;
  @override
  final int count;
  @override
  final double share;

  @override
  String toString() {
    return 'CategoryBreakdown(category: $category, count: $count, share: $share)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryBreakdownImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.share, share) || other.share == share));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, count, share);

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      __$$CategoryBreakdownImplCopyWithImpl<_$CategoryBreakdownImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryBreakdownImplToJson(this);
  }
}

abstract class _CategoryBreakdown extends CategoryBreakdown {
  const factory _CategoryBreakdown({
    required final WasteCategory category,
    required final int count,
    required final double share,
  }) = _$CategoryBreakdownImpl;
  const _CategoryBreakdown._() : super._();

  factory _CategoryBreakdown.fromJson(Map<String, dynamic> json) =
      _$CategoryBreakdownImpl.fromJson;

  @override
  WasteCategory get category;
  @override
  int get count;
  @override
  double get share;

  /// Create a copy of CategoryBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryBreakdownImplCopyWith<_$CategoryBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AccuracyMetrics _$AccuracyMetricsFromJson(Map<String, dynamic> json) {
  return _AccuracyMetrics.fromJson(json);
}

/// @nodoc
mixin _$AccuracyMetrics {
  double get overallAccuracy => throw _privateConstructorUsedError;
  List<CategoryAccuracy> get perCategory => throw _privateConstructorUsedError;
  List<CommonMistake> get commonMistakes => throw _privateConstructorUsedError;
  List<TrendPoint> get accuracyTrend => throw _privateConstructorUsedError;

  /// Serializes this AccuracyMetrics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccuracyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccuracyMetricsCopyWith<AccuracyMetrics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccuracyMetricsCopyWith<$Res> {
  factory $AccuracyMetricsCopyWith(
    AccuracyMetrics value,
    $Res Function(AccuracyMetrics) then,
  ) = _$AccuracyMetricsCopyWithImpl<$Res, AccuracyMetrics>;
  @useResult
  $Res call({
    double overallAccuracy,
    List<CategoryAccuracy> perCategory,
    List<CommonMistake> commonMistakes,
    List<TrendPoint> accuracyTrend,
  });
}

/// @nodoc
class _$AccuracyMetricsCopyWithImpl<$Res, $Val extends AccuracyMetrics>
    implements $AccuracyMetricsCopyWith<$Res> {
  _$AccuracyMetricsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccuracyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallAccuracy = null,
    Object? perCategory = null,
    Object? commonMistakes = null,
    Object? accuracyTrend = null,
  }) {
    return _then(
      _value.copyWith(
            overallAccuracy: null == overallAccuracy
                ? _value.overallAccuracy
                : overallAccuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            perCategory: null == perCategory
                ? _value.perCategory
                : perCategory // ignore: cast_nullable_to_non_nullable
                      as List<CategoryAccuracy>,
            commonMistakes: null == commonMistakes
                ? _value.commonMistakes
                : commonMistakes // ignore: cast_nullable_to_non_nullable
                      as List<CommonMistake>,
            accuracyTrend: null == accuracyTrend
                ? _value.accuracyTrend
                : accuracyTrend // ignore: cast_nullable_to_non_nullable
                      as List<TrendPoint>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AccuracyMetricsImplCopyWith<$Res>
    implements $AccuracyMetricsCopyWith<$Res> {
  factory _$$AccuracyMetricsImplCopyWith(
    _$AccuracyMetricsImpl value,
    $Res Function(_$AccuracyMetricsImpl) then,
  ) = __$$AccuracyMetricsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double overallAccuracy,
    List<CategoryAccuracy> perCategory,
    List<CommonMistake> commonMistakes,
    List<TrendPoint> accuracyTrend,
  });
}

/// @nodoc
class __$$AccuracyMetricsImplCopyWithImpl<$Res>
    extends _$AccuracyMetricsCopyWithImpl<$Res, _$AccuracyMetricsImpl>
    implements _$$AccuracyMetricsImplCopyWith<$Res> {
  __$$AccuracyMetricsImplCopyWithImpl(
    _$AccuracyMetricsImpl _value,
    $Res Function(_$AccuracyMetricsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AccuracyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallAccuracy = null,
    Object? perCategory = null,
    Object? commonMistakes = null,
    Object? accuracyTrend = null,
  }) {
    return _then(
      _$AccuracyMetricsImpl(
        overallAccuracy: null == overallAccuracy
            ? _value.overallAccuracy
            : overallAccuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        perCategory: null == perCategory
            ? _value._perCategory
            : perCategory // ignore: cast_nullable_to_non_nullable
                  as List<CategoryAccuracy>,
        commonMistakes: null == commonMistakes
            ? _value._commonMistakes
            : commonMistakes // ignore: cast_nullable_to_non_nullable
                  as List<CommonMistake>,
        accuracyTrend: null == accuracyTrend
            ? _value._accuracyTrend
            : accuracyTrend // ignore: cast_nullable_to_non_nullable
                  as List<TrendPoint>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AccuracyMetricsImpl implements _AccuracyMetrics {
  const _$AccuracyMetricsImpl({
    required this.overallAccuracy,
    final List<CategoryAccuracy> perCategory = const <CategoryAccuracy>[],
    final List<CommonMistake> commonMistakes = const <CommonMistake>[],
    final List<TrendPoint> accuracyTrend = const <TrendPoint>[],
  }) : _perCategory = perCategory,
       _commonMistakes = commonMistakes,
       _accuracyTrend = accuracyTrend;

  factory _$AccuracyMetricsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccuracyMetricsImplFromJson(json);

  @override
  final double overallAccuracy;
  final List<CategoryAccuracy> _perCategory;
  @override
  @JsonKey()
  List<CategoryAccuracy> get perCategory {
    if (_perCategory is EqualUnmodifiableListView) return _perCategory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_perCategory);
  }

  final List<CommonMistake> _commonMistakes;
  @override
  @JsonKey()
  List<CommonMistake> get commonMistakes {
    if (_commonMistakes is EqualUnmodifiableListView) return _commonMistakes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commonMistakes);
  }

  final List<TrendPoint> _accuracyTrend;
  @override
  @JsonKey()
  List<TrendPoint> get accuracyTrend {
    if (_accuracyTrend is EqualUnmodifiableListView) return _accuracyTrend;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_accuracyTrend);
  }

  @override
  String toString() {
    return 'AccuracyMetrics(overallAccuracy: $overallAccuracy, perCategory: $perCategory, commonMistakes: $commonMistakes, accuracyTrend: $accuracyTrend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccuracyMetricsImpl &&
            (identical(other.overallAccuracy, overallAccuracy) ||
                other.overallAccuracy == overallAccuracy) &&
            const DeepCollectionEquality().equals(
              other._perCategory,
              _perCategory,
            ) &&
            const DeepCollectionEquality().equals(
              other._commonMistakes,
              _commonMistakes,
            ) &&
            const DeepCollectionEquality().equals(
              other._accuracyTrend,
              _accuracyTrend,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    overallAccuracy,
    const DeepCollectionEquality().hash(_perCategory),
    const DeepCollectionEquality().hash(_commonMistakes),
    const DeepCollectionEquality().hash(_accuracyTrend),
  );

  /// Create a copy of AccuracyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccuracyMetricsImplCopyWith<_$AccuracyMetricsImpl> get copyWith =>
      __$$AccuracyMetricsImplCopyWithImpl<_$AccuracyMetricsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AccuracyMetricsImplToJson(this);
  }
}

abstract class _AccuracyMetrics implements AccuracyMetrics {
  const factory _AccuracyMetrics({
    required final double overallAccuracy,
    final List<CategoryAccuracy> perCategory,
    final List<CommonMistake> commonMistakes,
    final List<TrendPoint> accuracyTrend,
  }) = _$AccuracyMetricsImpl;

  factory _AccuracyMetrics.fromJson(Map<String, dynamic> json) =
      _$AccuracyMetricsImpl.fromJson;

  @override
  double get overallAccuracy;
  @override
  List<CategoryAccuracy> get perCategory;
  @override
  List<CommonMistake> get commonMistakes;
  @override
  List<TrendPoint> get accuracyTrend;

  /// Create a copy of AccuracyMetrics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccuracyMetricsImplCopyWith<_$AccuracyMetricsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryAccuracy _$CategoryAccuracyFromJson(Map<String, dynamic> json) {
  return _CategoryAccuracy.fromJson(json);
}

/// @nodoc
mixin _$CategoryAccuracy {
  WasteCategory get category => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;

  /// Serializes this CategoryAccuracy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryAccuracyCopyWith<CategoryAccuracy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryAccuracyCopyWith<$Res> {
  factory $CategoryAccuracyCopyWith(
    CategoryAccuracy value,
    $Res Function(CategoryAccuracy) then,
  ) = _$CategoryAccuracyCopyWithImpl<$Res, CategoryAccuracy>;
  @useResult
  $Res call({WasteCategory category, double accuracy, int attempts});
}

/// @nodoc
class _$CategoryAccuracyCopyWithImpl<$Res, $Val extends CategoryAccuracy>
    implements $CategoryAccuracyCopyWith<$Res> {
  _$CategoryAccuracyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? accuracy = null,
    Object? attempts = null,
  }) {
    return _then(
      _value.copyWith(
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as WasteCategory,
            accuracy: null == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            attempts: null == attempts
                ? _value.attempts
                : attempts // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CategoryAccuracyImplCopyWith<$Res>
    implements $CategoryAccuracyCopyWith<$Res> {
  factory _$$CategoryAccuracyImplCopyWith(
    _$CategoryAccuracyImpl value,
    $Res Function(_$CategoryAccuracyImpl) then,
  ) = __$$CategoryAccuracyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WasteCategory category, double accuracy, int attempts});
}

/// @nodoc
class __$$CategoryAccuracyImplCopyWithImpl<$Res>
    extends _$CategoryAccuracyCopyWithImpl<$Res, _$CategoryAccuracyImpl>
    implements _$$CategoryAccuracyImplCopyWith<$Res> {
  __$$CategoryAccuracyImplCopyWithImpl(
    _$CategoryAccuracyImpl _value,
    $Res Function(_$CategoryAccuracyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CategoryAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? accuracy = null,
    Object? attempts = null,
  }) {
    return _then(
      _$CategoryAccuracyImpl(
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as WasteCategory,
        accuracy: null == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        attempts: null == attempts
            ? _value.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryAccuracyImpl extends _CategoryAccuracy {
  const _$CategoryAccuracyImpl({
    required this.category,
    required this.accuracy,
    required this.attempts,
  }) : super._();

  factory _$CategoryAccuracyImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryAccuracyImplFromJson(json);

  @override
  final WasteCategory category;
  @override
  final double accuracy;
  @override
  final int attempts;

  @override
  String toString() {
    return 'CategoryAccuracy(category: $category, accuracy: $accuracy, attempts: $attempts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryAccuracyImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, accuracy, attempts);

  /// Create a copy of CategoryAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryAccuracyImplCopyWith<_$CategoryAccuracyImpl> get copyWith =>
      __$$CategoryAccuracyImplCopyWithImpl<_$CategoryAccuracyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryAccuracyImplToJson(this);
  }
}

abstract class _CategoryAccuracy extends CategoryAccuracy {
  const factory _CategoryAccuracy({
    required final WasteCategory category,
    required final double accuracy,
    required final int attempts,
  }) = _$CategoryAccuracyImpl;
  const _CategoryAccuracy._() : super._();

  factory _CategoryAccuracy.fromJson(Map<String, dynamic> json) =
      _$CategoryAccuracyImpl.fromJson;

  @override
  WasteCategory get category;
  @override
  double get accuracy;
  @override
  int get attempts;

  /// Create a copy of CategoryAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryAccuracyImplCopyWith<_$CategoryAccuracyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
