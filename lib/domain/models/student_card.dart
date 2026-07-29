import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_card.freezed.dart';
part 'student_card.g.dart';

/// Physical Student ID card mapping. The card UID (read by the NFC/RFID reader
/// on the kiosk or the canteen terminal) resolves to a student account.
@freezed
class StudentCard with _$StudentCard {
  const StudentCard._();

  const factory StudentCard({
    required String cardUid,
    required String studentId,
    required DateTime issuedAt,
    DateTime? expiresAt,
    @Default(true) bool isActive,
  }) = _StudentCard;

  factory StudentCard.fromJson(Map<String, dynamic> json) =>
      _$StudentCardFromJson(json);

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  bool get isUsable => isActive && !isExpired;

  /// Masked UID for admin/audit display; never show full UID on shared screens.
  String get maskedUid {
    if (cardUid.length <= 4) return '•••• $cardUid';
    return '•••• ${cardUid.substring(cardUid.length - 4)}';
  }
}
