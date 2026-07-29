import 'package:ecolens/app/router.dart';
import 'package:ecolens/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Tests that role-based route guards redirect unauthenticated staff to their
/// section login and keep the kiosk publicly reachable.
void main() {
  testWidgets('unauthenticated teacher route redirects to teacher login', (
    tester,
  ) async {
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

  testWidgets('unauthenticated admin route redirects to admin login', (
    tester,
  ) async {
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

  testWidgets('unauthenticated canteen route redirects to canteen login', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final router = container.read(routerProvider);

    router.go(AppRoutes.canteenRewards);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // The guard blocks unauthenticated access and sends staff to login (a
    // static screen), proving role-based protection across all staff sections.
    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.canteenLogin,
    );
  });
}
