import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Reusable AI result card shown after any model analysis completes.
class ResultDisplay extends StatelessWidget {
  const ResultDisplay({
    super.key,
    required this.statusLabel,
    required this.isPositive,
    required this.confidenceLabel,
    required this.confidence,
    this.detail,
  });

  /// Short status text shown in the badge (e.g. "Healthy", "Diseased").
  final String statusLabel;

  /// Controls badge colour: green when true, red when false.
  final bool isPositive;

  /// Label above the progress bar (e.g. "Confidence").
  final String confidenceLabel;

  /// Confidence value between 0.0 and 1.0.
  final double confidence;

  /// Optional extra detail line below the progress bar.
  final String? detail;

  @override
  Widget build(BuildContext context) {
    // Using professional semantic colors: primary for positive, error for negative
    final badgeColor = isPositive ? AppColors.primary : AppColors.error;
    final percentText = '${(confidence * 100).round()}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status badge ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Confidence label + percentage ───────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                confidenceLabel,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSubtle,
                ),
              ),
              Text(
                percentText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Progress bar ────────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.cardBorder,
              valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
            ),
          ),

          // ── Optional detail line ────────────────────────────────────────
          if (detail != null) ...[
            const SizedBox(height: 12),
            Text(
              detail!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSubtle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
