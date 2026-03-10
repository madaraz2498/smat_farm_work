import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Reusable primary action button used for Sign In, Create Account,
/// Estimate, Analyze, and all other CTA buttons across the app.
///
/// Pixel-perfect match of the original ElevatedButton style shared by
/// login_screen.dart and register_screen.dart. Zero visual changes.
///
/// Usage:
/// ```dart
/// ActionButton(label: AppStrings.loginButton, onPressed: _handleLogin)
/// ```
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// When true, shows a circular progress indicator instead of the label.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          elevation: 1,
          shadowColor: AppColors.textDark,
          // Original padding: vertical 12, horizontal 24
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // original: 20
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.surface,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
