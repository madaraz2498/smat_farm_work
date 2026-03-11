import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// Models
import 'models/admin_nav_item.dart';

// Widgets
import 'widgets/admin_sidebar.dart';
import 'widgets/admin_top_bar.dart';

// Pages
import 'pages/dashboard_page.dart';
import 'pages/user_management_page.dart';
import 'pages/system_management_page.dart';
import 'pages/system_reports_page.dart';
import 'pages/admin_settings_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminDashboardScreen  —  pure shell.
//
// Owns ONLY:  Scaffold, navigation state, Drawer wiring.
// Everything visual lives in widget / page files.
//
// Layout:
//   Wide  (≥ 700 px): Column [ AdminTopBar ] [ Row [ AdminSidebar | page ] ]
//   Narrow (< 700 px): Scaffold Drawer + Column [ AdminTopBar | page ]
// ─────────────────────────────────────────────────────────────────────────────
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  static const List<AdminNavItem> _navItems = [
    AdminNavItem(icon: Icons.dashboard_outlined,             label: 'Admin Dashboard'),
    AdminNavItem(icon: Icons.people_outline,                 label: 'User Management'),
    AdminNavItem(icon: Icons.settings_applications_outlined, label: 'System Management'),
    AdminNavItem(icon: Icons.bar_chart_outlined,             label: 'System Reports'),
    AdminNavItem(icon: Icons.tune_outlined,                  label: 'Settings'),
  ];

  String get _pageTitle => _navItems[_selectedIndex].label;

  void _onNavSelected(int index) {
    setState(() => _selectedIndex = index);
    if (Navigator.canPop(context)) Navigator.pop(context); // close Drawer
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > AppSizes.wideBreak;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Drawer is only wired on narrow screens; null on wide
      drawer: wide
          ? null
          : AdminSidebar.asDrawer(
              items:          _navItems,
              selectedIndex:  _selectedIndex,
              onItemSelected: _onNavSelected,
            ),
      body: Column(
        children: [
          AdminTopBar(pageTitle: _pageTitle),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wide)
                  AdminSidebar(
                    items:          _navItems,
                    selectedIndex:  _selectedIndex,
                    onItemSelected: _onNavSelected,
                  ),
                Expanded(child: _buildPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Page router ─────────────────────────────────────────────────────────────
  // Uses const constructors → Flutter skips rebuild if widget type is unchanged.

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 1:  return const UserManagementPage();
      case 2:  return const SystemManagementPage();
      case 3:  return const SystemReportsPage();
      case 4:  return const AdminSettingsPage();
      default: return const DashboardPage();
    }
  }
}
