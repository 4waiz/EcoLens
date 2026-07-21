/// Assorted domain enums used across models and services.
///
/// Kept in one file (they are small and closely related) so imports stay tidy.
library;

/// LED feedback colour sent to the bin controller for a slot.
enum FeedbackColour { off, green, red, houseColour, amber }

/// Lifecycle status of a student account.
enum AccountStatus {
  active,
  suspended,
  archived;

  String get label => switch (this) {
    AccountStatus.active => 'Active',
    AccountStatus.suspended => 'Suspended',
    AccountStatus.archived => 'Archived',
  };
}

/// Health rollup used by hardware / kiosk / controller status objects.
enum HealthStatus {
  online,
  degraded,
  offline,
  maintenance,
  unknown;

  String get label => switch (this) {
    HealthStatus.online => 'Online',
    HealthStatus.degraded => 'Degraded',
    HealthStatus.offline => 'Offline',
    HealthStatus.maintenance => 'Maintenance',
    HealthStatus.unknown => 'Unknown',
  };

  bool get isHealthy => this == HealthStatus.online;
}

/// Status of a single peripheral (camera, NFC reader, sensor, controller link).
enum PeripheralStatus {
  ok,
  warning,
  error,
  disconnected;

  String get label => switch (this) {
    PeripheralStatus.ok => 'OK',
    PeripheralStatus.warning => 'Warning',
    PeripheralStatus.error => 'Error',
    PeripheralStatus.disconnected => 'Disconnected',
  };
}

/// Result of dispatching an open-slot command to the (existing) bin controller.
enum HardwareCommandStatus {
  pending,
  sent,
  acknowledged,
  failed,
  skippedOffline;

  String get label => switch (this) {
    HardwareCommandStatus.pending => 'Pending',
    HardwareCommandStatus.sent => 'Sent',
    HardwareCommandStatus.acknowledged => 'Acknowledged',
    HardwareCommandStatus.failed => 'Failed',
    HardwareCommandStatus.skippedOffline => 'Queued (offline)',
  };
}

/// Lifecycle of a recycling session record.
enum SessionStatus {
  active,
  completed,
  abandoned,
  timedOut,
  queuedOffline,
  synced;

  String get label => switch (this) {
    SessionStatus.active => 'Active',
    SessionStatus.completed => 'Completed',
    SessionStatus.abandoned => 'Abandoned',
    SessionStatus.timedOut => 'Timed out',
    SessionStatus.queuedOffline => 'Queued (offline)',
    SessionStatus.synced => 'Synced',
  };
}

/// Reward transaction category.
enum RewardTransactionType {
  redemption,
  earn,
  bonus,
  raffleEntry,
  reversal;

  String get label => switch (this) {
    RewardTransactionType.redemption => 'Redemption',
    RewardTransactionType.earn => 'Earned',
    RewardTransactionType.bonus => 'Bonus',
    RewardTransactionType.raffleEntry => 'Raffle entry',
    RewardTransactionType.reversal => 'Reversal',
  };
}

/// State of a reward transaction.
enum RewardTransactionStatus {
  pending,
  approved,
  completed,
  cancelled,
  failed;

  String get label => switch (this) {
    RewardTransactionStatus.pending => 'Pending',
    RewardTransactionStatus.approved => 'Approved',
    RewardTransactionStatus.completed => 'Completed',
    RewardTransactionStatus.cancelled => 'Cancelled',
    RewardTransactionStatus.failed => 'Failed',
  };
}

/// Category of a redeemable reward item.
enum RewardCategory {
  snack,
  stationery,
  housePrivilege,
  raffleEntry,
  avatarAccessory,
  badge;

  String get label => switch (this) {
    RewardCategory.snack => 'Healthy Snack',
    RewardCategory.stationery => 'Stationery',
    RewardCategory.housePrivilege => 'House Privilege',
    RewardCategory.raffleEntry => 'Raffle Entry',
    RewardCategory.avatarAccessory => 'Avatar Accessory',
    RewardCategory.badge => 'Achievement Badge',
  };
}

/// Stock availability of a reward item.
enum StockStatus {
  inStock,
  lowStock,
  outOfStock;

  String get label => switch (this) {
    StockStatus.inStock => 'In stock',
    StockStatus.lowStock => 'Low stock',
    StockStatus.outOfStock => 'Out of stock',
  };

  bool get isAvailable => this != StockStatus.outOfStock;
}

/// Leaderboard entity type.
enum LeaderboardEntityType {
  student,
  house,
  className;

  String get label => switch (this) {
    LeaderboardEntityType.student => 'Student',
    LeaderboardEntityType.house => 'House',
    LeaderboardEntityType.className => 'Class',
  };
}

/// Application role used for route guards and login screens.
enum UserRole {
  student,
  teacher,
  admin,
  canteenStaff;

  String get label => switch (this) {
    UserRole.student => 'Student',
    UserRole.teacher => 'Teacher',
    UserRole.admin => 'Administrator',
    UserRole.canteenStaff => 'Canteen Staff',
  };
}

/// Confidence-condition detected by the AI classifier (drives contamination
/// messaging on the quiz + result screens).
enum ItemCondition {
  clean,
  contaminated,
  wet,
  unknown;

  String get label => switch (this) {
    ItemCondition.clean => 'Clean',
    ItemCondition.contaminated => 'Contaminated',
    ItemCondition.wet => 'Wet / soiled',
    ItemCondition.unknown => 'Unclear',
  };
}

/// Runtime environment / flavour.
enum AppEnvironment {
  mock,
  demo,
  development,
  production;

  String get label => switch (this) {
    AppEnvironment.mock => 'Mock',
    AppEnvironment.demo => 'Demo',
    AppEnvironment.development => 'Development',
    AppEnvironment.production => 'Production',
  };

  /// Whether mock services should back the app (everything except production).
  bool get usesMockServices => this != AppEnvironment.production;
}
