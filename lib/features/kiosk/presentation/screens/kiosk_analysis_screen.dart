import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/camera_frame.dart';
import '../../../../shared/world/guardian_emotion.dart';
import '../../../../shared/world/guardian_mascot.dart';

/// SCREEN 5 — AI analysis.
///
/// A friendly "EcoLens is identifying your item…" screen: a captured-item panel
/// on the left and a numbered checklist (object type → material → condition →
/// contamination) that ticks off progressively, with a percentage progress bar.
/// Matches the reference design. Timeout/offline are handled by the controller.
class KioskAnalysisScreen extends ConsumerStatefulWidget {
  const KioskAnalysisScreen({super.key});

  @override
  ConsumerState<KioskAnalysisScreen> createState() =>
      _KioskAnalysisScreenState();
}

class _KioskAnalysisScreenState extends ConsumerState<KioskAnalysisScreen> {
  int _step = 0; // 0..4 (4 = all done)

  static const _steps = [
    ('Object type', Icons.category_outlined),
    ('Material', Icons.science_outlined),
    ('Condition', Icons.water_drop_outlined),
    ('Contamination', Icons.sanitizer_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _advance();
  }

  void _advance() {
    Future.delayed(const Duration(milliseconds: 420), () {
      if (!mounted) return;
      setState(() => _step = (_step + 1).clamp(0, _steps.length));
      if (_step < _steps.length) _advance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final classification = ref.watch(kioskControllerProvider).classification;
    final progress = ((_step / _steps.length) * 100).round();

    // Human-friendly per-step detail (falls back to generic copy).
    final details = [
      classification?.detectedObjectName ?? 'Item detected',
      'Material identified',
      classification?.condition.label ?? 'Checked',
      classification?.contaminationDetected == true
          ? 'Contamination found'
          : 'Clean',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: captured item.
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 280,
                  child: CameraFrame(
                    itemLabel: classification?.detectedObjectName,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.xpPurpleSurface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.auto_awesome,
                        color: AppColors.xpPurple,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'AI analysis in progress · almost there!',
                        style: TextStyle(
                          color: AppColors.xpPurpleDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right: the checklist + progress.
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.xpPurple,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'EcoLens ',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            TextSpan(
                              text: 'is identifying your item…',
                              style: TextStyle(color: AppColors.ink),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(
                      width: 64,
                      height: 64,
                      child: GuardianPortrait(
                        size: 64,
                        emotion: GuardianEmotion.thinking,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < _steps.length; i++) ...[
                  _ChecklistRow(
                    index: i + 1,
                    label: _steps[i].$1,
                    detail: details[i],
                    icon: _steps[i].$2,
                    done: i < _step,
                    active: i == _step,
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Analysing item…',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.xpPurpleDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$progress%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: _step / _steps.length,
                    minHeight: 12,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
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

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.index,
    required this.label,
    required this.detail,
    required this.icon,
    required this.done,
    required this.active,
  });

  final int index;
  final String label;
  final String detail;
  final IconData icon;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? AppColors.xpPurple : AppColors.border,
          width: active ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: done
                  ? AppColors.successSurface
                  : active
                  ? AppColors.xpPurpleSurface
                  : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: done
                  ? AppColors.success
                  : active
                  ? AppColors.xpPurple
                  : AppColors.inkFaint,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. $label',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  done || active ? detail : 'Waiting…',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: done
                ? const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 26,
                  )
                : active
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.xpPurple,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
