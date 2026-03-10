import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/admin/admin_dashboard_screen.dart';
import 'package:smart_farm/feature/settings/settings_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';
import 'feature/farmer/dashboard_screen.dart';
import 'theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Smart Farm AI — Development Entry Point
//
// ⚠️  AUTH IS FULLY DISABLED.
//     The app opens directly to DashboardScreen every time.
//     All sidebar items (including Admin Dashboard) are freely accessible.
//
// To restore auth for production:
//   1. Set kDevBypassAuth = false in lib/providers/auth_provider.dart
//   2. Change home: below to const AuthWrapper()
//   3. Import screens/auth_wrapper.dart
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  runApp(
    MultiProvider(
      providers: [
        // AuthProvider starts pre-authenticated (mock Farmer) so the
        // NavBar / Sidebar show a name + role on the very first frame.
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // NavigationProvider drives the sidebar highlight index.
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const SmartFarmApp(),
    ),
  );
}

class SmartFarmApp extends StatelessWidget {
  const SmartFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Farm AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // ── DEV: open the dashboard directly — zero login, zero auth check ─────
      home: const AdminDashboardScreen(),
    );
  }
}