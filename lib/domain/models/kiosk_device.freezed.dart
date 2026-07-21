// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kiosk_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KioskDevice _$KioskDeviceFromJson(Map<String, dynamic> json) {
  return _KioskDevice.fromJson(json);
}

/// @nodoc
mixin _$KioskDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get schoolLocation => throw _privateConstructorUsedError;
  PeripheralStatus get controllerStatus => throw _privateConstructorUsedError;
  PeripheralStatus get cameraStatus => throw _privateConstructorUsedError;
  PeripheralStatus get nfcStatus => throw _privateConstructorUsedError;
  PeripheralStatus get sensorStatus => throw _privateConstructorUsedError;
  PeripheralStatus get internetStatus => throw _privateConstructorUsedError;
  DateTime get lastHeartbeat => throw _privateConstructorUsedError;
  String get softwareVersion => throw _privateConstructorUsedError;
  bool get maintenanceMode => throw _privateConstructorUsedError;
  int get sessionsToday => throw _privateConstructorUsedError;

  /// Serializes this KioskDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KioskDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KioskDeviceCopyWith<KioskDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KioskDeviceCopyWith<$Res> {
  factory $KioskDeviceCopyWith(
    KioskDevice value,
    $Res Function(KioskDevice) then,
  ) = _$KioskDeviceCopyWithImpl<$Res, KioskDevice>;
  @useResult
  $Res call({
    String id,
    String name,
    String schoolLocation,
    PeripheralStatus controllerStatus,
    PeripheralStatus cameraStatus,
    PeripheralStatus nfcStatus,
    PeripheralStatus sensorStatus,
    PeripheralStatus internetStatus,
    DateTime lastHeartbeat,
    String softwareVersion,
    bool maintenanceMode,
    int sessionsToday,
  });
}

/// @nodoc
class _$KioskDeviceCopyWithImpl<$Res, $Val extends KioskDevice>
    implements $KioskDeviceCopyWith<$Res> {
  _$KioskDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KioskDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? schoolLocation = null,
    Object? controllerStatus = null,
    Object? cameraStatus = null,
    Object? nfcStatus = null,
    Object? sensorStatus = null,
    Object? internetStatus = null,
    Object? lastHeartbeat = null,
    Object? softwareVersion = null,
    Object? maintenanceMode = null,
    Object? sessionsToday = null,
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
            schoolLocation: null == schoolLocation
                ? _value.schoolLocation
                : schoolLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            controllerStatus: null == controllerStatus
                ? _value.controllerStatus
                : controllerStatus // ignore: cast_nullable_to_non_nullable
                      as PeripheralStatus,
            cameraStatus: null == cameraStatus
                ? _value.cameraStatus
                : cameraStatus // ignore: cast_nullable_to_non_nullable
                      as PeripheralStatus,
            nfcStatus: null == nfcStatus
                ? _value.nfcStatus
                : nfcStatus // ignore: cast_nullable_to_non_nullable
                      as PeripheralStatus,
            sensorStatus: null == sensorStatus
                ? _value.sensorStatus
                : sensorStatus // ignore: cast_nullable_to_non_nullable
                      as PeripheralStatus,
            internetStatus: null == internetStatus
                ? _value.internetStatus
                : internetStatus // ignore: cast_nullable_to_non_nullable
                      as PeripheralStatus,
            lastHeartbeat: null == lastHeartbeat
                ? _value.lastHeartbeat
                : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            softwareVersion: null == softwareVersion
                ? _value.softwareVersion
                : softwareVersion // ignore: cast_nullable_to_non_nullable
                      as String,
            maintenanceMode: null == maintenanceMode
                ? _value.maintenanceMode
                : maintenanceMode // ignore: cast_nullable_to_non_nullable
                      as bool,
            sessionsToday: null == sessionsToday
                ? _value.sessionsToday
                : sessionsToday // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KioskDeviceImplCopyWith<$Res>
    implements $KioskDeviceCopyWith<$Res> {
  factory _$$KioskDeviceImplCopyWith(
    _$KioskDeviceImpl value,
    $Res Function(_$KioskDeviceImpl) then,
  ) = __$$KioskDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String schoolLocation,
    PeripheralStatus controllerStatus,
    PeripheralStatus cameraStatus,
    PeripheralStatus nfcStatus,
    PeripheralStatus sensorStatus,
    PeripheralStatus internetStatus,
    DateTime lastHeartbeat,
    String softwareVersion,
    bool maintenanceMode,
    int sessionsToday,
  });
}

/// @nodoc
class __$$KioskDeviceImplCopyWithImpl<$Res>
    extends _$KioskDeviceCopyWithImpl<$Res, _$KioskDeviceImpl>
    implements _$$KioskDeviceImplCopyWith<$Res> {
  __$$KioskDeviceImplCopyWithImpl(
    _$KioskDeviceImpl _value,
    $Res Function(_$KioskDeviceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KioskDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? schoolLocation = null,
    Object? controllerStatus = null,
    Object? cameraStatus = null,
    Object? nfcStatus = null,
    Object? sensorStatus = null,
    Object? internetStatus = null,
    Object? lastHeartbeat = null,
    Object? softwareVersion = null,
    Object? maintenanceMode = null,
    Object? sessionsToday = null,
  }) {
    return _then(
      _$KioskDeviceImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        schoolLocation: null == schoolLocation
            ? _value.schoolLocation
            : schoolLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        controllerStatus: null == controllerStatus
            ? _value.controllerStatus
            : controllerStatus // ignore: cast_nullable_to_non_nullable
                  as PeripheralStatus,
        cameraStatus: null == cameraStatus
            ? _value.cameraStatus
            : cameraStatus // ignore: cast_nullable_to_non_nullable
                  as PeripheralStatus,
        nfcStatus: null == nfcStatus
            ? _value.nfcStatus
            : nfcStatus // ignore: cast_nullable_to_non_nullable
                  as PeripheralStatus,
        sensorStatus: null == sensorStatus
            ? _value.sensorStatus
            : sensorStatus // ignore: cast_nullable_to_non_nullable
                  as PeripheralStatus,
        internetStatus: null == internetStatus
            ? _value.internetStatus
            : internetStatus // ignore: cast_nullable_to_non_nullable
                  as PeripheralStatus,
        lastHeartbeat: null == lastHeartbeat
            ? _value.lastHeartbeat
            : lastHeartbeat // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        softwareVersion: null == softwareVersion
            ? _value.softwareVersion
            : softwareVersion // ignore: cast_nullable_to_non_nullable
                  as String,
        maintenanceMode: null == maintenanceMode
            ? _value.maintenanceMode
            : maintenanceMode // ignore: cast_nullable_to_non_nullable
                  as bool,
        sessionsToday: null == sessionsToday
            ? _value.sessionsToday
            : sessionsToday // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KioskDeviceImpl extends _KioskDevice {
  const _$KioskDeviceImpl({
    required this.id,
    required this.name,
    required this.schoolLocation,
    this.controllerStatus = PeripheralStatus.ok,
    this.cameraStatus = PeripheralStatus.ok,
    this.nfcStatus = PeripheralStatus.ok,
    this.sensorStatus = PeripheralStatus.ok,
    this.internetStatus = PeripheralStatus.ok,
    required this.lastHeartbeat,
    this.softwareVersion = '1.0.0',
    this.maintenanceMode = false,
    this.sessionsToday = 0,
  }) : super._();

  factory _$KioskDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$KioskDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String schoolLocation;
  @override
  @JsonKey()
  final PeripheralStatus controllerStatus;
  @override
  @JsonKey()
  final PeripheralStatus cameraStatus;
  @override
  @JsonKey()
  final PeripheralStatus nfcStatus;
  @override
  @JsonKey()
  final PeripheralStatus sensorStatus;
  @override
  @JsonKey()
  final PeripheralStatus internetStatus;
  @override
  final DateTime lastHeartbeat;
  @override
  @JsonKey()
  final String softwareVersion;
  @override
  @JsonKey()
  final bool maintenanceMode;
  @override
  @JsonKey()
  final int sessionsToday;

  @override
  String toString() {
    return 'KioskDevice(id: $id, name: $name, schoolLocation: $schoolLocation, controllerStatus: $controllerStatus, cameraStatus: $cameraStatus, nfcStatus: $nfcStatus, sensorStatus: $sensorStatus, internetStatus: $internetStatus, lastHeartbeat: $lastHeartbeat, softwareVersion: $softwareVersion, maintenanceMode: $maintenanceMode, sessionsToday: $sessionsToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KioskDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.schoolLocation, schoolLocation) ||
                other.schoolLocation == schoolLocation) &&
            (identical(other.controllerStatus, controllerStatus) ||
                other.controllerStatus == controllerStatus) &&
            (identical(other.cameraStatus, cameraStatus) ||
                other.cameraStatus == cameraStatus) &&
            (identical(other.nfcStatus, nfcStatus) ||
                other.nfcStatus == nfcStatus) &&
            (identical(other.sensorStatus, sensorStatus) ||
                other.sensorStatus == sensorStatus) &&
            (identical(other.internetStatus, internetStatus) ||
                other.internetStatus == internetStatus) &&
            (identical(other.lastHeartbeat, lastHeartbeat) ||
                other.lastHeartbeat == lastHeartbeat) &&
            (identical(other.softwareVersion, softwareVersion) ||
                other.softwareVersion == softwareVersion) &&
            (identical(other.maintenanceMode, maintenanceMode) ||
                other.maintenanceMode == maintenanceMode) &&
            (identical(other.sessionsToday, sessionsToday) ||
                other.sessionsToday == sessionsToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    schoolLocation,
    controllerStatus,
    cameraStatus,
    nfcStatus,
    sensorStatus,
    internetStatus,
    lastHeartbeat,
    softwareVersion,
    maintenanceMode,
    sessionsToday,
  );

  /// Create a copy of KioskDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KioskDeviceImplCopyWith<_$KioskDeviceImpl> get copyWith =>
      __$$KioskDeviceImplCopyWithImpl<_$KioskDeviceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KioskDeviceImplToJson(this);
  }
}

abstract class _KioskDevice extends KioskDevice {
  const factory _KioskDevice({
    required final String id,
    required final String name,
    required final String schoolLocation,
    final PeripheralStatus controllerStatus,
    final PeripheralStatus cameraStatus,
    final PeripheralStatus nfcStatus,
    final PeripheralStatus sensorStatus,
    final PeripheralStatus internetStatus,
    required final DateTime lastHeartbeat,
    final String softwareVersion,
    final bool maintenanceMode,
    final int sessionsToday,
  }) = _$KioskDeviceImpl;
  const _KioskDevice._() : super._();

  factory _KioskDevice.fromJson(Map<String, dynamic> json) =
      _$KioskDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get schoolLocation;
  @override
  PeripheralStatus get controllerStatus;
  @override
  PeripheralStatus get cameraStatus;
  @override
  PeripheralStatus get nfcStatus;
  @override
  PeripheralStatus get sensorStatus;
  @override
  PeripheralStatus get internetStatus;
  @override
  DateTime get lastHeartbeat;
  @override
  String get softwareVersion;
  @override
  bool get maintenanceMode;
  @override
  int get sessionsToday;

  /// Create a copy of KioskDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KioskDeviceImplCopyWith<_$KioskDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
