import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/kiosk_state.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';

/// Maintenance / error state. Friendly, student-safe messaging; recovery
/// actions are available to staff (and the dev panel).
class KioskMaintenanceScreen extends ConsumerWidget {
  const KioskMaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final isError = session.state == KioskState.error;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: isError
                    ? AppColors.errorSurface
                    : AppColors.warningSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.build_circle_outlined,
                size: 56,
                color: isError ? AppColors.error : AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isError ? 'Something went wrong' : 'Back soon!',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isError
                  ? (session.errorMessage ??
                        'This kiosk hit a snag. Please tell a teacher.')
                  : 'This EcoLens kiosk is being looked after. '
                        'Please use another bin for now.',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.inkMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            KioskButton(
              label: 'Return to Home',
              icon: Icons.home_outlined,
              onPressed: controller.exitMaintenance,
            ),
          ],
        ),
      ),
    );
  }
}
