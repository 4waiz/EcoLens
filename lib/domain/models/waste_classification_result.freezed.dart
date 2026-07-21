// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'waste_classification_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WasteClassificationResult _$WasteClassificationResultFromJson(
  Map<String, dynamic> json,
) {
  return _WasteClassificationResult.fromJson(json);
}

/// @nodoc
mixin _$WasteClassificationResult {
  WasteCategory get predictedCategory => throw _privateConstructorUsedError;
  String get detectedObjectName => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError; // 0..1
  ItemCondition get condition => throw _privateConstructorUsedError;
  bool get contaminationDetected => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  String get educationalFact => throw _privateConstructorUsedError;
  String? get capturedImagePath =>
      throw _privateConstructorUsedError; // cleared by privacy service after processing
  DateTime get processedAt => throw _privateConstructorUsedError;
  bool get isFallback => throw _privateConstructorUsedError;

  /// Serializes this WasteClassificationResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WasteClassificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WasteClassificationResultCopyWith<WasteClassificationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WasteClassificationResultCopyWith<$Res> {
  factory $WasteClassificationResultCopyWith(
    WasteClassificationResult value,
    $Res Function(WasteClassificationResult) then,
  ) = _$WasteClassificationResultCopyWithImpl<$Res, WasteClassificationResult>;
  @useResult
  $Res call({
    WasteCategory predictedCategory,
    String detectedObjectName,
    double confidence,
    ItemCondition condition,
    bool contaminationDetected,
    String explanation,
    String educationalFact,
    String? capturedImagePath,
    DateTime processedAt,
    bool isFallback,
  });
}

/// @nodoc
class _$WasteClassificationResultCopyWithImpl<
  $Res,
  $Val extends WasteClassificationResult
>
    implements $WasteClassificationResultCopyWith<$Res> {
  _$WasteClassificationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WasteClassificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedCategory = null,
    Object? detectedObjectName = null,
    Object? confidence = null,
    Object? condition = null,
    Object? contaminationDetected = null,
    Object? explanation = null,
    Object? educationalFact = null,
    Object? capturedImagePath = freezed,
    Object? processedAt = null,
    Object? isFallback = null,
  }) {
    return _then(
      _value.copyWith(
            predictedCategory: null == predictedCategory
                ? _value.predictedCategory
                : predictedCategory // ignore: cast_nullable_to_non_nullable
                      as WasteCategory,
            detectedObjectName: null == detectedObjectName
                ? _value.detectedObjectName
                : detectedObjectName // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
            condition: null == condition
                ? _value.condition
                : condition // ignore: cast_nullable_to_non_nullable
                      as ItemCondition,
            contaminationDetected: null == contaminationDetected
                ? _value.contaminationDetected
                : contaminationDetected // ignore: cast_nullable_to_non_nullable
                      as bool,
            explanation: null == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String,
            educationalFact: null == educationalFact
                ? _value.educationalFact
                : educationalFact // ignore: cast_nullable_to_non_nullable
                      as String,
            capturedImagePath: freezed == capturedImagePath
                ? _value.capturedImagePath
                : capturedImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
            processedAt: null == processedAt
                ? _value.processedAt
                : processedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isFallback: null == isFallback
                ? _value.isFallback
                : isFallback // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WasteClassificationResultImplCopyWith<$Res>
    implements $WasteClassificationResultCopyWith<$Res> {
  factory _$$WasteClassificationResultImplCopyWith(
    _$WasteClassificationResultImpl value,
    $Res Function(_$WasteClassificationResultImpl) then,
  ) = __$$WasteClassificationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    WasteCategory predictedCategory,
    String detectedObjectName,
    double confidence,
    ItemCondition condition,
    bool contaminationDetected,
    String explanation,
    String educationalFact,
    String? capturedImagePath,
    DateTime processedAt,
    bool isFallback,
  });
}

/// @nodoc
class __$$WasteClassificationResultImplCopyWithImpl<$Res>
    extends
        _$WasteClassificationResultCopyWithImpl<
          $Res,
          _$WasteClassificationResultImpl
        >
    implements _$$WasteClassificationResultImplCopyWith<$Res> {
  __$$WasteClassificationResultImplCopyWithImpl(
    _$WasteClassificationResultImpl _value,
    $Res Function(_$WasteClassificationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WasteClassificationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? predictedCategory = null,
    Object? detectedObjectName = null,
    Object? confidence = null,
    Object? condition = null,
    Object? contaminationDetected = null,
    Object? explanation = null,
    Object? educationalFact = null,
    Object? capturedImagePath = freezed,
    Object? processedAt = null,
    Object? isFallback = null,
  }) {
    return _then(
      _$WasteClassificationResultImpl(
        predictedCategory: null == predictedCategory
            ? _value.predictedCategory
            : predictedCategory // ignore: cast_nullable_to_non_nullable
                  as WasteCategory,
        detectedObjectName: null == detectedObjectName
            ? _value.detectedObjectName
            : detectedObjectName // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
        condition: null == condition
            ? _value.condition
            : condition // ignore: cast_nullable_to_non_nullable
                  as ItemCondition,
        contaminationDetected: null == contaminationDetected
            ? _value.contaminationDetected
            : contaminationDetected // ignore: cast_nullable_to_non_nullable
                  as bool,
        explanation: null == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String,
        educationalFact: null == educationalFact
            ? _value.educationalFact
            : educationalFact // ignore: cast_nullable_to_non_nullable
                  as String,
        capturedImagePath: freezed == capturedImagePath
            ? _value.capturedImagePath
            : capturedImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        processedAt: null == processedAt
            ? _value.processedAt
            : processedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isFallback: null == isFallback
            ? _value.isFallback
            : isFallback // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WasteClassificationResultImpl extends _WasteClassificationResult {
  const _$WasteClassificationResultImpl({
    required this.predictedCategory,
    required this.detectedObjectName,
    required this.confidence,
    this.condition = ItemCondition.clean,
    this.contaminationDetected = false,
    required this.explanation,
    required this.educationalFact,
    this.capturedImagePath,
    required this.processedAt,
    this.isFallback = false,
  }) : super._();

  factory _$WasteClassificationResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$WasteClassificationResultImplFromJson(json);

  @override
  final WasteCategory predictedCategory;
  @override
  final String detectedObjectName;
  @override
  final double confidence;
  // 0..1
  @override
  @JsonKey()
  final ItemCondition condition;
  @override
  @JsonKey()
  final bool contaminationDetected;
  @override
  final String explanation;
  @override
  final String educationalFact;
  @override
  final String? capturedImagePath;
  // cleared by privacy service after processing
  @override
  final DateTime processedAt;
  @override
  @JsonKey()
  final bool isFallback;

  @override
  String toString() {
    return 'WasteClassificationResult(predictedCategory: $predictedCategory, detectedObjectName: $detectedObjectName, confidence: $confidence, condition: $condition, contaminationDetected: $contaminationDetected, explanation: $explanation, educationalFact: $educationalFact, capturedImagePath: $capturedImagePath, processedAt: $processedAt, isFallback: $isFallback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WasteClassificationResultImpl &&
            (identical(other.predictedCategory, predictedCategory) ||
                other.predictedCategory == predictedCategory) &&
            (identical(other.detectedObjectName, detectedObjectName) ||
                other.detectedObjectName == detectedObjectName) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.contaminationDetected, contaminationDetected) ||
                other.contaminationDetected == contaminationDetected) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.educationalFact, educationalFact) ||
                other.educationalFact == educationalFact) &&
            (identical(other.capturedImagePath, capturedImagePath) ||
                other.capturedImagePath == capturedImagePath) &&
            (identical(other.processedAt, processedAt) ||
                other.processedAt == processedAt) &&
            (identical(other.isFallback, isFallback) ||
                other.isFallback == isFallback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    predictedCategory,
    detectedObjectName,
    confidence,
    condition,
    contaminationDetected,
    explanation,
    educationalFact,
    capturedImagePath,
    processedAt,
    isFallback,
  );

  /// Create a copy of WasteClassificationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WasteClassificationResultImplCopyWith<_$WasteClassificationResultImpl>
  get copyWith =>
      __$$WasteClassificationResultImplCopyWithImpl<
        _$WasteClassificationResultImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WasteClassificationResultImplToJson(this);
  }
}

abstract class _WasteClassificationResult extends WasteClassificationResult {
  const factory _WasteClassificationResult({
    required final WasteCategory predictedCategory,
    required final String detectedObjectName,
    required final double confidence,
    final ItemCondition condition,
    final bool contaminationDetected,
    required final String explanation,
    required final String educationalFact,
    final String? capturedImagePath,
    required final DateTime processedAt,
    final bool isFallback,
  }) = _$WasteClassificationResultImpl;
  const _WasteClassificationResult._() : super._();

  factory _WasteClassificationResult.fromJson(Map<String, dynamic> json) =
      _$WasteClassificationResultImpl.fromJson;

  @override
  WasteCategory get predictedCategory;
  @override
  String get detectedObjectName;
  @override
  double get confidence; // 0..1
  @override
  ItemCondition get condition;
  @override
  bool get contaminationDetected;
  @override
  String get explanation;
  @override
  String get educationalFact;
  @override
  String? get capturedImagePath; // cleared by privacy service after processing
  @override
  DateTime get processedAt;
  @override
  bool get isFallback;

  /// Create a copy of WasteClassificationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WasteClassificationResultImplCopyWith<_$WasteClassificationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
