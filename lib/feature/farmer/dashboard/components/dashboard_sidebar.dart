import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/providers/navigation_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'dashboard_constants.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD SIDEBAR
// Contains three public components:
//   1. DashboardSidebar  — persistent 256-px panel for desktop (w > 700).
//   2. DashboardDrawer   — slide-in drawer for mobile.
//   3. SidebarNavTile    — shared row tile used by both above.
// ═══════════════════════════════════════════════════════════════════════════════

// ─── DashboardSidebar ─────────────────────────────────────────────────────────

/// Persistent sidebar rendered on screens wider than 700 px.
class DashboardSidebar extends StatelessWidget {
  final List<NavItem> navItems;
  final int selectedIndex;                           // ← أضف هذا
  final void Function(int index) onNavigate;

  const DashboardSidebar({
    super.key,
    required this.navItems,
    required this.selectedIndex,                     // ← أضف هذا
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.33),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        children: List.generate(navItems.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SidebarNavTile(
              item:       navItems[i],
              isSelected: selectedIndex == i,        // ← استخدم الـ prop مباشرة
              onTap:      () => onNavigate(i),
            ),
          );
        }),
      ),
    );
  }
}
// ─── DashboardDrawer ──────────────────────────────────────────────────────────

/// Mobile drawer that slides in from the left.
class SideBarDrawer extends StatelessWidget {
  final List<NavItem> navItems;
  final void Function(int index) onNavigate;

  const SideBarDrawer({
    super.key,
    required this.navItems,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final user = context
        .watch<AuthProvider>()
        .currentUser;
    final userName = user?.name ?? '';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
              Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              ),
              child: Center(
                child: SvgPicture.asset(
                    'assets/images/icons/plant_icon.svg',

                    colorFilter:const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
              ),
            ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Farm AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (userName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        userName,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NavigationProvider>(
              builder: (_, nav, __) =>
                  ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8),
                    children: List.generate(navItems.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: SidebarNavTile(
                          item: navItems[i],
                          isSelected: nav.selectedIndex == i,
                          onTap: () {
                            Navigator.pop(context);
                            context.read<NavigationProvider>().setIndex(i);
                            if (i >= 1) {
                              onNavigate(i);
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

// ─── SidebarNavTile ───────────────────────────────────────────────────────────

class SidebarNavTile extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarNavTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isTitleLong = item.label.length > 20;

    return Tooltip(
      message: item.label,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 500),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
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
              _TileIcon(item: item, isSelected: isSelected),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isTitleLong ? 12.5 : 14,
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    letterSpacing: isTitleLong ? -0.3 : 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const _TileIcon({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.white : AppColors.primary;

    if (item.svg != null) {
      return SvgPicture.asset(
        item.svg!,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    }

    return Icon(item.icon, size: 20, color: color);
  }
}
