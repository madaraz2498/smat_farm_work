import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/admin_nav_item.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminSidebar
//
// Reusable navigation sidebar.  Receives items, selected index, and a callback
// — it owns NO navigation logic itself.
//
// Use [AdminSidebar.asDrawer] to wrap it inside a [Drawer] for narrow screens.
// ─────────────────────────────────────────────────────────────────────────────
class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<AdminNavItem> items;
  final int                selectedIndex;
  final ValueChanged<int>  onItemSelected;

  /// Wraps this widget in a [Drawer] — suitable for narrow (mobile) screens.
  static Widget asDrawer({
    required List<AdminNavItem> items,
    required int                selectedIndex,
    required ValueChanged<int>  onItemSelected,
  }) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: AdminSidebar(
          items:          items,
          selectedIndex:  selectedIndex,
          onItemSelected: onItemSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.sidebarWidth,
      decoration: BoxDecoration(
        color:  AppColors.surface,
        border: Border(
          right: BorderSide(color: Colors.black.withOpacity(0.07)),
        ),
      ),
      child: Column(
        children: [
          _buildBrand(),
          const Divider(height: 1, thickness: 1, color: AppColors.divider),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              itemCount: items.length,
              itemBuilder: (_, i) => _NavTile(
                item:       items[i],
                isSelected: i == selectedIndex,
                onTap:      () => onItemSelected(i),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        children: [
          Container(
            width:  40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.eco, color: AppColors.surface, size: 22),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Smart Farm AI',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize:   14,
                    fontWeight: FontWeight.w700,
                    color:      AppColors.textDark,
                  ),
                ),
                Text('Admin Panel',
                  style: TextStyle(fontSize: 11, color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width:  34, height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('A',
                style: TextStyle(
                  color: AppColors.surface, fontWeight: FontWeight.bold, fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin User',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark,
                  ),
                ),
                Text('admin@smartfarm.ai',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _NavTile  —  single row inside the sidebar list.
// ─────────────────────────────────────────────────────────────────────────────
class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AdminNavItem item;
  final bool         isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color:        Colors.transparent,
        borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        child: InkWell(
          onTap:        onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:     const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration:  BoxDecoration(
              color:        isSelected
                  ? AppColors.primary.withOpacity(0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border: isSelected
                  ? Border.all(color: AppColors.primary.withOpacity(0.25))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size:  20,
                  color: isSelected ? AppColors.primary : AppColors.textSubtle,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize:   13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:      isSelected ? AppColors.primary : AppColors.textMid,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 5, height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.primary, shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
