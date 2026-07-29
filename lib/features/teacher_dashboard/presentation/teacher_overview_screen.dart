import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/models/dashboard_models.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/stat_grid.dart';
import '../../../shared/responsive/responsive.dart';
import 'teacher_nav.dart';

/// Teacher overview: headline metrics, participation trend, top classes/houses,
/// and common mistakes. Reads live analytics from the mock dashboard service.
class TeacherOverviewScreen extends ConsumerWidget {
  const TeacherOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(teacherOverviewProvider);
    return TeacherScaffold(
      title: 'Overview',
      currentRoute: AppRoutes.teacherOverview,
      child: overviewAsync.when(
        loading: () => const LoadingView(message: 'Crunching the numbers…'),
        error: (e, _) => ErrorView(
          message: 'Could not load the overview.',
          onRetry: () => ref.invalidate(teacherOverviewProvider),
        ),
        data: (o) => _OverviewBody(overview: o),
      ),
    );
  }
}

/// Provider for teacher overview analytics.
final teacherOverviewProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(dashboardServiceProvider).getTeacherOverview();
});

class _OverviewBody extends StatelessWidget {
  const _OverviewBody({required this.overview});
  final TeacherOverview overview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentBounds(
        maxWidth: 1500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Great work this week 🌱',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'A snapshot of recycling activity and learning across your classes.',
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
                        title: 'Weekly participation',
                        subtitle: 'Recycling sessions per day',
                        icon: Icons.show_chart,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: _ParticipationChart(
                          points: overview.participationTrend,
                        ),
                      ),
                    ],
                  ),
                );
                final rates = _RatesCard(overview: overview);
                if (!wide) {
                  return Column(
                    children: [trend, const SizedBox(height: 16), rates],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: trend),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: rates),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 900;
                final houses = _TopList(
                  title: 'Top houses',
                  icon: Icons.shield_outlined,
                  items: overview.topHouses,
                );
                final classes = _TopList(
                  title: 'Top classes',
                  icon: Icons.class_outlined,
                  items: overview.topClasses,
                );
                final mistakes = _CommonMistakesCard(
                  mistakes: overview.commonMistakes,
                );
                if (!wide) {
                  return Column(
                    children: [
                      houses,
                      const SizedBox(height: 16),
                      classes,
                      const SizedBox(height: 16),
                      mistakes,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: houses),
                    const SizedBox(width: 16),
                    Expanded(child: classes),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: mistakes),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ParticipationChart extends StatelessWidget {
  const _ParticipationChart({required this.points});
  final List<TrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const EmptyView(title: 'No activity yet');
    }
    final maxY = points
        .map((p) => p.value)
        .fold<double>(0, (a, b) => b > a ? b : a);
    return BarChart(
      duration: Duration.zero, // instant render (test-safe, no looping anim)
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
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    points[i].label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
                    colors: [AppColors.info, AppColors.plastic],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _RatesCard extends StatelessWidget {
  const _RatesCard({required this.overview});
  final TeacherOverview overview;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Key rates', icon: Icons.speed),
          const SizedBox(height: 20),
          _RadialRate(
            label: 'Correct classification',
            value: overview.correctClassificationRate,
            colour: AppColors.success,
          ),
          const SizedBox(height: 16),
          _RadialRate(
            label: 'Participation',
            value: overview.participationRate,
            colour: AppColors.xpPurple,
          ),
        ],
      ),
    );
  }
}

class _RadialRate extends StatelessWidget {
  const _RadialRate({
    required this.label,
    required this.value,
    required this.colour,
  });
  final String label;
  final double value;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                backgroundColor: colour.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(colour),
              ),
              Text(
                '${(value * 100).round()}%',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.titleSmall),
        ),
      ],
    );
  }
}

class _TopList extends StatelessWidget {
  const _TopList({
    required this.title,
    required this.icon,
    required this.items,
  });
  final String title;
  final IconData icon;
  final List<LeaderboardMini> items;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title, icon: icon),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No data yet'),
            )
          else
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${item.points}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.fromHex(item.colour),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: item.progress,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(
                          AppColors.fromHex(item.colour),
                        ),
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

class _CommonMistakesCard extends StatelessWidget {
  const _CommonMistakesCard({required this.mistakes});
  final List<CommonMistake> mistakes;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Common mistakes',
            subtitle: 'Where students need a little help',
            icon: Icons.psychology_alt_outlined,
          ),
          const SizedBox(height: 12),
          if (mistakes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('No mistakes recorded — great sorting!'),
            )
          else
            for (final m in mistakes.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      m.chosenCategory.icon,
                      color: m.chosenCategory.colour,
                      size: 20,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.inkFaint,
                    ),
                    Icon(
                      m.correctCategory.icon,
                      color: m.correctCategory.colour,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${m.exampleItem.isNotEmpty ? m.exampleItem : m.correctCategory.label} · '
                        'put in ${m.chosenCategory.shortLabel} instead of '
                        '${m.correctCategory.shortLabel}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${m.occurrences}×',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
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
