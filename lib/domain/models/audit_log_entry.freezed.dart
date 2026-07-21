// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuditLogEntry _$AuditLogEntryFromJson(Map<String, dynamic> json) {
  return _AuditLogEntry.fromJson(json);
}

/// @nodoc
mixin _$AuditLogEntry {
  String get id => throw _privateConstructorUsedError;
  String get actorId => throw _privateConstructorUsedError;
  String get actorName => throw _privateConstructorUsedError;
  String get action =>
      throw _privateConstructorUsedError; // e.g. "Updated AI confidence threshold"
  String get target =>
      throw _privateConstructorUsedError; // e.g. "GamificationConfig"
  String get detail => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this AuditLogEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogEntryCopyWith<AuditLogEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogEntryCopyWith<$Res> {
  factory $AuditLogEntryCopyWith(
    AuditLogEntry value,
    $Res Function(AuditLogEntry) then,
  ) = _$AuditLogEntryCopyWithImpl<$Res, AuditLogEntry>;
  @useResult
  $Res call({
    String id,
    String actorId,
    String actorName,
    String action,
    String target,
    String detail,
    DateTime timestamp,
  });
}

/// @nodoc
class _$AuditLogEntryCopyWithImpl<$Res, $Val extends AuditLogEntry>
    implements $AuditLogEntryCopyWith<$Res> {
  _$AuditLogEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorId = null,
    Object? actorName = null,
    Object? action = null,
    Object? target = null,
    Object? detail = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            actorId: null == actorId
                ? _value.actorId
                : actorId // ignore: cast_nullable_to_non_nullable
                      as String,
            actorName: null == actorName
                ? _value.actorName
                : actorName // ignore: cast_nullable_to_non_nullable
                      as String,
            action: null == action
                ? _value.action
                : action // ignore: cast_nullable_to_non_nullable
                      as String,
            target: null == target
                ? _value.target
                : target // ignore: cast_nullable_to_non_nullable
                      as String,
            detail: null == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuditLogEntryImplCopyWith<$Res>
    implements $AuditLogEntryCopyWith<$Res> {
  factory _$$AuditLogEntryImplCopyWith(
    _$AuditLogEntryImpl value,
    $Res Function(_$AuditLogEntryImpl) then,
  ) = __$$AuditLogEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String actorId,
    String actorName,
    String action,
    String target,
    String detail,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$AuditLogEntryImplCopyWithImpl<$Res>
    extends _$AuditLogEntryCopyWithImpl<$Res, _$AuditLogEntryImpl>
    implements _$$AuditLogEntryImplCopyWith<$Res> {
  __$$AuditLogEntryImplCopyWithImpl(
    _$AuditLogEntryImpl _value,
    $Res Function(_$AuditLogEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuditLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? actorId = null,
    Object? actorName = null,
    Object? action = null,
    Object? target = null,
    Object? detail = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$AuditLogEntryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        actorId: null == actorId
            ? _value.actorId
            : actorId // ignore: cast_nullable_to_non_nullable
                  as String,
        actorName: null == actorName
            ? _value.actorName
            : actorName // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _value.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        target: null == target
            ? _value.target
            : target // ignore: cast_nullable_to_non_nullable
                  as String,
        detail: null == detail
            ? _value.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogEntryImpl extends _AuditLogEntry {
  const _$AuditLogEntryImpl({
    required this.id,
    required this.actorId,
    required this.actorName,
    required this.action,
    required this.target,
    this.detail = '',
    required this.timestamp,
  }) : super._();

  factory _$AuditLogEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogEntryImplFromJson(json);

  @override
  final String id;
  @override
  final String actorId;
  @override
  final String actorName;
  @override
  final String action;
  // e.g. "Updated AI confidence threshold"
  @override
  final String target;
  // e.g. "GamificationConfig"
  @override
  @JsonKey()
  final String detail;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'AuditLogEntry(id: $id, actorId: $actorId, actorName: $actorName, action: $action, target: $target, detail: $detail, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.actorName, actorName) ||
                other.actorName == actorName) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.target, target) || other.target == target) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    actorId,
    actorName,
    action,
    target,
    detail,
    timestamp,
  );

  /// Create a copy of AuditLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      __$$AuditLogEntryImplCopyWithImpl<_$AuditLogEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogEntryImplToJson(this);
  }
}

abstract class _AuditLogEntry extends AuditLogEntry {
  const factory _AuditLogEntry({
    required final String id,
    required final String actorId,
    required final String actorName,
    required final String action,
    required final String target,
    final String detail,
    required final DateTime timestamp,
  }) = _$AuditLogEntryImpl;
  const _AuditLogEntry._() : super._();

  factory _AuditLogEntry.fromJson(Map<String, dynamic> json) =
      _$AuditLogEntryImpl.fromJson;

  @override
  String get id;
  @override
  String get actorId;
  @override
  String get actorName;
  @override
  String get action; // e.g. "Updated AI confidence threshold"
  @override
  String get target; // e.g. "GamificationConfig"
  @override
  String get detail;
  @override
  DateTime get timestamp;

  /// Create a copy of AuditLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogEntryImplCopyWith<_$AuditLogEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
