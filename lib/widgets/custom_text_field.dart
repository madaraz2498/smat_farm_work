import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Reusable styled text field used across login, register, and all feature forms.
///
/// Pixel-perfect match of the original `_buildTextField` / `_buildPasswordField`
/// helpers in login_screen.dart and register_screen.dart. Zero visual changes.
///
/// Usage (plain):
/// ```dart
/// CustomTextField(
///   controller: _emailController,
///   hint: AppStrings.hintEmail,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
///
/// Usage (password):
/// ```dart
/// CustomTextField(
///   controller: _passwordController,
///   hint: AppStrings.hintPassword,
///   isPassword: true,
///   obscureText: _obscure,
///   onToggleObscure: () => setState(() => _obscure = !_obscure),
/// )
/// ```
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  /// Set to true to show the eye-toggle suffix icon.
  final bool isPassword;

  /// Controls whether the text is hidden (only relevant when [isPassword] = true).
  final bool obscureText;

  /// Called when the user taps the eye icon. Must be provided when [isPassword] is true.
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Original decoration from _buildTextField / _buildPasswordField
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(20),       // original: 20
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && obscureText,
        style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: AppColors.textHint,
          ),
          border: InputBorder.none,
          // Original content padding: horizontal 17, vertical 15
          contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onToggleObscure,
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
