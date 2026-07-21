import 'package:flutter/widgets.dart';

/// Named breakpoints for EcoLens surfaces.
///
/// The kiosk always renders in a landscape composition; dashboards adapt from
/// mobile-ish → tablet → desktop; the canteen terminal targets landscape tablet.
enum ScreenSize { compact, medium, expanded, large }

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  ScreenSize get sizeClass {
    final w = screenWidth;
    if (w < 640) return ScreenSize.compact;
    if (w < 1024) return ScreenSize.medium;
    if (w < 1440) return ScreenSize.expanded;
    return ScreenSize.large;
  }

  bool get isCompact => sizeClass == ScreenSize.compact;
  bool get isMedium => sizeClass == ScreenSize.medium;
  bool get isDesktop =>
      sizeClass == ScreenSize.expanded || sizeClass == ScreenSize.large;

  bool get isLandscape => screenWidth >= screenHeight;

  /// Sensible number of grid columns for dashboard content.
  int get dashboardColumns => switch (sizeClass) {
    ScreenSize.compact => 1,
    ScreenSize.medium => 2,
    ScreenSize.expanded => 3,
    ScreenSize.large => 4,
  };
}

/// Selects a value based on the current screen size class.
T responsiveValue<T>(
  BuildContext context, {
  required T compact,
  T? medium,
  T? expanded,
  T? large,
}) {
  return switch (context.sizeClass) {
    ScreenSize.compact => compact,
    ScreenSize.medium => medium ?? compact,
    ScreenSize.expanded => expanded ?? medium ?? compact,
    ScreenSize.large => large ?? expanded ?? medium ?? compact,
  };
}

/// A max-width content wrapper for dashboard/canteen readability on wide
/// screens.
class ContentBounds extends StatelessWidget {
  const ContentBounds({
    super.key,
    required this.child,
    this.maxWidth = 1360,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
