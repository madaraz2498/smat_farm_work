import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';
import 'admin_dashboard_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Role dropdown is purely a UI hint — it does NOT grant admin access.
  String? _selectedRole;
  final List<String> _roles = ['Farmer', 'Agronomist', 'Researcher', 'Admin'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Sign-in handler ───────────────────────────────────────────────────────

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Small delay to show loading state (remove when using real API)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    final auth = context.read<AuthProvider>();
    final result = auth.login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (result.status == AuthStatus.success) {
      // Route: admin → AdminDashboardPage, everyone else → SmartFarmDashboard
      final destination = auth.isAdmin
          ? const AdminDashboardPage()
          : const SmartFarmDashboard();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.message;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: _buildCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Logo ──────────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(height: 23),

          // ── Title ─────────────────────────────────────────────────────────
          const Center(
            child: Text('Smart Farm AI',
                style: TextStyle(fontSize: 16, color: Color(0xFF1F2937))),
          ),
          const SizedBox(height: 7),
          const Center(
            child: Text('Sign in to manage your smart farm',
                style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
          ),
          const SizedBox(height: 23),

          // ── Error banner ──────────────────────────────────────────────────
          if (_errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Color(0xFFEF4444), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_errorMessage!,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFFEF4444))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // ── Email ─────────────────────────────────────────────────────────
          _buildLabel('Email'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 19),

          // ── Password ──────────────────────────────────────────────────────
          _buildLabel('Password'),
          const SizedBox(height: 8),
          _buildPasswordField(),
          const SizedBox(height: 19),

          // ── Role (UI hint only — not used for auth decisions) ─────────────
          _buildLabel('Role'),
          const SizedBox(height: 8),
          _buildRoleDropdown(),
          const SizedBox(height: 24),

          // ── Sign In button ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF4CAF50).withOpacity(0.6),
                elevation: 1,
                shadowColor: Colors.black.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Sign In', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 23),

          // ── Dev hint (remove in production) ──────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFD54F)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('🔑 Dev credentials',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF795548))),
                SizedBox(height: 4),
                Text('Admin: admin@smartfarm.com / admin123',
                    style:
                        TextStyle(fontSize: 11, color: Color(0xFF795548))),
                Text('User:  farmer@smartfarm.com / farmer123',
                    style:
                        TextStyle(fontSize: 11, color: Color(0xFF795548))),
              ],
            ),
          ),
          const SizedBox(height: 23),

          // ── Register link ─────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? ",
                  style:
                      TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen())),
                child: const Text('Sign up',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 16,
              color: const Color(0xFF1F2937).withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(
              fontSize: 16,
              color: const Color(0xFF1F2937).withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          suffixIcon: GestureDetector(
            onTap: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          hint: const Text('Select your role',
              style: TextStyle(fontSize: 16, color: Color(0xFF1F2937))),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: Color(0xFF6B7280)),
          style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
          items: _roles
              .map((role) =>
                  DropdownMenuItem<String>(value: role, child: Text(role)))
              .toList(),
          onChanged: (val) => setState(() => _selectedRole = val),
        ),
      ),
    );
  }
}
