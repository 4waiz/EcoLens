import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/models/dashboard_models.dart';
import 'eco_card.dart';

/// A responsive grid of headline metric tiles from [MetricValue]s.
class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.metrics, this.accent});

  final List<MetricValue> metrics;
  final Color? accent;

  static const _accents = [
    (AppColors.primary, AppColors.primarySurface),
    (AppColors.xpPurple, AppColors.xpPurpleSurface),
    (AppColors.coinGoldDark, AppColors.coinGoldSurface),
    (AppColors.info, Color(0xFFE7F0FB)),
  ];

  static const _icons = [
    Icons.groups_outlined,
    Icons.recycling,
    Icons.verified_outlined,
    Icons.star_outline,
  ];

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 560
            ? 1
            : constraints.maxWidth < 900
                ? 2
                : metrics.length.clamp(1, 4);
        const spacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < metrics.length; i++)
              SizedBox(
                width: itemWidth,
                child: StatTile(
                  label: metrics[i].label,
                  value: metrics[i].value,
                  caption: metrics[i].caption.isEmpty ? null : metrics[i].caption,
                  delta: metrics[i].delta.isEmpty ? null : metrics[i].delta,
                  deltaPositive: metrics[i].deltaPositive,
                  icon: _icons[i % _icons.length],
                  accent: _accents[i % _accents.length].$1,
                  accentSurface: _accents[i % _accents.length].$2,
                ),
              ),
          ],
        );
      },
    );
  }
}
