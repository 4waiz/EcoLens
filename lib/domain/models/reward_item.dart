import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/app_enums.dart';

part 'reward_item.freezed.dart';
part 'reward_item.g.dart';

/// A catalogue item a student can redeem points for. Supports non-monetary
/// rewards (snack voucher, stationery, house privilege, raffle entry, avatar
/// accessory, achievement badge) so schools can disable AED conversion.
@freezed
class RewardItem with _$RewardItem {
  const RewardItem._();

  const factory RewardItem({
    required String id,
    required String name,
    required String description,
    required int pointCost,
    required RewardCategory category,
    @Default('') String imagePath, // procedural icon key
    @Default(StockStatus.inStock) StockStatus stockStatus,
    @Default(false) bool requiresStaffApproval,
    @Default(true) bool isActive,
    @Default(0) int dailyRedemptionLimit, // 0 = unlimited
  }) = _RewardItem;

  factory RewardItem.fromJson(Map<String, dynamic> json) =>
      _$RewardItemFromJson(json);

  bool get isRedeemable => isActive && stockStatus.isAvailable;
}
