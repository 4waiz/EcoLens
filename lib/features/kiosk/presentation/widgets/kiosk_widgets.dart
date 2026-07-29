import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../domain/enums/waste_category.dart';
import '../../../../domain/models/models.dart';
import '../../../../shared/components/house_badge.dart';

/// A compact stat pill (icon + value + label) used on the kiosk profile row.
class KioskStatPill extends StatelessWidget {
  const KioskStatPill({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.accent,
    required this.accentSurface,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color accent;
  final Color accentSurface;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular coloured icon badge (matches the reference design).
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accentSurface,
              shape: BoxShape.circle,
              border: Border.all(
                color: accent.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Icon(icon, color: accent, size: 28),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1,
                  color: accent,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A row of XP / points / streak stat pills for the loaded student.
class KioskStudentStatsRow extends StatelessWidget {
  const KioskStudentStatsRow({
    super.key,
    required this.student,
    this.avatarLevel,
  });

  final Student student;
  final int? avatarLevel;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        KioskStatPill(
          icon: Icons.star_rounded,
          value: '${student.totalXp}',
          label: 'Total XP',
          accent: AppColors.xpPurple,
          accentSurface: AppColors.xpPurpleSurface,
        ),
        KioskStatPill(
          icon: Icons.monetization_on_rounded,
          value: '${student.availablePoints}',
          label: 'Eco Points',
          accent: AppColors.coinGoldDark,
          accentSurface: AppColors.coinGoldSurface,
        ),
        KioskStatPill(
          icon: Icons.local_fire_department_rounded,
          value: '${student.currentStreak}',
          label: 'Day Streak',
          accent: AppColors.error,
          accentSurface: AppColors.errorSurface,
        ),
        if (avatarLevel != null)
          KioskStatPill(
            icon: Icons.military_tech_rounded,
            value: 'Lv $avatarLevel',
            label: 'Guardian',
            accent: AppColors.primary,
            accentSurface: AppColors.primarySurface,
          ),
      ],
    );
  }
}

/// A speech bubble the Guardian uses to talk to the student.
class GuardianSpeech extends StatelessWidget {
  const GuardianSpeech({
    super.key,
    required this.text,
    this.color = AppColors.primarySurface,
    this.textColor = AppColors.primaryDark,
    this.maxWidth = 460,
  });

  final String text;
  final Color color;
  final Color textColor;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            height: 1.35,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// A horizontal confidence meter for the AI result.
class ConfidenceMeter extends StatelessWidget {
  const ConfidenceMeter({
    super.key,
    required this.confidence,
    required this.threshold,
    this.width = 320,
  });

  final double confidence; // 0..1
  final double threshold; // 0..1
  final double width;

  @override
  Widget build(BuildContext context) {
    final clears = confidence >= threshold;
    final colour = clears ? AppColors.success : AppColors.warning;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI confidence',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const Spacer(),
            Text(
              '${(confidence * 100).round()}%',
              style: TextStyle(fontWeight: FontWeight.w800, color: colour),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: width,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: confidence,
                  minHeight: 12,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(colour),
                ),
              ),
              // Threshold marker.
              Positioned(
                left: width * threshold - 1,
                top: 0,
                bottom: 0,
                child: Container(width: 2, color: AppColors.ink),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Threshold ${(threshold * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// A large touch-friendly waste-category selection button for the quiz.
class WasteCategoryButton extends StatelessWidget {
  const WasteCategoryButton({
    super.key,
    required this.category,
    required this.onTap,
    this.highlighted = false,
    this.state = WasteButtonState.normal,
    this.enabled = true,
  });

  final WasteCategory category;
  final VoidCallback onTap;
  final bool highlighted;
  final WasteButtonState state;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final base = category.colour;
    Color bg;
    Color border;
    Color fg;
    switch (state) {
      case WasteButtonState.correct:
        bg = AppColors.successSurface;
        border = AppColors.success;
        fg = AppColors.success;
      case WasteButtonState.wrong:
        bg = AppColors.errorSurface;
        border = AppColors.error;
        fg = AppColors.error;
      case WasteButtonState.dimmed:
        bg = AppColors.surfaceAlt;
        border = AppColors.border;
        fg = AppColors.inkFaint;
      case WasteButtonState.normal:
        bg = AppColors.surface;
        border = highlighted ? base : AppColors.border;
        fg = base;
    }

    return Semantics(
      button: true,
      label: '${category.label} bin',
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: enabled ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: border,
                width: (highlighted || state != WasteButtonState.normal)
                    ? 3
                    : 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: base.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(category.icon, size: 34, color: base),
                ),
                const SizedBox(height: 12),
                Text(
                  category.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: state == WasteButtonState.normal
                        ? AppColors.ink
                        : fg,
                  ),
                ),
                if (state == WasteButtonState.correct) ...[
                  const SizedBox(height: 6),
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 22,
                  ),
                ] else if (state == WasteButtonState.wrong) ...[
                  const SizedBox(height: 6),
                  const Icon(Icons.cancel, color: AppColors.error, size: 22),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum WasteButtonState { normal, correct, wrong, dimmed }

/// Small house context chip used on kiosk screens.
class KioskHouseChip extends StatelessWidget {
  const KioskHouseChip({super.key, required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    return HouseChip(
      name: '${house.name} House',
      colourHex: house.colour,
      emblem: house.emblem,
    );
  }
}
