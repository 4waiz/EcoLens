import 'package:ecolens/app/providers.dart';
import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/models/dashboard_models.dart';
import 'package:ecolens/domain/services/auth_service.dart';
import 'package:ecolens/features/teacher_dashboard/presentation/teacher_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget test — teacher overview renders its analytics.
///
/// The overview's data is provided via an overridden [teacherOverviewProvider]
/// so the screen renders synchronously (no mock network delay, no indeterminate
/// spinner) — this keeps the test deterministic and fast.
void main() {
  final overview = TeacherOverview(
    activeStudents: 12,
    recyclingSessions: 24,
    correctClassificationRate: 0.82,
    participationRate: 0.9,
    xpAwarded: 120,
    housePoints: 640,
    headlineMetrics: const [
      MetricValue(label: 'Active students', value: '12', caption: 'this week'),
      MetricValue(label: 'Sessions', value: '24', caption: 'this week'),
    ],
    participationTrend: const [
      TrendPoint(label: 'Mon', value: 12),
      TrendPoint(label: 'Tue', value: 18),
    ],
    commonMistakes: const [],
    topClasses: const [LeaderboardMini(name: 'Class 4B', points: 300)],
    topHouses: const [LeaderboardMini(name: 'Taurus', points: 4850)],
  );

  testWidgets('teacher overview shows headline + key sections', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        teacherOverviewProvider.overrideWith((ref) async => overview),
      ],
    );
    addTearDown(container.dispose);

    // A teacher session is needed for the scaffold user menu.
    //
    // MUST run inside runAsync: the mock auth service awaits a simulated
    // network delay, and testWidgets bodies execute in a FakeAsync zone where
    // nothing advances the clock until a pump. Awaiting it directly here (with
    // no widget tree pumped yet) blocks the test forever.
    await tester.runAsync(
      () => container
          .read(authServiceProvider)
          .authenticateTeacher(
            const LoginCredentials(
              identifier: MockSeedData.teacherEmail,
              password: MockSeedData.demoPassword,
            ),
          ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const TeacherOverviewScreen(),
        ),
      ),
    );
    // A few fixed frames for the (already-resolved) future + first chart frame.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Great work this week'), findsOneWidget);
    expect(find.text('Weekly participation'), findsOneWidget);
    expect(find.text('Top houses'), findsOneWidget);
  });
}
