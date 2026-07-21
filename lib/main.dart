import 'app/app_bootstrap.dart';

/// EcoLens Interactive Recycling Kiosk — entry point.
///
/// The same binary serves four experiences (kiosk, teacher dashboard, admin
/// dashboard, canteen terminal) selected by route. There is intentionally NO
/// student mobile app: students are identified only by their physical Student
/// ID card at the shared kiosk.
Future<void> main() => bootstrapEcoLens();
