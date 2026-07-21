import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'leaderboard_entry.freezed.dart';
part 'leaderboard_entry.g.dart';

/// A row in a leaderboard (student, class, or house).
@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const LeaderboardEntry._();

  const factory LeaderboardEntry({
    required String entityId,
    required String entityName,
    required LeaderboardEntityType entityType,
    required int rank,
    required int totalPoints,
    @Default(0) int weeklyChange, // positions gained (+) / lost (-) this week
    @Default('#2E7D46') String houseColour,
    @Default('') String subtitle, // e.g. "Green Pioneer" or "Class 4B"
    @Default(false) bool isCurrentEntity,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}
