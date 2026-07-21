import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../components/ecolens_logo.dart';
import '../responsive/responsive.dart';

/// A navigation destination for the dashboard shell.
class DashboardNavItem {
  const DashboardNavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
  final String label;
  final IconData icon;
  final String route;
}

/// Responsive shell for the teacher & admin dashboards: a persistent nav rail
/// (drawer on compact widths) + a top bar + the routed content. Keyboard
/// navigable and screen-reader friendly.
class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.title,
    required this.items,
    required this.currentRoute,
    required this.child,
    required this.accent,
    required this.userName,
    required this.userRoleLabel,
    this.onLogout,
    this.actions = const [],
  });

  final String title;
  final List<DashboardNavItem> items;
  final String currentRoute;
  final Widget child;
  final Color accent;
  final String userName;
  final String userRoleLabel;
  final VoidCallback? onLogout;
  final List<Widget> actions;

  int get _selectedIndex {
    final i = items.indexWhere((e) => currentRoute.startsWith(e.route));
    return i < 0 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenWidth < 900;
    final content = Column(
      children: [
        _TopBar(
          title: title,
          accent: accent,
          userName: userName,
          userRoleLabel: userRoleLabel,
          onLogout: onLogout,
          actions: actions,
          showMenu: compact,
        ),
        Expanded(child: child),
      ],
    );

    if (compact) {
      return Scaffold(
        drawer: Drawer(
          child: _NavList(
            items: items,
            selectedIndex: _selectedIndex,
            accent: accent,
            onTap: (route) {
              Navigator.of(context).pop();
              context.go(route);
            },
          ),
        ),
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(child: content),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Row(
          children: [
            SizedBox(
              width: 248,
              child: _NavList(
                items: items,
                selectedIndex: _selectedIndex,
                accent: accent,
                onTap: (route) => context.go(route),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}

class _NavList extends StatelessWidget {
  const _NavList({
    required this.items,
    required this.selectedIndex,
    required this.accent,
    required this.onTap,
  });

  final List<DashboardNavItem> items;
  final int selectedIndex;
  final Color accent;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: InkWell(
              onTap: () => context.go(AppRoutes.home),
              child: const EcoLensLogo(height: 36),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (context, i) {
                final item = items[i];
                final selected = i == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: item.label,
                    child: Material(
                      color: selected
                          ? accent.withValues(alpha: 0.10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onTap(item.route),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: selected ? accent : AppColors.inkFaint,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color:
                                        selected ? accent : AppColors.inkMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.accent,
    required this.userName,
    required this.userRoleLabel,
    required this.onLogout,
    required this.actions,
    required this.showMenu,
  });

  final String title;
  final Color accent;
  final String userName;
  final String userRoleLabel;
  final VoidCallback? onLogout;
  final List<Widget> actions;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (showMenu)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          ...actions,
          const SizedBox(width: 8),
          _UserMenu(
            name: userName,
            roleLabel: userRoleLabel,
            accent: accent,
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }
}

class _UserMenu extends StatelessWidget {
  const _UserMenu({
    required this.name,
    required this.roleLabel,
    required this.accent,
    required this.onLogout,
  });

  final String name;
  final String roleLabel;
  final Color accent;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Account',
      onSelected: (v) {
        if (v == 'logout') onLogout?.call();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Sign out'),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: accent.withValues(alpha: 0.15),
            child: Text(
              name.isNotEmpty ? name.characters.first : '?',
              style: TextStyle(color: accent, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                roleLabel,
                style: const TextStyle(
                  color: AppColors.inkFaint,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Icon(Icons.expand_more, color: AppColors.inkFaint),
        ],
      ),
    );
  }
}
