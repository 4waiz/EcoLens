import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../domain/models/models.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/guardian_avatar.dart';
import '../../../shared/components/house_badge.dart';
import '../../../shared/responsive/responsive.dart';
import 'teacher_nav.dart';

/// Loads a student + related context for the detail screen.
final _studentDetailProvider =
    FutureProvider.autoDispose.family((ref, String id) async {
  final student = await ref.watch(studentRepositoryProvider).getStudentById(id);
  if (student == null) return null;
  final house = await ref.watch(houseRepositoryProvider).getHouseById(student.houseId);
  final avatar = await ref.watch(avatarRepositoryProvider).getAvatarById(student.avatarId);
  final sessions =
      await ref.watch(sessionRepositoryProvider).getSessionsForStudent(id);
  return (student: student, house: house, avatar: avatar, sessions: sessions);
});

/// Teacher student detail — profile, guardian stage, accuracy, recent activity,
/// learning areas. Deliberately avoids exposing unnecessary sensitive data.
class TeacherStudentDetailScreen extends ConsumerWidget {
  const TeacherStudentDetailScreen({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_studentDetailProvider(studentId));
    return TeacherScaffold(
      title: 'Student',
      currentRoute: AppRoutes.teacherStudents,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load this student.',
          onRetry: () => ref.invalidate(_studentDetailProvider(studentId)),
        ),
        data: (data) {
          if (data == null) {
            return const EmptyView(
              title: 'Student not found',
              icon: Icons.person_off_outlined,
            );
          }
          return _DetailBody(
            student: data.student,
            house: data.house,
            avatar: data.avatar,
            sessions: data.sessions,
          );
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.student,
    required this.house,
    required this.avatar,
    required this.sessions,
  });

  final Student student;
  final House? house;
  final Avatar? avatar;
  final List<RecyclingSession> sessions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentBounds(
        maxWidth: 1300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => context.go(AppRoutes.teacherStudents),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('All students'),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 900;
                final profile = _ProfileCard(
                  student: student,
                  house: house,
                  avatar: avatar,
                );
                final stats = _StatsColumn(student: student, sessions: sessions);
                if (!wide) {
                  return Column(
                    children: [profile, const SizedBox(height: 16), stats],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: profile),
                    const SizedBox(width: 16),
                    Expanded(flex: 3, child: stats),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _RecentActivity(sessions: sessions),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.student,
    required this.house,
    required this.avatar,
  });
  final Student student;
  final House? house;
  final Avatar? avatar;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: GuardianAvatar(stage: avatar?.stage ?? 1, size: 160),
          ),
          Text(
            student.fullName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text('Grade ${student.grade} · Class ${student.className}'),
          const SizedBox(height: 10),
          if (house != null)
            HouseChip(
              name: '${house!.name} House',
              colourHex: house!.colour,
              emblem: house!.emblem,
            ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          _kv(context, 'Guardian stage',
              avatar != null ? 'Level ${avatar!.level}' : '—'),
          _kv(context, 'Student ID', student.maskedStudentNumber),
          _kv(context, 'Status', student.accountStatus.label),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(k, style: Theme.of(context).textTheme.bodySmall),
          const Spacer(),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatsColumn extends StatelessWidget {
  const _StatsColumn({required this.student, required this.sessions});
  final Student student;
  final List<RecyclingSession> sessions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _bigStat('Total XP', '${student.totalXp}',
                  AppColors.xpPurple, Icons.star),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bigStat('Accuracy', '${(student.accuracy * 100).round()}%',
                  AppColors.success, Icons.verified),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bigStat('Streak', '${student.currentStreak}',
                  AppColors.error, Icons.local_fire_department),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _bigStat('Correct', '${student.correctRecyclingCount}',
                  AppColors.primary, Icons.check_circle_outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bigStat('Incorrect', '${student.incorrectRecyclingCount}',
                  AppColors.warning, Icons.info_outline),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _bigStat('Points', '${student.availablePoints}',
                  AppColors.coinGoldDark, Icons.monetization_on_outlined),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _LearningAreas(sessions: sessions),
      ],
    );
  }

  Widget _bigStat(String label, String value, Color colour, IconData icon) {
    return EcoCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colour, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
          Text(label, style: const TextStyle(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _LearningAreas extends StatelessWidget {
  const _LearningAreas({required this.sessions});
  final List<RecyclingSession> sessions;

  @override
  Widget build(BuildContext context) {
    final wrong = sessions.where((s) => !s.wasCorrect).toList();
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Learning areas',
            subtitle: 'Where a little coaching helps',
            icon: Icons.tips_and_updates_outlined,
          ),
          const SizedBox(height: 12),
          if (wrong.isEmpty)
            const Text('No mistakes recently — excellent sorting! 🎉')
          else
            for (final s in wrong.take(4))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${s.classificationResult?.detectedObjectName ?? 'Item'} · '
                        'chose ${s.studentSelectedCategory?.shortLabel ?? '—'}, '
                        'correct was ${s.finalCategory?.shortLabel ?? '—'}',
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

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({required this.sessions});
  final List<RecyclingSession> sessions;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent activity',
            icon: Icons.history,
          ),
          const SizedBox(height: 12),
          if (sessions.isEmpty)
            const Text('No sessions yet.')
          else
            for (final s in sessions.take(8))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      s.wasCorrect ? Icons.check_circle : Icons.cancel,
                      color: s.wasCorrect ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.classificationResult?.detectedObjectName ?? 'Item',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (s.finalCategory != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Row(
                          children: [
                            Icon(s.finalCategory!.icon,
                                size: 16, color: s.finalCategory!.colour),
                            const SizedBox(width: 4),
                            Text(s.finalCategory!.shortLabel,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                    Text(
                      s.wasCorrect ? '+${s.pointsAwarded} pts' : '0 pts',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: s.wasCorrect
                            ? AppColors.success
                            : AppColors.inkFaint,
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
