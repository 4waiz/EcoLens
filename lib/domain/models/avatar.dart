import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar.freezed.dart';
part 'avatar.g.dart';

/// The student's personal Guardian creature. Its evolution stage visually
/// mirrors the real-world impact of the student's recycling (seedling → sprout
/// → eco guardian → forest protector → thriving ecosystem).
@freezed
class Avatar with _$Avatar {
  const Avatar._();

  const factory Avatar({
    required String id,
    required String name,
    required int stage, // index into the evolution ladder (0-based)
    required int level,
    required int currentXp,
    required int xpRequiredForNextLevel,
    @Default(<String>[]) List<String> unlockedAccessories,
    @Default(<String>[]) List<String> equippedAccessories,
    @Default('') String visualAssetPath, // procedural key; empty = painter
  }) = _Avatar;

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  /// Progress toward the next level in the range 0..1.
  double get levelProgress {
    if (xpRequiredForNextLevel <= 0) return 1;
    return (currentXp / xpRequiredForNextLevel).clamp(0.0, 1.0);
  }
}
