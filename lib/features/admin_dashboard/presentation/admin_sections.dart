import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/mock/mock_seed_data.dart';
import '../../../domain/enums/app_enums.dart';
import '../../../domain/enums/waste_category.dart';
import '../../../domain/models/models.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/house_badge.dart';
import '../../../shared/responsive/responsive.dart';
import 'admin_nav.dart';
import 'admin_overview_screen.dart' show healthColour;

// =============================================================================
// Students
// =============================================================================
final _studentsProvider = FutureProvider.autoDispose((ref) async {
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  final houses = await ref.watch(houseRepositoryProvider).getAllHouses();
  final byId = {for (final h in houses) h.id: h};
  return [for (final s in students) (student: s, house: byId[s.houseId])];
});

class AdminStudentsScreen extends ConsumerStatefulWidget {
  const AdminStudentsScreen({super.key});

  @override
  ConsumerState<AdminStudentsScreen> createState() =>
      _AdminStudentsScreenState();
}

class _AdminStudentsScreenState extends ConsumerState<AdminStudentsScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_studentsProvider);
    return AdminScaffold(
      title: 'Students',
      currentRoute: AppRoutes.adminStudents,
      actions: [
        FilledButton.icon(
          onPressed: () => _openAddDialog(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Add student'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
        ),
      ],
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load students.',
          onRetry: () => ref.invalidate(_studentsProvider),
        ),
        data: (rows) {
          final filtered = rows.where((r) {
            final q = _query.toLowerCase();
            return q.isEmpty ||
                r.student.fullName.toLowerCase().contains(q) ||
                r.student.className.toLowerCase().contains(q);
          }).toList();
          return ContentBounds(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or class…',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filtered.isEmpty
                      ? const EmptyView(
                          title: 'No students match',
                          icon: Icons.groups_outlined,
                        )
                      : EcoCard(
                          padding: EdgeInsets.zero,
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final r = filtered[i];
                              return _StudentRow(
                                student: r.student,
                                house: r.house,
                                onDeactivate: () =>
                                    _deactivate(context, r.student),
                              );
                            },
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

  Future<void> _deactivate(BuildContext context, Student student) async {
    if (student.accountStatus != AccountStatus.active) return;
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(studentRepositoryProvider).deactivateStudent(student.id);
    ref.invalidate(_studentsProvider);
    messenger.showSnackBar(
      SnackBar(content: Text('${student.fullName} deactivated.')),
    );
  }

  Future<void> _openAddDialog(BuildContext context) async {
    final classes = await ref.read(classRepositoryProvider).getAllClasses();
    final houses = await ref.read(houseRepositoryProvider).getAllHouses();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => _AddStudentDialog(
        classes: classes,
        houses: houses,
        onSaved: () => ref.invalidate(_studentsProvider),
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.house,
    required this.onDeactivate,
  });
  final Student student;
  final House? house;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final active = student.accountStatus == AccountStatus.active;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.xpPurpleSurface,
        child: Text(
          student.firstName.characters.first,
          style: const TextStyle(
              color: AppColors.xpPurple, fontWeight: FontWeight.w700),
        ),
      ),
      title: Text(student.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('Grade ${student.grade} · Class ${student.className}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (house != null) ...[
            HouseChip(
                name: house!.name,
                colourHex: house!.colour,
                emblem: house!.emblem),
            const SizedBox(width: 8),
          ],
          _StatusChip(status: student.accountStatus),
          const SizedBox(width: 4),
          IconButton(
            tooltip: active ? 'Deactivate' : 'Already inactive',
            onPressed: active ? onDeactivate : null,
            icon: const Icon(Icons.person_off_outlined),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final AccountStatus status;

  @override
  Widget build(BuildContext context) {
    final colour = switch (status) {
      AccountStatus.active => AppColors.success,
      AccountStatus.suspended => AppColors.warning,
      AccountStatus.archived => AppColors.inkFaint,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
            color: colour, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _AddStudentDialog extends ConsumerStatefulWidget {
  const _AddStudentDialog({
    required this.classes,
    required this.houses,
    required this.onSaved,
  });
  final List<SchoolClass> classes;
  final List<House> houses;
  final VoidCallback onSaved;

  @override
  ConsumerState<_AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends ConsumerState<_AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  SchoolClass? _class;
  House? _house;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _class = widget.classes.isNotEmpty ? widget.classes.first : null;
    _house = widget.houses.isNotEmpty ? widget.houses.first : null;
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_class == null || _house == null) return;
    setState(() => _saving = true);
    final id = 'stu-${DateTime.now().millisecondsSinceEpoch}';
    final student = Student(
      id: id,
      studentNumber: 'STU-2026-${id.hashCode.abs() % 10000}'.padRight(13, '0'),
      firstName: _first.text.trim(),
      lastName: _last.text.trim(),
      grade: _class!.grade,
      className: _class!.name,
      houseId: _house!.id,
      avatarId: 'avatar-liam',
    );
    await ref.read(studentRepositoryProvider).upsertStudent(student);
    widget.onSaved();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add student'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _first,
                decoration: const InputDecoration(labelText: 'First name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _last,
                decoration: const InputDecoration(labelText: 'Last name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SchoolClass>(
                initialValue: _class,
                decoration: const InputDecoration(labelText: 'Class'),
                items: [
                  for (final c in widget.classes)
                    DropdownMenuItem(
                        value: c, child: Text('${c.name} (Grade ${c.grade})')),
                ],
                onChanged: (v) => setState(() => _class = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<House>(
                initialValue: _house,
                decoration: const InputDecoration(labelText: 'House'),
                items: [
                  for (final h in widget.houses)
                    DropdownMenuItem(value: h, child: Text(h.name)),
                ],
                onChanged: (v) => setState(() => _house = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}

// =============================================================================
// ID Cards
// =============================================================================
final _cardsProvider = FutureProvider.autoDispose((ref) async {
  final cards = await ref.watch(cardRepositoryProvider).getAllCards();
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  final byId = {for (final s in students) s.id: s};
  final rows = [for (final c in cards) (card: c, student: byId[c.studentId])];
  rows.sort((a, b) =>
      (a.student?.fullName ?? '').compareTo(b.student?.fullName ?? ''));
  return rows;
});

class AdminCardsScreen extends ConsumerWidget {
  const AdminCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_cardsProvider);
    return AdminScaffold(
      title: 'ID Cards',
      currentRoute: AppRoutes.adminCards,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load cards.',
          onRetry: () => ref.invalidate(_cardsProvider),
        ),
        data: (rows) => ContentBounds(
          child: rows.isEmpty
              ? const EmptyView(
                  title: 'No cards issued', icon: Icons.badge_outlined)
              : EcoCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    itemCount: rows.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final r = rows[i];
                      return _CardRow(
                        card: r.card,
                        student: r.student,
                        onReplace: () =>
                            _replace(context, ref, r.card, r.student),
                        onToggle: () => _toggle(context, ref, r.card),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _toggle(
      BuildContext context, WidgetRef ref, StudentCard card) async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(cardRepositoryProvider);
    if (card.isActive) {
      await repo.deactivateCard(card.cardUid);
    } else {
      await repo.assignCard(card.copyWith(isActive: true));
    }
    ref.invalidate(_cardsProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(card.isActive ? 'Card deactivated.' : 'Card reactivated.'),
      ),
    );
  }

  Future<void> _replace(BuildContext context, WidgetRef ref, StudentCard card,
      Student? student) async {
    final newUid = await showDialog<String>(
      context: context,
      builder: (_) => _ReplaceCardDialog(student: student),
    );
    if (newUid == null || newUid.isEmpty) return;
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(cardRepositoryProvider).replaceCard(card.studentId, newUid);
    final session = ref.read(authServiceProvider).getCurrentSession();
    await ref.read(auditRepositoryProvider).record(
          AuditLogEntry(
            id: 'audit-${DateTime.now().millisecondsSinceEpoch}',
            actorId: session?.accountId ?? 'admin-1',
            actorName: session?.displayName ?? 'Administrator',
            action: 'Replaced Student ID card',
            target: card.studentId,
            detail: 'Lost card reissued for ${student?.fullName ?? card.studentId}',
            timestamp: DateTime.now(),
          ),
        );
    ref.invalidate(_cardsProvider);
    messenger.showSnackBar(
      SnackBar(content: Text('Replacement card issued for '
          '${student?.fullName ?? 'student'}.')),
    );
  }
}

class _CardRow extends StatelessWidget {
  const _CardRow({
    required this.card,
    required this.student,
    required this.onReplace,
    required this.onToggle,
  });
  final StudentCard card;
  final Student? student;
  final VoidCallback onReplace;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.primarySurface,
        child: const Icon(Icons.badge_outlined, color: AppColors.primary),
      ),
      title: Text(student?.fullName ?? 'Unknown student',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('UID ${card.maskedUid} · '
          '${card.isActive ? 'Active' : 'Inactive'}'
          '${card.isExpired ? ' · Expired' : ''}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: card.isActive,
            activeThumbColor: AppColors.xpPurple,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: 4),
          OutlinedButton.icon(
            onPressed: onReplace,
            icon: const Icon(Icons.sync, size: 18),
            label: const Text('Replace'),
          ),
        ],
      ),
    );
  }
}

class _ReplaceCardDialog extends StatefulWidget {
  const _ReplaceCardDialog({required this.student});
  final Student? student;

  @override
  State<_ReplaceCardDialog> createState() => _ReplaceCardDialogState();
}

class _ReplaceCardDialogState extends State<_ReplaceCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _uid = TextEditingController(
    text: '04${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}',
  );

  @override
  void dispose() {
    _uid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Replace lost card'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Issuing a new card for '
                  '${widget.student?.fullName ?? 'this student'}. '
                  'The old card is deactivated automatically.'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _uid,
                decoration: const InputDecoration(
                  labelText: 'New card UID',
                  prefixIcon: Icon(Icons.nfc),
                ),
                validator: (v) =>
                    (v == null || v.trim().length < 4) ? 'Enter a valid UID' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(_uid.text.trim());
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: const Text('Issue card'),
        ),
      ],
    );
  }
}

// =============================================================================
// Classes
// =============================================================================
final _adminClassesProvider = FutureProvider.autoDispose((ref) async {
  final classes = await ref.watch(classRepositoryProvider).getAllClasses();
  final students = await ref.watch(studentRepositoryProvider).getAllStudents();
  return classes.map((c) {
    final count = students.where((s) => s.className == c.name).length;
    return (schoolClass: c, members: count);
  }).toList();
});

class AdminClassesScreen extends ConsumerWidget {
  const AdminClassesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_adminClassesProvider);
    return AdminScaffold(
      title: 'Classes',
      currentRoute: AppRoutes.adminClasses,
      actions: [
        FilledButton.icon(
          onPressed: () => _openAddDialog(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Add class'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
        ),
      ],
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load classes.',
          onRetry: () => ref.invalidate(_adminClassesProvider),
        ),
        data: (rows) => ContentBounds(
          child: GridView.count(
            crossAxisCount: context.dashboardColumns,
            childAspectRatio: 1.7,
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
                            backgroundColor: AppColors.xpPurpleSurface,
                            child: Text('${r.schoolClass.grade}',
                                style: const TextStyle(
                                    color: AppColors.xpPurple,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Text('Class ${r.schoolClass.name}',
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const Spacer(),
                      Text('Grade ${r.schoolClass.grade}',
                          style: const TextStyle(color: AppColors.inkMuted)),
                      const SizedBox(height: 4),
                      Text('${r.members} students',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openAddDialog(BuildContext context, WidgetRef ref) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _AddClassDialog(
        onSaved: () => ref.invalidate(_adminClassesProvider),
      ),
    );
  }
}

class _AddClassDialog extends ConsumerStatefulWidget {
  const _AddClassDialog({required this.onSaved});
  final VoidCallback onSaved;

  @override
  ConsumerState<_AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends ConsumerState<_AddClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  int _grade = 4;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final id = 'class-${DateTime.now().millisecondsSinceEpoch}';
    await ref.read(classRepositoryProvider).upsertClass(
          SchoolClass(id: id, name: _name.text.trim(), grade: _grade),
        );
    widget.onSaved();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add class'),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration:
                    const InputDecoration(labelText: 'Class name (e.g. 6A)'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _grade,
                decoration: const InputDecoration(labelText: 'Grade'),
                items: [
                  for (var g = 1; g <= 6; g++)
                    DropdownMenuItem(value: g, child: Text('Grade $g')),
                ],
                onChanged: (v) => setState(() => _grade = v ?? _grade),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// =============================================================================
// Houses
// =============================================================================
final _adminHousesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(houseRepositoryProvider).getAllHouses(),
);

class AdminHousesScreen extends ConsumerWidget {
  const AdminHousesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_adminHousesProvider);
    return AdminScaffold(
      title: 'Houses',
      currentRoute: AppRoutes.adminHouses,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load houses.',
          onRetry: () => ref.invalidate(_adminHousesProvider),
        ),
        data: (houses) {
          final sorted = [...houses]
            ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
          return ContentBounds(
            child: GridView.count(
              crossAxisCount: context.isDesktop ? 2 : 1,
              childAspectRatio: 2.2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                for (final h in sorted)
                  _AdminHouseCard(
                    house: h,
                    onEditGoal: () => _editGoal(context, ref, h),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _editGoal(BuildContext context, WidgetRef ref, House house) async {
    final newGoal = await showDialog<String>(
      context: context,
      builder: (_) => _EditGoalDialog(house: house),
    );
    if (newGoal == null || newGoal.trim().isEmpty) return;
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(houseRepositoryProvider)
        .updateHouse(house.copyWith(sustainabilityGoal: newGoal.trim()));
    ref.invalidate(_adminHousesProvider);
    messenger.showSnackBar(
      SnackBar(content: Text('${house.name} goal updated.')),
    );
  }
}

class _AdminHouseCard extends StatelessWidget {
  const _AdminHouseCard({required this.house, required this.onEditGoal});
  final House house;
  final VoidCallback onEditGoal;

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
                Row(
                  children: [
                    Expanded(
                      child: Text('${house.name} House',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    IconButton(
                      tooltip: 'Edit goal',
                      onPressed: onEditGoal,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                    ),
                  ],
                ),
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

class _EditGoalDialog extends StatefulWidget {
  const _EditGoalDialog({required this.house});
  final House house;

  @override
  State<_EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<_EditGoalDialog> {
  late final TextEditingController _goal =
      TextEditingController(text: widget.house.sustainabilityGoal);

  @override
  void dispose() {
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.house.name} sustainability goal'),
      content: SizedBox(
        width: 400,
        child: TextField(
          controller: _goal,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Goal',
            hintText: 'e.g. Recycle 500 items this term',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_goal.text),
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// =============================================================================
// Kiosks
// =============================================================================
final _adminDevicesProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(deviceRepositoryProvider).getDevices(),
);

class AdminKiosksScreen extends ConsumerWidget {
  const AdminKiosksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_adminDevicesProvider);
    return AdminScaffold(
      title: 'Kiosks',
      currentRoute: AppRoutes.adminKiosks,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load kiosks.',
          onRetry: () => ref.invalidate(_adminDevicesProvider),
        ),
        data: (devices) => ContentBounds(
          child: devices.isEmpty
              ? const EmptyView(
                  title: 'No kiosks registered',
                  icon: Icons.devices_other_outlined)
              : ListView.separated(
                  itemCount: devices.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, i) => _KioskCard(
                    device: devices[i],
                    onToggleMaintenance: () =>
                        _toggleMaintenance(context, ref, devices[i]),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _toggleMaintenance(
      BuildContext context, WidgetRef ref, KioskDevice device) async {
    final messenger = ScaffoldMessenger.of(context);
    final enable = !device.maintenanceMode;
    await ref
        .read(deviceRepositoryProvider)
        .setMaintenance(device.id, enabled: enable);
    ref.invalidate(_adminDevicesProvider);
    messenger.showSnackBar(
      SnackBar(
        content: Text(enable
            ? '${device.name} entered maintenance mode.'
            : '${device.name} exited maintenance mode.'),
      ),
    );
  }
}

class _KioskCard extends StatelessWidget {
  const _KioskCard({required this.device, required this.onToggleMaintenance});
  final KioskDevice device;
  final VoidCallback onToggleMaintenance;

  @override
  Widget build(BuildContext context) {
    final colour = healthColour(device.health);
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colour.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.devices_other_outlined, color: colour),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(device.schoolLocation,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colour.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(device.health.label,
                    style: TextStyle(
                        color: colour, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: [
              _kv(context, 'Software', device.softwareVersion),
              _kv(context, 'Sessions today', '${device.sessionsToday}'),
              _kv(context, 'Last heartbeat', _ago(device.sinceHeartbeat)),
            ],
          ),
          const Divider(height: 28),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _PeripheralPill(
                  label: 'Controller', status: device.controllerStatus),
              _PeripheralPill(label: 'Camera', status: device.cameraStatus),
              _PeripheralPill(label: 'NFC', status: device.nfcStatus),
              _PeripheralPill(label: 'Sensor', status: device.sensorStatus),
              _PeripheralPill(
                  label: 'Internet', status: device.internetStatus),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: onToggleMaintenance,
              icon: Icon(device.maintenanceMode
                  ? Icons.play_circle_outline
                  : Icons.build_outlined),
              label: Text(device.maintenanceMode
                  ? 'Exit maintenance mode'
                  : 'Enter maintenance mode'),
            ),
          ),
        ],
      ),
    );
  }

  static String _ago(Duration d) {
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }

  Widget _kv(BuildContext context, String k, String v) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: Theme.of(context).textTheme.bodySmall),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      );
}

class _PeripheralPill extends StatelessWidget {
  const _PeripheralPill({required this.label, required this.status});
  final String label;
  final PeripheralStatus status;

  @override
  Widget build(BuildContext context) {
    final colour = switch (status) {
      PeripheralStatus.ok => AppColors.success,
      PeripheralStatus.warning => AppColors.warning,
      PeripheralStatus.error => AppColors.error,
      PeripheralStatus.disconnected => AppColors.inkFaint,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colour.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('$label · ${status.label}',
              style: TextStyle(
                  color: colour, fontWeight: FontWeight.w600, fontSize: 12)),
        ],
      ),
    );
  }
}

// =============================================================================
// Rewards
// =============================================================================
final _adminRewardsProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(rewardRepositoryProvider).getRewardItems(),
);

class AdminRewardsScreen extends ConsumerWidget {
  const AdminRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_adminRewardsProvider);
    return AdminScaffold(
      title: 'Rewards',
      currentRoute: AppRoutes.adminRewards,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load rewards.',
          onRetry: () => ref.invalidate(_adminRewardsProvider),
        ),
        data: (items) => ContentBounds(
          child: items.isEmpty
              ? const EmptyView(
                  title: 'No rewards yet', icon: Icons.card_giftcard_outlined)
              : EcoCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) => _RewardRow(
                      item: items[i],
                      onToggle: () => _toggle(context, ref, items[i]),
                      onEdit: () => _editCost(context, ref, items[i]),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _toggle(
      BuildContext context, WidgetRef ref, RewardItem item) async {
    await ref
        .read(rewardRepositoryProvider)
        .upsertRewardItem(item.copyWith(isActive: !item.isActive));
    ref.invalidate(_adminRewardsProvider);
  }

  Future<void> _editCost(
      BuildContext context, WidgetRef ref, RewardItem item) async {
    final newCost = await showDialog<int>(
      context: context,
      builder: (_) => _EditCostDialog(item: item),
    );
    if (newCost == null) return;
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    await ref
        .read(rewardRepositoryProvider)
        .upsertRewardItem(item.copyWith(pointCost: newCost));
    ref.invalidate(_adminRewardsProvider);
    messenger.showSnackBar(
      SnackBar(content: Text('${item.name} now costs $newCost points.')),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    required this.item,
    required this.onToggle,
    required this.onEdit,
  });
  final RewardItem item;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final stockColour = switch (item.stockStatus) {
      StockStatus.inStock => AppColors.success,
      StockStatus.lowStock => AppColors.warning,
      StockStatus.outOfStock => AppColors.error,
    };
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.coinGoldSurface,
        child: const Icon(Icons.card_giftcard, color: AppColors.coinGoldDark),
      ),
      title: Text(item.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Row(
        children: [
          Text(item.category.label),
          const Text('  ·  '),
          Text(item.stockStatus.label,
              style: TextStyle(color: stockColour, fontWeight: FontWeight.w600)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${item.pointCost} pts',
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.coinGoldDark)),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Edit cost',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
          Switch(
            value: item.isActive,
            activeThumbColor: AppColors.xpPurple,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}

class _EditCostDialog extends StatefulWidget {
  const _EditCostDialog({required this.item});
  final RewardItem item;

  @override
  State<_EditCostDialog> createState() => _EditCostDialogState();
}

class _EditCostDialogState extends State<_EditCostDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cost =
      TextEditingController(text: '${widget.item.pointCost}');

  @override
  void dispose() {
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit cost · ${widget.item.name}'),
      content: SizedBox(
        width: 320,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _cost,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Point cost',
              suffixText: 'points',
            ),
            validator: (v) {
              final n = int.tryParse(v ?? '');
              if (n == null || n <= 0) return 'Enter a positive number';
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(int.parse(_cost.text));
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// =============================================================================
// Gamification (config form)
// =============================================================================
final _configProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(configRepositoryProvider).getConfig(),
);

class AdminGamificationScreen extends ConsumerWidget {
  const AdminGamificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_configProvider);
    return AdminScaffold(
      title: 'Gamification',
      currentRoute: AppRoutes.adminGamification,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load configuration.',
          onRetry: () => ref.invalidate(_configProvider),
        ),
        data: (config) => _GamificationForm(initial: config),
      ),
    );
  }
}

class _GamificationForm extends ConsumerStatefulWidget {
  const _GamificationForm({required this.initial});
  final GamificationConfig initial;

  @override
  ConsumerState<_GamificationForm> createState() => _GamificationFormState();
}

class _GamificationFormState extends ConsumerState<_GamificationForm> {
  late GamificationConfig _config = widget.initial;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final c = _config;
    return SingleChildScrollView(
      child: ContentBounds(
        maxWidth: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Points & XP',
                    subtitle: 'How much a correct sort is worth',
                    icon: Icons.stars_outlined,
                  ),
                  const SizedBox(height: 16),
                  _numberField(
                    label: 'Points per correct',
                    value: c.pointsPerCorrect,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(pointsPerCorrect: v)),
                  ),
                  _numberField(
                    label: 'Points per incorrect',
                    value: c.pointsPerIncorrect,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(pointsPerIncorrect: v)),
                  ),
                  _numberField(
                    label: 'Daily points cap',
                    value: c.dailyPointsCap,
                    onChanged: (v) =>
                        setState(() => _config = c.copyWith(dailyPointsCap: v)),
                  ),
                  _numberField(
                    label: 'XP per correct',
                    value: c.xpPerCorrect,
                    onChanged: (v) =>
                        setState(() => _config = c.copyWith(xpPerCorrect: v)),
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
                    title: 'Streak & bonuses',
                    subtitle: 'Reward consistency',
                    icon: Icons.local_fire_department_outlined,
                  ),
                  const SizedBox(height: 16),
                  _numberField(
                    label: 'Bonus streak threshold',
                    value: c.bonusStreakThreshold,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(bonusStreakThreshold: v)),
                  ),
                  _numberField(
                    label: 'Bonus points',
                    value: c.bonusPoints,
                    onChanged: (v) =>
                        setState(() => _config = c.copyWith(bonusPoints: v)),
                  ),
                  _numberField(
                    label: 'Streak grace days',
                    value: c.streakGraceDays,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(streakGraceDays: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.xpPurple,
                    title: const Text('Weekends count as active'),
                    value: c.weekendsCountAsActive,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(weekendsCountAsActive: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.xpPurple,
                    title: const Text('Holidays count as active'),
                    value: c.holidaysCountAsActive,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(holidaysCountAsActive: v)),
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
                    title: 'Monetary conversion',
                    subtitle: 'Optional points-to-currency for the canteen',
                    icon: Icons.currency_exchange_outlined,
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.xpPurple,
                    title: const Text('Enable monetary conversion'),
                    value: c.monetaryConversionEnabled,
                    onChanged: (v) => setState(() =>
                        _config = c.copyWith(monetaryConversionEnabled: v)),
                  ),
                  _numberField(
                    label: 'Points per currency unit',
                    value: c.pointsPerCurrencyUnit,
                    enabled: c.monetaryConversionEnabled,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(pointsPerCurrencyUnit: v)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      enabled: c.monetaryConversionEnabled,
                      initialValue: c.currencyCode,
                      decoration:
                          const InputDecoration(labelText: 'Currency code'),
                      onChanged: (v) => setState(() =>
                          _config = c.copyWith(currencyCode: v.toUpperCase())),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.xpPurpleSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate_outlined,
                            color: AppColors.xpPurple),
                        const SizedBox(width: 10),
                        Text(
                          c.monetaryConversionEnabled
                              ? '${c.pointsPerCurrencyUnit} points = '
                                  '${c.formatCurrency(c.pointsPerCurrencyUnit)}'
                              : 'Conversion disabled — rewards are non-monetary.',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.xpPurpleDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save changes'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.xpPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: _saving
                      ? null
                      : () => setState(() => _config = widget.initial),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        enabled: enabled,
        initialValue: '$value',
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (v) {
          final n = int.tryParse(v);
          if (n != null) onChanged(n);
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(configRepositoryProvider).saveConfig(_config);
    final session = ref.read(authServiceProvider).getCurrentSession();
    await ref.read(auditRepositoryProvider).record(
          AuditLogEntry(
            id: 'audit-${DateTime.now().millisecondsSinceEpoch}',
            actorId: session?.accountId ?? 'admin-1',
            actorName: session?.displayName ?? 'Administrator',
            action: 'Updated gamification config',
            target: 'GamificationConfig',
            detail: 'Points/XP, streak and conversion rules saved',
            timestamp: DateTime.now(),
          ),
        );
    ref.invalidate(_configProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(
      const SnackBar(content: Text('Gamification settings saved.')),
    );
  }
}

// =============================================================================
// AI Settings
// =============================================================================
class AdminAiSettingsScreen extends ConsumerWidget {
  const AdminAiSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_configProvider);
    return AdminScaffold(
      title: 'AI Settings',
      currentRoute: AppRoutes.adminAiSettings,
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load AI settings.',
          onRetry: () => ref.invalidate(_configProvider),
        ),
        data: (config) => _AiSettingsForm(initial: config),
      ),
    );
  }
}

class _AiSettingsForm extends ConsumerStatefulWidget {
  const _AiSettingsForm({required this.initial});
  final GamificationConfig initial;

  @override
  ConsumerState<_AiSettingsForm> createState() => _AiSettingsFormState();
}

class _AiSettingsFormState extends ConsumerState<_AiSettingsForm> {
  late GamificationConfig _config = widget.initial;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final c = _config;
    return SingleChildScrollView(
      child: ContentBounds(
        maxWidth: 800,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Classification confidence',
                    subtitle: 'The safety net for uncertain items',
                    icon: Icons.psychology_outlined,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When the AI is less confident than this threshold, the item '
                    'is routed to General Waste to protect the clean recycling '
                    'streams.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('${(c.aiConfidenceThreshold * 100).round()}%',
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.xpPurple)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Minimum confidence to trust the AI’s bin '
                            'choice.'),
                      ),
                    ],
                  ),
                  Slider(
                    value: c.aiConfidenceThreshold.clamp(0.50, 0.99),
                    min: 0.50,
                    max: 0.99,
                    divisions: 49,
                    activeColor: AppColors.xpPurple,
                    label: '${(c.aiConfidenceThreshold * 100).round()}%',
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(aiConfidenceThreshold: v)),
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
                    title: 'Privacy & timing',
                    subtitle: 'Image retention and inactivity handling',
                    icon: Icons.privacy_tip_outlined,
                  ),
                  const SizedBox(height: 16),
                  _numberField(
                    label: 'Image retention (seconds, 0 = clear immediately)',
                    value: c.imageRetentionSeconds,
                    onChanged: (v) => setState(
                        () => _config = c.copyWith(imageRetentionSeconds: v)),
                  ),
                  _numberField(
                    label: 'Inactivity timeout (seconds)',
                    value: c.inactivityTimeoutSeconds,
                    onChanged: (v) => setState(() =>
                        _config = c.copyWith(inactivityTimeoutSeconds: v)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save AI settings'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.xpPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _numberField({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: '$value',
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label),
        onChanged: (v) {
          final n = int.tryParse(v);
          if (n != null) onChanged(n);
        },
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(configRepositoryProvider).saveConfig(_config);
    final session = ref.read(authServiceProvider).getCurrentSession();
    await ref.read(auditRepositoryProvider).record(
          AuditLogEntry(
            id: 'audit-${DateTime.now().millisecondsSinceEpoch}',
            actorId: session?.accountId ?? 'admin-1',
            actorName: session?.displayName ?? 'Administrator',
            action: 'Updated AI confidence threshold',
            target: 'GamificationConfig',
            detail:
                'Threshold set to ${(_config.aiConfidenceThreshold * 100).round()}%',
            timestamp: DateTime.now(),
          ),
        );
    ref.invalidate(_configProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    messenger.showSnackBar(
      const SnackBar(content: Text('AI settings saved.')),
    );
  }
}

// =============================================================================
// Waste Categories
// =============================================================================
class AdminWasteCategoriesScreen extends ConsumerStatefulWidget {
  const AdminWasteCategoriesScreen({super.key});

  @override
  ConsumerState<AdminWasteCategoriesScreen> createState() =>
      _AdminWasteCategoriesScreenState();
}

class _AdminWasteCategoriesScreenState
    extends ConsumerState<AdminWasteCategoriesScreen> {
  late final Map<WasteCategory, TextEditingController> _labels = {
    for (final c in WasteCategory.values)
      c: TextEditingController(text: c.label),
  };
  late final Map<WasteCategory, TextEditingController> _descriptions = {
    for (final c in WasteCategory.values)
      c: TextEditingController(text: _defaultDescription(c)),
  };

  static String _defaultDescription(WasteCategory c) => switch (c) {
        WasteCategory.plastic =>
          'Clean plastics and recyclables. Maps to the blue bin slot.',
        WasteCategory.paper =>
          'Dry paper and flattened cardboard. Maps to the indigo bin slot.',
        WasteCategory.organic =>
          'Food scraps and compostables. Maps to the green bin slot.',
        WasteCategory.general =>
          'Everything else, including contaminated items. Maps to the grey slot.',
      };

  @override
  void dispose() {
    for (final c in _labels.values) {
      c.dispose();
    }
    for (final c in _descriptions.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      title: 'Waste Categories',
      currentRoute: AppRoutes.adminWasteCategories,
      child: SingleChildScrollView(
        child: ContentBounds(
          maxWidth: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'These four categories map directly to the physical bin '
                        'slots and their LED colours. Labels and descriptions are '
                        'shown to students on the kiosk.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final c in WasteCategory.values) ...[
                EcoCard(
                  borderColor: c.colour.withValues(alpha: 0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: c.colour.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(c.icon, color: c.colour),
                          ),
                          const SizedBox(width: 12),
                          Text(c.label,
                              style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: c.colour.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('LED · ${c.shortLabel}',
                                style: TextStyle(
                                    color: c.colour,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _labels[c],
                        decoration:
                            const InputDecoration(labelText: 'Display label'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptions[c],
                        maxLines: 2,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category labels updated for this session. '
                          '(Bin-slot mapping is fixed by hardware.)'),
                    ),
                  );
                },
                icon: const Icon(Icons.check),
                label: const Text('Apply labels'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.xpPurple,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Users
// =============================================================================
class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacher = MockSeedData.teacher();
    final admin = MockSeedData.admin();
    final canteen = MockSeedData.canteenStaff();
    final users = <_StaffUser>[
      _StaffUser(
          name: admin.name,
          identifier: admin.email,
          role: UserRole.admin,
          detail: '${admin.permissions.length} permissions'),
      _StaffUser(
          name: teacher.name,
          identifier: teacher.email,
          role: UserRole.teacher,
          detail: 'Classes: ${teacher.assignedClasses.join(', ')}'),
      _StaffUser(
          name: canteen.name,
          identifier: canteen.employeeNumber,
          role: UserRole.canteenStaff,
          detail: 'Terminal ${canteen.terminalId}'),
    ];
    return AdminScaffold(
      title: 'Users',
      currentRoute: AppRoutes.adminUsers,
      actions: [
        FilledButton.icon(
          onPressed: () => _invite(context),
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text('Invite user'),
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
        ),
      ],
      child: ContentBounds(
        child: EcoCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: users.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) => _UserRow(user: users[i]),
          ),
        ),
      ),
    );
  }

  Future<void> _invite(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _InviteUserDialog(),
    );
  }
}

class _StaffUser {
  const _StaffUser({
    required this.name,
    required this.identifier,
    required this.role,
    required this.detail,
  });
  final String name;
  final String identifier;
  final UserRole role;
  final String detail;
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user});
  final _StaffUser user;

  @override
  Widget build(BuildContext context) {
    final colour = switch (user.role) {
      UserRole.admin => AppColors.xpPurple,
      UserRole.teacher => AppColors.info,
      UserRole.canteenStaff => AppColors.coinGoldDark,
      UserRole.student => AppColors.primary,
    };
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: colour.withValues(alpha: 0.15),
        child: Text(user.name.characters.first,
            style: TextStyle(color: colour, fontWeight: FontWeight.w700)),
      ),
      title: Text(user.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${user.identifier} · ${user.detail}'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colour.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(user.role.label,
            style: TextStyle(color: colour, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _InviteUserDialog extends StatefulWidget {
  const _InviteUserDialog();

  @override
  State<_InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends State<_InviteUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  UserRole _role = UserRole.teacher;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Invite user'),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'Work email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<UserRole>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Role'),
                items: const [
                  DropdownMenuItem(
                      value: UserRole.teacher, child: Text('Teacher')),
                  DropdownMenuItem(
                      value: UserRole.admin, child: Text('Administrator')),
                  DropdownMenuItem(
                      value: UserRole.canteenStaff, child: Text('Canteen Staff')),
                ],
                onChanged: (v) => setState(() => _role = v ?? _role),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final email = _email.text.trim();
            final messenger = ScaffoldMessenger.of(context);
            Navigator.of(context).pop();
            messenger.showSnackBar(
              SnackBar(
                content: Text('Invitation sent to $email as '
                    '${_role.label}. (Simulated in the MVP.)'),
              ),
            );
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.xpPurple),
          child: const Text('Send invite'),
        ),
      ],
    );
  }
}

// =============================================================================
// Audit Log
// =============================================================================
final _auditProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(auditRepositoryProvider).getEntries(limit: 100),
);

class AdminAuditLogScreen extends ConsumerWidget {
  const AdminAuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_auditProvider);
    return AdminScaffold(
      title: 'Audit Log',
      currentRoute: AppRoutes.adminAuditLog,
      actions: [
        IconButton(
          tooltip: 'Refresh',
          onPressed: () => ref.invalidate(_auditProvider),
          icon: const Icon(Icons.refresh),
        ),
      ],
      child: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: 'Could not load the audit log.',
          onRetry: () => ref.invalidate(_auditProvider),
        ),
        data: (entries) => ContentBounds(
          child: entries.isEmpty
              ? const EmptyView(
                  title: 'No audit events yet',
                  icon: Icons.receipt_long_outlined)
              : EcoCard(
                  padding: EdgeInsets.zero,
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, i) =>
                        _AuditRow(entry: entries[i]),
                  ),
                ),
        ),
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry});
  final AuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: const CircleAvatar(
        backgroundColor: AppColors.xpPurpleSurface,
        child: Icon(Icons.history, color: AppColors.xpPurple),
      ),
      title: Text(entry.action,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        '${entry.actorName} · ${entry.target}'
        '${entry.detail.isNotEmpty ? ' · ${entry.detail}' : ''}',
      ),
      trailing: Text(
        _formatTimestamp(entry.timestamp),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  static String _formatTimestamp(DateTime t) {
    final d =
        '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year}';
    final time =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return '$d $time';
  }
}

// =============================================================================
// System Health
// =============================================================================
class AdminSystemHealthScreen extends ConsumerWidget {
  const AdminSystemHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devicesAsync = ref.watch(_adminDevicesProvider);
    final hardwareAsync = ref.watch(hardwareStatusStreamProvider);
    return AdminScaffold(
      title: 'System Health',
      currentRoute: AppRoutes.adminSystemHealth,
      child: SingleChildScrollView(
        child: ContentBounds(
          maxWidth: 1100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              devicesAsync.when(
                loading: () => const SizedBox(
                  height: 120,
                  child: LoadingView(message: 'Checking devices…'),
                ),
                error: (e, _) =>
                    const Text('Could not load device health summary.'),
                data: (devices) => _FleetSummary(devices: devices),
              ),
              const SizedBox(height: 16),
              hardwareAsync.when(
                loading: () => const EcoCard(
                  child: SizedBox(
                    height: 120,
                    child: LoadingView(message: 'Connecting to bin controller…'),
                  ),
                ),
                error: (e, _) => const EcoCard(
                  child: Text('Live hardware status unavailable.'),
                ),
                data: (status) => _LiveHardware(status: status),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _FleetSummary extends StatelessWidget {
  const _FleetSummary({required this.devices});
  final List<KioskDevice> devices;

  @override
  Widget build(BuildContext context) {
    final online =
        devices.where((d) => d.health == HealthStatus.online).length;
    final degraded =
        devices.where((d) => d.health == HealthStatus.degraded).length;
    final offline =
        devices.where((d) => d.health == HealthStatus.offline).length;
    final maintenance =
        devices.where((d) => d.health == HealthStatus.maintenance).length;
    final allHealthy = degraded == 0 && offline == 0;
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(allHealthy ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: allHealthy ? AppColors.success : AppColors.warning,
                  size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        allHealthy
                            ? 'All systems operational'
                            : 'Attention needed',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text('${devices.length} kiosks monitored',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _pill(context, 'Online', online, AppColors.success),
              _pill(context, 'Degraded', degraded, AppColors.warning),
              _pill(context, 'Offline', offline, AppColors.error),
              _pill(context, 'Maintenance', maintenance, AppColors.info),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String label, int count, Color colour) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$count',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: colour)),
          Text(label, style: const TextStyle(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}

class _LiveHardware extends StatelessWidget {
  const _LiveHardware({required this.status});
  final HardwareStatus status;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Live bin controller',
            subtitle: 'Real-time peripheral, LED and fill status',
            icon: Icons.sensors,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _BoolPill(label: 'Controller', ok: status.controllerConnected),
              _BoolPill(label: 'Camera', ok: status.cameraAvailable),
              _BoolPill(label: 'Card reader', ok: status.cardReaderAvailable),
              _BoolPill(
                  label: 'Waste detected',
                  ok: status.wastePresenceDetected,
                  okLabel: 'Present',
                  offLabel: 'Clear'),
            ],
          ),
          const Divider(height: 32),
          Text('Slot LEDs', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final c in WasteCategory.values)
                _LedTile(
                  category: c,
                  colour: status.slotLedStatuses[c] ?? FeedbackColour.off,
                ),
            ],
          ),
          const Divider(height: 32),
          Text('Bin fill levels',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final c in WasteCategory.values)
            _FillBar(
              category: c,
              level: (status.binFillLevels[c] ?? 0).clamp(0, 1).toDouble(),
            ),
          const SizedBox(height: 4),
          Text(
            'Updated ${_formatTime(status.lastUpdatedAt)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';
}

class _BoolPill extends StatelessWidget {
  const _BoolPill({
    required this.label,
    required this.ok,
    this.okLabel = 'OK',
    this.offLabel = 'Down',
  });
  final String label;
  final bool ok;
  final String okLabel;
  final String offLabel;

  @override
  Widget build(BuildContext context) {
    final colour = ok ? AppColors.success : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colour.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.error_outline,
              size: 18, color: colour),
          const SizedBox(width: 8),
          Text('$label · ${ok ? okLabel : offLabel}',
              style: TextStyle(color: colour, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _LedTile extends StatelessWidget {
  const _LedTile({required this.category, required this.colour});
  final WasteCategory category;
  final FeedbackColour colour;

  @override
  Widget build(BuildContext context) {
    final ledColour = switch (colour) {
      FeedbackColour.off => AppColors.inkFaint,
      FeedbackColour.green => AppColors.success,
      FeedbackColour.red => AppColors.error,
      FeedbackColour.amber => AppColors.warning,
      FeedbackColour.houseColour => category.colour,
    };
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: ledColour,
              shape: BoxShape.circle,
              boxShadow: colour == FeedbackColour.off
                  ? null
                  : [
                      BoxShadow(
                        color: ledColour.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.shortLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(_ledLabel(colour),
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _ledLabel(FeedbackColour c) => switch (c) {
        FeedbackColour.off => 'Off',
        FeedbackColour.green => 'Green',
        FeedbackColour.red => 'Red',
        FeedbackColour.amber => 'Amber',
        FeedbackColour.houseColour => 'House colour',
      };
}

class _FillBar extends StatelessWidget {
  const _FillBar({required this.category, required this.level});
  final WasteCategory category;
  final double level;

  @override
  Widget build(BuildContext context) {
    final full = level >= 0.9;
    final colour = full ? AppColors.error : category.colour;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, size: 18, color: category.colour),
              const SizedBox(width: 8),
              Text(category.label,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${(level * 100).round()}%'
                  '${full ? ' · full' : ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: colour)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: level,
              minHeight: 10,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(colour),
            ),
          ),
        ],
      ),
    );
  }
}
