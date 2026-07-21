import 'package:ecolens/domain/services/auth_service.dart';
import 'package:ecolens/app/providers.dart';
import 'package:ecolens/core/theme/app_theme.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/features/teacher_dashboard/presentation/teacher_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget test — teacher overview renders live analytics after login.
void main() {
  testWidgets('teacher overview shows headline metrics and charts',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // A teacher session is needed for the scaffold user menu.
    await container.read(authServiceProvider).authenticateTeacher(
          const LoginCredentials(
            identifier: MockSeedData.teacherEmail,
            password: MockSeedData.demoPassword,
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

    // Loading state first.
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // Let the mock analytics resolve (fixed pumps — avoids hanging on the
    // indeterminate progress indicator's repeating animation).
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // Headline + key sections render.
    expect(find.textContaining('Great work this week'), findsOneWidget);
    expect(find.text('Weekly participation'), findsOneWidget);
    expect(find.text('Common mistakes'), findsOneWidget);
  });
}
