import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Page header for SystemReportsPage.
/// Shows the title, subtitle, and a period-filter dropdown.
///
/// [selectedPeriod] — currently selected period string.
/// [onPeriodChanged] — called when the user picks a new period.
// ─────────────────────────────────────────────────────────────────────────────
class ReportsHeader extends StatelessWidget {
  const ReportsHeader({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  final String                   selectedPeriod;
  final ValueChanged<String>     onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Title + subtitle ───────────────────────────────────────────
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('System Reports', style: AppTextStyles.pageTitle),
              SizedBox(height: 4),
              Text(
                'Analytics and usage statistics across the platform',
                style: AppTextStyles.pageSubtitle,
              ),
            ],
          ),
        ),

        // ── Period dropdown ────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color:        AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border: Border.all(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedPeriod,
              style: const TextStyle(
                fontSize: 13,
                color:    AppColors.textDark,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size:  16,
                color: AppColors.textDisabled,
              ),
              items: kReportPeriods
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onPeriodChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}