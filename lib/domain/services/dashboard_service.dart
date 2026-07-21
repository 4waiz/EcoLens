import '../models/dashboard_models.dart';
import '../models/kiosk_device.dart';
import '../models/reward_transaction.dart';
import '../repositories/repositories.dart';

/// Facade over [DashboardRepository] exposing the dashboard queries the teacher
/// and admin experiences need. Kept as a service so presentation code depends
/// on a stable API rather than the repository directly.
class DashboardService {
  DashboardService({required DashboardRepository repository})
    : _repo = repository;

  final DashboardRepository _repo;

  Future<TeacherOverview> getTeacherOverview({String? teacherId}) =>
      _repo.getTeacherOverview(teacherId: teacherId);

  Future<AdminOverview> getAdminOverview() => _repo.getAdminOverview();

  Future<AccuracyMetrics> getAccuracyMetrics({String? classFilter}) =>
      _repo.getAccuracyMetrics(classFilter: classFilter);

  Future<List<CommonMistake>> getCommonMistakes() => _repo.getCommonMistakes();

  Future<List<TrendPoint>> getParticipationTrends() =>
      _repo.getParticipationTrends();

  Future<List<KioskDevice>> getDeviceHealthSummary() =>
      _repo.getDeviceHealthSummary();

  Future<List<RewardTransaction>> getRewardUsageSummary() =>
      _repo.getRewardUsageSummary();
}
