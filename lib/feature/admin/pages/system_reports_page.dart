import 'package:flutter/material.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_data_layout.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_export_actions.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_header.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stat_cards.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_chart.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// System Reports page — analytics, model performance, top users.
/// Fully scrollable; no vertical overflow possible.
// ─────────────────────────────────────────────────────────────────────────────
class SystemReportsPage extends StatefulWidget {
  const SystemReportsPage({super.key});

  @override
  State<SystemReportsPage> createState() => _SystemReportsPageState();
}

class _SystemReportsPageState extends State<SystemReportsPage> {
  String _period = 'Last 7 Days';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header + period picker ───────────────────────────────────
          ReportsHeader(
            selectedPeriod:  _period,
            onPeriodChanged: (v) => setState(() => _period = v),
          ),
          const SizedBox(height: 24),

          // ── KPI stat cards ───────────────────────────────────────────
          const AdminStatCards(cards: kReportsKpis),
          const SizedBox(height: 24),

          // ── Bar chart ────────────────────────────────────────────────
          ReportsChart(data: kChartData, period: _period),
          const SizedBox(height: 24),

          // ── Model table + top users (responsive) ─────────────────────
          const ReportsDataLayout(
            reports: kModelReports,
            users:   kTopUsers,
          ),
          const SizedBox(height: 24),

          // ── Export buttons ───────────────────────────────────────────
          const ReportsExportActions(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}