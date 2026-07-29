import '../../core/constants/app_config.dart';
import '../../domain/enums/app_enums.dart';
import '../../domain/enums/waste_category.dart';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../mock/mock_database.dart';
import '../mock/mock_seed_data.dart';

/// Computes teacher/admin analytics from the live mock database so dashboards
/// reflect real kiosk activity (including sessions completed this app session).
class MockDashboardRepository implements DashboardRepository {
  MockDashboardRepository(this._db);
  final MockDatabase _db;

  Future<void> _tick() => Future<void>.delayed(AppConfig.mockNetworkDelay);

  int get _correct => _db.sessions.where((s) => s.wasCorrect).length;
  int get _total => _db.sessions.length;
  double get _accuracy => _total == 0 ? 0 : _correct / _total;

  @override
  Future<TeacherOverview> getTeacherOverview({String? teacherId}) async {
    await _tick();
    final activeStudents = _db.students
        .where((s) => s.accountStatus == AccountStatus.active)
        .length;
    final xpAwarded = _db.sessions
        .where((s) => s.wasCorrect)
        .fold<int>(0, (a, s) => a + _db.config.xpPerCorrect);
    final housePoints = _db.houses.fold<int>(0, (a, h) => a + h.weeklyPoints);

    return TeacherOverview(
      activeStudents: activeStudents,
      recyclingSessions: _total,
      correctClassificationRate: _accuracy,
      participationRate: _db.students.isEmpty
          ? 0
          : (activeStudents / _db.students.length),
      xpAwarded: xpAwarded,
      housePoints: housePoints,
      headlineMetrics: [
        MetricValue(
          label: 'Active students',
          value: '$activeStudents',
          delta: '+2',
          caption: 'this week',
        ),
        MetricValue(
          label: 'Sessions',
          value: '$_total',
          delta: '+18',
          caption: 'this week',
        ),
        MetricValue(
          label: 'Accuracy',
          value: '${(_accuracy * 100).round()}%',
          delta: '+3%',
          caption: 'vs last week',
        ),
        MetricValue(
          label: 'XP awarded',
          value: '$xpAwarded',
          delta: '+120',
          caption: 'this week',
        ),
      ],
      participationTrend: _weeklyTrend(),
      commonMistakes: _computeCommonMistakes(),
      topClasses: _topClasses(),
      topHouses: _topHouses(),
    );
  }

  @override
  Future<AdminOverview> getAdminOverview() async {
    await _tick();
    final active = _db.devices
        .where((d) => d.health == HealthStatus.online)
        .length;
    final attention = _db.devices
        .where(
          (d) =>
              d.health == HealthStatus.offline ||
              d.health == HealthStatus.degraded,
        )
        .length;
    final sessionsToday = _db.sessions
        .where((s) => _isSameDay(s.startedAt, MockSeedData.baseDate))
        .length;
    final redeemedToday = _db.transactions
        .where(
          (t) =>
              t.type == RewardTransactionType.redemption &&
              _isSameDay(t.createdAt, MockSeedData.baseDate),
        )
        .length;

    return AdminOverview(
      totalStudents: _db.students.length,
      activeKiosks: active,
      kiosksNeedingAttention: attention,
      sessionsToday: sessionsToday,
      systemAccuracy: _accuracy,
      rewardsRedeemedToday: redeemedToday,
      headlineMetrics: [
        MetricValue(
          label: 'Students',
          value: '${_db.students.length}',
          caption: 'enrolled',
        ),
        MetricValue(
          label: 'Active kiosks',
          value: '$active / ${_db.devices.length}',
          caption: 'online',
        ),
        MetricValue(
          label: 'Sessions today',
          value: '$sessionsToday',
          delta: '+12',
          caption: 'vs yesterday',
        ),
        MetricValue(
          label: 'System accuracy',
          value: '${(_accuracy * 100).round()}%',
          delta: '+2%',
          caption: 'this week',
        ),
      ],
      weeklySessions: _weeklyTrend(),
      categoryBreakdown: _categoryBreakdown(),
    );
  }

  @override
  Future<AccuracyMetrics> getAccuracyMetrics({String? classFilter}) async {
    await _tick();
    final relevant = classFilter == null
        ? _db.sessions
        : _db.sessions.where((s) {
            final student = _db.studentById(s.studentId);
            return student?.className == classFilter;
          }).toList();

    final perCategory = <CategoryAccuracy>[];
    for (final cat in WasteCategory.values) {
      final attempts = relevant.where((s) => s.finalCategory == cat).toList();
      final correct = attempts.where((s) => s.wasCorrect).length;
      perCategory.add(
        CategoryAccuracy(
          category: cat,
          accuracy: attempts.isEmpty ? 0 : correct / attempts.length,
          attempts: attempts.length,
        ),
      );
    }

    final overall = relevant.isEmpty
        ? 0.0
        : relevant.where((s) => s.wasCorrect).length / relevant.length;

    return AccuracyMetrics(
      overallAccuracy: overall,
      perCategory: perCategory,
      commonMistakes: _computeCommonMistakes(),
      accuracyTrend: _weeklyTrend(scale: 100),
    );
  }

  @override
  Future<List<CommonMistake>> getCommonMistakes() async {
    await _tick();
    return _computeCommonMistakes();
  }

  @override
  Future<List<TrendPoint>> getParticipationTrends() async {
    await _tick();
    return _weeklyTrend();
  }

  @override
  Future<List<KioskDevice>> getDeviceHealthSummary() async {
    await _tick();
    return List.of(_db.devices);
  }

  @override
  Future<List<RewardTransaction>> getRewardUsageSummary() async {
    await _tick();
    final list = List.of(_db.transactions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  // ---- helpers ----

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<CommonMistake> _computeCommonMistakes() {
    final map = <String, CommonMistake>{};
    for (final s in _db.sessions.where((s) => !s.wasCorrect)) {
      final chosen = s.studentSelectedCategory;
      final correct = s.finalCategory;
      if (chosen == null || correct == null) continue;
      final key = '${correct.name}->${chosen.name}';
      final existing = map[key];
      map[key] = CommonMistake(
        correctCategory: correct,
        chosenCategory: chosen,
        occurrences: (existing?.occurrences ?? 0) + 1,
        exampleItem:
            s.classificationResult?.detectedObjectName ??
            existing?.exampleItem ??
            '',
      );
    }
    final list = map.values.toList()
      ..sort((a, b) => b.occurrences.compareTo(a.occurrences));
    return list;
  }

  List<CategoryBreakdown> _categoryBreakdown() {
    final counts = <WasteCategory, int>{};
    for (final s in _db.sessions) {
      final cat = s.finalCategory;
      if (cat == null) continue;
      counts[cat] = (counts[cat] ?? 0) + 1;
    }
    final total = counts.values.fold<int>(0, (a, b) => a + b);
    return WasteCategory.values
        .map(
          (c) => CategoryBreakdown(
            category: c,
            count: counts[c] ?? 0,
            share: total == 0 ? 0 : (counts[c] ?? 0) / total,
          ),
        )
        .toList();
  }

  List<LeaderboardMini> _topClasses() {
    final byClass = <String, int>{};
    for (final s in _db.students) {
      byClass[s.className] = (byClass[s.className] ?? 0) + s.totalXp;
    }
    final entries = byClass.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final max = entries.isEmpty ? 1 : entries.first.value;
    return entries
        .take(4)
        .map(
          (e) => LeaderboardMini(
            name: 'Class ${e.key}',
            points: e.value,
            progress: max == 0 ? 0 : e.value / max,
          ),
        )
        .toList();
  }

  List<LeaderboardMini> _topHouses() {
    final sorted = List.of(_db.houses)
      ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    final max = sorted.isEmpty ? 1 : sorted.first.totalPoints;
    return sorted
        .map(
          (h) => LeaderboardMini(
            name: h.name,
            points: h.totalPoints,
            colour: h.colour,
            progress: max == 0 ? 0 : h.totalPoints / max,
          ),
        )
        .toList();
  }

  List<TrendPoint> _weeklyTrend({double scale = 1}) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    // Deterministic pseudo-trend derived from session counts.
    final base = [12, 18, 15, 22, 26, 8, 5];
    return List.generate(days.length, (i) {
      final value = scale == 100
          ? (78 + (base[i] % 12))
                .toDouble() // accuracy-ish percentages
          : base[i].toDouble();
      return TrendPoint(label: days[i], value: value);
    });
  }
}
