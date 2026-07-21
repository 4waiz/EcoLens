import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The four physical bin compartments on the EcoLens recycling bin.
enum WasteCategory {
  plastic,
  paper,
  organic,
  general;

  /// Human-facing label shown on bin buttons and dashboards.
  String get label => switch (this) {
    WasteCategory.plastic => 'Plastic',
    WasteCategory.paper => 'Paper',
    WasteCategory.organic => 'Organic',
    WasteCategory.general => 'General Waste',
  };

  /// Short label for compact chips.
  String get shortLabel => switch (this) {
    WasteCategory.plastic => 'Plastic',
    WasteCategory.paper => 'Paper',
    WasteCategory.organic => 'Organic',
    WasteCategory.general => 'General',
  };

  /// Category accent colour (also used for the physical LED strip semantics).
  Color get colour => switch (this) {
    WasteCategory.plastic => AppColors.plastic,
    WasteCategory.paper => AppColors.paper,
    WasteCategory.organic => AppColors.organic,
    WasteCategory.general => AppColors.general,
  };

  IconData get icon => switch (this) {
    WasteCategory.plastic => Icons.local_drink_outlined,
    WasteCategory.paper => Icons.description_outlined,
    WasteCategory.organic => Icons.eco_outlined,
    WasteCategory.general => Icons.delete_outline,
  };

  /// Stable serialization key.
  String get key => name;

  static WasteCategory fromKey(String key) => WasteCategory.values.firstWhere(
    (c) => c.name == key,
    orElse: () => WasteCategory.general,
  );
}
