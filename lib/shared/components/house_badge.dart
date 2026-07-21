import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// A circular house emblem badge. Uses an emoji/icon glyph mapped from the
/// house emblem key, coloured by the house colour. Self-contained (no assets).
class HouseBadge extends StatelessWidget {
  const HouseBadge({
    super.key,
    required this.emblem,
    required this.colourHex,
    this.size = 48,
    this.selected = false,
  });

  final String emblem;
  final String colourHex;
  final double size;
  final bool selected;

  static const Map<String, IconData> _icons = {
    'aries': Icons.filter_hdr, // ram/mountain
    'taurus': Icons.agriculture, // bull/earth
    'leo': Icons.wb_sunny, // lion/sun
    'aquarius': Icons.water_drop, // water bearer
  };

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(colourHex);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(
          color: colour,
          width: selected ? size * 0.08 : size * 0.05,
        ),
      ),
      child: Icon(
        _icons[emblem.toLowerCase()] ?? Icons.shield_outlined,
        color: colour,
        size: size * 0.5,
      ),
    );
  }
}

/// A colour-coded house name chip.
class HouseChip extends StatelessWidget {
  const HouseChip({
    super.key,
    required this.name,
    required this.colourHex,
    this.emblem,
  });

  final String name;
  final String colourHex;
  final String? emblem;

  @override
  Widget build(BuildContext context) {
    final colour = AppColors.fromHex(colourHex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colour.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emblem != null) ...[
            HouseBadge(emblem: emblem!, colourHex: colourHex, size: 20),
            const SizedBox(width: 6),
          ],
          Text(
            name,
            style: TextStyle(
              color: colour,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
