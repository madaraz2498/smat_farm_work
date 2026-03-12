import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/admin/admin_dashboard_screen.dart';
import 'package:smart_farm/feature/farmer/dashboard/welcome_screen.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/providers/navigation_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// main.dart  —  Production-ready entry point.
//
// MultiProvider provides global access to Auth and Navigation states.
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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

      // ── Theme ────────────────────────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.topBarBg,
          foregroundColor: AppColors.textDark,
          elevation: 0,
        ),
      ),

      // ── Entry point ──────────────────────────────────────────────────
      home: const AdminDashboardScreen(),

      // ── Named routes ─────────────────────────────────────────────────
      routes: {
        '/dashboard': (_) => const AdminDashboardScreen(),
      },
    );
  }
}
