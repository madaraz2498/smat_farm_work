import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';// Import your screen files here:
import 'package:smart_farm/feature/farmer/dashboard/welcome_screen.dart';
import 'package:smart_farm/feature/auth/login_screen.dart';

/// Listens to [AuthProvider] and redirects automatically:
/// - Authenticated  → DashboardScreen
/// - Unauthenticated → LoginScreen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // We use context.watch so the widget rebuilds whenever the AuthProvider calls notifyListeners()
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.authenticated:
        return const WelcomeScreen();

      case AuthStatus.unauthenticated:
        return const LoginScreen();

      case AuthStatus.unknown:
      default:
      // While the app is checking the token/Firebase state,
      // show a loading spinner instead of jumping straight to Login.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }
}