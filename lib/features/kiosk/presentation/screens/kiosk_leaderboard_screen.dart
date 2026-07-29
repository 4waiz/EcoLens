import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../domain/models/models.dart';
import '../../application/kiosk_controller.dart';
import '../widgets/kiosk_chrome.dart';
import '../../../../shared/components/house_badge.dart';

/// SCREEN 11 — House leaderboard.
///
/// Shows Aries / Taurus / Leo / Aquarius ranked, weekly movement, house goals,
/// and highlights the current student's house. A Return button goes back; the
/// privacy timeout still applies via the controller.
class KioskLeaderboardScreen extends ConsumerWidget {
  const KioskLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(kioskControllerProvider);
    final controller = ref.read(kioskControllerProvider.notifier);
    final entries = session.leaderboard;
    if (entries.isEmpty) {
      return const LoadingView(message: 'Loading the leaderboard…');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 8, 48, 24),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.leaderboard, color: AppColors.primary, size: 28),
              const SizedBox(width: 10),
              Text(
                'House Leaderboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primaryDark,
                ),
              ),
              const Spacer(),
              Text(
                'Compete · Contribute · Lead the change 🌱',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.inkMuted),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Podium (top 3).
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (entries.length > 1)
                  Expanded(
                    child: _PodiumColumn(entry: entries[1], height: 180),
                  ),
                if (entries.isNotEmpty)
                  Expanded(
                    child: _PodiumColumn(
                      entry: entries[0],
                      height: 230,
                      crown: true,
                    ),
                  ),
                if (entries.length > 2)
                  Expanded(
                    child: _PodiumColumn(entry: entries[2], height: 150),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Remaining houses list.
          if (entries.length > 3)
            Column(
              children: [
                for (final e in entries.skip(3)) _LeaderboardRow(entry: e),
              ],
            ),
          const SizedBox(height: 16),
          KioskButton(
            label: 'Return',
            icon: Icons.arrow_back,
            onPressed: controller.backFromSubScreen,
          ),
        ],
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({
    required this.entry,
    required this.height,
    this.crown = false,
  });

  final LeaderboardEntry entry;
  final double height;
  final bool crown;

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(entry.houseColour);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (crown)
            const Icon(Icons.emoji_events, color: AppColors.coinGold, size: 30),
          HouseBadge(
            emblem: entry.subtitle.isNotEmpty
                ? _emblemFor(entry.entityName)
                : 'shield',
            colourHex: entry.houseColour,
            size: crown ? 64 : 52,
            selected: entry.isCurrentEntity,
          ),
          const SizedBox(height: 6),
          Text(
            entry.entityName,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: crown ? 20 : 17,
              color: colour,
            ),
          ),
          Text(
            '${entry.totalPoints} pts',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colour, colour.withValues(alpha: 0.7)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: entry.isCurrentEntity
                  ? Border.all(color: AppColors.ink, width: 3)
                  : null,
            ),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              '#${entry.rank}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 26,
              ),
            ),
          ),
          if (entry.isCurrentEntity)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                'Your house',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _emblemFor(String name) => name.toLowerCase();
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.entry});
  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(entry.houseColour);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isCurrentEntity
            ? colour.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.isCurrentEntity ? colour : AppColors.border,
          width: entry.isCurrentEntity ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            '#${entry.rank}',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(width: 14),
          HouseBadge(
            emblem: entry.entityName.toLowerCase(),
            colourHex: entry.houseColour,
            size: 34,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.entityName} House',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  entry.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _MovementChip(change: entry.weeklyChange),
          const SizedBox(width: 12),
          Text(
            '${entry.totalPoints} pts',
            style: TextStyle(fontWeight: FontWeight.w800, color: colour),
          ),
        ],
      ),
    );
  }
}

class _MovementChip extends StatelessWidget {
  const _MovementChip({required this.change});
  final int change;

  @override
  Widget build(BuildContext context) {
    if (change == 0) {
      return const Icon(Icons.remove, color: AppColors.inkFaint, size: 18);
    }
    final up = change > 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_upward : Icons.arrow_downward,
          size: 16,
          color: up ? AppColors.success : AppColors.error,
        ),
        Text(
          '${change.abs()}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: up ? AppColors.success : AppColors.error,
          ),
        ),
      ],
    );
  }
}
