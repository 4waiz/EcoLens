// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gamification_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GamificationConfig _$GamificationConfigFromJson(Map<String, dynamic> json) {
  return _GamificationConfig.fromJson(json);
}

/// @nodoc
mixin _$GamificationConfig {
  // ---- Points ----
  int get pointsPerCorrect => throw _privateConstructorUsedError;
  int get pointsPerIncorrect => throw _privateConstructorUsedError;
  int get dailyPointsCap => throw _privateConstructorUsedError;
  int get xpPerCorrect =>
      throw _privateConstructorUsedError; // ---- Streak / bonus ----
  int get bonusStreakThreshold => throw _privateConstructorUsedError;
  int get bonusPoints =>
      throw _privateConstructorUsedError; // AED 5 -> 25 points at 5pts=AED1... configurable
  bool get weekendsCountAsActive => throw _privateConstructorUsedError;
  bool get holidaysCountAsActive => throw _privateConstructorUsedError;
  int get streakGraceDays =>
      throw _privateConstructorUsedError; // extra approved-absence tolerance
  // ---- Monetary conversion ----
  bool get monetaryConversionEnabled => throw _privateConstructorUsedError;
  int get pointsPerCurrencyUnit =>
      throw _privateConstructorUsedError; // 50 points = 1 AED
  String get currencyCode => throw _privateConstructorUsedError; // ---- AI ----
  double get aiConfidenceThreshold =>
      throw _privateConstructorUsedError; // ---- Privacy ----
  int get inactivityTimeoutSeconds => throw _privateConstructorUsedError;
  int get imageRetentionSeconds =>
      throw _privateConstructorUsedError; // 0 = clear immediately
  int get autoLogoutCountdownSeconds => throw _privateConstructorUsedError;

  /// Serializes this GamificationConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GamificationConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GamificationConfigCopyWith<GamificationConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GamificationConfigCopyWith<$Res> {
  factory $GamificationConfigCopyWith(
    GamificationConfig value,
    $Res Function(GamificationConfig) then,
  ) = _$GamificationConfigCopyWithImpl<$Res, GamificationConfig>;
  @useResult
  $Res call({
    int pointsPerCorrect,
    int pointsPerIncorrect,
    int dailyPointsCap,
    int xpPerCorrect,
    int bonusStreakThreshold,
    int bonusPoints,
    bool weekendsCountAsActive,
    bool holidaysCountAsActive,
    int streakGraceDays,
    bool monetaryConversionEnabled,
    int pointsPerCurrencyUnit,
    String currencyCode,
    double aiConfidenceThreshold,
    int inactivityTimeoutSeconds,
    int imageRetentionSeconds,
    int autoLogoutCountdownSeconds,
  });
}

/// @nodoc
class _$GamificationConfigCopyWithImpl<$Res, $Val extends GamificationConfig>
    implements $GamificationConfigCopyWith<$Res> {
  _$GamificationConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GamificationConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointsPerCorrect = null,
    Object? pointsPerIncorrect = null,
    Object? dailyPointsCap = null,
    Object? xpPerCorrect = null,
    Object? bonusStreakThreshold = null,
    Object? bonusPoints = null,
    Object? weekendsCountAsActive = null,
    Object? holidaysCountAsActive = null,
    Object? streakGraceDays = null,
    Object? monetaryConversionEnabled = null,
    Object? pointsPerCurrencyUnit = null,
    Object? currencyCode = null,
    Object? aiConfidenceThreshold = null,
    Object? inactivityTimeoutSeconds = null,
    Object? imageRetentionSeconds = null,
    Object? autoLogoutCountdownSeconds = null,
  }) {
    return _then(
      _value.copyWith(
            pointsPerCorrect: null == pointsPerCorrect
                ? _value.pointsPerCorrect
                : pointsPerCorrect // ignore: cast_nullable_to_non_nullable
                      as int,
            pointsPerIncorrect: null == pointsPerIncorrect
                ? _value.pointsPerIncorrect
                : pointsPerIncorrect // ignore: cast_nullable_to_non_nullable
                      as int,
            dailyPointsCap: null == dailyPointsCap
                ? _value.dailyPointsCap
                : dailyPointsCap // ignore: cast_nullable_to_non_nullable
                      as int,
            xpPerCorrect: null == xpPerCorrect
                ? _value.xpPerCorrect
                : xpPerCorrect // ignore: cast_nullable_to_non_nullable
                      as int,
            bonusStreakThreshold: null == bonusStreakThreshold
                ? _value.bonusStreakThreshold
                : bonusStreakThreshold // ignore: cast_nullable_to_non_nullable
                      as int,
            bonusPoints: null == bonusPoints
                ? _value.bonusPoints
                : bonusPoints // ignore: cast_nullable_to_non_nullable
                      as int,
            weekendsCountAsActive: null == weekendsCountAsActive
                ? _value.weekendsCountAsActive
                : weekendsCountAsActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            holidaysCountAsActive: null == holidaysCountAsActive
                ? _value.holidaysCountAsActive
                : holidaysCountAsActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            streakGraceDays: null == streakGraceDays
                ? _value.streakGraceDays
                : streakGraceDays // ignore: cast_nullable_to_non_nullable
                      as int,
            monetaryConversionEnabled: null == monetaryConversionEnabled
                ? _value.monetaryConversionEnabled
                : monetaryConversionEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            pointsPerCurrencyUnit: null == pointsPerCurrencyUnit
                ? _value.pointsPerCurrencyUnit
                : pointsPerCurrencyUnit // ignore: cast_nullable_to_non_nullable
                      as int,
            currencyCode: null == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                      as String,
            aiConfidenceThreshold: null == aiConfidenceThreshold
                ? _value.aiConfidenceThreshold
                : aiConfidenceThreshold // ignore: cast_nullable_to_non_nullable
                      as double,
            inactivityTimeoutSeconds: null == inactivityTimeoutSeconds
                ? _value.inactivityTimeoutSeconds
                : inactivityTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            imageRetentionSeconds: null == imageRetentionSeconds
                ? _value.imageRetentionSeconds
                : imageRetentionSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            autoLogoutCountdownSeconds: null == autoLogoutCountdownSeconds
                ? _value.autoLogoutCountdownSeconds
                : autoLogoutCountdownSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GamificationConfigImplCopyWith<$Res>
    implements $GamificationConfigCopyWith<$Res> {
  factory _$$GamificationConfigImplCopyWith(
    _$GamificationConfigImpl value,
    $Res Function(_$GamificationConfigImpl) then,
  ) = __$$GamificationConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int pointsPerCorrect,
    int pointsPerIncorrect,
    int dailyPointsCap,
    int xpPerCorrect,
    int bonusStreakThreshold,
    int bonusPoints,
    bool weekendsCountAsActive,
    bool holidaysCountAsActive,
    int streakGraceDays,
    bool monetaryConversionEnabled,
    int pointsPerCurrencyUnit,
    String currencyCode,
    double aiConfidenceThreshold,
    int inactivityTimeoutSeconds,
    int imageRetentionSeconds,
    int autoLogoutCountdownSeconds,
  });
}

/// @nodoc
class __$$GamificationConfigImplCopyWithImpl<$Res>
    extends _$GamificationConfigCopyWithImpl<$Res, _$GamificationConfigImpl>
    implements _$$GamificationConfigImplCopyWith<$Res> {
  __$$GamificationConfigImplCopyWithImpl(
    _$GamificationConfigImpl _value,
    $Res Function(_$GamificationConfigImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GamificationConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointsPerCorrect = null,
    Object? pointsPerIncorrect = null,
    Object? dailyPointsCap = null,
    Object? xpPerCorrect = null,
    Object? bonusStreakThreshold = null,
    Object? bonusPoints = null,
    Object? weekendsCountAsActive = null,
    Object? holidaysCountAsActive = null,
    Object? streakGraceDays = null,
    Object? monetaryConversionEnabled = null,
    Object? pointsPerCurrencyUnit = null,
    Object? currencyCode = null,
    Object? aiConfidenceThreshold = null,
    Object? inactivityTimeoutSeconds = null,
    Object? imageRetentionSeconds = null,
    Object? autoLogoutCountdownSeconds = null,
  }) {
    return _then(
      _$GamificationConfigImpl(
        pointsPerCorrect: null == pointsPerCorrect
            ? _value.pointsPerCorrect
            : pointsPerCorrect // ignore: cast_nullable_to_non_nullable
                  as int,
        pointsPerIncorrect: null == pointsPerIncorrect
            ? _value.pointsPerIncorrect
            : pointsPerIncorrect // ignore: cast_nullable_to_non_nullable
                  as int,
        dailyPointsCap: null == dailyPointsCap
            ? _value.dailyPointsCap
            : dailyPointsCap // ignore: cast_nullable_to_non_nullable
                  as int,
        xpPerCorrect: null == xpPerCorrect
            ? _value.xpPerCorrect
            : xpPerCorrect // ignore: cast_nullable_to_non_nullable
                  as int,
        bonusStreakThreshold: null == bonusStreakThreshold
            ? _value.bonusStreakThreshold
            : bonusStreakThreshold // ignore: cast_nullable_to_non_nullable
                  as int,
        bonusPoints: null == bonusPoints
            ? _value.bonusPoints
            : bonusPoints // ignore: cast_nullable_to_non_nullable
                  as int,
        weekendsCountAsActive: null == weekendsCountAsActive
            ? _value.weekendsCountAsActive
            : weekendsCountAsActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        holidaysCountAsActive: null == holidaysCountAsActive
            ? _value.holidaysCountAsActive
            : holidaysCountAsActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        streakGraceDays: null == streakGraceDays
            ? _value.streakGraceDays
            : streakGraceDays // ignore: cast_nullable_to_non_nullable
                  as int,
        monetaryConversionEnabled: null == monetaryConversionEnabled
            ? _value.monetaryConversionEnabled
            : monetaryConversionEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        pointsPerCurrencyUnit: null == pointsPerCurrencyUnit
            ? _value.pointsPerCurrencyUnit
            : pointsPerCurrencyUnit // ignore: cast_nullable_to_non_nullable
                  as int,
        currencyCode: null == currencyCode
            ? _value.currencyCode
            : currencyCode // ignore: cast_nullable_to_non_nullable
                  as String,
        aiConfidenceThreshold: null == aiConfidenceThreshold
            ? _value.aiConfidenceThreshold
            : aiConfidenceThreshold // ignore: cast_nullable_to_non_nullable
                  as double,
        inactivityTimeoutSeconds: null == inactivityTimeoutSeconds
            ? _value.inactivityTimeoutSeconds
            : inactivityTimeoutSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        imageRetentionSeconds: null == imageRetentionSeconds
            ? _value.imageRetentionSeconds
            : imageRetentionSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        autoLogoutCountdownSeconds: null == autoLogoutCountdownSeconds
            ? _value.autoLogoutCountdownSeconds
            : autoLogoutCountdownSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GamificationConfigImpl extends _GamificationConfig {
  const _$GamificationConfigImpl({
    this.pointsPerCorrect = 5,
    this.pointsPerIncorrect = 0,
    this.dailyPointsCap = 50,
    this.xpPerCorrect = 5,
    this.bonusStreakThreshold = 20,
    this.bonusPoints = 25,
    this.weekendsCountAsActive = true,
    this.holidaysCountAsActive = true,
    this.streakGraceDays = 1,
    this.monetaryConversionEnabled = true,
    this.pointsPerCurrencyUnit = 50,
    this.currencyCode = 'AED',
    this.aiConfidenceThreshold = 0.80,
    this.inactivityTimeoutSeconds = 45,
    this.imageRetentionSeconds = 0,
    this.autoLogoutCountdownSeconds = 8,
  }) : super._();

  factory _$GamificationConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$GamificationConfigImplFromJson(json);

  // ---- Points ----
  @override
  @JsonKey()
  final int pointsPerCorrect;
  @override
  @JsonKey()
  final int pointsPerIncorrect;
  @override
  @JsonKey()
  final int dailyPointsCap;
  @override
  @JsonKey()
  final int xpPerCorrect;
  // ---- Streak / bonus ----
  @override
  @JsonKey()
  final int bonusStreakThreshold;
  @override
  @JsonKey()
  final int bonusPoints;
  // AED 5 -> 25 points at 5pts=AED1... configurable
  @override
  @JsonKey()
  final bool weekendsCountAsActive;
  @override
  @JsonKey()
  final bool holidaysCountAsActive;
  @override
  @JsonKey()
  final int streakGraceDays;
  // extra approved-absence tolerance
  // ---- Monetary conversion ----
  @override
  @JsonKey()
  final bool monetaryConversionEnabled;
  @override
  @JsonKey()
  final int pointsPerCurrencyUnit;
  // 50 points = 1 AED
  @override
  @JsonKey()
  final String currencyCode;
  // ---- AI ----
  @override
  @JsonKey()
  final double aiConfidenceThreshold;
  // ---- Privacy ----
  @override
  @JsonKey()
  final int inactivityTimeoutSeconds;
  @override
  @JsonKey()
  final int imageRetentionSeconds;
  // 0 = clear immediately
  @override
  @JsonKey()
  final int autoLogoutCountdownSeconds;

  @override
  String toString() {
    return 'GamificationConfig(pointsPerCorrect: $pointsPerCorrect, pointsPerIncorrect: $pointsPerIncorrect, dailyPointsCap: $dailyPointsCap, xpPerCorrect: $xpPerCorrect, bonusStreakThreshold: $bonusStreakThreshold, bonusPoints: $bonusPoints, weekendsCountAsActive: $weekendsCountAsActive, holidaysCountAsActive: $holidaysCountAsActive, streakGraceDays: $streakGraceDays, monetaryConversionEnabled: $monetaryConversionEnabled, pointsPerCurrencyUnit: $pointsPerCurrencyUnit, currencyCode: $currencyCode, aiConfidenceThreshold: $aiConfidenceThreshold, inactivityTimeoutSeconds: $inactivityTimeoutSeconds, imageRetentionSeconds: $imageRetentionSeconds, autoLogoutCountdownSeconds: $autoLogoutCountdownSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GamificationConfigImpl &&
            (identical(other.pointsPerCorrect, pointsPerCorrect) ||
                other.pointsPerCorrect == pointsPerCorrect) &&
            (identical(other.pointsPerIncorrect, pointsPerIncorrect) ||
                other.pointsPerIncorrect == pointsPerIncorrect) &&
            (identical(other.dailyPointsCap, dailyPointsCap) ||
                other.dailyPointsCap == dailyPointsCap) &&
            (identical(other.xpPerCorrect, xpPerCorrect) ||
                other.xpPerCorrect == xpPerCorrect) &&
            (identical(other.bonusStreakThreshold, bonusStreakThreshold) ||
                other.bonusStreakThreshold == bonusStreakThreshold) &&
            (identical(other.bonusPoints, bonusPoints) ||
                other.bonusPoints == bonusPoints) &&
            (identical(other.weekendsCountAsActive, weekendsCountAsActive) ||
                other.weekendsCountAsActive == weekendsCountAsActive) &&
            (identical(other.holidaysCountAsActive, holidaysCountAsActive) ||
                other.holidaysCountAsActive == holidaysCountAsActive) &&
            (identical(other.streakGraceDays, streakGraceDays) ||
                other.streakGraceDays == streakGraceDays) &&
            (identical(
                  other.monetaryConversionEnabled,
                  monetaryConversionEnabled,
                ) ||
                other.monetaryConversionEnabled == monetaryConversionEnabled) &&
            (identical(other.pointsPerCurrencyUnit, pointsPerCurrencyUnit) ||
                other.pointsPerCurrencyUnit == pointsPerCurrencyUnit) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.aiConfidenceThreshold, aiConfidenceThreshold) ||
                other.aiConfidenceThreshold == aiConfidenceThreshold) &&
            (identical(
                  other.inactivityTimeoutSeconds,
                  inactivityTimeoutSeconds,
                ) ||
                other.inactivityTimeoutSeconds == inactivityTimeoutSeconds) &&
            (identical(other.imageRetentionSeconds, imageRetentionSeconds) ||
                other.imageRetentionSeconds == imageRetentionSeconds) &&
            (identical(
                  other.autoLogoutCountdownSeconds,
                  autoLogoutCountdownSeconds,
                ) ||
                other.autoLogoutCountdownSeconds ==
                    autoLogoutCountdownSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pointsPerCorrect,
    pointsPerIncorrect,
    dailyPointsCap,
    xpPerCorrect,
    bonusStreakThreshold,
    bonusPoints,
    weekendsCountAsActive,
    holidaysCountAsActive,
    streakGraceDays,
    monetaryConversionEnabled,
    pointsPerCurrencyUnit,
    currencyCode,
    aiConfidenceThreshold,
    inactivityTimeoutSeconds,
    imageRetentionSeconds,
    autoLogoutCountdownSeconds,
  );

  /// Create a copy of GamificationConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GamificationConfigImplCopyWith<_$GamificationConfigImpl> get copyWith =>
      __$$GamificationConfigImplCopyWithImpl<_$GamificationConfigImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GamificationConfigImplToJson(this);
  }
}

abstract class _GamificationConfig extends GamificationConfig {
  const factory _GamificationConfig({
    final int pointsPerCorrect,
    final int pointsPerIncorrect,
    final int dailyPointsCap,
    final int xpPerCorrect,
    final int bonusStreakThreshold,
    final int bonusPoints,
    final bool weekendsCountAsActive,
    final bool holidaysCountAsActive,
    final int streakGraceDays,
    final bool monetaryConversionEnabled,
    final int pointsPerCurrencyUnit,
    final String currencyCode,
    final double aiConfidenceThreshold,
    final int inactivityTimeoutSeconds,
    final int imageRetentionSeconds,
    final int autoLogoutCountdownSeconds,
  }) = _$GamificationConfigImpl;
  const _GamificationConfig._() : super._();

  factory _GamificationConfig.fromJson(Map<String, dynamic> json) =
      _$GamificationConfigImpl.fromJson;

  // ---- Points ----
  @override
  int get pointsPerCorrect;
  @override
  int get pointsPerIncorrect;
  @override
  int get dailyPointsCap;
  @override
  int get xpPerCorrect; // ---- Streak / bonus ----
  @override
  int get bonusStreakThreshold;
  @override
  int get bonusPoints; // AED 5 -> 25 points at 5pts=AED1... configurable
  @override
  bool get weekendsCountAsActive;
  @override
  bool get holidaysCountAsActive;
  @override
  int get streakGraceDays; // extra approved-absence tolerance
  // ---- Monetary conversion ----
  @override
  bool get monetaryConversionEnabled;
  @override
  int get pointsPerCurrencyUnit; // 50 points = 1 AED
  @override
  String get currencyCode; // ---- AI ----
  @override
  double get aiConfidenceThreshold; // ---- Privacy ----
  @override
  int get inactivityTimeoutSeconds;
  @override
  int get imageRetentionSeconds; // 0 = clear immediately
  @override
  int get autoLogoutCountdownSeconds;

  /// Create a copy of GamificationConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GamificationConfigImplCopyWith<_$GamificationConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
