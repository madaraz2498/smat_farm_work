import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Animated bar chart showing requests over a selected time period.
///
/// [data]   — list of [ChartBar] entries (label + value).
/// [period] — displayed in the top-right corner of the card.
// ─────────────────────────────────────────────────────────────────────────────
class ReportsChart extends StatelessWidget {
  const ReportsChart({
    super.key,
    required this.data,
    required this.period,
  });

  final List<ChartBar> data;
  final String         period;

  // Fixed layout constants — keep label + bar + label inside 160 px total.
  static const double _containerH = 160.0;
  static const double _maxBarH    = 100.0;
  static const double _topTextH   = 16.0;
  static const double _gap        = 4.0;
  static const double _labelH     = 16.0;
  static const double _botGap     = 6.0;

  @override
  Widget build(BuildContext context) {
    final maxVal = data
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return Container(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ──────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Requests Over Time', style: AppTextStyles.cardTitle),
              Text(period, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 24),

          // ── Bar chart ────────────────────────────────────────────────
          SizedBox(
            height: _containerH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final double barH = (d.value / maxVal) * _maxBarH;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize:      MainAxisSize.min,
                      children: [
                        // Value label above bar
                        SizedBox(
                          height: _topTextH,
                          child: Text(
                            '${d.value}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 9,
                              color:    AppColors.textDisabled,
                            ),
                          ),
                        ),
                        const SizedBox(height: _gap),

                        // Animated bar
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve:    Curves.easeOut,
                          height:   barH.clamp(4.0, _maxBarH),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                            gradient: LinearGradient(
                              begin:  Alignment.topCenter,
                              end:    Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryLight,
                                AppColors.primary,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: _botGap),

                        // Day label below bar
                        SizedBox(
                          height: _labelH,
                          child: Text(
                            d.label,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}