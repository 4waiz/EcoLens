import 'package:ecolens/shared/layouts/dashboard_shell.dart';
import 'package:ecolens/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('probe: DashboardShell', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardShell(
          title: 'X',
          items: const [
            DashboardNavItem(label: 'A', icon: Icons.abc, route: '/a'),
          ],
          currentRoute: '/a',
          accent: AppColors.info,
          userName: 'Test',
          userRoleLabel: 'Teacher',
          child: const Text('hello'),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('hello'), findsOneWidget);
  });
}
