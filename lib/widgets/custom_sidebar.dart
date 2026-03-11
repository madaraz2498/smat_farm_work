import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/navigation_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NavItem model
//
// Moved here so both the sidebar and the dashboard can share one definition.
// ─────────────────────────────────────────────────────────────────────────────

class NavItem {
  final IconData icon;
  final String   label;
  final String?  svgPath; // null → fall back to [icon]

  const NavItem({
    required this.icon,
    required this.label,
    this.svgPath,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// AppSidebar  (Desktop — persistent, 256 px wide)
// ─────────────────────────────────────────────────────────────────────────────

class AppSidebar extends StatelessWidget {
  final List<NavItem> navItems;

  /// Called when a non-home item is tapped (idx ≥ 1).
  final void Function(int idx) onNavigate;

  const AppSidebar({
    super.key,
    required this.navItems,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (_, nav, __) => Container(
        width: AppSizes.sidebarWidth + 36, // Adjusting for original 256px
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            right: BorderSide(color: AppColors.cardBorder, width: 1.33),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: List.generate(navItems.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SidebarTile(
                item:       navItems[i],
                isSelected: nav.selectedIndex == i,
                onTap: () {
                  if (i >= 1) {
                    onNavigate(i);
                  } else {
                    context.read<NavigationProvider>().setIndex(i);
                  }
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AppDrawer  (Mobile — slides in from left)
// ─────────────────────────────────────────────────────────────────────────────

class AppDrawer extends StatelessWidget {
  final List<NavItem> navItems;
  final void Function(int idx) onNavigate;

  const AppDrawer({
    super.key,
    required this.navItems,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    final cs   = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color:         Colors.white.withValues(alpha: 0.2),
                    borderRadius:  BorderRadius.circular(AppSizes.radiusMid),
                  ),
                  child: const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Smart Farm AI',
                          style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(user?.name ?? '',
                          style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      Text(user?.role.toLowerCase() ?? '',
                          style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Nav items ────────────────────────────────────────────────
          Expanded(
            child: Consumer<NavigationProvider>(
              builder: (_, nav, __) => ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                children: List.generate(navItems.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: SidebarTile(
                      item:       navItems[i],
                      isSelected: nav.selectedIndex == i,
                      onTap: () {
                        Navigator.pop(context); // close drawer first
                        if (i >= 1) {
                          onNavigate(i);
                        } else {
                          context.read<NavigationProvider>().setIndex(i);
                        }
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SidebarTile  (shared row used in both Sidebar and Drawer)
// ─────────────────────────────────────────────────────────────────────────────

class SidebarTile extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLong = item.label.length > 20;

    return InkWell(
      onTap:        onTap,
      borderRadius: BorderRadius.circular(99),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(99),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Row(
          children: [
            // Icon — SVG preferred, IconData fallback
            _TileIcon(item: item, isSelected: isSelected),
            const SizedBox(width: 12),

            // Label
            Flexible(
              child: Text(
                item.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isLong ? 12 : 14,
                  color:      isSelected ? Colors.white : AppColors.textDark,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: isLong ? -0.3 : 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const _TileIcon({
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? Colors.white : AppColors.primary;

    if (item.svgPath != null) {
      return SvgPicture.asset(
        item.svgPath!,
        width: 20, height: 20,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      );
    }

    return Icon(item.icon, size: 20, color: iconColor);
  }
}
