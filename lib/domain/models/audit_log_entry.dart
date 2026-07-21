import 'package:freezed_annotation/freezed_annotation.dart';

part 'audit_log_entry.freezed.dart';
part 'audit_log_entry.g.dart';

/// An administrator audit event. Configuration changes and card/account
/// operations are recorded here for accountability.
@freezed
class AuditLogEntry with _$AuditLogEntry {
  const AuditLogEntry._();

  const factory AuditLogEntry({
    required String id,
    required String actorId,
    required String actorName,
    required String action, // e.g. "Updated AI confidence threshold"
    required String target, // e.g. "GamificationConfig"
    @Default('') String detail,
    required DateTime timestamp,
  }) = _AuditLogEntry;

  factory AuditLogEntry.fromJson(Map<String, dynamic> json) =>
      _$AuditLogEntryFromJson(json);
}
