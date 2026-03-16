import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ⚠️  DEV BYPASS FLAG
//
// true  → AuthProvider constructs already-authenticated with the mock Farmer.
//          No login screen is shown. No async session check runs.
// false → Normal flow: status starts as `unknown`, resolves to
//          `unauthenticated` after 400 ms, then user must log in.
//
// IMPORTANT: This constant lives HERE (not in main.dart) to avoid a
// circular import (main.dart ↔ auth_provider.dart).
// ─────────────────────────────────────────────────────────────────────────────
const bool kDevBypassAuth = true;

// ─────────────────────────────────────────────────────────────────────────────
// Mock user pre-loaded when kDevBypassAuth == true
// ─────────────────────────────────────────────────────────────────────────────
const _kDevUser = UserModel(
  id:    'dev_farmer_001',
  name:  'John Farmer',
  email: 'farmer@smartfarm.com',
);

// ─────────────────────────────────────────────────────────────────────────────
// AuthStatus
// ─────────────────────────────────────────────────────────────────────────────
enum AuthStatus { unknown, authenticated, unauthenticated }

// ─────────────────────────────────────────────────────────────────────────────
// AuthProvider
// ─────────────────────────────────────────────────────────────────────────────
class AuthProvider extends ChangeNotifier {
  final AuthService _service = MockAuthService();

  // When bypass is active: start authenticated with the mock user so the
  // NavBar / Sidebar have a name on frame 1 — no async wait, no null flash.
  AuthStatus _status = kDevBypassAuth
      ? AuthStatus.authenticated
      : AuthStatus.unknown;

  UserModel? _user   = kDevBypassAuth ? _kDevUser : null;

  bool    _isLoading    = false;
  String? _errorMessage;

  // ── Getters ────────────────────────────────────────────────────────────────

  AuthStatus get status       => _status;
  UserModel? get currentUser  => _user;
  bool       get isLoading    => _isLoading;
  String?    get errorMessage => _errorMessage;

  String get displayName =>
      (_user?.name.isNotEmpty ?? false) ? _user!.name : 'Farmer';


  // ── Constructor ────────────────────────────────────────────────────────────

  AuthProvider() {
    // Skip the session check in bypass mode — state is already set above.
    if (!kDevBypassAuth) _checkPersistedSession();
  }

  // ── Session bootstrap (production only) ────────────────────────────────────

  Future<void> _checkPersistedSession() async {
    await Future.delayed(const Duration(milliseconds: 400));
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final cleanEmail = email.trim().toLowerCase();
      final cleanPass  = password.trim();

      if (cleanEmail.isEmpty || cleanPass.isEmpty) {
        _errorMessage = 'Email and password are required.';
        return AuthResult.fail(_errorMessage!);
      }

      // Fall through to service for dynamically registered accounts
      final result = await _service.login(cleanEmail, cleanPass);
      if (result.success && result.user != null) {
        _user   = result.user;
        _status = AuthStatus.authenticated;
      } else {
        // ── COMMENTED OUT for dev: login gate disabled ───────────────────
        // _errorMessage = result.error ?? 'Invalid credentials.';
        // _status       = AuthStatus.unauthenticated;

        // In dev mode: just accept any unknown credential as the Farmer.
        _user   = _kDevUser;
        _status = AuthStatus.authenticated;
      }

      notifyListeners();
      return result.success ? result : AuthResult.ok(_user!);

    } catch (e) {
      _errorMessage = 'An unexpected error occurred.';
      _status       = AuthStatus.unauthenticated;
      notifyListeners();
      return AuthResult.fail(_errorMessage!);
    } finally {
      if (_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // ── Register ───────────────────────────────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.register(
        name: name, email: email, password: password,
      );
      if (result.success && result.user != null) {
        _user   = result.user;
        _status = AuthStatus.authenticated;
      } else {
        _errorMessage = result.error ?? 'Registration failed.';
        _status       = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _errorMessage = 'Registration failed.';
      _status       = AuthStatus.unauthenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  void logout() {
    _user         = null;
    _errorMessage = null;
    _status       = AuthStatus.unauthenticated;
    notifyListeners();
  }
}