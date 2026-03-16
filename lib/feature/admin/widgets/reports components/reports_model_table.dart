import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Table showing performance metrics for each AI model.
///
/// [reports] — list of [ModelReport] to display.
// ─────────────────────────────────────────────────────────────────────────────
class ReportsModelTable extends StatelessWidget {
  const ReportsModelTable({super.key, required this.reports});

  final List<ModelReport> reports;

  @override
  Widget build(BuildContext context) {
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
          const Text('AI Model Performance', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),

          // ── Column headers ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withValues(alpha: 0.06),
                ),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 4, child: Text('MODEL',    style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('REQUESTS', style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('SUCCESS',  style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('AVG TIME', style: AppTextStyles.tableHeader)),
              ],
            ),
          ),

          // ── Rows ─────────────────────────────────────────────────────
          ...reports.asMap().entries.map(
                (e) => _ModelRow(
              model:  e.value,
              isLast: e.key == reports.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Single row inside [ReportsModelTable].
// ─────────────────────────────────────────────────────────────────────────────
class _ModelRow extends StatelessWidget {
  const _ModelRow({required this.model, required this.isLast});

  final ModelReport model;
  final bool        isLast;

  @override
  Widget build(BuildContext context) {
    final rate   = model.requests > 0
        ? (model.success / model.requests * 100).toStringAsFixed(1)
        : '0.0';
    final rateOk = double.parse(rate) >= 95;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
          bottom: BorderSide(
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      child: Row(
        children: [
          // Model name with colour dot
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width:  8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color:        model.color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color:    AppColors.textMid,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Request count
          Expanded(
            flex: 2,
            child: Text(
              '${model.requests}',
              style: const TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w500,
                color:      AppColors.textDark,
              ),
            ),
          ),

          // Success rate — green ≥ 95 %, amber below
          Expanded(
            flex: 2,
            child: Text(
              '$rate%',
              style: TextStyle(
                fontSize:   12,
                fontWeight: FontWeight.w500,
                color: rateOk ? AppColors.success : AppColors.warning,
              ),
            ),
          ),

          // Average response time
          Expanded(
            flex: 2,
            child: Text(model.avgTime, style: AppTextStyles.caption),
          ),
        ],
      ),
    );
  }
}