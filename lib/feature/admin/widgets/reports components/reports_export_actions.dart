import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/widgets/admin_forms.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Row of export action buttons (CSV + PDF).
/// Calls [AdminForms.showGenerateReport] on press.
// ─────────────────────────────────────────────────────────────────────────────
class ReportsExportActions extends StatelessWidget {
  const ReportsExportActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Export CSV ───────────────────────────────────────────────
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => AdminForms.showGenerateReport(context),
            icon:  const Icon(Icons.download_outlined, size: 16),
            label: const Text('Export as CSV'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side:    const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // ── Export PDF ───────────────────────────────────────────────
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => AdminForms.showGenerateReport(context),
            icon:  const Icon(Icons.picture_as_pdf_outlined, size: 16),
            label: const Text('Export as PDF'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.info,
              side:    const BorderSide(color: AppColors.info),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              ),
            ),
          ),
        ),
      ],
    );
  }
}