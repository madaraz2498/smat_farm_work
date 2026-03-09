import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/feature_model.dart';

/// Reusable dashboard feature card.
///
/// Pixel-perfect match of the original `_buildFeatureCard` method in
/// `welcome_screen.dart`. Zero visual changes — only extraction.
///
/// Usage:
/// ```dart
/// FeatureCard(
///   feature: FeatureModel(
///     icon: Icons.local_florist_outlined,
///     title: AppStrings.featurePlantTitle,
///     description: AppStrings.featurePlantDesc,
///   ),
/// )
/// ```
class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.feature});

  final FeatureModel feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ── Exact decoration from original _buildFeatureCard ──────────────────
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),          // original: 16
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),                  // original: 24
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container — original: 48×48, radius 20
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),    // original: 20
            ),
            child: Icon(feature.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 16),                     // original: 16
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),                      // original: 8
          Expanded(
            child: Text(
              feature.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.625,                            // original: 1.625
              ),
            ),
          ),
        ],
      ),
    );
  }
}
