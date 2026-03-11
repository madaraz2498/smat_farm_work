import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stat_cards.dart';
import 'package:smart_farm/feature/admin/widgets/system_health_monitor.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DashboardPage  —  overview tab inside AdminDashboardScreen.
// Entirely scrollable, zero fixed heights, uses Wrap for cards.
// ─────────────────────────────────────────────────────────────────────────────
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const List<StatCardData> _stats = [
    StatCardData(
      label:     'Total Users',
      value:     '1,284',
      delta:     '+48 this week',
      icon:      Icons.people_outline,
      iconColor: AppColors.primary,
      iconBg:    AppColors.primarySurface,
    ),
    StatCardData(
      label:     'AI Requests Today',
      value:     '4,920',
      delta:     '+320 vs yesterday',
      icon:      Icons.api_outlined,
      iconColor: AppColors.info,
      iconBg:    Color(0xFFE3F2FD),
    ),
    StatCardData(
      label:     'Active Sessions',
      value:     '317',
      icon:      Icons.devices_outlined,
      iconColor: Color(0xFF9C27B0),
      iconBg:    Color(0xFFF3E5F5),
    ),
    StatCardData(
      label:     'Pending Reports',
      value:     '12',
      icon:      Icons.pending_actions_outlined,
      iconColor: AppColors.warning,
      iconBg:    Color(0xFFFFF3E0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page heading
          const Text('Admin Dashboard', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text(
            'Welcome back! Here\'s a snapshot of your platform.',
            style: AppTextStyles.pageSubtitle,
          ),
          const SizedBox(height: 24),

          // Stat cards (responsive Wrap)
          const AdminStatCards(cards: _stats),
          const SizedBox(height: 28),

          // System health section
          const SystemHealthMonitor(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
