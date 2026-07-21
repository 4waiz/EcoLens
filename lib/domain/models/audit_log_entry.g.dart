// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogEntryImpl _$$AuditLogEntryImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogEntryImpl(
      id: json['id'] as String,
      actorId: json['actorId'] as String,
      actorName: json['actorName'] as String,
      action: json['action'] as String,
      target: json['target'] as String,
      detail: json['detail'] as String? ?? '',
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$AuditLogEntryImplToJson(_$AuditLogEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'actorId': instance.actorId,
      'actorName': instance.actorName,
      'action': instance.action,
      'target': instance.target,
      'detail': instance.detail,
      'timestamp': instance.timestamp.toIso8601String(),
    };
