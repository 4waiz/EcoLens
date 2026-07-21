// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hardware_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HardwareStatus _$HardwareStatusFromJson(Map<String, dynamic> json) {
  return _HardwareStatus.fromJson(json);
}

/// @nodoc
mixin _$HardwareStatus {
  HealthStatus get overallStatus => throw _privateConstructorUsedError;
  bool get controllerConnected => throw _privateConstructorUsedError;
  bool get cameraAvailable => throw _privateConstructorUsedError;
  bool get cardReaderAvailable => throw _privateConstructorUsedError;
  Map<WasteCategory, FeedbackColour> get slotLedStatuses =>
      throw _privateConstructorUsedError;
  Map<WasteCategory, PeripheralStatus> get slotStatuses =>
      throw _privateConstructorUsedError;
  bool get wastePresenceDetected => throw _privateConstructorUsedError;
  Map<WasteCategory, double> get binFillLevels =>
      throw _privateConstructorUsedError; // 0..1 per slot
  DateTime get lastUpdatedAt => throw _privateConstructorUsedError;

  /// Serializes this HardwareStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwareStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwareStatusCopyWith<HardwareStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareStatusCopyWith<$Res> {
  factory $HardwareStatusCopyWith(
    HardwareStatus value,
    $Res Function(HardwareStatus) then,
  ) = _$HardwareStatusCopyWithImpl<$Res, HardwareStatus>;
  @useResult
  $Res call({
    HealthStatus overallStatus,
    bool controllerConnected,
    bool cameraAvailable,
    bool cardReaderAvailable,
    Map<WasteCategory, FeedbackColour> slotLedStatuses,
    Map<WasteCategory, PeripheralStatus> slotStatuses,
    bool wastePresenceDetected,
    Map<WasteCategory, double> binFillLevels,
    DateTime lastUpdatedAt,
  });
}

/// @nodoc
class _$HardwareStatusCopyWithImpl<$Res, $Val extends HardwareStatus>
    implements $HardwareStatusCopyWith<$Res> {
  _$HardwareStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwareStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallStatus = null,
    Object? controllerConnected = null,
    Object? cameraAvailable = null,
    Object? cardReaderAvailable = null,
    Object? slotLedStatuses = null,
    Object? slotStatuses = null,
    Object? wastePresenceDetected = null,
    Object? binFillLevels = null,
    Object? lastUpdatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            overallStatus: null == overallStatus
                ? _value.overallStatus
                : overallStatus // ignore: cast_nullable_to_non_nullable
                      as HealthStatus,
            controllerConnected: null == controllerConnected
                ? _value.controllerConnected
                : controllerConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
            cameraAvailable: null == cameraAvailable
                ? _value.cameraAvailable
                : cameraAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            cardReaderAvailable: null == cardReaderAvailable
                ? _value.cardReaderAvailable
                : cardReaderAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            slotLedStatuses: null == slotLedStatuses
                ? _value.slotLedStatuses
                : slotLedStatuses // ignore: cast_nullable_to_non_nullable
                      as Map<WasteCategory, FeedbackColour>,
            slotStatuses: null == slotStatuses
                ? _value.slotStatuses
                : slotStatuses // ignore: cast_nullable_to_non_nullable
                      as Map<WasteCategory, PeripheralStatus>,
            wastePresenceDetected: null == wastePresenceDetected
                ? _value.wastePresenceDetected
                : wastePresenceDetected // ignore: cast_nullable_to_non_nullable
                      as bool,
            binFillLevels: null == binFillLevels
                ? _value.binFillLevels
                : binFillLevels // ignore: cast_nullable_to_non_nullable
                      as Map<WasteCategory, double>,
            lastUpdatedAt: null == lastUpdatedAt
                ? _value.lastUpdatedAt
                : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HardwareStatusImplCopyWith<$Res>
    implements $HardwareStatusCopyWith<$Res> {
  factory _$$HardwareStatusImplCopyWith(
    _$HardwareStatusImpl value,
    $Res Function(_$HardwareStatusImpl) then,
  ) = __$$HardwareStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    HealthStatus overallStatus,
    bool controllerConnected,
    bool cameraAvailable,
    bool cardReaderAvailable,
    Map<WasteCategory, FeedbackColour> slotLedStatuses,
    Map<WasteCategory, PeripheralStatus> slotStatuses,
    bool wastePresenceDetected,
    Map<WasteCategory, double> binFillLevels,
    DateTime lastUpdatedAt,
  });
}

/// @nodoc
class __$$HardwareStatusImplCopyWithImpl<$Res>
    extends _$HardwareStatusCopyWithImpl<$Res, _$HardwareStatusImpl>
    implements _$$HardwareStatusImplCopyWith<$Res> {
  __$$HardwareStatusImplCopyWithImpl(
    _$HardwareStatusImpl _value,
    $Res Function(_$HardwareStatusImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HardwareStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? overallStatus = null,
    Object? controllerConnected = null,
    Object? cameraAvailable = null,
    Object? cardReaderAvailable = null,
    Object? slotLedStatuses = null,
    Object? slotStatuses = null,
    Object? wastePresenceDetected = null,
    Object? binFillLevels = null,
    Object? lastUpdatedAt = null,
  }) {
    return _then(
      _$HardwareStatusImpl(
        overallStatus: null == overallStatus
            ? _value.overallStatus
            : overallStatus // ignore: cast_nullable_to_non_nullable
                  as HealthStatus,
        controllerConnected: null == controllerConnected
            ? _value.controllerConnected
            : controllerConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
        cameraAvailable: null == cameraAvailable
            ? _value.cameraAvailable
            : cameraAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        cardReaderAvailable: null == cardReaderAvailable
            ? _value.cardReaderAvailable
            : cardReaderAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        slotLedStatuses: null == slotLedStatuses
            ? _value._slotLedStatuses
            : slotLedStatuses // ignore: cast_nullable_to_non_nullable
                  as Map<WasteCategory, FeedbackColour>,
        slotStatuses: null == slotStatuses
            ? _value._slotStatuses
            : slotStatuses // ignore: cast_nullable_to_non_nullable
                  as Map<WasteCategory, PeripheralStatus>,
        wastePresenceDetected: null == wastePresenceDetected
            ? _value.wastePresenceDetected
            : wastePresenceDetected // ignore: cast_nullable_to_non_nullable
                  as bool,
        binFillLevels: null == binFillLevels
            ? _value._binFillLevels
            : binFillLevels // ignore: cast_nullable_to_non_nullable
                  as Map<WasteCategory, double>,
        lastUpdatedAt: null == lastUpdatedAt
            ? _value.lastUpdatedAt
            : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareStatusImpl extends _HardwareStatus {
  const _$HardwareStatusImpl({
    this.overallStatus = HealthStatus.online,
    this.controllerConnected = true,
    this.cameraAvailable = true,
    this.cardReaderAvailable = true,
    final Map<WasteCategory, FeedbackColour> slotLedStatuses = const {},
    final Map<WasteCategory, PeripheralStatus> slotStatuses = const {},
    this.wastePresenceDetected = false,
    final Map<WasteCategory, double> binFillLevels = const {},
    required this.lastUpdatedAt,
  }) : _slotLedStatuses = slotLedStatuses,
       _slotStatuses = slotStatuses,
       _binFillLevels = binFillLevels,
       super._();

  factory _$HardwareStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareStatusImplFromJson(json);

  @override
  @JsonKey()
  final HealthStatus overallStatus;
  @override
  @JsonKey()
  final bool controllerConnected;
  @override
  @JsonKey()
  final bool cameraAvailable;
  @override
  @JsonKey()
  final bool cardReaderAvailable;
  final Map<WasteCategory, FeedbackColour> _slotLedStatuses;
  @override
  @JsonKey()
  Map<WasteCategory, FeedbackColour> get slotLedStatuses {
    if (_slotLedStatuses is EqualUnmodifiableMapView) return _slotLedStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_slotLedStatuses);
  }

  final Map<WasteCategory, PeripheralStatus> _slotStatuses;
  @override
  @JsonKey()
  Map<WasteCategory, PeripheralStatus> get slotStatuses {
    if (_slotStatuses is EqualUnmodifiableMapView) return _slotStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_slotStatuses);
  }

  @override
  @JsonKey()
  final bool wastePresenceDetected;
  final Map<WasteCategory, double> _binFillLevels;
  @override
  @JsonKey()
  Map<WasteCategory, double> get binFillLevels {
    if (_binFillLevels is EqualUnmodifiableMapView) return _binFillLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_binFillLevels);
  }

  // 0..1 per slot
  @override
  final DateTime lastUpdatedAt;

  @override
  String toString() {
    return 'HardwareStatus(overallStatus: $overallStatus, controllerConnected: $controllerConnected, cameraAvailable: $cameraAvailable, cardReaderAvailable: $cardReaderAvailable, slotLedStatuses: $slotLedStatuses, slotStatuses: $slotStatuses, wastePresenceDetected: $wastePresenceDetected, binFillLevels: $binFillLevels, lastUpdatedAt: $lastUpdatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareStatusImpl &&
            (identical(other.overallStatus, overallStatus) ||
                other.overallStatus == overallStatus) &&
            (identical(other.controllerConnected, controllerConnected) ||
                other.controllerConnected == controllerConnected) &&
            (identical(other.cameraAvailable, cameraAvailable) ||
                other.cameraAvailable == cameraAvailable) &&
            (identical(other.cardReaderAvailable, cardReaderAvailable) ||
                other.cardReaderAvailable == cardReaderAvailable) &&
            const DeepCollectionEquality().equals(
              other._slotLedStatuses,
              _slotLedStatuses,
            ) &&
            const DeepCollectionEquality().equals(
              other._slotStatuses,
              _slotStatuses,
            ) &&
            (identical(other.wastePresenceDetected, wastePresenceDetected) ||
                other.wastePresenceDetected == wastePresenceDetected) &&
            const DeepCollectionEquality().equals(
              other._binFillLevels,
              _binFillLevels,
            ) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    overallStatus,
    controllerConnected,
    cameraAvailable,
    cardReaderAvailable,
    const DeepCollectionEquality().hash(_slotLedStatuses),
    const DeepCollectionEquality().hash(_slotStatuses),
    wastePresenceDetected,
    const DeepCollectionEquality().hash(_binFillLevels),
    lastUpdatedAt,
  );

  /// Create a copy of HardwareStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareStatusImplCopyWith<_$HardwareStatusImpl> get copyWith =>
      __$$HardwareStatusImplCopyWithImpl<_$HardwareStatusImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareStatusImplToJson(this);
  }
}

abstract class _HardwareStatus extends HardwareStatus {
  const factory _HardwareStatus({
    final HealthStatus overallStatus,
    final bool controllerConnected,
    final bool cameraAvailable,
    final bool cardReaderAvailable,
    final Map<WasteCategory, FeedbackColour> slotLedStatuses,
    final Map<WasteCategory, PeripheralStatus> slotStatuses,
    final bool wastePresenceDetected,
    final Map<WasteCategory, double> binFillLevels,
    required final DateTime lastUpdatedAt,
  }) = _$HardwareStatusImpl;
  const _HardwareStatus._() : super._();

  factory _HardwareStatus.fromJson(Map<String, dynamic> json) =
      _$HardwareStatusImpl.fromJson;

  @override
  HealthStatus get overallStatus;
  @override
  bool get controllerConnected;
  @override
  bool get cameraAvailable;
  @override
  bool get cardReaderAvailable;
  @override
  Map<WasteCategory, FeedbackColour> get slotLedStatuses;
  @override
  Map<WasteCategory, PeripheralStatus> get slotStatuses;
  @override
  bool get wastePresenceDetected;
  @override
  Map<WasteCategory, double> get binFillLevels; // 0..1 per slot
  @override
  DateTime get lastUpdatedAt;

  /// Create a copy of HardwareStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwareStatusImplCopyWith<_$HardwareStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
