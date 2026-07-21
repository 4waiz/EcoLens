import 'package:freezed_annotation/freezed_annotation.dart';

part 'school_class.freezed.dart';
part 'school_class.g.dart';

/// A class/form group (e.g. "4B"). Used for filtering and class leaderboards.
@freezed
class SchoolClass with _$SchoolClass {
  const SchoolClass._();

  const factory SchoolClass({
    required String id,
    required String name, // e.g. "4B"
    required int grade,
    @Default('') String teacherId,
    @Default(0) int studentCount,
  }) = _SchoolClass;

  factory SchoolClass.fromJson(Map<String, dynamic> json) =>
      _$SchoolClassFromJson(json);
}
