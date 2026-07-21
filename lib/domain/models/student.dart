import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'student.freezed.dart';
part 'student.g.dart';

/// A student's EcoLens profile. The account lives in the backend and is loaded
/// onto the shared kiosk after the physical Student ID card is scanned. It is
/// cleared from the kiosk when the session ends (see SessionPrivacyService).
@freezed
class Student with _$Student {
  const Student._();

  const factory Student({
    required String id,
    required String studentNumber,
    required String firstName,
    required String lastName,
    required int grade,
    required String className,
    required String houseId,
    required String avatarId,
    @Default(0) int totalXp,
    @Default(0) int availablePoints,
    @Default(0.0) double rewardBalance,
    @Default(0) int currentStreak,
    @Default(0) int longestStreak,
    @Default(0) int correctRecyclingCount,
    @Default(0) int incorrectRecyclingCount,
    @Default(0) int dailyEarnedPoints,
    DateTime? lastActiveAt,
    @Default(AccountStatus.active) AccountStatus accountStatus,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  String get fullName => '$firstName $lastName';

  int get totalRecyclingCount =>
      correctRecyclingCount + incorrectRecyclingCount;

  /// Correct-classification accuracy in the range 0..1.
  double get accuracy => totalRecyclingCount == 0
      ? 0
      : correctRecyclingCount / totalRecyclingCount;

  /// Masked identifier for on-screen display. Never expose the full number on
  /// the shared kiosk. e.g. "STU-2024-0007" -> "•••• 0007".
  String get maskedStudentNumber {
    final digits = studentNumber.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    if (digits.length <= 4) return '•••• $digits';
    return '•••• ${digits.substring(digits.length - 4)}';
  }
}
