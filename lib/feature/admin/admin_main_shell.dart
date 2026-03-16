import 'package:flutter/material.dart';
import 'package:smart_farm/feature/admin/pages/admin_dashboard_page.dart';
import 'package:smart_farm/feature/admin/pages/admin_settings_page.dart';
import 'package:smart_farm/feature/admin/pages/system_management_page.dart';
import 'package:smart_farm/feature/admin/pages/system_reports_page.dart';
import 'package:smart_farm/theme/app_theme.dart' hide AppColors;
import 'pages/user_management_page.dart';
import 'widgets/admin_sidebar.dart';
import 'widgets/admin_top_bar.dart';

class AdminMainShell extends StatefulWidget {
  const AdminMainShell({super.key});

  @override
  State<AdminMainShell> createState() => _AdminMainShellState();
}

class _AdminMainShellState extends State<AdminMainShell> {
  int _selectedIndex = 0;

  static const List<AdminNavItem> _adminNavItems = [
    AdminNavItem(icon: Icons.dashboard_outlined, label: 'Admin Dashboard'),
    AdminNavItem(icon: Icons.people_outline, label: 'User Management'),
    AdminNavItem(icon: Icons.settings_applications_outlined, label: 'System Management', isAdminOnly: true),
    AdminNavItem(icon: Icons.bar_chart_outlined, label: 'System Reports'),
    AdminNavItem(icon: Icons.tune_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > AppSizes.wideBreak;

    return Scaffold(
      backgroundColor: AppColors.background,
      // الـ Drawer يظهر فقط في الشاشات الصغيرة
      drawer: isWide ? null : AdminDrawer(
        navItems: _adminNavItems,
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        onSignOut: () {},
      ),
      body: SafeArea(
        child: Row(
          children: [
            // 1. السايدبار (Desktop Only)
            if (isWide)
              AdminSidebar(
                navItems: _adminNavItems,
                selectedIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                onSignOut: () {},
              ),
        
            // 2. الجزء الرئيسي
            Expanded(
              child: Column(
                children: [
                  // استخدام الـ TopBar اللي بعته
                  AdminTopBar(
                    pageTitle: _adminNavItems[_selectedIndex].label,
                    showBurger: !isWide, // يظهر فقط لو مش Desktop
                    onNotificationTap: () {
                      // كود الإشعارات
                    },
                  ),
        
                  // محتوى الصفحات
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        AdminDashboardPage(),         // صفحة الداشبورد (اللي فيها الرسومات)
                        UserManagementPage(), // صفحة إدارة المستخدمين
                        SystemManagementPage(),
                        SystemReportsPage(),
                        AdminSettingsPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}