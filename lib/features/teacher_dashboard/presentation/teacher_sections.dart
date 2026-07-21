import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/enums/waste_category.dart';
import '../../../domain/models/models.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/house_badge.dart';
import '../../../shared/responsive/responsive.dart';
import 'teacher_nav.dart';

// -----------------------------------------------------------------------------
// Classes
// -----------------------------------------------------------------------------
final _classesProvider = FutureProvider.autoDispose((ref) async {
  final classes = await ref.watch(classRepositoryProvider).getAllClasses();
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  return classes.map((c) {
    final members = students.where((s) => s.className == c.name).toList();
    final xp = members.fold<int>(0, (a, s) => a + s.totalXp);
    final acc = members.isEmpty
        ? 0.0
        : members.map((s) => s.accuracy).reduce((a, b) => a + b) /
            members.length;
    return (schoolClass: c, members: members.length, xp: xp, accuracy: acc);
  }).toList();
});

class TeacherClassesScreen extends ConsumerWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_classesProvider);
    return TeacherScaffold(
      title: 'Classes',
      currentRoute: AppRoutes.teacherClasses,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load classes.'),
        data: (rows) => ContentBounds(
          child: GridView.count(
            crossAxisCount: context.dashboardColumns,
            childAspectRatio: 1.6,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              for (final r in rows)
                EcoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primarySurface,
                            child: Text('${r.schoolClass.grade}',
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Text('Class ${r.schoolClass.name}',
                              style:
                                  Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _kv('Students', '${r.members}'),
                          _kv('Class XP', '${r.xp}'),
                          _kv('Accuracy', '${(r.accuracy * 100).round()}%'),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800)),
          Text(k, style: const TextStyle(color: AppColors.inkMuted)),
        ],
      );
}

// -----------------------------------------------------------------------------
// Houses
// -----------------------------------------------------------------------------
final _housesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(houseRepositoryProvider).getAllHouses(),
);

class TeacherHousesScreen extends ConsumerWidget {
  const TeacherHousesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_housesProvider);
    return TeacherScaffold(
      title: 'Houses',
      currentRoute: AppRoutes.teacherHouses,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load houses.'),
        data: (houses) {
          final sorted = [...houses]
            ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
          return ContentBounds(
            child: GridView.count(
              crossAxisCount: context.isDesktop ? 2 : 1,
              childAspectRatio: 2.4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [for (final h in sorted) _HouseCard(house: h)],
            ),
          );
        },
      ),
    );
  }
}

class _HouseCard extends StatelessWidget {
  const _HouseCard({required this.house});
  final House house;

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(house.colour);
    return EcoCard(
      borderColor: colour.withValues(alpha: 0.4),
      child: Row(
        children: [
          HouseBadge(emblem: house.emblem, colourHex: house.colour, size: 64),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${house.name} House',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('${house.totalPoints} points · rank #${house.leaderboardPosition}',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text(house.sustainabilityGoal,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: house.goalProgress,
                    minHeight: 8,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(colour),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${(house.goalProgress * 100).round()}% to goal',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Leaderboards
// -----------------------------------------------------------------------------
final _leaderboardsProvider = FutureProvider.autoDispose((ref) async {
  final svc = ref.watch(leaderboardServiceProvider);
  final students = await svc.getStudentLeaderboard(limit: 12);
  final houses = await svc.getHouseLeaderboard();
  final classes = await svc.getClassLeaderboard();
  return (students: students, houses: houses, classes: classes);
});

class TeacherLeaderboardsScreen extends ConsumerWidget {
  const TeacherLeaderboardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_leaderboardsProvider);
    return TeacherScaffold(
      title: 'Leaderboards',
      currentRoute: AppRoutes.teacherLeaderboards,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load leaderboards.'),
        data: (data) => DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const Material(
                color: Colors.transparent,
                child: TabBar(
                  labelColor: AppColors.info,
                  indicatorColor: AppColors.info,
                  tabs: [
                    Tab(text: 'Students'),
                    Tab(text: 'Houses'),
                    Tab(text: 'Classes'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _LeaderboardList(entries: data.students),
                    _LeaderboardList(entries: data.houses),
                    _LeaderboardList(entries: data.classes),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({required this.entries});
  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ContentBounds(
      child: ListView.separated(
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final e = entries[i];
          final colour = AppColors.fromHex(e.houseColour);
          return EcoCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text('#${e.rank}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 18)),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colour.withValues(alpha: 0.15),
                  child: Text(e.entityName.characters.first,
                      style: TextStyle(
                          color: colour, fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.entityName,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      if (e.subtitle.isNotEmpty)
                        Text(e.subtitle,
                            style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                Text('${e.totalPoints} pts',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, color: colour)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Accuracy
// -----------------------------------------------------------------------------
final _accuracyProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(dashboardServiceProvider).getAccuracyMetrics(),
);

class TeacherAccuracyScreen extends ConsumerWidget {
  const TeacherAccuracyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_accuracyProvider);
    return TeacherScaffold(
      title: 'Accuracy',
      currentRoute: AppRoutes.teacherAccuracy,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load accuracy.'),
        data: (m) => SingleChildScrollView(
          child: ContentBounds(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EcoCard(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: m.overallAccuracy,
                              strokeWidth: 10,
                              backgroundColor:
                                  AppColors.success.withValues(alpha: 0.15),
                              valueColor: const AlwaysStoppedAnimation(
                                  AppColors.success),
                            ),
                            Text('${(m.overallAccuracy * 100).round()}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Overall classification accuracy',
                                style:
                                    Theme.of(context).textTheme.titleLarge),
                            Text(
                                'Across all recorded recycling sessions this term.',
                                style:
                                    Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                EcoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                          title: 'Accuracy by category',
                          icon: Icons.category_outlined),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: _CategoryAccuracyChart(data: m.perCategory),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _MistakesCard(mistakes: m.commonMistakes),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryAccuracyChart extends StatelessWidget {
  const _CategoryAccuracyChart({required this.data});
  final List<CategoryAccuracy> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const EmptyView(title: 'No data');
    return BarChart(
      BarChartData(
        maxY: 100,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 32)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(data[i].category.shortLabel,
                      style: Theme.of(context).textTheme.bodySmall),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < data.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: data[i].accuracy * 100,
                width: 30,
                borderRadius: BorderRadius.circular(6),
                color: data[i].category.colour,
              ),
            ]),
        ],
      ),
    );
  }
}

class _MistakesCard extends StatelessWidget {
  const _MistakesCard({required this.mistakes});
  final List<CommonMistake> mistakes;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              title: 'Most common mistakes',
              icon: Icons.psychology_alt_outlined),
          const SizedBox(height: 12),
          if (mistakes.isEmpty)
            const Text('No mistakes recorded.')
          else
            for (final m in mistakes.take(6))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(m.chosenCategory.icon,
                        color: m.chosenCategory.colour, size: 20),
                    const Icon(Icons.arrow_forward,
                        size: 16, color: AppColors.inkFaint),
                    Icon(m.correctCategory.icon,
                        color: m.correctCategory.colour, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Put ${m.correctCategory.shortLabel} items in '
                        '${m.chosenCategory.shortLabel} (${m.occurrences}×)',
                        style: Theme.of(context).textTheme.bodyMedium,
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

// -----------------------------------------------------------------------------
// Rewards (teacher view — read-only summary)
// -----------------------------------------------------------------------------
final _rewardUsageProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(dashboardServiceProvider).getRewardUsageSummary(),
);

class TeacherRewardsScreen extends ConsumerWidget {
  const TeacherRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_rewardUsageProvider);
    return TeacherScaffold(
      title: 'Rewards',
      currentRoute: AppRoutes.teacherRewards,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => const ErrorView(message: 'Could not load rewards.'),
        data: (txns) => ContentBounds(
          child: txns.isEmpty
              ? const EmptyView(
                  title: 'No redemptions yet',
                  icon: Icons.card_giftcard_outlined,
                )
              : EcoCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    itemCount: txns.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final t = txns[i];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.coinGoldSurface,
                          child: Icon(
                            t.isDebit
                                ? Icons.redeem
                                : Icons.add_circle_outline,
                            color: AppColors.coinGoldDark,
                          ),
                        ),
                        title: Text(t.description),
                        subtitle: Text(t.type.label),
                        trailing: Text(
                          '${t.points > 0 ? '+' : ''}${t.points} pts',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: t.isDebit
                                ? AppColors.error
                                : AppColors.success,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Reports
// -----------------------------------------------------------------------------
class TeacherReportsScreen extends ConsumerStatefulWidget {
  const TeacherReportsScreen({super.key});

  @override
  ConsumerState<TeacherReportsScreen> createState() =>
      _TeacherReportsScreenState();
}

class _TeacherReportsScreenState extends ConsumerState<TeacherReportsScreen> {
  String _range = 'This week';
  String _classFilter = 'All classes';
  WasteCategory? _category;

  @override
  Widget build(BuildContext context) {
    return TeacherScaffold(
      title: 'Reports',
      currentRoute: AppRoutes.teacherReports,
      child: ContentBounds(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EcoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Build a report',
                      subtitle: 'Filter, preview, then export or print',
                      icon: Icons.tune,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _dropdown('Date range', _range,
                            ['Today', 'This week', 'This month', 'This term'],
                            (v) => setState(() => _range = v)),
                        _dropdown('Class', _classFilter,
                            ['All classes', '4A', '4B', '5A', '5B'],
                            (v) => setState(() => _classFilter = v)),
                        _categoryDropdown(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () => _simulateExport(context, 'CSV'),
                          icon: const Icon(Icons.download),
                          label: const Text('Export CSV'),
                          style: FilledButton.styleFrom(
                              backgroundColor: AppColors.info),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => _simulateExport(context, 'PDF'),
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Export PDF'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () => _simulateExport(context, 'print'),
                          icon: const Icon(Icons.print_outlined),
                          label: const Text('Print'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ReportPreview(
                range: _range,
                classFilter: _classFilter,
                category: _category,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items,
      ValueChanged<String> onChanged) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final i in items) DropdownMenuItem(value: i, child: Text(i)),
        ],
        onChanged: (v) => v == null ? null : onChanged(v),
      ),
    );
  }

  Widget _categoryDropdown() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<WasteCategory?>(
        initialValue: _category,
        decoration: const InputDecoration(labelText: 'Waste category'),
        items: [
          const DropdownMenuItem(value: null, child: Text('All categories')),
          for (final c in WasteCategory.values)
            DropdownMenuItem(value: c, child: Text(c.label)),
        ],
        onChanged: (v) => setState(() => _category = v),
      ),
    );
  }

  void _simulateExport(BuildContext context, String kind) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(kind == 'print'
            ? 'Preparing a printable report ($_range · $_classFilter)…'
            : 'Exported $kind report ($_range · $_classFilter). '
                '(Simulated in the MVP.)'),
      ),
    );
  }
}

class _ReportPreview extends ConsumerWidget {
  const _ReportPreview({
    required this.range,
    required this.classFilter,
    required this.category,
  });
  final String range;
  final String classFilter;
  final WasteCategory? category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(_reportSessionsProvider);
    return EcoCard(
      child: sessionsAsync.when(
        loading: () => const SizedBox(
          height: 120,
          child: LoadingView(),
        ),
        error: (e, _) => const Text('Could not load report data.'),
        data: (sessions) {
          var rows = sessions.where((s) {
            final okClass = classFilter == 'All classes' ||
                (s.$2?.className == classFilter);
            final okCat = category == null || s.$1.finalCategory == category;
            return okClass && okCat;
          }).toList();
          final correct = rows.where((r) => r.$1.wasCorrect).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Preview · $range',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  Text('${rows.length} sessions · $correct correct',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 12),
              // Printable-style table.
              _table(context, rows.take(12).toList()),
            ],
          );
        },
      ),
    );
  }

  Widget _table(BuildContext context,
      List<(RecyclingSession, Student?)> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Student')),
          DataColumn(label: Text('Class')),
          DataColumn(label: Text('Item')),
          DataColumn(label: Text('Category')),
          DataColumn(label: Text('Result')),
          DataColumn(label: Text('Points')),
        ],
        rows: [
          for (final r in rows)
            DataRow(cells: [
              DataCell(Text(r.$2?.firstName ?? '—')),
              DataCell(Text(r.$2?.className ?? '—')),
              DataCell(Text(
                  r.$1.classificationResult?.detectedObjectName ?? '—')),
              DataCell(Text(r.$1.finalCategory?.shortLabel ?? '—')),
              DataCell(Text(r.$1.wasCorrect ? 'Correct' : 'Incorrect',
                  style: TextStyle(
                      color: r.$1.wasCorrect
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600))),
              DataCell(Text('${r.$1.pointsAwarded}')),
            ]),
        ],
      ),
    );
  }
}

final _reportSessionsProvider = FutureProvider.autoDispose((ref) async {
  final sessions =
      await ref.watch(sessionRepositoryProvider).getRecentSessions(limit: 60);
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  final byId = {for (final s in students) s.id: s};
  return [for (final s in sessions) (s, byId[s.studentId])];
});

// -----------------------------------------------------------------------------
// Announcements
// -----------------------------------------------------------------------------
class TeacherAnnouncementsScreen extends ConsumerStatefulWidget {
  const TeacherAnnouncementsScreen({super.key});

  @override
  ConsumerState<TeacherAnnouncementsScreen> createState() =>
      _TeacherAnnouncementsScreenState();
}

class _TeacherAnnouncementsScreenState
    extends ConsumerState<TeacherAnnouncementsScreen> {
  final _controller = TextEditingController();
  final List<(String, DateTime)> _posts = [
    ('Taurus House is smashing the plastic recycling goal — keep it up! 🌱',
        DateTime(2026, 7, 20, 9)),
    ('Reminder: bring clean recyclables. Rinse those yoghurt pots!',
        DateTime(2026, 7, 18, 14)),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TeacherScaffold(
      title: 'Announcements',
      currentRoute: AppRoutes.teacherAnnouncements,
      child: ContentBounds(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                      title: 'Post an announcement',
                      icon: Icons.campaign_outlined),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Share an eco-tip or celebrate a class win…',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (_controller.text.trim().isEmpty) return;
                        setState(() {
                          _posts.insert(
                              0, (_controller.text.trim(), DateTime(2026, 7, 21)));
                          _controller.clear();
                        });
                      },
                      icon: const Icon(Icons.send),
                      label: const Text('Post'),
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: _posts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) => EcoCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primarySurface,
                        child: Icon(Icons.eco, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_posts[i].$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              '${_posts[i].$2.day}/${_posts[i].$2.month}/${_posts[i].$2.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
