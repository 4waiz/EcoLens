import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_config.dart';
import '../core/theme/app_theme.dart';
import 'router.dart';

/// Root application widget. Wires the theme + router and configures the app for
/// a kiosk-friendly, localisation-ready experience.
class EcoLensApp extends ConsumerWidget {
  const EcoLensApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      // Localisation is structured but ships English-only for now. Adding a
      // locale + delegates here (and an Arabic ARB) enables RTL without any
      // layout rewrites — the UI uses directional widgets throughout.
      builder: (context, child) {
        // Clamp text scaling so kiosk layouts never overflow from OS settings.
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: mq.textScaler.clamp(
              minScaleFactor: 0.9,
              maxScaleFactor: 1.2,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
