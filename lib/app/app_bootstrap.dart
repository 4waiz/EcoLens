import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_config.dart';
import 'app.dart';
import 'providers.dart';

/// Bootstraps EcoLens: initialises bindings, warms the hardware bridge, applies
/// kiosk display preferences, and mounts the app inside a Riverpod scope.
///
/// This is the single composition root. To target production, override the
/// leaf providers here (auth/ai/hardware/repositories) with real adapters.
Future<void> bootstrapEcoLens() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kiosk-friendly: prefer landscape and edge-to-edge. On desktop/web these are
  // no-ops; on a locked kiosk tablet they enforce the intended composition.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final container = ProviderContainer();

  // Warm the hardware bridge so the kiosk is responsive immediately. Failures
  // are non-fatal — the kiosk surfaces an offline/hardware state instead.
  try {
    await container.read(hardwareBridgeProvider).initialise();
  } catch (_) {
    // Ignored: the UI will reflect degraded hardware health.
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const EcoLensApp(),
    ),
  );

  debugPrint('EcoLens started in ${AppConfig.environment.label} mode');
}
