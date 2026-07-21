import '../../core/constants/app_config.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/enums/waste_category.dart';
import '../../domain/models/models.dart';

/// Deterministic in-memory seed data for the full EcoLens demo.
///
/// Everything the mock stack serves originates here. Liam is the primary demo
/// student (Grade 4, Class 4B, Taurus house). A fixed base date keeps the demo
/// reproducible.
abstract final class MockSeedData {
  /// Fixed "now" reference for reproducible relative timestamps.
  static final DateTime baseDate = DateTime(2026, 7, 21, 9, 30);

  // ---------------------------------------------------------------------------
  // Houses (PE houses)
  // ---------------------------------------------------------------------------
  static List<House> houses() => [
    House(
      id: 'house-taurus',
      name: 'Taurus',
      colour: '#2E7D46',
      emblem: 'taurus',
      totalPoints: 4850,
      weeklyPoints: 620,
      sustainabilityGoal: 'Recycle 500 items this term',
      goalProgress: 0.72,
      leaderboardPosition: 2,
      memberCount: 4,
    ),
    House(
      id: 'house-leo',
      name: 'Leo',
      colour: '#E0A400',
      emblem: 'leo',
      totalPoints: 6250,
      weeklyPoints: 810,
      sustainabilityGoal: 'Reach 90% classification accuracy',
      goalProgress: 0.88,
      leaderboardPosition: 1,
      memberCount: 3,
    ),
    House(
      id: 'house-aries',
      name: 'Aries',
      colour: '#B5322E',
      emblem: 'aries',
      totalPoints: 4100,
      weeklyPoints: 540,
      sustainabilityGoal: 'Reduce plastic contamination by 10%',
      goalProgress: 0.61,
      leaderboardPosition: 3,
      memberCount: 3,
    ),
    House(
      id: 'house-aquarius',
      name: 'Aquarius',
      colour: '#2F72C4',
      emblem: 'aquarius',
      totalPoints: 3620,
      weeklyPoints: 470,
      sustainabilityGoal: 'Recycle organic waste 200 times',
      goalProgress: 0.55,
      leaderboardPosition: 4,
      memberCount: 3,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Classes
  // ---------------------------------------------------------------------------
  static List<SchoolClass> classes() => const [
    SchoolClass(id: 'class-4a', name: '4A', grade: 4, teacherId: 'teacher-1', studentCount: 3),
    SchoolClass(id: 'class-4b', name: '4B', grade: 4, teacherId: 'teacher-1', studentCount: 4),
    SchoolClass(id: 'class-5a', name: '5A', grade: 5, teacherId: 'teacher-1', studentCount: 3),
    SchoolClass(id: 'class-5b', name: '5B', grade: 5, teacherId: 'teacher-1', studentCount: 2),
  ];

  // ---------------------------------------------------------------------------
  // Avatar evolution ladder (data-driven; 5 stages)
  // ---------------------------------------------------------------------------
  static List<AvatarEvolutionStage> evolutionLadder() => const [
    AvatarEvolutionStage(
      id: 'stage-seedling',
      title: 'Seedling',
      minimumXp: 0,
      stageIndex: 0,
      assetPath: 'seedling',
      environmentalMeaning:
          'Every forest begins with a single seed. Your recycling journey starts here.',
    ),
    AvatarEvolutionStage(
      id: 'stage-sprout',
      title: 'Sprout',
      minimumXp: 100,
      stageIndex: 1,
      assetPath: 'sprout',
      environmentalMeaning:
          'Your first leaves unfurl. Consistent recycling helps you grow strong.',
    ),
    AvatarEvolutionStage(
      id: 'stage-guardian',
      title: 'Eco Guardian',
      minimumXp: 300,
      stageIndex: 2,
      assetPath: 'guardian',
      environmentalMeaning:
          'You now protect a small patch of nature. Your good habits keep it thriving.',
    ),
    AvatarEvolutionStage(
      id: 'stage-protector',
      title: 'Forest Protector',
      minimumXp: 700,
      stageIndex: 3,
      assetPath: 'protector',
      environmentalMeaning:
          'A grove flourishes under your care — home to birds and butterflies.',
    ),
    AvatarEvolutionStage(
      id: 'stage-ecosystem',
      title: 'Thriving Ecosystem Guardian',
      minimumXp: 1400,
      stageIndex: 4,
      assetPath: 'ecosystem',
      environmentalMeaning:
          'A whole ecosystem thrives because of you — a living mirror of your impact.',
    ),
  ];

  // ---------------------------------------------------------------------------
  // Avatars (one per student)
  // ---------------------------------------------------------------------------
  static List<Avatar> avatars() => const [
    Avatar(id: 'avatar-liam', name: 'Sprout', stage: 1, level: 3, currentXp: 120, xpRequiredForNextLevel: 225, unlockedAccessories: ['leaf-hat'], equippedAccessories: ['leaf-hat']),
    Avatar(id: 'avatar-amara', name: 'Willow', stage: 2, level: 6, currentXp: 340, xpRequiredForNextLevel: 900, unlockedAccessories: ['eco-glasses', 'leaf-hat'], equippedAccessories: ['eco-glasses']),
    Avatar(id: 'avatar-noah', name: 'Fern', stage: 2, level: 5, currentXp: 310, xpRequiredForNextLevel: 625, unlockedAccessories: ['sprout-antenna']),
    Avatar(id: 'avatar-zara', name: 'Blossom', stage: 3, level: 8, currentXp: 720, xpRequiredForNextLevel: 1600, unlockedAccessories: ['flower-crown', 'eco-wings'], equippedAccessories: ['flower-crown']),
    Avatar(id: 'avatar-ethan', name: 'Cedar', stage: 1, level: 2, currentXp: 90, xpRequiredForNextLevel: 100, unlockedAccessories: []),
    Avatar(id: 'avatar-maya', name: 'Ivy', stage: 2, level: 5, currentXp: 300, xpRequiredForNextLevel: 625, unlockedAccessories: ['leaf-hat']),
    Avatar(id: 'avatar-omar', name: 'Basil', stage: 3, level: 9, currentXp: 850, xpRequiredForNextLevel: 2025, unlockedAccessories: ['eco-wings', 'recycled-backpack'], equippedAccessories: ['eco-wings']),
    Avatar(id: 'avatar-lily', name: 'Petal', stage: 1, level: 2, currentXp: 60, xpRequiredForNextLevel: 100, unlockedAccessories: []),
    Avatar(id: 'avatar-kai', name: 'Moss', stage: 4, level: 12, currentXp: 1480, xpRequiredForNextLevel: 3600, unlockedAccessories: ['flower-crown', 'eco-wings', 'recycled-backpack'], equippedAccessories: ['recycled-backpack']),
    Avatar(id: 'avatar-sara', name: 'Coral', stage: 2, level: 4, currentXp: 210, xpRequiredForNextLevel: 400, unlockedAccessories: ['sprout-antenna']),
    Avatar(id: 'avatar-leo2', name: 'Pine', stage: 3, level: 7, currentXp: 560, xpRequiredForNextLevel: 1225, unlockedAccessories: ['eco-glasses']),
    Avatar(id: 'avatar-nour', name: 'Reed', stage: 1, level: 3, currentXp: 130, xpRequiredForNextLevel: 225, unlockedAccessories: ['leaf-hat']),
  ];

  // ---------------------------------------------------------------------------
  // Students (12), Liam first. Houses distributed across all four.
  // ---------------------------------------------------------------------------
  static List<Student> students() => [
    Student(id: 'stu-liam', studentNumber: 'STU-2026-0417', firstName: 'Liam', lastName: 'Carter', grade: 4, className: '4B', houseId: 'house-taurus', avatarId: 'avatar-liam', totalXp: 120, availablePoints: 15, rewardBalance: 0.30, currentStreak: 4, longestStreak: 9, correctRecyclingCount: 24, incorrectRecyclingCount: 3, dailyEarnedPoints: 10, lastActiveAt: baseDate.subtract(const Duration(days: 1))),
    Student(id: 'stu-amara', studentNumber: 'STU-2026-0102', firstName: 'Amara', lastName: 'Okafor', grade: 5, className: '5A', houseId: 'house-leo', avatarId: 'avatar-amara', totalXp: 340, availablePoints: 45, rewardBalance: 0.90, currentStreak: 12, longestStreak: 18, correctRecyclingCount: 68, incorrectRecyclingCount: 6, dailyEarnedPoints: 25, lastActiveAt: baseDate.subtract(const Duration(hours: 2))),
    Student(id: 'stu-noah', studentNumber: 'STU-2026-0233', firstName: 'Noah', lastName: 'Ivanov', grade: 4, className: '4A', houseId: 'house-aries', avatarId: 'avatar-noah', totalXp: 310, availablePoints: 30, rewardBalance: 0.60, currentStreak: 7, longestStreak: 11, correctRecyclingCount: 62, incorrectRecyclingCount: 9, dailyEarnedPoints: 15, lastActiveAt: baseDate.subtract(const Duration(hours: 5))),
    Student(id: 'stu-zara', studentNumber: 'STU-2026-0388', firstName: 'Zara', lastName: 'Ahmed', grade: 5, className: '5B', houseId: 'house-aquarius', avatarId: 'avatar-zara', totalXp: 720, availablePoints: 60, rewardBalance: 1.20, currentStreak: 15, longestStreak: 22, correctRecyclingCount: 144, incorrectRecyclingCount: 11, dailyEarnedPoints: 40, lastActiveAt: baseDate.subtract(const Duration(hours: 1))),
    Student(id: 'stu-ethan', studentNumber: 'STU-2026-0451', firstName: 'Ethan', lastName: 'Brooks', grade: 4, className: '4B', houseId: 'house-taurus', avatarId: 'avatar-ethan', totalXp: 90, availablePoints: 10, rewardBalance: 0.20, currentStreak: 2, longestStreak: 5, correctRecyclingCount: 18, incorrectRecyclingCount: 7, dailyEarnedPoints: 5, lastActiveAt: baseDate.subtract(const Duration(days: 2))),
    Student(id: 'stu-maya', studentNumber: 'STU-2026-0509', firstName: 'Maya', lastName: 'Santos', grade: 4, className: '4A', houseId: 'house-leo', avatarId: 'avatar-maya', totalXp: 300, availablePoints: 35, rewardBalance: 0.70, currentStreak: 5, longestStreak: 14, correctRecyclingCount: 60, incorrectRecyclingCount: 5, dailyEarnedPoints: 20, lastActiveAt: baseDate.subtract(const Duration(hours: 3))),
    Student(id: 'stu-omar', studentNumber: 'STU-2026-0611', firstName: 'Omar', lastName: 'Haddad', grade: 5, className: '5A', houseId: 'house-aries', avatarId: 'avatar-omar', totalXp: 850, availablePoints: 75, rewardBalance: 1.50, currentStreak: 20, longestStreak: 25, correctRecyclingCount: 170, incorrectRecyclingCount: 8, dailyEarnedPoints: 50, lastActiveAt: baseDate.subtract(const Duration(minutes: 40))),
    Student(id: 'stu-lily', studentNumber: 'STU-2026-0677', firstName: 'Lily', lastName: 'Nguyen', grade: 4, className: '4B', houseId: 'house-aquarius', avatarId: 'avatar-lily', totalXp: 60, availablePoints: 5, rewardBalance: 0.10, currentStreak: 1, longestStreak: 3, correctRecyclingCount: 12, incorrectRecyclingCount: 4, dailyEarnedPoints: 5, lastActiveAt: baseDate.subtract(const Duration(days: 3))),
    Student(id: 'stu-kai', studentNumber: 'STU-2026-0720', firstName: 'Kai', lastName: 'Fischer', grade: 5, className: '5B', houseId: 'house-taurus', avatarId: 'avatar-kai', totalXp: 1480, availablePoints: 90, rewardBalance: 1.80, currentStreak: 18, longestStreak: 31, correctRecyclingCount: 296, incorrectRecyclingCount: 14, dailyEarnedPoints: 30, lastActiveAt: baseDate.subtract(const Duration(minutes: 15))),
    Student(id: 'stu-sara', studentNumber: 'STU-2026-0784', firstName: 'Sara', lastName: 'Kowalski', grade: 4, className: '4A', houseId: 'house-leo', avatarId: 'avatar-sara', totalXp: 210, availablePoints: 25, rewardBalance: 0.50, currentStreak: 6, longestStreak: 10, correctRecyclingCount: 42, incorrectRecyclingCount: 6, dailyEarnedPoints: 15, lastActiveAt: baseDate.subtract(const Duration(hours: 4))),
    Student(id: 'stu-leo2', studentNumber: 'STU-2026-0810', firstName: 'Leo', lastName: 'Martins', grade: 5, className: '5A', houseId: 'house-aries', avatarId: 'avatar-leo2', totalXp: 560, availablePoints: 55, rewardBalance: 1.10, currentStreak: 9, longestStreak: 16, correctRecyclingCount: 112, incorrectRecyclingCount: 10, dailyEarnedPoints: 25, lastActiveAt: baseDate.subtract(const Duration(hours: 6))),
    Student(id: 'stu-nour', studentNumber: 'STU-2026-0899', firstName: 'Nour', lastName: 'Khalil', grade: 4, className: '4B', houseId: 'house-aquarius', avatarId: 'avatar-nour', totalXp: 130, availablePoints: 18, rewardBalance: 0.36, currentStreak: 3, longestStreak: 8, correctRecyclingCount: 26, incorrectRecyclingCount: 5, dailyEarnedPoints: 10, lastActiveAt: baseDate.subtract(const Duration(days: 1, hours: 3))),
  ];

  // ---------------------------------------------------------------------------
  // Student ID cards (one active per student). Liam's UID is the demo default.
  // ---------------------------------------------------------------------------
  static const String liamCardUid = '04A1B2C3D4';

  static List<StudentCard> cards() => [
    StudentCard(cardUid: liamCardUid, studentId: 'stu-liam', issuedAt: baseDate.subtract(const Duration(days: 200)), expiresAt: baseDate.add(const Duration(days: 500))),
    StudentCard(cardUid: '04B2C3D4E5', studentId: 'stu-amara', issuedAt: baseDate.subtract(const Duration(days: 210))),
    StudentCard(cardUid: '04C3D4E5F6', studentId: 'stu-noah', issuedAt: baseDate.subtract(const Duration(days: 190))),
    StudentCard(cardUid: '04D4E5F6A7', studentId: 'stu-zara', issuedAt: baseDate.subtract(const Duration(days: 180))),
    StudentCard(cardUid: '04E5F6A7B8', studentId: 'stu-ethan', issuedAt: baseDate.subtract(const Duration(days: 170))),
    StudentCard(cardUid: '04F6A7B8C9', studentId: 'stu-maya', issuedAt: baseDate.subtract(const Duration(days: 160))),
    StudentCard(cardUid: '05A7B8C9D0', studentId: 'stu-omar', issuedAt: baseDate.subtract(const Duration(days: 150))),
    StudentCard(cardUid: '05B8C9D0E1', studentId: 'stu-lily', issuedAt: baseDate.subtract(const Duration(days: 140))),
    StudentCard(cardUid: '05C9D0E1F2', studentId: 'stu-kai', issuedAt: baseDate.subtract(const Duration(days: 130))),
    StudentCard(cardUid: '05D0E1F2A3', studentId: 'stu-sara', issuedAt: baseDate.subtract(const Duration(days: 120))),
    StudentCard(cardUid: '05E1F2A3B4', studentId: 'stu-leo2', issuedAt: baseDate.subtract(const Duration(days: 110))),
    StudentCard(cardUid: '05F2A3B4C5', studentId: 'stu-nour', issuedAt: baseDate.subtract(const Duration(days: 100))),
  ];

  // ---------------------------------------------------------------------------
  // Reward catalogue (10+ items, mix of monetary and non-monetary)
  // ---------------------------------------------------------------------------
  static List<RewardItem> rewardItems() => const [
    RewardItem(id: 'rw-snack', name: 'Healthy Snack Voucher', description: 'A fresh fruit or granola bar from the canteen.', pointCost: 50, category: RewardCategory.snack, imagePath: 'snack', requiresStaffApproval: true, dailyRedemptionLimit: 2),
    RewardItem(id: 'rw-juice', name: 'Fresh Juice', description: 'A cup of freshly squeezed juice.', pointCost: 40, category: RewardCategory.snack, imagePath: 'juice', requiresStaffApproval: true, dailyRedemptionLimit: 2),
    RewardItem(id: 'rw-pencil', name: 'Eco Pencil Set', description: 'Set of recycled-wood pencils.', pointCost: 60, category: RewardCategory.stationery, imagePath: 'pencil'),
    RewardItem(id: 'rw-notebook', name: 'Recycled Notebook', description: 'Notebook made from recycled paper.', pointCost: 80, category: RewardCategory.stationery, imagePath: 'notebook', stockStatus: StockStatus.lowStock),
    RewardItem(id: 'rw-privilege', name: 'House Privilege Point', description: 'Contribute a privilege point to your house.', pointCost: 100, category: RewardCategory.housePrivilege, imagePath: 'privilege'),
    RewardItem(id: 'rw-raffle', name: 'Sustainability Raffle Entry', description: 'One entry into the Weekly Sustainability Raffle.', pointCost: 30, category: RewardCategory.raffleEntry, imagePath: 'raffle'),
    RewardItem(id: 'rw-leafhat', name: 'Leaf Hat (Avatar)', description: 'A leafy hat for your Guardian.', pointCost: 150, category: RewardCategory.avatarAccessory, imagePath: 'leaf-hat'),
    RewardItem(id: 'rw-ecoglasses', name: 'Eco Glasses (Avatar)', description: 'Cool recycled glasses for your Guardian.', pointCost: 120, category: RewardCategory.avatarAccessory, imagePath: 'eco-glasses'),
    RewardItem(id: 'rw-flowercrown', name: 'Flower Crown (Avatar)', description: 'A blooming crown for your Guardian.', pointCost: 150, category: RewardCategory.avatarAccessory, imagePath: 'flower-crown'),
    RewardItem(id: 'rw-ecowings', name: 'Eco Wings (Avatar)', description: 'Delicate leaf wings for your Guardian.', pointCost: 200, category: RewardCategory.avatarAccessory, imagePath: 'eco-wings'),
    RewardItem(id: 'rw-backpack', name: 'Recycled Backpack (Avatar)', description: 'A tiny recycled backpack accessory.', pointCost: 180, category: RewardCategory.avatarAccessory, imagePath: 'recycled-backpack'),
    RewardItem(id: 'rw-badge', name: 'Recycling Champion Badge', description: 'An achievement badge on your profile.', pointCost: 90, category: RewardCategory.badge, imagePath: 'badge', stockStatus: StockStatus.outOfStock),
  ];

  // ---------------------------------------------------------------------------
  // Reward transactions (redemption history)
  // ---------------------------------------------------------------------------
  static List<RewardTransaction> transactions() => [
    RewardTransaction(id: 'txn-1', studentId: 'stu-liam', type: RewardTransactionType.redemption, points: -40, rewardValue: 0.80, description: 'Redeemed Fresh Juice', createdAt: baseDate.subtract(const Duration(days: 2)), kioskOrTerminalId: 'CANTEEN-01', staffId: 'canteen-1', rewardItemId: 'rw-juice'),
    RewardTransaction(id: 'txn-2', studentId: 'stu-amara', type: RewardTransactionType.redemption, points: -50, rewardValue: 1.00, description: 'Redeemed Healthy Snack Voucher', createdAt: baseDate.subtract(const Duration(days: 1)), kioskOrTerminalId: 'CANTEEN-01', staffId: 'canteen-1', rewardItemId: 'rw-snack'),
    RewardTransaction(id: 'txn-3', studentId: 'stu-omar', type: RewardTransactionType.bonus, points: 25, description: '20-cycle streak bonus', createdAt: baseDate.subtract(const Duration(hours: 6))),
    RewardTransaction(id: 'txn-4', studentId: 'stu-zara', type: RewardTransactionType.redemption, points: -30, rewardValue: 0.60, description: 'Redeemed Raffle Entry', createdAt: baseDate.subtract(const Duration(hours: 20)), kioskOrTerminalId: 'CANTEEN-01', staffId: 'canteen-1', rewardItemId: 'rw-raffle'),
    RewardTransaction(id: 'txn-5', studentId: 'stu-kai', type: RewardTransactionType.redemption, points: -100, rewardValue: 2.00, description: 'Redeemed House Privilege Point', createdAt: baseDate.subtract(const Duration(days: 3)), kioskOrTerminalId: 'CANTEEN-01', staffId: 'canteen-1', rewardItemId: 'rw-privilege'),
  ];

  // ---------------------------------------------------------------------------
  // Kiosk devices
  // ---------------------------------------------------------------------------
  static List<KioskDevice> devices() => [
    KioskDevice(id: AppConfig.demoKioskId, name: 'Main Hall Kiosk', schoolLocation: 'Oakwood Elementary — Main Hall', lastHeartbeat: baseDate.subtract(const Duration(seconds: 12)), softwareVersion: '1.0.0', sessionsToday: 47),
    KioskDevice(id: 'KIOSK-OAK-02', name: 'Cafeteria Kiosk', schoolLocation: 'Oakwood Elementary — Cafeteria', controllerStatus: PeripheralStatus.ok, cameraStatus: PeripheralStatus.warning, nfcStatus: PeripheralStatus.ok, sensorStatus: PeripheralStatus.ok, internetStatus: PeripheralStatus.ok, lastHeartbeat: baseDate.subtract(const Duration(minutes: 1)), softwareVersion: '1.0.0', sessionsToday: 31),
    KioskDevice(id: 'KIOSK-OAK-03', name: 'Science Wing Kiosk', schoolLocation: 'Oakwood Elementary — Science Wing', controllerStatus: PeripheralStatus.disconnected, cameraStatus: PeripheralStatus.disconnected, nfcStatus: PeripheralStatus.disconnected, sensorStatus: PeripheralStatus.disconnected, internetStatus: PeripheralStatus.error, lastHeartbeat: baseDate.subtract(const Duration(hours: 3)), softwareVersion: '0.9.8', sessionsToday: 0),
    KioskDevice(id: 'KIOSK-OAK-04', name: 'Library Kiosk', schoolLocation: 'Oakwood Elementary — Library', maintenanceMode: true, lastHeartbeat: baseDate.subtract(const Duration(minutes: 25)), softwareVersion: '1.0.0', sessionsToday: 8),
  ];

  // ---------------------------------------------------------------------------
  // Staff accounts
  // ---------------------------------------------------------------------------
  static const teacherEmail = 'teacher@oakwood.edu';
  static const adminEmail = 'admin@oakwood.edu';
  static const canteenEmployeeNumber = 'EMP-1042';
  static const demoPassword = 'ecolens';

  static TeacherAccount teacher() => const TeacherAccount(
    id: 'teacher-1',
    name: 'Ms. Priya Sharma',
    email: teacherEmail,
    assignedClasses: ['4A', '4B', '5A', '5B'],
  );

  static AdminAccount admin() => const AdminAccount(
    id: 'admin-1',
    name: 'Mr. David Chen',
    email: adminEmail,
    permissions: [
      'students.manage',
      'cards.manage',
      'config.manage',
      'devices.manage',
      'rewards.manage',
      'users.manage',
      'audit.view',
    ],
  );

  static CanteenStaffAccount canteenStaff() => const CanteenStaffAccount(
    id: 'canteen-1',
    name: 'Mr. Tom Baker',
    employeeNumber: canteenEmployeeNumber,
    terminalId: 'CANTEEN-01',
  );

  // ---------------------------------------------------------------------------
  // Recycling sessions (20+) for analytics
  // ---------------------------------------------------------------------------
  static List<RecyclingSession> sessions() {
    final list = <RecyclingSession>[];
    final studentIds = students().map((s) => s.id).toList();
    // A repeatable pattern of item/category outcomes.
    const items = [
      ('Plastic Water Bottle', WasteCategory.plastic, 0.94, true),
      ('Newspaper', WasteCategory.paper, 0.91, true),
      ('Apple Core', WasteCategory.organic, 0.88, true),
      ('Coffee-stained Paper Cup', WasteCategory.general, 0.83, true),
      ('Yoghurt Pot', WasteCategory.plastic, 0.72, false), // low confidence
      ('Banana Peel', WasteCategory.organic, 0.90, true),
      ('Cardboard Box', WasteCategory.paper, 0.95, true),
      ('Crisp Packet', WasteCategory.general, 0.86, false),
      ('Milk Carton', WasteCategory.plastic, 0.79, true),
      ('Magazine', WasteCategory.paper, 0.92, true),
    ];
    for (var i = 0; i < 24; i++) {
      final item = items[i % items.length];
      final studentId = studentIds[i % studentIds.length];
      final started = baseDate.subtract(Duration(hours: i * 3 + 1));
      final routed = item.$3 >= 0.80 ? item.$2 : WasteCategory.general;
      final correct = item.$4;
      final selected = correct
          ? routed
          : WasteCategory.values[(routed.index + 1) % 4];
      list.add(
        RecyclingSession(
          id: 'sess-${i + 1}',
          studentId: studentId,
          kioskId: AppConfig.demoKioskId,
          startedAt: started,
          completedAt: started.add(const Duration(seconds: 40)),
          studentSelectedCategory: selected,
          finalCategory: routed,
          wasCorrect: correct,
          pointsAwarded: correct ? 5 : 0,
          housePointsAwarded: correct ? 5 : 0,
          streakAfterSession: correct ? (i % 8) + 1 : 0,
          status: SessionStatus.completed,
          hardwareCommandStatus: HardwareCommandStatus.acknowledged,
          idempotencyKey: 'seed-$i',
          classificationResult: WasteClassificationResult(
            predictedCategory: item.$2,
            detectedObjectName: item.$1,
            confidence: item.$3,
            explanation: 'Seed classification for analytics.',
            educationalFact: 'Recycling helps reduce landfill waste.',
            processedAt: started.add(const Duration(seconds: 5)),
          ),
        ),
      );
    }
    return list;
  }

  // ---------------------------------------------------------------------------
  // Audit log
  // ---------------------------------------------------------------------------
  static List<AuditLogEntry> auditLog() => [
    AuditLogEntry(id: 'audit-1', actorId: 'admin-1', actorName: 'Mr. David Chen', action: 'Updated AI confidence threshold', target: 'GamificationConfig', detail: '0.75 → 0.80', timestamp: baseDate.subtract(const Duration(days: 1, hours: 2))),
    AuditLogEntry(id: 'audit-2', actorId: 'admin-1', actorName: 'Mr. David Chen', action: 'Replaced Student ID card', target: 'stu-ethan', detail: 'Lost card reissued', timestamp: baseDate.subtract(const Duration(days: 2))),
    AuditLogEntry(id: 'audit-3', actorId: 'admin-1', actorName: 'Mr. David Chen', action: 'Enabled maintenance mode', target: 'KIOSK-OAK-04', detail: 'Library kiosk servicing', timestamp: baseDate.subtract(const Duration(hours: 25))),
    AuditLogEntry(id: 'audit-4', actorId: 'admin-1', actorName: 'Mr. David Chen', action: 'Updated daily points cap', target: 'GamificationConfig', detail: '40 → 50', timestamp: baseDate.subtract(const Duration(days: 4))),
  ];

  // ---------------------------------------------------------------------------
  // AI classification catalogue — items the mock classifier can "detect"
  // ---------------------------------------------------------------------------
  static List<MockWasteItem> aiCatalogue() => const [
    MockWasteItem(id: 'bottle', name: 'Plastic Water Bottle', category: WasteCategory.plastic, baseConfidence: 0.95, condition: ItemCondition.clean, explanation: 'A clear PET plastic bottle. Empty and clean bottles are fully recyclable.', fact: 'Recycling one plastic bottle saves enough energy to power a lightbulb for 3 hours.'),
    MockWasteItem(id: 'newspaper', name: 'Newspaper', category: WasteCategory.paper, baseConfidence: 0.93, condition: ItemCondition.clean, explanation: 'Clean newsprint paper. Dry paper belongs in the paper bin.', fact: 'Recycling a stack of newspapers saves trees and reduces landfill methane.'),
    MockWasteItem(id: 'apple', name: 'Apple Core', category: WasteCategory.organic, baseConfidence: 0.89, condition: ItemCondition.clean, explanation: 'Food waste like an apple core composts into nutrient-rich soil.', fact: 'Composting food scraps cuts the methane that rotting food creates in landfills.'),
    MockWasteItem(id: 'coffeecup', name: 'Coffee-stained Paper Cup', category: WasteCategory.general, baseConfidence: 0.84, condition: ItemCondition.contaminated, contamination: true, explanation: 'Since your paper cup has coffee in it, it can contaminate the pure paper in the paper bin, so it belongs in General Waste.', fact: 'Most disposable cups have a plastic lining and food residue, so they go to general waste.'),
    MockWasteItem(id: 'yoghurt', name: 'Yoghurt Pot', category: WasteCategory.plastic, baseConfidence: 0.74, condition: ItemCondition.wet, contamination: true, explanation: 'A yoghurt pot with residue. When unsure or dirty, we play it safe with General Waste.', fact: 'Rinsing plastic pots before recycling helps them actually get recycled.'),
    MockWasteItem(id: 'banana', name: 'Banana Peel', category: WasteCategory.organic, baseConfidence: 0.91, condition: ItemCondition.clean, explanation: 'A banana peel is organic waste and composts quickly.', fact: 'Banana peels break down in weeks and enrich compost with potassium.'),
    MockWasteItem(id: 'cardboard', name: 'Cardboard Box', category: WasteCategory.paper, baseConfidence: 0.96, condition: ItemCondition.clean, explanation: 'Flattened, clean cardboard belongs in the paper bin.', fact: 'Recycled cardboard uses 75% less energy than making new cardboard.'),
    MockWasteItem(id: 'crisps', name: 'Crisp Packet', category: WasteCategory.general, baseConfidence: 0.87, condition: ItemCondition.contaminated, explanation: 'Foil-lined crisp packets are not recyclable and go in General Waste.', fact: 'Crisp packets are made of mixed materials that are hard to separate.'),
    MockWasteItem(id: 'can', name: 'Aluminium Can', category: WasteCategory.plastic, baseConfidence: 0.90, condition: ItemCondition.clean, explanation: 'In this 4-bin setup, metal cans go with recyclables in the Plastic/recycling slot.', fact: 'Aluminium can be recycled endlessly without losing quality.'),
    MockWasteItem(id: 'unknown', name: 'Unidentified Object', category: WasteCategory.general, baseConfidence: 0.55, condition: ItemCondition.unknown, explanation: 'The item could not be identified confidently.', fact: 'When in doubt, General Waste keeps recyclables clean.'),
  ];
}

/// A mock waste item the AI classifier can "recognise".
class MockWasteItem {
  const MockWasteItem({
    required this.id,
    required this.name,
    required this.category,
    required this.baseConfidence,
    required this.condition,
    required this.explanation,
    required this.fact,
    this.contamination = false,
  });

  final String id;
  final String name;
  final WasteCategory category;
  final double baseConfidence;
  final ItemCondition condition;
  final String explanation;
  final String fact;
  final bool contamination;
}
