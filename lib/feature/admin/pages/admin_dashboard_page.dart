import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stats_grid.dart';
import 'package:smart_farm/feature/admin/widgets/pi_chart.dart';

// ملاحظة: استبدل AppColors بألوانك الخاصة أو استخدم الألوان المعرفة هنا
class AppColors {
  static const primary = Color(0xFF4CAF50);
  static const primaryLight = Color(0xFF81C784);
  static const surface = Colors.white;
  static const cardBorder = Color(0xFFE0E0E0);
  static const background = Color(0xFFF5F5F5);
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // إذا كان العرض أقل من 800 بكسل نعتبره موبايل
          bool isMobile = constraints.maxWidth < 800;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. قسم الكروت العلوية
                AdminStatsGrid(),

                const SizedBox(height: 24),

                // 2. قسم الرسومات البيانية
                if (isMobile)
                  Column(
                    children: [
                      const UsageChart(),
                      const SizedBox(height: 24),
                      const ServicePieChart(),
                      const SizedBox(height: 24),

                      const ActiveUsersChart(),
                    ],
                  )
                else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(flex: 2,
                          child: UsageChart()),
                      SizedBox(width: 24),
                      Expanded(flex: 1, child: ServicePieChart()),
                      const SizedBox(height: 24),
                      Expanded(flex: 1, child: ActiveUsersChart()),


                    ],
                  ),
                const SizedBox(height: 24),
                const RecentActivityList(),
              ],
            ),
          );
        },
      ),
    );
  }
}




