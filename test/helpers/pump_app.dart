import 'package:ecolens/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] wrapped in a ProviderScope + MaterialApp with the app theme,
/// sized to a landscape kiosk surface so layout-sensitive widgets render.
Future<void> pumpEcoWidget(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  // Default to the real kiosk target resolution (1920 x 1200, 16:10).
  Size surfaceSize = const Size(1920, 1200),
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    ),
  );
}
