import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import '../models/feature_model.dart';

/// Reusable dashboard feature card.
///
/// Pixel-perfect match of the original `_buildFeatureCard` method.
/// Uses professional theme tokens for consistency.
class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key, required this.feature});

  final FeatureModel feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(feature.icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600, // Changed to w600 for better heading look
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              feature.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
