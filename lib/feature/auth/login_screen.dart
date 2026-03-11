import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool    _obscurePassword = true;
  bool    _isLoading       = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_isLoading) return;

    final email    = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    final result = await context.read<AuthProvider>().login(
      email:    email,
      password: password,
    );

    if (!mounted) return;

    if (result.success) {
      setState(() => _isLoading = false);
    } else {
      setState(() {
        _isLoading    = false;
        _errorMessage = result.error ?? 'Invalid credentials. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Logo ───────────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                color:        AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:      AppColors.primary.withOpacity(0.30),
                    blurRadius: 12,
                    offset:     const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.eco_rounded, color: Colors.white, size: 38),
            ),
          ),
          const SizedBox(height: 22),

          // ── Titles ─────────────────────────────────────────────────────────
          const Center(
            child: Text('Smart Farm AI',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Text('Sign in to manage your smart farm',
                style: TextStyle(fontSize: 14, color: AppColors.textSubtle)),
          ),
          const SizedBox(height: 22),

          // ── Error banner ───────────────────────────────────────────────────
          if (_errorMessage != null) ...[
            _ErrorBanner(message: _errorMessage!),
            const SizedBox(height: 14),
          ],

          // ── Email ──────────────────────────────────────────────────────────
          const _FieldLabel('Email'),
          const SizedBox(height: 7),
          _InputField(
            controller:   _emailCtrl,
            hint:         'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // ── Password ───────────────────────────────────────────────────────
          const _FieldLabel('Password'),
          const SizedBox(height: 7),
          _PasswordField(
            controller:      _passwordCtrl,
            obscure:         _obscurePassword,
            onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 24),

          // ── Sign In button ─────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor:         AppColors.primary,
                foregroundColor:         Colors.white,
                disabledBackgroundColor: AppColors.primaryLight,
                disabledForegroundColor: Colors.white70,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: _isLoading
                  ? const SizedBox(
                height: 20, width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
                  : const Text('Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 22),

          // ── Register link ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? ",
                  style: TextStyle(fontSize: 14, color: AppColors.textSubtle)),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Sign up',
                    style: TextStyle(
                        fontSize:   14,
                        color:      AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
  );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String                hint;
  final TextInputType         keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: BorderRadius.circular(50),
        border:       Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller:   controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText:       hint,
          hintStyle:      const TextStyle(fontSize: 14, color: AppColors.textDisabled),
          border:         InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool                  obscure;
  final VoidCallback          onToggleObscure;

  const _PasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.background,
        borderRadius: BorderRadius.circular(50),
        border:       Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller:  controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 14, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText:       'Enter your password',
          hintStyle:      const TextStyle(fontSize: 14, color: AppColors.textDisabled),
          border:         InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: GestureDetector(
            onTap: onToggleObscure,
            child: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSubtle,
              size:  20,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color:        const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(10),
        border:       Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 13, color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}