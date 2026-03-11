import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FeatureCard
//
// The card shown in the Welcome/Dashboard grid. Currently non-tappable
// (displays only); set [onTap] to make it navigate.
// ─────────────────────────────────────────────────────────────────────────────

class FeatureCard extends StatelessWidget {
  final String svgPath;
  final String title;
  final String description;

  /// When provided the card becomes tappable (InkWell ripple + arrow icon).
  final VoidCallback? onTap;

  /// Fixed height mode: set true when rendering inside a Wrap with SizedBox.
  final bool fixedHeight;

  const FeatureCard({
    super.key,
    required this.svgPath,
    required this.title,
    required this.description,
    this.onTap,
    this.fixedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final card = Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: fixedHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Icon chip
          _IconChip(svgPath: svgPath),
          const SizedBox(height: AppSizes.itemPadding),

          // Title row
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios_rounded, 
                  size: 14, 
                  color: AppColors.primary
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),

          // Description
          Text(
            description,
            style: AppTextStyles.pageSubtitle.copyWith(fontSize: 13),
            maxLines: fixedHeight ? 2 : null,
            overflow: fixedHeight ? TextOverflow.ellipsis : null,
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    // Tappable variant
    return Material(
      color:        Colors.transparent,
      borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      child: InkWell(
        onTap:        onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        splashColor:  AppColors.primary.withValues(alpha: 0.08),
        child: card,
      ),
    );
  }
}

// ─── Icon chip ────────────────────────────────────────────────────────────────

class _IconChip extends StatelessWidget {
  final String svgPath;

  const _IconChip({required this.svgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color:         AppColors.primarySurface,
        borderRadius:  BorderRadius.circular(AppSizes.radiusMid),
      ),
      child: Center(
        child: SvgPicture.asset(svgPath, width: 24, height: 24),
      ),
    );
  }
}
