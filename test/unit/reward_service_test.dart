import 'package:ecolens/core/errors/failures.dart';
import 'package:ecolens/data/mock/mock_database.dart';
import 'package:ecolens/data/repositories/mock_reward_repository.dart';
import 'package:ecolens/data/repositories/mock_simple_repositories.dart';
import 'package:ecolens/domain/enums/app_enums.dart';
import 'package:ecolens/domain/models/reward_item.dart';
import 'package:ecolens/domain/services/reward_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests for reward redemption: valid flow, insufficient balance, availability.
void main() {
  late MockDatabase db;
  late RewardService service;

  setUp(() {
    db = MockDatabase();
    service = RewardService(
      rewardRepository: MockRewardRepository(db),
      configRepository: MockConfigRepository(db),
    );
  });

  RewardItem cheapItem() => const RewardItem(
    id: 'rw-cheap',
    name: 'Cheap Reward',
    description: 'x',
    pointCost: 10,
    category: RewardCategory.snack,
  );

  test('a student with enough points passes validation', () async {
    final student = db.studentById('stu-liam')!; // 15 points
    final result = await service.validateRedemption(
      student: student,
      item: cheapItem(),
      staffId: 'canteen-1',
      terminalId: 'CANTEEN-01',
    );
    expect(result.isOk, isTrue);
  });

  test('insufficient balance is rejected', () async {
    final student = db.studentById('stu-liam')!; // 15 points
    final expensive = cheapItem().copyWith(pointCost: 9999);
    final result = await service.validateRedemption(
      student: student,
      item: expensive,
      staffId: 'canteen-1',
      terminalId: 'CANTEEN-01',
    );
    expect(result.isErr, isTrue);
    expect(result.failureOrNull, isA<RedemptionFailure>());
  });

  test('out-of-stock rewards are rejected', () async {
    final student = db.studentById('stu-liam')!;
    final oos = cheapItem().copyWith(stockStatus: StockStatus.outOfStock);
    final result = await service.validateRedemption(
      student: student,
      item: oos,
      staffId: 'canteen-1',
      terminalId: 'CANTEEN-01',
    );
    expect(result.isErr, isTrue);
  });

  test('missing staff authorisation is rejected', () async {
    final student = db.studentById('stu-liam')!;
    final result = await service.validateRedemption(
      student: student,
      item: cheapItem(),
      staffId: '',
      terminalId: 'CANTEEN-01',
    );
    expect(result.isErr, isTrue);
  });

  test(
    'creating a completed redemption debits the student balance once',
    () async {
      final student = db.studentById('stu-liam')!; // 15 points
      final validated = await service.validateRedemption(
        student: student,
        item: cheapItem(), // costs 10, no staff approval required
        staffId: 'canteen-1',
        terminalId: 'CANTEEN-01',
      );
      expect(validated.isOk, isTrue);

      final txn = await service.createRedemption(validated.valueOrNull!);
      expect(txn.points, -10);
      expect(txn.status, RewardTransactionStatus.completed);

      // Balance reduced from 15 to 5 exactly once.
      expect(db.studentById('stu-liam')!.availablePoints, 5);
    },
  );
}
