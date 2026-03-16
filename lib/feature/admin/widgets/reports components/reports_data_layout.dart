import 'package:flutter/material.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_model_table.dart';
import 'package:smart_farm/feature/admin/widgets/reports%20components/reports_top_users.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/models/reports_data_models.dart';

// ─────────────────────────────────────────────────────────────────────────────
/// Responsive layout widget that places [ReportsModelTable] and
/// [ReportsTopUsers] side-by-side on wide screens and stacked on narrow ones.
///
/// Wide  (> [AppSizes.wideBreak]) → Row  (3 : 2 flex ratio)
/// Narrow                         → Column
// ─────────────────────────────────────────────────────────────────────────────
class ReportsDataLayout extends StatelessWidget {
  const ReportsDataLayout({
    super.key,
    required this.reports,
    required this.users,
  });

  final List<ModelReport> reports;
  final List<TopUser>     users;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final isWide = constraints.maxWidth > AppSizes.wideBreak;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: ReportsModelTable(reports: reports)),
              const SizedBox(width: 20),
              Expanded(flex: 2, child: ReportsTopUsers(users: users)),
            ],
          );
        }

        return Column(
          children: [
            ReportsModelTable(reports: reports),
            const SizedBox(height: 20),
            ReportsTopUsers(users: users),
          ],
        );
      },
    );
  }
}