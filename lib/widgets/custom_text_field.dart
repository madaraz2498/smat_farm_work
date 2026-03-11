import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Reusable styled text field used across login, register, and all feature forms.
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
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword && obscureText,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 16,
            color: AppColors.textSubtle.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: onToggleObscure,
                  child: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSubtle,
                    size: 20,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
