import '../../domain/enums/app_enums.dart';

/// Global runtime configuration and feature flavour.
///
/// The [environment] controls whether mock services back the app. For this MVP
/// the default is [AppEnvironment.demo] which uses the full in-memory mock
/// stack so every experience runs end-to-end without a backend.
abstract final class AppConfig {
  /// Active environment. Override via --dart-define=ECOLENS_ENV=production etc.
  static AppEnvironment get environment => _resolvedEnvironment;

  static const String _envName = String.fromEnvironment(
    'ECOLENS_ENV',
    defaultValue: 'demo',
  );

  static AppEnvironment get _resolvedEnvironment => switch (_envName) {
    'mock' => AppEnvironment.mock,
    'development' || 'dev' => AppEnvironment.development,
    'production' || 'prod' => AppEnvironment.production,
    _ => AppEnvironment.demo,
  };

  /// Whether the mock service stack is active.
  static bool get useMockServices => environment.usesMockServices;

  /// Whether the hidden developer/hardware-simulation panel is reachable.
  /// Disabled in production so students can never open it.
  static bool get devPanelEnabled => environment != AppEnvironment.production;

  /// Base URL for the (future) real backend. Unused in mock mode.
  static const String apiBaseUrl = String.fromEnvironment(
    'ECOLENS_API_URL',
    defaultValue: 'https://api.ecolens.example',
  );

  /// Base URL / channel for the hardware bridge (future real integration).
  static const String hardwareBridgeUrl = String.fromEnvironment(
    'ECOLENS_HW_URL',
    defaultValue: 'ws://localhost:8081/bin-controller',
  );

  static const String appName = 'EcoLens';
  static const String appTagline = 'Learn. Act. Earn. Save our planet.';
  static const String appVersion = '1.0.0';

  /// Default kiosk id used by the single-kiosk demo build.
  static const String demoKioskId = 'KIOSK-OAK-01';

  /// Simulated latencies for the mock stack (kept short for a snappy demo).
  static const Duration mockCardReadDelay = Duration(milliseconds: 1400);
  static const Duration mockCaptureDelay = Duration(milliseconds: 1100);
  static const Duration mockClassifyDelay = Duration(milliseconds: 1600);
  static const Duration mockHardwareDelay = Duration(milliseconds: 600);
  static const Duration mockNetworkDelay = Duration(milliseconds: 450);
}
