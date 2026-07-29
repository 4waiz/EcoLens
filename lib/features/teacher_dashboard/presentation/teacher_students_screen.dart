import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/models/models.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/house_badge.dart';
import '../../../shared/responsive/responsive.dart';
import 'teacher_nav.dart';

final _studentsProvider = FutureProvider.autoDispose((ref) async {
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  final houses = await ref.watch(houseRepositoryProvider).getAllHouses();
  return (students: students, houses: {for (final h in houses) h.id: h});
});

/// Teacher students list with search + filter. Rows link to the detail screen.
class TeacherStudentsScreen extends ConsumerStatefulWidget {
  const TeacherStudentsScreen({super.key});

  @override
  ConsumerState<TeacherStudentsScreen> createState() =>
      _TeacherStudentsScreenState();
}

class _TeacherStudentsScreenState extends ConsumerState<TeacherStudentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_studentsProvider);
    return TeacherScaffold(
      title: 'Students',
      currentRoute: AppRoutes.teacherStudents,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load students.',
          onRetry: () => ref.invalidate(_studentsProvider),
        ),
        data: (data) {
          final filtered = data.students.where((s) {
            final q = _query.toLowerCase();
            return q.isEmpty ||
                s.fullName.toLowerCase().contains(q) ||
                s.className.toLowerCase().contains(q);
          }).toList()..sort((a, b) => b.totalXp.compareTo(a.totalXp));

          return ContentBounds(
            maxWidth: 1400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name or class…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filtered.isEmpty
                      ? const EmptyView(
                          title: 'No students found',
                          subtitle: 'Try a different search.',
                        )
                      : EcoCard(
                          padding: EdgeInsets.zero,
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) => _StudentRow(
                              student: filtered[i],
                              house: data.houses[filtered[i].houseId],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student, required this.house});
  final Student student;
  final House? house;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(AppRoutes.teacherStudentDetailPath(student.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primarySurface,
              child: Text(
                student.firstName.characters.first,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Grade ${student.grade} · ${student.className}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (house != null)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: HouseChip(
                    name: house!.name,
                    colourHex: house!.colour,
                    emblem: house!.emblem,
                  ),
                ),
              ),
            _MiniStat(
              label: 'XP',
              value: '${student.totalXp}',
              colour: AppColors.xpPurple,
            ),
            _MiniStat(
              label: 'Accuracy',
              value: '${(student.accuracy * 100).round()}%',
              colour: AppColors.success,
            ),
            _MiniStat(
              label: 'Streak',
              value: '${student.currentStreak}',
              colour: AppColors.error,
            ),
            const Icon(Icons.chevron_right, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.colour,
  });
  final String label;
  final String value;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w800, color: colour),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
