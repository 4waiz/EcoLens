import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// A rounded, softly-shadowed surface — the base card used across EcoLens.
class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.borderColor,
    this.onTap,
    this.elevated = true,
    this.radius = AppRadius.lg,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final Color? borderColor;
  final VoidCallback? onTap;
  final bool elevated;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? AppColors.border),
        boxShadow: elevated ? AppShadows.soft : null,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: content,
      ),
    );
  }
}

/// A titled section header with optional trailing widget.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (subtitle case final s?)
                Text(s, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// A compact statistic tile (icon + big number + label). Used on kiosk profile,
/// dashboards and overview grids.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accent = AppColors.primary,
    this.accentSurface = AppColors.primarySurface,
    this.caption,
    this.delta,
    this.deltaPositive = true,
    this.large = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color accent;
  final Color accentSurface;
  final String? caption;
  final String? delta;
  final bool deltaPositive;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EcoCard(
      padding: EdgeInsets.all(large ? 24 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: large ? 48 : 40,
                  height: large ? 48 : 40,
                  decoration: BoxDecoration(
                    color: accentSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accent, size: large ? 26 : 22),
                ),
              const Spacer(),
              if (delta != null && delta!.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (deltaPositive
                            ? AppColors.success
                            : AppColors.error)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        deltaPositive
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 14,
                        color: deltaPositive
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        delta!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: deltaPositive
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: large ? 16 : 12),
          Text(
            value,
            style: (large
                    ? theme.textTheme.displaySmall
                    : theme.textTheme.headlineMedium)
                ?.copyWith(color: AppColors.ink, height: 1),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelMedium),
          if (caption != null)
            Text(
              caption!,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.inkFaint),
            ),
        ],
      ),
    );
  }
}
