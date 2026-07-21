import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/mock/mock_seed_data.dart';
import '../../../domain/enums/app_enums.dart';
import '../../../domain/models/models.dart';
import '../../../domain/services/auth_service.dart';
import '../../../shared/components/eco_card.dart';
import '../../../shared/components/house_badge.dart';
import '../../../shared/layouts/staff_login_scaffold.dart';
import '../../../shared/responsive/responsive.dart';
import '../../kiosk/presentation/widgets/student_card_illustration.dart';
import '../application/canteen_controller.dart';

/// =============================================================================
/// EcoLens — Canteen Redemption Terminal
/// =============================================================================
///
/// Staff-operated terminal where a student redeems reward points by tapping
/// their PHYSICAL Student ID card on the terminal's card reader. There is no
/// phone, no QR code and no camera anywhere in this flow — card UID only.
///
/// Flow: login → scan card → student summary → choose reward → confirm →
/// success receipt → (auto-clear for the next customer). A staff-facing
/// redemption history is reachable from the scan screen.

// -----------------------------------------------------------------------------
// 1. Login
// -----------------------------------------------------------------------------

/// Secure canteen-staff sign-in. Uses the seeded demo canteen account and a
/// gold rewards accent. On success the terminal advances to the scan screen.
class CanteenLoginScreen extends ConsumerStatefulWidget {
  const CanteenLoginScreen({super.key});

  @override
  ConsumerState<CanteenLoginScreen> createState() => _CanteenLoginScreenState();
}

class _CanteenLoginScreenState extends ConsumerState<CanteenLoginScreen> {
  final _identifier =
      TextEditingController(text: MockSeedData.canteenEmployeeNumber);
  final _password = TextEditingController(text: MockSeedData.demoPassword);
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref.read(authServiceProvider).authenticateCanteenStaff(
          LoginCredentials(
            identifier: _identifier.text,
            password: _password.text,
          ),
        );
    if (!mounted) return;
    result.when(
      ok: (_) {
        // Fresh terminal session — never inherit a previous customer.
        ref.read(canteenControllerProvider.notifier).clearSession();
        context.go(AppRoutes.canteenScanCard);
      },
      err: (f) => setState(() {
        _loading = false;
        _error = f.message;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StaffLoginScaffold(
      roleTitle: 'Canteen Terminal',
      roleSubtitle: 'Redeem student reward points at the counter. Students tap '
          'their physical ID card — no phone needed.',
      accent: AppColors.coinGoldDark,
      heroIcon: Icons.storefront_outlined,
      demoHint: 'Demo account is pre-filled. Just press Sign in.\n'
          'Employee #: ${MockSeedData.canteenEmployeeNumber} · '
          'Password: ${MockSeedData.demoPassword}',
      form: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _identifier,
              decoration: const InputDecoration(
                labelText: 'Employee number',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter your employee number'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              onFieldSubmitted: (_) => _submit(),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Enter your password' : null,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coinGoldDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Sign in'),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.history, size: 16, color: AppColors.inkFaint),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Redemption history is available on the terminal once you '
                    'sign in.',
                    style: TextStyle(color: AppColors.inkFaint, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Back to launcher'),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. Scan card
// -----------------------------------------------------------------------------

/// Idle "tap your card" screen. Shows the physical-ID-card illustration with its
/// NFC pulse and lets staff simulate a card tap for the demo (Liam plus a couple
/// of other seeded students). An unknown card is handled inline with a retry.
class CanteenScanCardScreen extends ConsumerWidget {
  const CanteenScanCardScreen({super.key});

  /// The demo cards offered as "simulate tap" buttons: (label, uid).
  static List<({String label, String uid})> _demoCards() {
    final students = {for (final s in MockSeedData.students()) s.id: s};
    return [
      for (final card in MockSeedData.cards().take(3))
        (
          label: students[card.studentId]?.firstName ?? card.studentId,
          uid: card.cardUid,
        ),
    ];
  }

  Future<void> _simulateTap(
    BuildContext context,
    WidgetRef ref,
    String uid,
  ) async {
    final ok =
        await ref.read(canteenControllerProvider.notifier).scanCard(uid);
    if (ok && context.mounted) context.go(AppRoutes.canteenStudent);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(canteenControllerProvider);
    final controller = ref.read(canteenControllerProvider.notifier);
    final session = ref.read(authServiceProvider).getCurrentSession();
    final staffName = session?.displayName ?? 'Canteen staff';
    final cards = _demoCards();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _CanteenTopBar(
              staffName: staffName,
              onHistory: () => context.go(AppRoutes.canteenHistory),
              onSignOut: () => _signOut(context, ref),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: state.error != null
                        ? _ScanError(
                            message: state.error!,
                            onRetry: controller.clearError,
                          )
                        : _ScanPrompt(
                            loading: state.loading,
                            cards: cards,
                            onSimulate: (uid) =>
                                _simulateTap(context, ref, uid),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    ref.read(canteenControllerProvider.notifier).clearSession();
    await ref.read(authServiceProvider).logout();
    if (context.mounted) context.go(AppRoutes.canteenLogin);
  }
}

class _ScanPrompt extends StatelessWidget {
  const _ScanPrompt({
    required this.loading,
    required this.cards,
    required this.onSimulate,
  });

  final bool loading;
  final List<({String label, String uid})> cards;
  final void Function(String uid) onSimulate;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const StudentCardIllustration(),
        const SizedBox(height: 36),
        Text(
          'Ask the student to tap their ID card',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Hold the physical Student ID card on the reader to look up their '
          'reward balance. No phone or QR code is used.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.inkMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        if (loading)
          Column(
            children: [
              const SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  color: AppColors.coinGoldDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Reading card…',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )
        else ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.coinGoldSurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'DEMO · simulate a card tap',
              style: TextStyle(
                color: AppColors.coinGoldDark,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (var i = 0; i < cards.length; i++)
                (i == 0 ? FilledButton.icon : OutlinedButton.icon)(
                  onPressed: () => onSimulate(cards[i].uid),
                  icon: const Icon(Icons.contactless_outlined),
                  label: Text('Tap (${cards[i].label})'),
                  style: i == 0
                      ? FilledButton.styleFrom(
                          backgroundColor: AppColors.coinGoldDark,
                        )
                      : null,
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ScanError extends StatelessWidget {
  const _ScanError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: AppColors.warningSurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.credit_card_off,
              size: 46, color: AppColors.warning),
        ),
        const SizedBox(height: 24),
        Text(
          "That card wasn't recognised",
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.inkMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Try another card'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.coinGoldDark,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 3. Student summary
// -----------------------------------------------------------------------------

/// Shows the scanned student's first name, class, house and reward balance.
/// The full ID number is never shown (masked). From here staff either proceed to
/// choose a reward or cancel and return to scan for the next student.
class CanteenStudentScreen extends ConsumerWidget {
  const CanteenStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(canteenControllerProvider);
    final controller = ref.read(canteenControllerProvider.notifier);
    final student = state.student;

    return _CanteenScaffold(
      ref: ref,
      title: 'Student',
      body: student == null
          ? _NoStudentRedirect(controller: controller)
          : _configBuilder(
              ref,
              (config) => ContentBounds(
                maxWidth: 720,
                child: Center(
                  child: SingleChildScrollView(
                    child: _StudentSummaryCard(
                      student: student,
                      house: state.house,
                      config: config,
                      onChoose: () => context.go(AppRoutes.canteenRewards),
                      onCancel: () {
                        controller.clearSession();
                        context.go(AppRoutes.canteenScanCard);
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _StudentSummaryCard extends StatelessWidget {
  const _StudentSummaryCard({
    required this.student,
    required this.house,
    required this.config,
    required this.onChoose,
    required this.onCancel,
  });

  final Student student;
  final House? house;
  final GamificationConfig config;
  final VoidCallback onChoose;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = config.formatCurrency(student.availablePoints);
    return EcoCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person,
                    size: 34, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.firstName,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Class ${student.className} · ${student.maskedStudentNumber}',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              if (house != null)
                HouseChip(
                  name: house!.name,
                  colourHex: house!.colour,
                  emblem: house!.emblem,
                ),
            ],
          ),
          const SizedBox(height: 24),
          _BalancePanel(points: student.availablePoints, money: money),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel / New student'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: onChoose,
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Choose Reward'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coinGoldDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A prominent points + monetary-value balance panel.
class _BalancePanel extends StatelessWidget {
  const _BalancePanel({required this.points, required this.money});

  final int points;
  final String money;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.coinGoldSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.coinGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, color: AppColors.coinGoldDark, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Reward balance',
                style: TextStyle(
                  color: AppColors.coinGoldDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$points pts',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(color: AppColors.ink, height: 1),
              ),
              if (money.isNotEmpty)
                Text(
                  'Worth $money',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.inkMuted),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 4. Rewards catalogue
// -----------------------------------------------------------------------------

/// Grid of available rewards. Items the student cannot afford or that are out of
/// stock are visibly disabled. Selecting an affordable, in-stock reward advances
/// to the confirmation screen. A compact balance header stays in view.
class CanteenRewardsScreen extends ConsumerWidget {
  const CanteenRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(canteenControllerProvider);
    final controller = ref.read(canteenControllerProvider.notifier);
    final student = state.student;

    return _CanteenScaffold(
      ref: ref,
      title: 'Choose a reward',
      body: student == null
          ? _NoStudentRedirect(controller: controller)
          : _configBuilder(
              ref,
              (config) => _RewardsBody(
                student: student,
                config: config,
                onSelect: (item) {
                  controller.selectReward(item);
                  context.go(AppRoutes.canteenConfirm);
                },
                onBack: () => context.go(AppRoutes.canteenStudent),
              ),
            ),
    );
  }
}

class _RewardsBody extends ConsumerWidget {
  const _RewardsBody({
    required this.student,
    required this.config,
    required this.onSelect,
    required this.onBack,
  });

  final Student student;
  final GamificationConfig config;
  final void Function(RewardItem) onSelect;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardsAsync = ref.watch(_availableRewardsProvider);
    return ContentBounds(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CompactBalanceHeader(
            student: student,
            config: config,
            onBack: onBack,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: rewardsAsync.when(
              loading: () => const LoadingView(message: 'Loading rewards…'),
              error: (e, _) => ErrorView(
                message: 'Could not load rewards.',
                onRetry: () => ref.invalidate(_availableRewardsProvider),
              ),
              data: (rewards) {
                if (rewards.isEmpty) {
                  return const EmptyView(
                    title: 'No rewards available',
                    subtitle: 'The reward catalogue is currently empty.',
                    icon: Icons.card_giftcard_outlined,
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 12),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisExtent: 196,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: rewards.length,
                  itemBuilder: (context, i) {
                    final item = rewards[i];
                    final affordable =
                        student.availablePoints >= item.pointCost;
                    final inStock = item.stockStatus.isAvailable;
                    return _RewardCard(
                      item: item,
                      config: config,
                      enabled: affordable && inStock && item.isActive,
                      affordable: affordable,
                      onTap: () => onSelect(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.item,
    required this.config,
    required this.enabled,
    required this.affordable,
    required this.onTap,
  });

  final RewardItem item;
  final GamificationConfig config;
  final bool enabled;
  final bool affordable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = config.formatCurrency(item.pointCost);
    final content = Opacity(
      opacity: enabled ? 1 : 0.55,
      child: EcoCard(
        onTap: enabled ? onTap : null,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.coinGoldSurface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_categoryIcon(item.category),
                      color: AppColors.coinGoldDark, size: 24),
                ),
                const Spacer(),
                _StockBadge(status: item.stockStatus),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: theme.textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                item.description,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.inkMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${item.pointCost} pts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: affordable ? AppColors.ink : AppColors.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (money.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    '· $money',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.inkMuted),
                  ),
                ],
                const Spacer(),
                Text(
                  item.category.label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: AppColors.inkFaint),
                ),
              ],
            ),
            if (!affordable && item.stockStatus.isAvailable)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Not enough points',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    return content;
  }
}

class _CompactBalanceHeader extends StatelessWidget {
  const _CompactBalanceHeader({
    required this.student,
    required this.config,
    required this.onBack,
  });

  final Student student;
  final GamificationConfig config;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final money = config.formatCurrency(student.availablePoints);
    return EcoCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Back to student',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              student.firstName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Icon(Icons.stars_rounded,
              color: AppColors.coinGoldDark, size: 22),
          const SizedBox(width: 6),
          Text(
            money.isEmpty
                ? '${student.availablePoints} pts'
                : '${student.availablePoints} pts · $money',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. Confirm
// -----------------------------------------------------------------------------

/// Redemption summary and staff authorisation. Validates the selection on load
/// (surfacing insufficient balance / out of stock / daily limit) and commits on
/// confirm. The confirm button is disabled while a commit is in flight to guard
/// against double submission.
class CanteenConfirmScreen extends ConsumerStatefulWidget {
  const CanteenConfirmScreen({super.key});

  @override
  ConsumerState<CanteenConfirmScreen> createState() =>
      _CanteenConfirmScreenState();
}

class _CanteenConfirmScreenState extends ConsumerState<CanteenConfirmScreen> {
  bool _submitting = false;
  bool _validating = true;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validate());
  }

  ({String staffId, String terminalId}) _staffContext() {
    final session = ref.read(authServiceProvider).getCurrentSession();
    return (
      staffId: session?.accountId ?? '',
      terminalId: MockSeedData.canteenStaff().terminalId,
    );
  }

  Future<void> _validate() async {
    final ctx = _staffContext();
    final result =
        await ref.read(canteenControllerProvider.notifier).validateSelection(
              staffId: ctx.staffId,
              terminalId: ctx.terminalId,
            );
    if (!mounted) return;
    setState(() {
      _validating = false;
      _validationError = result.failureOrNull?.message;
    });
  }

  Future<void> _confirm() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    final ctx = _staffContext();
    final ok =
        await ref.read(canteenControllerProvider.notifier).confirmRedemption(
              staffId: ctx.staffId,
              terminalId: ctx.terminalId,
            );
    if (!mounted) return;
    if (ok) {
      context.go(AppRoutes.canteenSuccess);
    } else {
      setState(() {
        _submitting = false;
        _validationError =
            ref.read(canteenControllerProvider).error ?? 'Redemption failed.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(canteenControllerProvider);
    final controller = ref.read(canteenControllerProvider.notifier);
    final student = state.student;
    final item = state.selectedReward;

    return _CanteenScaffold(
      ref: ref,
      title: 'Confirm redemption',
      body: (student == null || item == null)
          ? _NoStudentRedirect(controller: controller)
          : _configBuilder(
              ref,
              (config) => ContentBounds(
                maxWidth: 720,
                child: Center(
                  child: SingleChildScrollView(
                    child: _ConfirmCard(
                      student: student,
                      item: item,
                      config: config,
                      validating: _validating,
                      submitting: _submitting,
                      validationError: _validationError,
                      onConfirm: _confirm,
                      onBack: _submitting
                          ? null
                          : () => context.go(AppRoutes.canteenRewards),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({
    required this.student,
    required this.item,
    required this.config,
    required this.validating,
    required this.submitting,
    required this.validationError,
    required this.onConfirm,
    required this.onBack,
  });

  final Student student;
  final RewardItem item;
  final GamificationConfig config;
  final bool validating;
  final bool submitting;
  final String? validationError;
  final VoidCallback onConfirm;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cost = item.pointCost;
    final remaining = (student.availablePoints - cost).clamp(0, 1 << 30);
    final costMoney = config.formatCurrency(cost);
    final remainingMoney = config.formatCurrency(remaining);
    final blocked = validationError != null;

    return EcoCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SectionHeader(
            title: item.name,
            subtitle: item.description,
            icon: Icons.redeem,
          ),
          const SizedBox(height: 20),
          _SummaryRow(
            label: 'Student',
            value: '${student.firstName} · Class ${student.className}',
          ),
          _SummaryRow(
            label: 'ID',
            value: student.maskedStudentNumber,
          ),
          const Divider(height: 28),
          _SummaryRow(
            label: 'Cost',
            value: costMoney.isEmpty ? '$cost pts' : '$cost pts · $costMoney',
            emphasise: true,
          ),
          _SummaryRow(
            label: 'Current balance',
            value: '${student.availablePoints} pts',
          ),
          _SummaryRow(
            label: 'Balance after',
            value: remainingMoney.isEmpty
                ? '$remaining pts'
                : '$remaining pts · $remainingMoney',
          ),
          if (item.requiresStaffApproval) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This reward requires staff approval and will be recorded '
                      'as pending for hand-off.',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (blocked) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.errorSurface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.block, color: AppColors.error, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      validationError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: (validating || submitting || blocked)
                      ? null
                      : onConfirm,
                  icon: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    submitting
                        ? 'Processing…'
                        : validating
                            ? 'Checking…'
                            : 'Confirm Redemption',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.coinGoldDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 6. Success receipt
// -----------------------------------------------------------------------------

/// Receipt-style confirmation. Shows the reward, points deducted, monetary
/// value, new balance, timestamp, staff name and a transaction id. Auto-clears
/// the customer session after a short delay (privacy on a shared terminal) and
/// returns to the scan screen; "Done" does the same immediately.
class CanteenSuccessScreen extends ConsumerStatefulWidget {
  const CanteenSuccessScreen({super.key});

  @override
  ConsumerState<CanteenSuccessScreen> createState() =>
      _CanteenSuccessScreenState();
}

class _CanteenSuccessScreenState extends ConsumerState<CanteenSuccessScreen> {
  Timer? _timer;
  static const _autoClearAfter = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();
    // Privacy: never leave the previous customer's receipt on a shared screen.
    _timer = Timer(_autoClearAfter, _finish);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finish() {
    _timer?.cancel();
    ref.read(canteenControllerProvider.notifier).clearSession();
    if (mounted) context.go(AppRoutes.canteenScanCard);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(canteenControllerProvider);
    final controller = ref.read(canteenControllerProvider.notifier);
    final txn = state.lastTransaction;
    final student = state.student;
    final session = ref.read(authServiceProvider).getCurrentSession();
    final staffName = session?.displayName ?? 'Canteen staff';

    return _CanteenScaffold(
      ref: ref,
      title: 'Redemption complete',
      body: (txn == null || student == null)
          ? _NoStudentRedirect(controller: controller)
          : ContentBounds(
              maxWidth: 640,
              child: Center(
                child: SingleChildScrollView(
                  child: _ReceiptCard(
                    txn: txn,
                    student: student,
                    staffName: staffName,
                    onDone: _finish,
                  ),
                ),
              ),
            ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({
    required this.txn,
    required this.student,
    required this.staffName,
    required this.onDone,
  });

  final RewardTransaction txn;
  final Student student;
  final String staffName;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = txn.status == RewardTransactionStatus.pending;
    final money = txn.rewardValue > 0
        ? 'AED ${txn.rewardValue.toStringAsFixed(2)}'
        : '';
    return EcoCard(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: (pending ? AppColors.warning : AppColors.success)
                  .withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              pending ? Icons.hourglass_top_rounded : Icons.check_circle,
              size: 52,
              color: pending ? AppColors.warning : AppColors.success,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            pending ? 'Awaiting hand-off' : 'Redeemed!',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            txn.description,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: AppColors.inkMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Student', value: student.firstName),
                _SummaryRow(
                  label: 'Points deducted',
                  value: '${txn.points.abs()} pts',
                  emphasise: true,
                ),
                if (money.isNotEmpty)
                  _SummaryRow(label: 'Value', value: money),
                _SummaryRow(
                  label: 'New balance',
                  value: '${student.availablePoints} pts',
                ),
                _SummaryRow(label: 'Status', value: txn.status.label),
                _SummaryRow(
                  label: 'Time',
                  value: _formatDateTime(txn.createdAt),
                ),
                _SummaryRow(label: 'Authorised by', value: staffName),
                _SummaryRow(label: 'Transaction', value: txn.id),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Returning to the card reader shortly…',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.inkFaint),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onDone,
              icon: const Icon(Icons.done_all),
              label: const Text('Done'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coinGoldDark,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 7. History
// -----------------------------------------------------------------------------

/// Recent redemption history across all students on this terminal, newest
/// first. Read-only; back returns to the scan screen.
class CanteenHistoryScreen extends ConsumerWidget {
  const CanteenHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(_historyProvider);
    return _CanteenScaffold(
      ref: ref,
      title: 'Redemption history',
      onBack: () => context.go(AppRoutes.canteenScanCard),
      body: _configBuilder(
        ref,
        (config) => historyAsync.when(
          loading: () => const LoadingView(message: 'Loading history…'),
          error: (e, _) => ErrorView(
            message: 'Could not load redemption history.',
            onRetry: () => ref.invalidate(_historyProvider),
          ),
          data: (txns) {
            if (txns.isEmpty) {
              return const EmptyView(
                title: 'No redemptions yet',
                subtitle: 'Completed redemptions will appear here.',
                icon: Icons.receipt_long_outlined,
              );
            }
            return ContentBounds(
              child: ListView.separated(
                itemCount: txns.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, i) =>
                    _HistoryTile(txn: txns[i], config: config),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.txn, required this.config});

  final RewardTransaction txn;
  final GamificationConfig config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final money = txn.rewardValue > 0
        ? 'AED ${txn.rewardValue.toStringAsFixed(2)}'
        : '';
    return EcoCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.coinGoldSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.redeem,
                color: AppColors.coinGoldDark, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.description,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDateTime(txn.createdAt),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.inkFaint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${txn.points.abs()} pts',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              if (money.isNotEmpty)
                Text(
                  money,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.inkMuted),
                ),
              const SizedBox(height: 4),
              _TxnStatusBadge(status: txn.status),
            ],
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Shared building blocks
// -----------------------------------------------------------------------------

/// A gold-accented scaffold for the post-login terminal screens: a top bar with
/// the staff name, History and Sign out, plus an optional back button.
class _CanteenScaffold extends StatelessWidget {
  const _CanteenScaffold({
    required this.ref,
    required this.title,
    required this.body,
    this.onBack,
  });

  final WidgetRef ref;
  final String title;
  final Widget body;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final session = ref.read(authServiceProvider).getCurrentSession();
    final staffName = session?.displayName ?? 'Canteen staff';
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _CanteenTopBar(
              staffName: staffName,
              title: title,
              onBack: onBack,
              onHistory: () => context.go(AppRoutes.canteenHistory),
              onSignOut: () async {
                ref.read(canteenControllerProvider.notifier).clearSession();
                await ref.read(authServiceProvider).logout();
                if (context.mounted) context.go(AppRoutes.canteenLogin);
              },
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// Shared gold top bar: brand + staff identity + History / Sign out actions.
class _CanteenTopBar extends StatelessWidget {
  const _CanteenTopBar({
    required this.staffName,
    required this.onHistory,
    required this.onSignOut,
    this.title,
    this.onBack,
  });

  final String staffName;
  final VoidCallback onHistory;
  final VoidCallback onSignOut;
  final String? title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Back',
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.coinGoldSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.storefront,
                  color: AppColors.coinGoldDark, size: 22),
            ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? 'Canteen Terminal',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '${MockSeedData.canteenStaff().terminalId} · $staffName',
                style: const TextStyle(
                  color: AppColors.inkFaint,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onHistory,
            icon: const Icon(Icons.history, size: 20),
            label: const Text('History'),
          ),
          const SizedBox(width: 4),
          OutlinedButton.icon(
            onPressed: onSignOut,
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

/// Redirect-to-scan fallback for deep-links / stale state where the required
/// student (or transaction) is missing.
class _NoStudentRedirect extends StatelessWidget {
  const _NoStudentRedirect({required this.controller});

  final CanteenController controller;

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      title: 'No student scanned',
      subtitle: 'Ask the student to tap their ID card to begin.',
      icon: Icons.contactless_outlined,
      action: FilledButton.icon(
        onPressed: () {
          controller.clearSession();
          context.go(AppRoutes.canteenScanCard);
        },
        icon: const Icon(Icons.badge_outlined),
        label: const Text('Go to card reader'),
        style: FilledButton.styleFrom(backgroundColor: AppColors.coinGoldDark),
      ),
    );
  }
}

/// A label/value row used across the confirm and receipt cards.
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.inkMuted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: (emphasise
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(
                color: AppColors.ink,
                fontWeight: emphasise ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stock availability pill for a reward card.
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.status});

  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg) = switch (status) {
      StockStatus.inStock => (AppColors.success, AppColors.successSurface),
      StockStatus.lowStock => (AppColors.warning, AppColors.warningSurface),
      StockStatus.outOfStock => (AppColors.error, AppColors.errorSurface),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

/// Coloured status pill for a redemption transaction in the history list.
class _TxnStatusBadge extends StatelessWidget {
  const _TxnStatusBadge({required this.status});

  final RewardTransactionStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg) = switch (status) {
      RewardTransactionStatus.completed ||
      RewardTransactionStatus.approved =>
        (AppColors.success, AppColors.successSurface),
      RewardTransactionStatus.pending =>
        (AppColors.warning, AppColors.warningSurface),
      RewardTransactionStatus.cancelled ||
      RewardTransactionStatus.failed =>
        (AppColors.error, AppColors.errorSurface),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Helpers & data providers
// -----------------------------------------------------------------------------

/// Builds a widget once the active gamification config resolves, handling the
/// loading/error states with the shared views. Keeps every screen consistent
/// when reading `formatCurrency`.
Widget _configBuilder(
  WidgetRef ref,
  Widget Function(GamificationConfig config) builder,
) {
  final async = ref.watch(gamificationConfigProvider);
  return async.when(
    loading: () => const LoadingView(),
    error: (e, _) => const ErrorView(message: 'Could not load terminal config.'),
    data: builder,
  );
}

IconData _categoryIcon(RewardCategory category) => switch (category) {
      RewardCategory.snack => Icons.lunch_dining_outlined,
      RewardCategory.stationery => Icons.edit_outlined,
      RewardCategory.housePrivilege => Icons.shield_outlined,
      RewardCategory.raffleEntry => Icons.confirmation_number_outlined,
      RewardCategory.avatarAccessory => Icons.face_retouching_natural_outlined,
      RewardCategory.badge => Icons.military_tech_outlined,
    };

String _formatDateTime(DateTime dt) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${dt.year}-${two(dt.month)}-${two(dt.day)} '
      '${two(dt.hour)}:${two(dt.minute)}';
}

/// Available (active) rewards for the catalogue screen.
final _availableRewardsProvider = FutureProvider.autoDispose<List<RewardItem>>(
  (ref) => ref.watch(rewardServiceProvider).getAvailableRewards(),
);

/// All redemption history (no student filter) for the history screen.
final _historyProvider =
    FutureProvider.autoDispose<List<RewardTransaction>>(
  (ref) => ref.watch(rewardServiceProvider).getRedemptionHistory(),
);
