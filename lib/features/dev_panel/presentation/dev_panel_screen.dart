import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock/mock_seed_data.dart';
import '../../../domain/enums/app_enums.dart';
import '../../../domain/enums/waste_category.dart';
import '../../../shared/components/eco_card.dart';
import '../../kiosk/application/kiosk_controller.dart';

/// Developer / hardware-simulation panel.
///
/// PROTECTED, non-production only. Lets a developer drive the whole system
/// without physical hardware: simulate cards, capture, AI confidence, error
/// injection, sensor/fill state, LED tests, logical slot-open commands, offline
/// mode and a full session reset. NEVER visible to students in normal kiosk use
/// (reached only via a long-press on the kiosk logo, and disabled in prod).
class DevPanelScreen extends ConsumerStatefulWidget {
  const DevPanelScreen({super.key});

  @override
  ConsumerState<DevPanelScreen> createState() => _DevPanelScreenState();
}

class _DevPanelScreenState extends ConsumerState<DevPanelScreen> {
  String? _forcedItemId;
  double _confidence = 0.9;
  bool _forceConfidence = false;

  @override
  Widget build(BuildContext context) {
    final kiosk = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final hw = ref.read(mockHardwareBridgeProvider);
    final ai = ref.read(mockAiClassificationProvider);
    final cards = MockSeedData.cards();
    final catalogue = MockSeedData.aiCatalogue();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.ink,
        title: const Text('Developer · Hardware Simulator'),
        actions: [
          TextButton.icon(
            onPressed: () => context.go(AppRoutes.kiosk),
            icon: const Icon(Icons.smart_display, color: Colors.white),
            label: const Text('Open Kiosk',
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: (hw == null || ai == null)
          ? const Center(
              child: Text('Mock services are not active in this environment.'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatusBar(
                        state: kiosk.state.label,
                        offline: kiosk.isOffline,
                        queued: kiosk.queuedCount,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          // ---- Cards ----
                          _PanelCard(
                            title: 'Student ID cards',
                            icon: Icons.badge,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _DevButton(
                                  label: "Simulate Liam's card",
                                  icon: Icons.person,
                                  onTap: () =>
                                      hw.simulateStudentCard(MockSeedData.liamCardUid),
                                ),
                                const SizedBox(height: 8),
                                _DevButton(
                                  label: 'Simulate another student',
                                  icon: Icons.people,
                                  onTap: () => hw.simulateStudentCard(
                                    cards[3].cardUid,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _DevButton(
                                  label: 'Simulate UNKNOWN card',
                                  icon: Icons.help_outline,
                                  colour: AppColors.warning,
                                  onTap: () =>
                                      hw.simulateStudentCard('DEADBEEF00'),
                                ),
                              ],
                            ),
                          ),

                          // ---- Camera / AI ----
                          _PanelCard(
                            title: 'Camera & AI',
                            icon: Icons.camera,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DropdownButtonFormField<String>(
                                  initialValue: _forcedItemId,
                                  decoration: const InputDecoration(
                                    labelText: 'Force detected item',
                                  ),
                                  items: [
                                    const DropdownMenuItem(
                                      value: null,
                                      child: Text('Random (rotate)'),
                                    ),
                                    for (final item in catalogue)
                                      DropdownMenuItem(
                                        value: item.id,
                                        child: Text(item.name),
                                      ),
                                  ],
                                  onChanged: (v) {
                                    setState(() => _forcedItemId = v);
                                    ai.setForcedItem(v);
                                  },
                                ),
                                const SizedBox(height: 12),
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Force confidence'),
                                  value: _forceConfidence,
                                  onChanged: (v) {
                                    setState(() => _forceConfidence = v);
                                    ai.setForcedConfidence(
                                        v ? _confidence : null);
                                  },
                                ),
                                Slider(
                                  value: _confidence,
                                  min: 0.3,
                                  max: 1.0,
                                  divisions: 14,
                                  label: '${(_confidence * 100).round()}%',
                                  onChanged: _forceConfidence
                                      ? (v) {
                                          setState(() => _confidence = v);
                                          ai.setForcedConfidence(v);
                                        }
                                      : null,
                                ),
                                Text(
                                  'Threshold is ${(kiosk.config.aiConfidenceThreshold * 100).round()}%. '
                                  'Below it → General Waste.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          // ---- Fault injection ----
                          _PanelCard(
                            title: 'Fault injection',
                            icon: Icons.warning_amber,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ToggleRow(
                                  label: 'Camera available',
                                  value: hwStatusCamera(ref),
                                  onChanged: (v) => hw.setCameraAvailable(v),
                                ),
                                _ToggleRow(
                                  label: 'Card reader available',
                                  value: hwStatusReader(ref),
                                  onChanged: (v) =>
                                      hw.setCardReaderAvailable(v),
                                ),
                                _ToggleRow(
                                  label: 'Controller connected',
                                  value: hwStatusController(ref),
                                  onChanged: (v) =>
                                      hw.setControllerConnected(v),
                                ),
                                const Divider(),
                                _ToggleRow(
                                  label: 'AI error / timeout',
                                  value: false,
                                  onChanged: (v) => ai.setForceError(v),
                                ),
                                _ToggleRow(
                                  label: 'AI offline fallback',
                                  value: false,
                                  onChanged: (v) => ai.setOfflineFallback(v),
                                ),
                                _ToggleRow(
                                  label: 'Kiosk offline mode',
                                  value: kiosk.isOffline,
                                  onChanged: (v) => controller.setOffline(v),
                                ),
                              ],
                            ),
                          ),

                          // ---- Sensors & fill ----
                          _PanelCard(
                            title: 'Sensors & fill levels',
                            icon: Icons.sensors,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ToggleRow(
                                  label: 'Waste presence detected',
                                  value: hwStatusPresence(ref),
                                  onChanged: (v) => hw.setWastePresence(v),
                                ),
                                const SizedBox(height: 8),
                                for (final c in WasteCategory.values)
                                  _FillSlider(
                                    category: c,
                                    value: hwFill(ref, c),
                                    onChanged: (v) => hw.setFillLevel(c, v),
                                  ),
                              ],
                            ),
                          ),

                          // ---- LED & slot commands ----
                          _PanelCard(
                            title: 'LED & slot commands',
                            icon: Icons.lightbulb,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (final c in WasteCategory.values)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 90,
                                          child: Text(
                                            c.label,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        _LedDot(
                                          colour: AppColors.success,
                                          onTap: () => hw.setSlotLed(
                                              c, FeedbackColour.green),
                                        ),
                                        const SizedBox(width: 6),
                                        _LedDot(
                                          colour: AppColors.error,
                                          onTap: () => hw.setSlotLed(
                                              c, FeedbackColour.red),
                                        ),
                                        const Spacer(),
                                        TextButton.icon(
                                          onPressed: () =>
                                              hw.sendOpenSlotCommand(c),
                                          icon: const Icon(
                                              Icons.open_in_full, size: 16),
                                          label: const Text('Open'),
                                        ),
                                      ],
                                    ),
                                  ),
                                _DevButton(
                                  label: 'Clear all LEDs',
                                  icon: Icons.lightbulb_outline,
                                  colour: AppColors.inkMuted,
                                  onTap: hw.clearAllLeds,
                                ),
                              ],
                            ),
                          ),

                          // ---- Session ----
                          _PanelCard(
                            title: 'Session',
                            icon: Icons.restart_alt,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _DevButton(
                                  label: 'Reset full session',
                                  icon: Icons.restart_alt,
                                  colour: AppColors.error,
                                  onTap: () => controller.endSession(),
                                ),
                                const SizedBox(height: 8),
                                _DevButton(
                                  label: 'Enter maintenance mode',
                                  icon: Icons.build,
                                  colour: AppColors.warning,
                                  onTap: controller.enterMaintenance,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Helpers reading the latest hardware snapshot from the kiosk status stream.
  bool hwStatusCamera(WidgetRef ref) => _snap(ref).cameraAvailable;
  bool hwStatusReader(WidgetRef ref) => _snap(ref).cardReaderAvailable;
  bool hwStatusController(WidgetRef ref) => _snap(ref).controllerConnected;
  bool hwStatusPresence(WidgetRef ref) => _snap(ref).wastePresenceDetected;
  double hwFill(WidgetRef ref, WasteCategory c) =>
      _snap(ref).binFillLevels[c] ?? 0;

  _HwSnap _snap(WidgetRef ref) {
    final async = ref.watch(hardwareStatusStreamProvider);
    return async.maybeWhen(
      data: (s) => _HwSnap(
        cameraAvailable: s.cameraAvailable,
        cardReaderAvailable: s.cardReaderAvailable,
        controllerConnected: s.controllerConnected,
        wastePresenceDetected: s.wastePresenceDetected,
        binFillLevels: s.binFillLevels,
      ),
      orElse: () => const _HwSnap(
        cameraAvailable: true,
        cardReaderAvailable: true,
        controllerConnected: true,
        wastePresenceDetected: false,
        binFillLevels: {},
      ),
    );
  }
}

class _HwSnap {
  const _HwSnap({
    required this.cameraAvailable,
    required this.cardReaderAvailable,
    required this.controllerConnected,
    required this.wastePresenceDetected,
    required this.binFillLevels,
  });
  final bool cameraAvailable;
  final bool cardReaderAvailable;
  final bool controllerConnected;
  final bool wastePresenceDetected;
  final Map<WasteCategory, double> binFillLevels;
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.state,
    required this.offline,
    required this.queued,
  });
  final String state;
  final bool offline;
  final int queued;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.developer_board, color: Colors.white),
          const SizedBox(width: 12),
          Text(
            'Kiosk state: ',
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            state,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (offline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.warning,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'OFFLINE · $queued queued',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.icon,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: EcoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _DevButton extends StatelessWidget {
  const _DevButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.colour = AppColors.primary,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(label),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: colour,
        side: BorderSide(color: colour.withValues(alpha: 0.4)),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _FillSlider extends StatelessWidget {
  const _FillSlider({
    required this.category,
    required this.value,
    required this.onChanged,
  });
  final WasteCategory category;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(category.label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: Slider(
            value: value.clamp(0.0, 1.0),
            onChanged: onChanged,
            activeColor: category.colour,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text('${(value * 100).round()}%',
              style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}

class _LedDot extends StatelessWidget {
  const _LedDot({required this.colour, required this.onTap});
  final Color colour;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: colour.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: colour, width: 2),
        ),
        child: Icon(Icons.circle, size: 12, color: colour),
      ),
    );
  }
}
