import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../shared/components/ecolens_logo.dart';
import '../../application/kiosk_controller.dart';

/// Persistent kiosk frame: a soft environmental background plus a top bar with
/// the EcoLens logo, an offline indicator, and a HIDDEN developer entry point
/// (long-press the logo) that never appears to students in normal use.
class KioskChrome extends ConsumerWidget {
  const KioskChrome({
    super.key,
    required this.child,
    this.showDevAccess = false,
  });

  final Widget child;
  final bool showDevAccess;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.attractGradient,
        ),
      ),
      child: Stack(
        children: [
          // Decorative leaves in the corners.
          Positioned(
            top: -40,
            right: -30,
            child: Icon(
              Icons.eco,
              size: 220,
              color: AppColors.guardianLeaf.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: Icon(
              Icons.spa_outlined,
              size: 240,
              color: AppColors.primary.withValues(alpha: 0.06),
            ),
          ),

          // Main content.
          Positioned.fill(
            child: Column(
              children: [
                _KioskTopBar(
                  offline: session.isOffline,
                  queued: session.queuedCount,
                  showDevAccess: showDevAccess,
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KioskTopBar extends StatelessWidget {
  const _KioskTopBar({
    required this.offline,
    required this.queued,
    required this.showDevAccess,
  });

  final bool offline;
  final int queued;
  final bool showDevAccess;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 6),
      child: Row(
        children: [
          // Long-press the logo → hidden developer panel (protected).
          GestureDetector(
            onLongPress: showDevAccess
                ? () => context.go(AppRoutes.dev)
                : null,
            child: const EcoLensLogo(height: 40),
          ),
          const Spacer(),
          if (offline) OfflineBadge(queued: queued),
          const SizedBox(width: 12),
          // School badge (procedural).
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.forest,
                      size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 8),
                Text(
                  'Oakwood Elementary',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.ink,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A reusable large action button styled for touch (kiosk primary CTA).
class KioskButton extends StatelessWidget {
  const KioskButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.primary,
    this.filled = true,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color color;
  final bool filled;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[Icon(icon, size: 24), const SizedBox(width: 10)],
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
    final padding =
        const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
    if (filled) {
      return FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: child,
      );
    }
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5), width: 2),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      child: child,
    );
  }
}

/// Convenience for showing the demo AppConfig env tag on kiosk (debug only).
bool get kioskDevAccessEnabled => AppConfig.devPanelEnabled;
