// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentCardImpl _$$StudentCardImplFromJson(Map<String, dynamic> json) =>
    _$StudentCardImpl(
      cardUid: json['cardUid'] as String,
      studentId: json['studentId'] as String,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$StudentCardImplToJson(_$StudentCardImpl instance) =>
    <String, dynamic>{
      'cardUid': instance.cardUid,
      'studentId': instance.studentId,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'isActive': instance.isActive,
    };
