import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminStatCards
//
// Displays summary KPI cards in a responsive Wrap.
// Uses LayoutBuilder + Wrap so cards auto-stack on narrow screens — no overflow.
// Each card is a pure, stateless widget driven by [StatCardData].
// ─────────────────────────────────────────────────────────────────────────────

/// Data class for one stat card.
class StatCardData {
  final String   label;
  final String   value;
  final String?  delta;        // e.g. "+12 this week"
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;

  const StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.delta,
  });
}

class AdminStatCards extends StatelessWidget {
  const AdminStatCards({super.key, required this.cards});

  final List<StatCardData> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        // 4 cols on wide, 2 cols on narrow
        final cols      = constraints.maxWidth > AppSizes.wideBreak ? 4 : 2;
        final spacing   = 14.0;
        final cardWidth = (constraints.maxWidth - (cols - 1) * spacing) / cols;

        return Wrap(
          spacing:    spacing,
          runSpacing: spacing,
          children: cards.map((card) {
            return SizedBox(
              width: cardWidth,
              child: _StatCard(data: card),
            );
          }).toList(),
        );
      },
    );
  }
}

// ── Individual card ───────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});
  final StatCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            padding:    const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:        data.iconBg,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 20),
          ),
          const SizedBox(width: 12),

          // Text — Flexible prevents overflow when value is long
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize:   22,
                    fontWeight: FontWeight.bold,
                    color:      AppColors.textDark,
                  ),
                ),
                Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
                if (data.delta != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    data.delta!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10, color: AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
