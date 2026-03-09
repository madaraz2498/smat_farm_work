import 'package:flutter/material.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.unknown;

  AuthStatus get status => _status;

  AuthProvider() {
    _checkAuth();
  }

  // Simulate checking for a saved token or Firebase user
  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network/disk lag
    // Logic to determine if user is logged in...
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void login() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  void logout() {
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}