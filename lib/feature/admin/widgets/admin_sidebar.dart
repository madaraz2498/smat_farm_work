import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/admin/pages/admin_settings_page.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ADMIN SIDEBAR
// lib/feature/admin/widgets/admin_sidebar.dart
// ═══════════════════════════════════════════════════════════════════════════════

// ─── AdminNavItem ─────────────────────────────────────────────────────────────

class AdminNavItem {
  final IconData icon;
  final String label;
  final bool isAdminOnly;

  const AdminNavItem({
    required this.icon,
    required this.label,
    this.isAdminOnly = false,
  });
}

// ─── Canonical Admin nav items ─────────────────────────────────────────────────

const List<AdminNavItem> kAdminNavItems = [
  AdminNavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
  AdminNavItem(icon: Icons.people_outline, label: 'User Management', isAdminOnly: true),
  AdminNavItem(icon: Icons.bar_chart_outlined, label: 'System Reports', isAdminOnly: true),
  AdminNavItem(icon: Icons.settings_outlined, label: 'Settings', isAdminOnly: true),
];

const int kAdminSettingsIndex = 3;

// ─── AdminSidebar ─────────────────────────────────────────────────────────────

class AdminSidebar extends StatelessWidget {
  final List<AdminNavItem> navItems;
  final int selectedIndex;
  final void Function(int index) onTap;
  final VoidCallback? onSettingsPopped;
  final VoidCallback onSignOut;

  const AdminSidebar({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onTap,
    required this.onSignOut,
    this.onSettingsPopped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.33),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.pagePadding),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'ADMIN PANEL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ...List.generate(navItems.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: AdminNavTile(
                      item: navItems[i],
                      isSelected: selectedIndex == i,
                      onTap: () => _handleTap(context, i),
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(color: AppColors.cardBorder, height: 1),
          _SignOutRow(onSignOut: onSignOut),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (index == kAdminSettingsIndex) {
      onTap(index);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
      ).then((_) => onSettingsPopped?.call());
      return;
    }
    onTap(index);
  }
}

// ─── AdminDrawer ──────────────────────────────────────────────────────────────

class AdminDrawer extends StatelessWidget {
  final List<AdminNavItem> navItems;
  final int selectedIndex;
  final void Function(int index) onTap;
  final VoidCallback? onSettingsPopped;
  final VoidCallback onSignOut;

  const AdminDrawer({
    super.key,
    required this.navItems,
    required this.selectedIndex,
    required this.onTap,
    required this.onSignOut,
    this.onSettingsPopped,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user?.name ?? '';
    final userRole = (user?.role != null && user!.role.isNotEmpty)
        ? user.role.toLowerCase()
        : 'administrator';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Smart Farm AI',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      if (userName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(userName, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                      Text(userRole, style: const TextStyle(color: Colors.white60, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'ADMIN PANEL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
                ...List.generate(navItems.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: AdminNavTile(
                      item: navItems[i],
                      isSelected: selectedIndex == i,
                      onTap: () {
                        Navigator.pop(context);
                        _handleTap(context, i);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const Divider(color: AppColors.cardBorder, height: 1),
          _SignOutRow(onSignOut: () {
            Navigator.pop(context);
            onSignOut();
          }),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (index == kAdminSettingsIndex) {
      onTap(index);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
      ).then((_) => onSettingsPopped?.call());
      return;
    }
    onTap(index);
  }
}

// ─── AdminNavTile ─────────────────────────────────────────────────────────────

class AdminNavTile extends StatelessWidget {
  final AdminNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const AdminNavTile({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLong = item.label.length > 20;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(99),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 20,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  item.label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isLong ? 12.5 : 14,
                    color: isSelected ? Colors.white : AppColors.textDark,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: isLong ? -0.3 : 0,
                  ),
                ),
              ),
              if (item.isAdminOnly) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── _SignOutRow ──────────────────────────────────────────────────────────────

class _SignOutRow extends StatelessWidget {
  final VoidCallback onSignOut;
  const _SignOutRow({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSignOut,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: const [
            Icon(Icons.logout_rounded, size: 18, color: AppColors.textSubtle),
            SizedBox(width: 12),
            Text('Sign out', style: TextStyle(fontSize: 13, color: AppColors.textSubtle)),
          ],
        ),
      ),
    );
  }
}
