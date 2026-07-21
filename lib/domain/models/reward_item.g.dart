// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RewardItemImpl _$$RewardItemImplFromJson(Map<String, dynamic> json) =>
    _$RewardItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pointCost: (json['pointCost'] as num).toInt(),
      category: $enumDecode(_$RewardCategoryEnumMap, json['category']),
      imagePath: json['imagePath'] as String? ?? '',
      stockStatus:
          $enumDecodeNullable(_$StockStatusEnumMap, json['stockStatus']) ??
          StockStatus.inStock,
      requiresStaffApproval: json['requiresStaffApproval'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      dailyRedemptionLimit:
          (json['dailyRedemptionLimit'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RewardItemImplToJson(_$RewardItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'pointCost': instance.pointCost,
      'category': _$RewardCategoryEnumMap[instance.category]!,
      'imagePath': instance.imagePath,
      'stockStatus': _$StockStatusEnumMap[instance.stockStatus]!,
      'requiresStaffApproval': instance.requiresStaffApproval,
      'isActive': instance.isActive,
      'dailyRedemptionLimit': instance.dailyRedemptionLimit,
    };

const _$RewardCategoryEnumMap = {
  RewardCategory.snack: 'snack',
  RewardCategory.stationery: 'stationery',
  RewardCategory.housePrivilege: 'housePrivilege',
  RewardCategory.raffleEntry: 'raffleEntry',
  RewardCategory.avatarAccessory: 'avatarAccessory',
  RewardCategory.badge: 'badge',
};

const _$StockStatusEnumMap = {
  StockStatus.inStock: 'inStock',
  StockStatus.lowStock: 'lowStock',
  StockStatus.outOfStock: 'outOfStock',
};
