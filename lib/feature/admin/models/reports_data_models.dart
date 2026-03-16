import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stat_cards.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Reports Data Models  —  all data classes and static lists for SystemReportsPage
// ─────────────────────────────────────────────────────────────────────────────

/// Single bar entry for the requests-over-time chart.
class ChartBar {
  final String label;
  final int    value;
  const ChartBar({required this.label, required this.value});
}

/// Performance metrics for one AI model.
class ModelReport {
  final String name, avgTime;
  final int    requests, success, failed;
  final Color  color;
  const ModelReport({
    required this.name,
    required this.requests,
    required this.success,
    required this.failed,
    required this.avgTime,
    required this.color,
  });
}

/// A top user entry ranked by total requests.
class TopUser {
  final String name, role, initials;
  final int    requests;
  final Color  color;
  const TopUser({
    required this.name,
    required this.role,
    required this.initials,
    required this.requests,
    required this.color,
  });
}

// ── Static data ───────────────────────────────────────────────────────────────

/// Period filter options shown in the dropdown.
const List<String> kReportPeriods = [
  'Today',
  'Last 7 Days',
  'Last 30 Days',
  'Last 3 Months',
  'This Year',
];

/// Weekly request chart data.
const List<ChartBar> kChartData = [
  ChartBar(label: 'Mon', value: 620),
  ChartBar(label: 'Tue', value: 880),
  ChartBar(label: 'Wed', value: 740),
  ChartBar(label: 'Thu', value: 1020),
  ChartBar(label: 'Fri', value: 960),
  ChartBar(label: 'Sat', value: 430),
  ChartBar(label: 'Sun', value: 310),
];

/// AI model performance rows.
const List<ModelReport> kModelReports = [
  ModelReport(name: 'Plant Disease Detection',  requests: 3214, success: 3089, failed: 125, avgTime: '1.2s', color: AppColors.primary),
  ModelReport(name: 'Animal Weight Estimation', requests: 1876, success: 1821, failed: 55,  avgTime: '2.1s', color: AppColors.info),
  ModelReport(name: 'Crop Recommendation',      requests: 1432, success: 1398, failed: 34,  avgTime: '0.8s', color: Color(0xFF9C27B0)),
  ModelReport(name: 'Soil Type Analysis',       requests: 987,  success: 954,  failed: 33,  avgTime: '1.5s', color: AppColors.warning),
  ModelReport(name: 'Fruit Quality Analysis',   requests: 876,  success: 843,  failed: 33,  avgTime: '1.8s', color: AppColors.error),
  ModelReport(name: 'Smart Farm Chatbot',       requests: 2103, success: 2067, failed: 36,  avgTime: '0.4s', color: Color(0xFF00BCD4)),
];

/// Top users sorted by request count.
const List<TopUser> kTopUsers = [
  TopUser(name: 'Khaled Nasser', role: 'Researcher', initials: 'KN', requests: 1203, color: Color(0xFF9C27B0)),
  TopUser(name: 'Sara Mohamed',  role: 'Agronomist', initials: 'SM', requests: 512,  color: AppColors.info),
  TopUser(name: 'Ahmed Hassan',  role: 'Farmer',     initials: 'AH', requests: 234,  color: AppColors.primary),
  TopUser(name: 'Mahmoud Samy',  role: 'Farmer',     initials: 'MS', requests: 178,  color: AppColors.warning),
  TopUser(name: 'Dina Farouk',   role: 'Farmer',     initials: 'DF', requests: 89,   color: AppColors.error),
];

/// KPI summary cards shown at the top of the reports page.
const List<StatCardData> kReportsKpis = [
  StatCardData(label: 'Total Requests', value: '10,488', icon: Icons.api_outlined,         iconColor: AppColors.primary,       iconBg: AppColors.primarySurface),
  StatCardData(label: 'Success Rate',   value: '96.8%',  icon: Icons.check_circle_outline, iconColor: AppColors.info,          iconBg: Color(0xFFE3F2FD)),
  StatCardData(label: 'Active Users',   value: '1,284',  icon: Icons.people_outline,       iconColor: Color(0xFF9C27B0),       iconBg: Color(0xFFF3E5F5)),
  StatCardData(label: 'Avg Response',   value: '1.3s',   icon: Icons.timer_outlined,       iconColor: AppColors.warning,       iconBg: Color(0xFFFFF3E0)),
];