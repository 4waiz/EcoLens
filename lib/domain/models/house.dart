import 'package:freezed_annotation/freezed_annotation.dart';

part 'house.freezed.dart';
part 'house.g.dart';

/// A PE house (e.g. Aries, Taurus, Leo, Aquarius). Students belong to a house
/// and their correct recycles contribute to the collective house progress that
/// drives the leaderboard and the weekly winning-house privilege.
@freezed
class House with _$House {
  const House._();

  const factory House({
    required String id,
    required String name,
    required String colour, // hex string, e.g. "#E0A400"
    required String emblem, // symbolic emblem key (see HouseEmblem)
    @Default(0) int totalPoints,
    @Default(0) int weeklyPoints,
    required String sustainabilityGoal,
    @Default(0.0) double goalProgress, // 0..1 toward the sustainability goal
    @Default(0) int leaderboardPosition,
    @Default(0) int memberCount,
  }) = _House;

  factory House.fromJson(Map<String, dynamic> json) => _$HouseFromJson(json);
}
