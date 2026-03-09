import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/navigation_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ⚠️  DEV BYPASS FLAG
//
// true  → skips Login/Register; opens DashboardScreen immediately with the
//         mock Farmer profile pre-loaded.  No credentials needed.
// false → normal AuthWrapper flow: splash → login → dashboard.
//
// TO RE-ENABLE AUTH FOR PRODUCTION: change to false and hot-restart.
// ─────────────────────────────────────────────────────────────────────────────
const bool kDevBypassAuth = true;

// ─────────────────────────────────────────────────────────────────────────────
// Entry point
// ─────────────────────────────────────────────────────────────────────────────
void main() {
  runApp(
    MultiProvider(
      providers: [
        // AuthProvider reads kDevBypassAuth and pre-fills the mock user when
        // bypass is active, so the sidebar/AppBar have a name immediately.
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // NavigationProvider is always initialised here so the sidebar
        // and AppBar work on first frame regardless of bypass mode.
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const SmartFarmApp(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SmartFarmApp
// ─────────────────────────────────────────────────────────────────────────────
class SmartFarmApp extends StatelessWidget {
  const SmartFarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:                      'Smart Farm AI',
      debugShowCheckedModeBanner: false,
      theme:                      AppTheme.light,
      home: kDevBypassAuth
      // ── DEV: open dashboard directly, no auth check ────────────────────
          ? const DashboardScreen()
      // ── PROD: normal auth-gated flow ───────────────────────────────────
          : const AuthWrapper(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthWrapper  —  Root Navigation Gate  (used when kDevBypassAuth == false)
//
//   AuthStatus.unknown         → _SplashScreen  (≤400 ms session check)
//   AuthStatus.authenticated   → AdminDashboardScreen  (isAdmin == true)
//                              → DashboardScreen        (regular user)
//   AuthStatus.unauthenticated → LoginScreen
//
// Logout contract: callers MUST call
//   Navigator.of(context).popUntil((route) => route.isFirst)
// BEFORE calling AuthProvider.logout() so the stack unwinds cleanly back
// to this wrapper before it re-renders LoginScreen.
// ─────────────────────────────────────────────────────────────────────────────
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {

      case AuthStatus.unknown:
        return const _SplashScreen();

      case AuthStatus.authenticated:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.read<NavigationProvider>().reset();
        });
        return auth.isAdmin
            ? const AdminDashboardScreen()
            : const DashboardScreen();

    // ── Login gate  (never reached when kDevBypassAuth == true) ───────────
      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SplashScreen  —  shown for ≤400 ms while AuthProvider resolves session
//                   (only shown when kDevBypassAuth == false)
// ─────────────────────────────────────────────────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LogoWidget(),
            const SizedBox(height: 20),
            const Text(
              'Smart Farm AI',
              style: TextStyle(
                fontSize:   22,
                fontWeight: FontWeight.w700,
                color:      AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Loading…',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width:  28,
              height: 28,
              child:  CircularProgressIndicator(
                color:       AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Logo widget (non-const — BoxShadow uses withOpacity) ─────────────────────
class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width:  72,
      height: 72,
      decoration: BoxDecoration(
        color:        AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:        AppColors.primary.withOpacity(0.35),
            blurRadius:   20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(Icons.eco_rounded, color: Colors.white, size: 40),
    );
  }
}