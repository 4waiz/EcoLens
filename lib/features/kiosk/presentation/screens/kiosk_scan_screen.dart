import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/camera_frame.dart';
import '../widgets/kiosk_chrome.dart';

/// SCREEN 4 — Item scanning.
///
/// Shows a (mocked) camera preview inside a scanning frame, with capture
/// progress and cancel. If the camera is unavailable the frame shows a clear
/// camera-unavailable state with retry.
class KioskScanScreen extends ConsumerWidget {
  const KioskScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final capturing = session.state == KioskState.capturingImage;
    final cameraError = session.errorMessage != null && !capturing;

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 32),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Show me your item',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryDark,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hold the item in front of the camera, then tap Capture.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.inkMuted,
                ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: CameraFrame(
                capturing: capturing,
                unavailable: cameraError,
                errorMessage: session.errorMessage,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (cameraError)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KioskButton(
                  label: 'Try Again',
                  icon: Icons.refresh,
                  onPressed: controller.scanItem,
                ),
                const SizedBox(width: 14),
                KioskButton(
                  label: 'Back',
                  icon: Icons.arrow_back,
                  filled: false,
                  onPressed: controller.backFromSubScreen,
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                KioskButton(
                  label: capturing ? 'Capturing…' : 'Capture',
                  icon: Icons.camera_alt,
                  onPressed: capturing ? null : controller.scanItem,
                ),
                const SizedBox(width: 14),
                KioskButton(
                  label: 'Cancel',
                  icon: Icons.close,
                  filled: false,
                  color: AppColors.inkMuted,
                  onPressed: capturing
                      ? null
                      : controller.backFromSubScreen,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
