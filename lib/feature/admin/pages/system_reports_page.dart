import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/feature/admin/widgets/admin_stat_cards.dart';
import 'package:smart_farm/feature/admin/widgets/admin_forms.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SystemReportsPage  —  analytics, model performance, top users.
// 100% scrollable — no vertical overflow possible.
// ─────────────────────────────────────────────────────────────────────────────

// ── Data classes ──────────────────────────────────────────────────────────────

class _ChartBar {
  final String label;
  final int    value;
  const _ChartBar({required this.label, required this.value});
}

class _ModelReport {
  final String name, avgTime;
  final int    requests, success, failed;
  final Color  color;
  const _ModelReport({
    required this.name, required this.requests, required this.success,
    required this.failed, required this.avgTime, required this.color,
  });
}

class _TopUser {
  final String name, role, initials;
  final int    requests;
  final Color  color;
  const _TopUser({
    required this.name, required this.role, required this.initials,
    required this.requests, required this.color,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

class SystemReportsPage extends StatefulWidget {
  const SystemReportsPage({super.key});

  @override
  State<SystemReportsPage> createState() => _SystemReportsPageState();
}

class _SystemReportsPageState extends State<SystemReportsPage> {
  String _period = 'Last 7 Days';

  static const _periods = ['Today', 'Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'This Year'];

  static const _chartData = [
    _ChartBar(label: 'Mon', value: 620),
    _ChartBar(label: 'Tue', value: 880),
    _ChartBar(label: 'Wed', value: 740),
    _ChartBar(label: 'Thu', value: 1020),
    _ChartBar(label: 'Fri', value: 960),
    _ChartBar(label: 'Sat', value: 430),
    _ChartBar(label: 'Sun', value: 310),
  ];

  static const _modelReports = [
    _ModelReport(name: 'Plant Disease Detection',  requests: 3214, success: 3089, failed: 125, avgTime: '1.2s', color: AppColors.primary),
    _ModelReport(name: 'Animal Weight Estimation', requests: 1876, success: 1821, failed: 55,  avgTime: '2.1s', color: AppColors.info),
    _ModelReport(name: 'Crop Recommendation',      requests: 1432, success: 1398, failed: 34,  avgTime: '0.8s', color: Color(0xFF9C27B0)),
    _ModelReport(name: 'Soil Type Analysis',       requests: 987,  success: 954,  failed: 33,  avgTime: '1.5s', color: AppColors.warning),
    _ModelReport(name: 'Fruit Quality Analysis',   requests: 876,  success: 843,  failed: 33,  avgTime: '1.8s', color: AppColors.error),
    _ModelReport(name: 'Smart Farm Chatbot',       requests: 2103, success: 2067, failed: 36,  avgTime: '0.4s', color: Color(0xFF00BCD4)),
  ];

  static const _topUsers = [
    _TopUser(name: 'Khaled Nasser', role: 'Researcher', initials: 'KN', requests: 1203, color: Color(0xFF9C27B0)),
    _TopUser(name: 'Sara Mohamed',  role: 'Agronomist', initials: 'SM', requests: 512,  color: AppColors.info),
    _TopUser(name: 'Ahmed Hassan',  role: 'Farmer',     initials: 'AH', requests: 234,  color: AppColors.primary),
    _TopUser(name: 'Mahmoud Samy',  role: 'Farmer',     initials: 'MS', requests: 178,  color: AppColors.warning),
    _TopUser(name: 'Dina Farouk',   role: 'Farmer',     initials: 'DF', requests: 89,   color: AppColors.error),
  ];

  static const List<StatCardData> _kpis = [
    StatCardData(label: 'Total Requests', value: '10,488', icon: Icons.api_outlined,           iconColor: AppColors.primary,        iconBg: AppColors.primarySurface),
    StatCardData(label: 'Success Rate',   value: '96.8%',  icon: Icons.check_circle_outline,   iconColor: AppColors.info,           iconBg: Color(0xFFE3F2FD)),
    StatCardData(label: 'Active Users',   value: '1,284',  icon: Icons.people_outline,         iconColor: Color(0xFF9C27B0),        iconBg: Color(0xFFF3E5F5)),
    StatCardData(label: 'Avg Response',   value: '1.3s',   icon: Icons.timer_outlined,         iconColor: AppColors.warning,        iconBg: Color(0xFFFFF3E0)),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + period picker
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('System Reports', style: AppTextStyles.pageTitle),
                    SizedBox(height: 4),
                    Text('Analytics and usage statistics across the platform',
                        style: AppTextStyles.pageSubtitle),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color:        AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  border:       Border.all(color: Colors.black.withOpacity(0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _period,
                    style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                    icon:  const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textDisabled),
                    items: _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (v) => setState(() => _period = v!),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // KPI cards
          AdminStatCards(cards: _kpis),
          const SizedBox(height: 24),

          // Bar chart
          _RequestsChart(data: _chartData, period: _period),
          const SizedBox(height: 24),

          // Model table + top users — side by side on wide, stacked on narrow
          LayoutBuilder(builder: (_, constraints) {
            if (constraints.maxWidth > AppSizes.wideBreak) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _ModelTable(reports: _modelReports)),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: _TopUsersCard(users: _topUsers)),
                ],
              );
            }
            return Column(children: [
              _ModelTable(reports: _modelReports),
              const SizedBox(height: 20),
              _TopUsersCard(users: _topUsers),
            ]);
          }),
          const SizedBox(height: 24),

          // Export row
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AdminForms.showGenerateReport(context),
                  icon:  const Icon(Icons.download_outlined, size: 16),
                  label: const Text('Export as CSV'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side:            const BorderSide(color: AppColors.primary),
                    padding:         const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMid)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => AdminForms.showGenerateReport(context),
                  icon:  const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  label: const Text('Export as PDF'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.info,
                    side:            const BorderSide(color: AppColors.info),
                    padding:         const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMid)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ── Bar chart ─────────────────────────────────────────────────────────────────

class _RequestsChart extends StatelessWidget {
  const _RequestsChart({required this.data, required this.period});
  final List<_ChartBar> data;
  final String          period;

  @override
  Widget build(BuildContext context) {
    final maxVal = data.map((d) => d.value).reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Requests Over Time', style: AppTextStyles.cardTitle),
              Text(period, style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((d) {
                final barH = (d.value / maxVal) * 120;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${d.value}',
                          style: const TextStyle(fontSize: 9, color: AppColors.textDisabled)),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve:    Curves.easeOut,
                          height:   barH,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            gradient: const LinearGradient(
                              begin:  Alignment.topCenter,
                              end:    Alignment.bottomCenter,
                              colors: [AppColors.primaryLight, AppColors.primary],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(d.label, style: AppTextStyles.caption),
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

// ── Model performance table ────────────────────────────────────────────────────

class _ModelTable extends StatelessWidget {
  const _ModelTable({required this.reports});
  final List<_ModelReport> reports;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Model Performance', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.06))),
            ),
            child: Row(
              children: const [
                Expanded(flex: 4, child: Text('MODEL',    style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('REQUESTS', style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('SUCCESS',  style: AppTextStyles.tableHeader)),
                Expanded(flex: 2, child: Text('AVG TIME', style: AppTextStyles.tableHeader)),
              ],
            ),
          ),
          ...reports.asMap().entries.map((e) => _ModelRow(
            model: e.value, isLast: e.key == reports.length - 1,
          )),
        ],
      ),
    );
  }
}

class _ModelRow extends StatelessWidget {
  const _ModelRow({required this.model, required this.isLast});
  final _ModelReport model;
  final bool         isLast;

  @override
  Widget build(BuildContext context) {
    final rate    = model.requests > 0
        ? (model.success / model.requests * 100).toStringAsFixed(1)
        : '0.0';
    final rateOk  = double.parse(rate) >= 95;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.04)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: model.color, borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Text(model.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMid),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text('${model.requests}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark))),
          Expanded(flex: 2, child: Text('$rate%',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                color: rateOk ? AppColors.success : AppColors.warning))),
          Expanded(flex: 2, child: Text(model.avgTime,
            style: AppTextStyles.caption)),
        ],
      ),
    );
  }
}

// ── Top users card ────────────────────────────────────────────────────────────

class _TopUsersCard extends StatelessWidget {
  const _TopUsersCard({required this.users});
  final List<_TopUser> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Users by Usage', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          ...users.asMap().entries.map((e) => _UserRow(user: e.value, rank: e.key + 1)),
        ],
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.rank});
  final _TopUser user;
  final int      rank;

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1
        ? const Color(0xFFFFC107)
        : rank == 2 ? AppColors.textDisabled
        : rank == 3 ? const Color(0xFFCD7F32)
        : AppColors.divider;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle),
            child: Center(
              child: Text('$rank',
                style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold,
                  color: rank <= 3 ? Colors.white : AppColors.textSubtle,
                ),
              ),
            ),
          ),
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              color: user.color.withOpacity(0.15), shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(user.initials,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: user.color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label.copyWith(fontSize: 13),
                ),
                Text(user.role, style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${user.requests}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              Text('requests', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
