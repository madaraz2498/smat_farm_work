import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'dashboard_constants.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// FEATURE CARD
// Displays a single AI-feature with icon, title, and description.
// Includes a hover scale + shadow animation for Web / Desktop targets.
// ═══════════════════════════════════════════════════════════════════════════════

/// An interactive card that represents one SmartFarmAI feature.
///
/// On Web/Desktop a [MouseRegion] drives a subtle scale-up and deeper shadow
/// via [AnimatedContainer] so the card feels alive without being distracting.
class FeatureCard extends StatefulWidget {
  /// The feature data to display.
  final FeatureItem feature;

  /// When true the card fills its parent's height (used inside a sized [Wrap] cell).
  final bool fixedHeight;

  /// Optional tap callback; if provided the card becomes tappable.
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.feature,
    this.fixedHeight = true,
    this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _hovered = false;

  // ── helpers ──────────────────────────────────────────────────────────────

  List<BoxShadow> get _shadow => _hovered
      ? [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
      : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ];

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
              border: Border.all(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.30)
                    : AppColors.cardBorder,
              ),
              boxShadow: _shadow,
            ),
            padding: const EdgeInsets.all(AppSizes.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize:
                  widget.fixedHeight ? MainAxisSize.max : MainAxisSize.min,
              children: [
                // ── Icon container ──────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      widget.feature.svg,
                      width: 26,
                      height: 26,
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.itemPadding),

                // ── Title ───────────────────────────────────────────────
                Text(
                  widget.feature.title,
                  style: AppTextStyles.cardTitle,
                ),

                const SizedBox(height: 6),

                // ── Description ─────────────────────────────────────────
                Text(
                  widget.feature.description,
                  style: AppTextStyles.pageSubtitle.copyWith(
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
