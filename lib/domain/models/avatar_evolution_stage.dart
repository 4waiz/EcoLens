import 'package:freezed_annotation/freezed_annotation.dart';

part 'avatar_evolution_stage.freezed.dart';
part 'avatar_evolution_stage.g.dart';

/// A single rung of the Guardian evolution ladder. The ladder is data-driven so
/// admins can retune thresholds/copy without touching the rendering code.
@freezed
class AvatarEvolutionStage with _$AvatarEvolutionStage {
  const AvatarEvolutionStage._();

  const factory AvatarEvolutionStage({
    required String id,
    required String title,
    required int minimumXp,
    required String environmentalMeaning,
    @Default('') String assetPath, // procedural stage key
    @Default(0) int stageIndex,
  }) = _AvatarEvolutionStage;

  factory AvatarEvolutionStage.fromJson(Map<String, dynamic> json) =>
      _$AvatarEvolutionStageFromJson(json);
}
