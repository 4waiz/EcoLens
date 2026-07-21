import 'package:ecolens/app/providers.dart';
import 'package:ecolens/app/router.dart';
import 'package:ecolens/core/constants/app_routes.dart';
import 'package:ecolens/data/mock/mock_seed_data.dart';
import 'package:ecolens/domain/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests that role-based route guards redirect unauthenticated staff to their
/// section login and keep the kiosk publicly reachable.
void main() {
  testWidgets('unauthenticated teacher route redirects to teacher login',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    router.go(AppRoutes.teacherOverview);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.teacherLogin,
    );
  });

  testWidgets('unauthenticated admin route redirects to admin login',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    router.go(AppRoutes.adminSystemHealth);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.adminLogin,
    );
  });

  testWidgets('authenticated admin can reach an admin route', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Authenticate as admin first.
    await container.read(authServiceProvider).authenticateAdmin(
          const LoginCredentials(
            identifier: MockSeedData.adminEmail,
            password: MockSeedData.demoPassword,
          ),
        );

    final router = container.read(routerProvider);
    router.go(AppRoutes.adminOverview);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.adminOverview,
    );
  });

  testWidgets('the kiosk is reachable without authentication', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    router.go(AppRoutes.kiosk);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.kiosk,
    );
  });
}
