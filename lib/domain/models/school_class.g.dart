// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_class.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchoolClassImpl _$$SchoolClassImplFromJson(Map<String, dynamic> json) =>
    _$SchoolClassImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: (json['grade'] as num).toInt(),
      teacherId: json['teacherId'] as String? ?? '',
      studentCount: (json['studentCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SchoolClassImplToJson(_$SchoolClassImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade': instance.grade,
      'teacherId': instance.teacherId,
      'studentCount': instance.studentCount,
    };
