import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
// main.dart exposes the bypass flag at the top level
import '../main.dart' show kDevBypassAuth;

// ─────────────────────────────────────────────────────────────────────────────
// AuthStatus
// ─────────────────────────────────────────────────────────────────────────────
enum AuthStatus { unknown, authenticated, unauthenticated }

// ─────────────────────────────────────────────────────────────────────────────
// Mock user pre-loaded when kDevBypassAuth == true
// ─────────────────────────────────────────────────────────────────────────────
const _kDevUser = UserModel(
  id:    'dev_farmer_001',
  name:  'John Farmer',
  email: 'farmer@smartfarm.com',
  role:  'Farmer',
);

// ─────────────────────────────────────────────────────────────────────────────
// AuthProvider  —  single source of truth for auth state
// ─────────────────────────────────────────────────────────────────────────────
class AuthProvider extends ChangeNotifier {
  // ── Internals ──────────────────────────────────────────────────────────────

  final AuthService _service = MockAuthService();

  // When bypass is active: start as authenticated with the mock user so the
  // AppBar and Sidebar have a name/role to display on the very first frame.
  AuthStatus _status    = kDevBypassAuth
      ? AuthStatus.authenticated
      : AuthStatus.unknown;

  UserModel? _user      = kDevBypassAuth ? _kDevUser : null;

  bool       _isLoading = false;
  String?    _errorMessage;

  // ── Public getters ─────────────────────────────────────────────────────────

  AuthStatus  get status       => _status;
  UserModel?  get currentUser  => _user;
  bool        get isLoading    => _isLoading;
  String?     get errorMessage => _errorMessage;

  String get displayName =>
      (_user?.name.isNotEmpty ?? false) ? _user!.name : 'Farmer';

  String get displayRole =>
      (_user?.role.isNotEmpty ?? false) ? _user!.role : 'User';

  /// true for admin@smartfarm.com or any user whose role == 'Admin'
  bool get isAdmin =>
      _user?.email.trim().toLowerCase() == 'admin@smartfarm.com' ||
          (_user?.role.toLowerCase() == 'admin');

  // ── Constructor ────────────────────────────────────────────────────────────

  AuthProvider() {
    if (!kDevBypassAuth) {
      // Only run the async session-check in production mode.
      // In bypass mode the state is already set to authenticated above.
      _checkPersistedSession();
    }
  }

  // ── Session bootstrap  (production only) ──────────────────────────────────

  Future<void> _checkPersistedSession() async {
    // Simulate checking shared_prefs / secure storage (≤ 400 ms)
    await Future.delayed(const Duration(milliseconds: 400));
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ── Public helpers ─────────────────────────────────────────────────────────

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // ── Login ──────────────────────────────────────────────────────────────────

  /// Mock credentials:
  ///   admin@smartfarm.com  / admin123
  ///   farmer@smartfarm.com / farmer123
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

      // ── Hard-coded mock credentials ───────────────────────────────────────
      if (cleanEmail == 'admin@smartfarm.com' && cleanPass == 'admin123') {
        _user = const UserModel(
          id:    'admin_001',
          name:  'Admin User',
          email: 'admin@smartfarm.com',
          role:  'Admin',
        );
        _status = AuthStatus.authenticated;
        notifyListeners();
        return AuthResult.ok(_user!);
      }

      if (cleanEmail == 'farmer@smartfarm.com' && cleanPass == 'farmer123') {
        _user = const UserModel(
          id:    'farmer_001',
          name:  'John Farmer',
          email: 'farmer@smartfarm.com',
          role:  'Farmer',
        );
        _status = AuthStatus.authenticated;
        notifyListeners();
        return AuthResult.ok(_user!);
      }

      // ── Fall through to service (handles dynamically registered accounts) ─
      final result = await _service.login(cleanEmail, cleanPass);

      if (result.success && result.user != null) {
        _user   = result.user;
        _status = AuthStatus.authenticated;
      } else {
        _errorMessage = result.error ?? 'Invalid credentials. Please try again.';
        _status       = AuthStatus.unauthenticated;
      }

      notifyListeners();
      return result;

    } catch (e) {
      _errorMessage = 'An unexpected error occurred. Please try again.';
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
    required String role,
  }) async {
    _isLoading    = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.register(
        name:     name,
        email:    email,
        password: password,
        role:     role,
      );

      if (result.success && result.user != null) {
        _user   = result.user;
        _status = AuthStatus.authenticated;
      } else {
        _errorMessage = result.error ?? 'Registration failed. Please try again.';
        _status       = AuthStatus.unauthenticated;
      }
    } catch (_) {
      _errorMessage = 'Registration failed. Please try again.';
      _status       = AuthStatus.unauthenticated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────────

  /// Clears session state.
  ///
  /// Callers that push screens via Navigator.push MUST call
  ///   Navigator.of(context).popUntil((r) => r.isFirst)
  /// before or after this call so the stack unwinds to the AuthWrapper root,
  /// which then re-renders LoginScreen automatically.
  ///
  /// NOTE: In dev bypass mode (kDevBypassAuth == true) this will route to
  /// LoginScreen — which is intentional so you can test the login flow if
  /// needed. Flip kDevBypassAuth back to true and hot-restart to skip it again.
  void logout() {
    _user         = null;
    _errorMessage = null;
    _status       = AuthStatus.unauthenticated;
    notifyListeners();
  }
}