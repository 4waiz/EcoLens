import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/enums/app_enums.dart';
import '../../../domain/models/dashboard_models.dart';
import '../../../domain/models/kiosk_device.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/stat_grid.dart';
import '../../../shared/responsive/responsive.dart';
import 'admin_nav.dart';

/// Admin overview analytics (headline metrics, weekly sessions, category
/// breakdown) sourced from the mock dashboard service.
final adminOverviewProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(dashboardServiceProvider).getAdminOverview(),
);

/// Kiosk fleet used for the health-at-a-glance strip.
final _overviewDevicesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(deviceRepositoryProvider).getDevices(),
);

/// Maps a [HealthStatus] to a display colour.
Color healthColour(HealthStatus status) => switch (status) {
      HealthStatus.online => AppColors.success,
      HealthStatus.degraded => AppColors.warning,
      HealthStatus.offline => AppColors.error,
      HealthStatus.maintenance => AppColors.info,
      HealthStatus.unknown => AppColors.inkFaint,
    };

class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(adminOverviewProvider);
    return AdminScaffold(
      title: 'Overview',
      currentRoute: AppRoutes.adminOverview,
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: () {
            ref.invalidate(adminOverviewProvider);
            ref.invalidate(_overviewDevicesProvider);
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: overviewAsync.when(
        loading: () => const LoadingView(message: 'Crunching the numbers…'),
        error: (e, _) => ErrorView(
          message: 'Could not load the overview.',
          onRetry: () => ref.invalidate(adminOverviewProvider),
        ),
        data: (o) => _OverviewBody(overview: o),
      ),
    );
  }
}

class _OverviewBody extends StatelessWidget {
  const _OverviewBody({required this.overview});
  final AdminOverview overview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentBounds(
        maxWidth: 1500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System at a glance 🛠️',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Live health, activity and recycling accuracy across every kiosk.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            StatGrid(metrics: overview.headlineMetrics),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 900;
                final trend = EcoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: 'Weekly sessions',
                        subtitle: 'Recycling sessions per day',
                        icon: Icons.show_chart,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child:
                            _WeeklySessionsChart(points: overview.weeklySessions),
                      ),
                    ],
                  ),
                );
                final breakdown =
                    _CategoryBreakdownCard(items: overview.categoryBreakdown);
                if (!wide) {
                  return Column(
                    children: [trend, const SizedBox(height: 16), breakdown],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: trend),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: breakdown),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const _KioskHealthStrip(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WeeklySessionsChart extends StatelessWidget {
  const _WeeklySessionsChart({required this.points});
  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const EmptyView(title: 'No activity yet');
    }
    final maxY =
        points.map((p) => p.value).fold<double>(0, (a, b) => b > a ? b : a);
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxY * 1.3).clamp(5, double.infinity),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(points[i].label,
                      style: Theme.of(context).textTheme.bodySmall),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < points.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: points[i].value,
                  width: 22,
                  borderRadius: BorderRadius.circular(6),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [AppColors.xpPurple, AppColors.xpPurpleDark],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({required this.items});
  final List<CategoryBreakdown> items;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Items by category',
            subtitle: 'Share of everything processed',
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No items processed yet'),
            )
          else
            for (final c in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(c.category.icon, color: c.category.colour, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c.category.label,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${c.count} · ${(c.share * 100).round()}%',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: c.category.colour,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: c.share.clamp(0, 1),
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(c.category.colour),
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

class _KioskHealthStrip extends ConsumerWidget {
  const _KioskHealthStrip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(_overviewDevicesProvider);
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Kiosk health',
            subtitle: 'A live glance at every device',
            icon: Icons.devices_other_outlined,
            trailing: TextButton(
              onPressed: () => context.go(AppRoutes.adminKiosks),
              child: const Text('Manage'),
            ),
          ),
          const SizedBox(height: 12),
          devicesAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: LoadingView(message: 'Checking devices…'),
            ),
            error: (e, _) => const Text('Could not load device health.'),
            data: (devices) {
              if (devices.isEmpty) {
                return const Text('No kiosks registered.');
              }
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [for (final d in devices) _KioskChip(device: d)],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _KioskChip extends StatelessWidget {
  const _KioskChip({required this.device});
  final KioskDevice device;

  @override
  Widget build(BuildContext context) {
    final colour = healthColour(device.health);
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colour.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  device.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            device.health.label,
            style: TextStyle(color: colour, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            '${device.sessionsToday} sessions today',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
