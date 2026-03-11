import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// UploadBox
//
// A reusable image-upload area used by Plant Disease, Animal Weight,
// Soil Analysis, and Fruit Quality screens.
// ─────────────────────────────────────────────────────────────────────────────

class UploadBox extends StatelessWidget {
  /// File path (or URL) of the selected image.
  final String? imagePath;

  /// Whether an API call is in-flight.
  final bool isLoading;

  /// Label shown beneath the spinner in loading state.
  final String loadingLabel;

  /// Icon shown in the idle state inside the tinted icon-box.
  final IconData icon;

  /// Icon shown as placeholder when [imagePath] is set.
  final IconData previewIcon;

  /// Primary label in idle state.
  final String label;

  /// Secondary hint text in idle state.
  final String hint;

  /// Called when the user taps the × button in preview state.
  final VoidCallback onReset;

  /// Height of the box. Defaults to 200.
  final double height;

  const UploadBox({
    super.key,
    required this.imagePath,
    required this.isLoading,
    required this.onReset,
    this.loadingLabel = 'Analyzing...',
    this.icon         = Icons.upload_rounded,
    this.previewIcon  = Icons.image_rounded,
    this.label        = 'Upload image',
    this.hint         = 'PNG or JPG, max 10 MB',
    this.height       = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width:  double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: imagePath != null
            ? const Color(0xFFF9FAFB)
            : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.28),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) return _LoadingState(label: loadingLabel);
    if (imagePath != null) return _PreviewState(icon: previewIcon, onReset: onReset);
    return _IdleState(icon: icon, label: label, hint: hint);
  }
}

// ─── Internal states ─────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  final String loadingLabel;

  const _LoadingState({required String label}) : loadingLabel = label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3),
        const SizedBox(height: 14),
        Text(
          loadingLabel,
          style: AppTextStyles.label.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PreviewState extends StatelessWidget {
  final IconData icon;
  final VoidCallback onReset;

  const _PreviewState({required this.icon, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.grey.shade100,
          child: Icon(icon, size: 64, color: Colors.grey.shade300),
        ),
        Positioned(
          top: 8, right: 8,
          child: _CloseButton(onTap: onReset),
        ),
      ],
    );
  }
}

class _IdleState extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;

  const _IdleState({
    required this.icon,
    required this.label,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          ),
          child:  Icon( icon, size: 30, color: AppColors.primary),
        ),
        const SizedBox(height: 14),
        Text(label, style: AppTextStyles.cardTitle),
        const SizedBox(height: 4),
        Text(hint, style: AppTextStyles.caption),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textDark),
      ),
    );
  }
}
