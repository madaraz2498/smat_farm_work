import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Reusable AI result card shown after any model analysis completes.
///
/// Displays:
/// - A status badge (e.g. "Healthy" / "Diseased")
/// - A label (e.g. "Confidence")
/// - A linear progress bar representing the confidence value (0.0 – 1.0)
/// - An optional detail string beneath the bar
///
/// This widget has NO Scaffold / AppBar of its own — it is a pure body widget
/// intended to be embedded inside any page's content area.
///
/// Usage:
/// ```dart
/// ResultDisplay(
///   statusLabel: 'Healthy',
///   isPositive: true,
///   confidenceLabel: 'Confidence',
///   confidence: 0.92,
///   detail: 'Tomato — Late Blight (92%)',
/// )
/// ```
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
    final badgeColor = isPositive ? AppColors.primary : AppColors.danger;
    final percentText = '${(confidence * 100).round()}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 3,
            offset: Offset(0, 1),
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
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                percentText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
              backgroundColor: AppColors.border,
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
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
