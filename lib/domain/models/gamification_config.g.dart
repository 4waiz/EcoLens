// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GamificationConfigImpl _$$GamificationConfigImplFromJson(
  Map<String, dynamic> json,
) => _$GamificationConfigImpl(
  pointsPerCorrect: (json['pointsPerCorrect'] as num?)?.toInt() ?? 5,
  pointsPerIncorrect: (json['pointsPerIncorrect'] as num?)?.toInt() ?? 0,
  dailyPointsCap: (json['dailyPointsCap'] as num?)?.toInt() ?? 50,
  xpPerCorrect: (json['xpPerCorrect'] as num?)?.toInt() ?? 5,
  bonusStreakThreshold: (json['bonusStreakThreshold'] as num?)?.toInt() ?? 20,
  bonusPoints: (json['bonusPoints'] as num?)?.toInt() ?? 25,
  weekendsCountAsActive: json['weekendsCountAsActive'] as bool? ?? true,
  holidaysCountAsActive: json['holidaysCountAsActive'] as bool? ?? true,
  streakGraceDays: (json['streakGraceDays'] as num?)?.toInt() ?? 1,
  monetaryConversionEnabled: json['monetaryConversionEnabled'] as bool? ?? true,
  pointsPerCurrencyUnit: (json['pointsPerCurrencyUnit'] as num?)?.toInt() ?? 50,
  currencyCode: json['currencyCode'] as String? ?? 'AED',
  aiConfidenceThreshold:
      (json['aiConfidenceThreshold'] as num?)?.toDouble() ?? 0.80,
  inactivityTimeoutSeconds:
      (json['inactivityTimeoutSeconds'] as num?)?.toInt() ?? 45,
  imageRetentionSeconds: (json['imageRetentionSeconds'] as num?)?.toInt() ?? 0,
  autoLogoutCountdownSeconds:
      (json['autoLogoutCountdownSeconds'] as num?)?.toInt() ?? 8,
);

Map<String, dynamic> _$$GamificationConfigImplToJson(
  _$GamificationConfigImpl instance,
) => <String, dynamic>{
  'pointsPerCorrect': instance.pointsPerCorrect,
  'pointsPerIncorrect': instance.pointsPerIncorrect,
  'dailyPointsCap': instance.dailyPointsCap,
  'xpPerCorrect': instance.xpPerCorrect,
  'bonusStreakThreshold': instance.bonusStreakThreshold,
  'bonusPoints': instance.bonusPoints,
  'weekendsCountAsActive': instance.weekendsCountAsActive,
  'holidaysCountAsActive': instance.holidaysCountAsActive,
  'streakGraceDays': instance.streakGraceDays,
  'monetaryConversionEnabled': instance.monetaryConversionEnabled,
  'pointsPerCurrencyUnit': instance.pointsPerCurrencyUnit,
  'currencyCode': instance.currencyCode,
  'aiConfidenceThreshold': instance.aiConfidenceThreshold,
  'inactivityTimeoutSeconds': instance.inactivityTimeoutSeconds,
  'imageRetentionSeconds': instance.imageRetentionSeconds,
  'autoLogoutCountdownSeconds': instance.autoLogoutCountdownSeconds,
};
