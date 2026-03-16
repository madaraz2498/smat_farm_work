import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_app_bar.dart';

// ─── 1. Enums ─────────────────────────────────────────────────────────────────

enum _ReportType { aiAnalysis, computerVision, machineLearning, analytics }

// ─── 2. Pure data classes ─────────────────────────────────────────────────────

class _ReportItem {
  final String      title, subtitle, date, typeBadge;
  final _ReportType type;
  const _ReportItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.typeBadge,
    required this.type,
  });
}

class _Stat {
  final String   value, label;
  final IconData icon;
  const _Stat({required this.value, required this.label, required this.icon});
}

// ─── 3. Sub-widgets ───────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color  bgColor, textColor;
  const _Badge({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color:        bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500, color: textColor,
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: Icon(stat.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                stat.value,
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:      AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.label,
                style: tt.bodySmall?.copyWith(color: AppColors.textSubtle),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final _ReportItem report;
  const _ReportCard({required this.report});

  IconData get _icon {
    switch (report.type) {
      case _ReportType.aiAnalysis:      return Icons.local_florist_outlined;
      case _ReportType.computerVision:  return Icons.monitor_weight_outlined;
      case _ReportType.machineLearning: return Icons.grass_outlined;
      case _ReportType.analytics:       return Icons.bar_chart_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top: icon + text + badges ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color:        AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                  ),
                  child: Icon(_icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:      AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.subtitle,
                        style: tt.bodySmall?.copyWith(color: AppColors.textSubtle),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing:            6,
                        runSpacing:         4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 12, color: AppColors.textSubtle),
                              const SizedBox(width: 4),
                              Text(
                                report.date,
                                style: tt.bodySmall?.copyWith(
                                  fontSize: 12, color: AppColors.textSubtle,
                                ),
                              ),
                            ],
                          ),
                          _Badge(
                            label:     report.typeBadge,
                            bgColor:   const Color(0xFFF3F4F6),
                            textColor: AppColors.textSubtle,
                          ),
                          _Badge(
                            label:     'Completed',
                            bgColor:   AppColors.primarySurface,
                            textColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ───────────────────────────────────────────────────
          Divider(height: 1, thickness: 1, color: AppColors.cardBorder),

          // ── Download button ───────────────────────────────────────────
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download_outlined,
                      size: 16, color: AppColors.textSubtle),
                  const SizedBox(width: 8),
                  Text(
                    'Download',
                    style: tt.bodyMedium?.copyWith(
                      color:      AppColors.textSubtle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String       label, value;
  final bool         hasValue;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.hasValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: tt.labelMedium?.copyWith(
            fontWeight: FontWeight.w500, color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              border:       Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: tt.bodyMedium?.copyWith(
                      color: hasValue ? AppColors.textDark : AppColors.textSubtle,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size:  18,
                  color: hasValue ? AppColors.primary : AppColors.textSubtle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 4. Screen ────────────────────────────────────────────────────────────────

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  static const List<_Stat> _stats = [
    _Stat(value: '24',   label: 'Total Reports', icon: Icons.description_outlined),
    _Stat(value: '6',    label: 'This Month',     icon: Icons.calendar_today_outlined),
    _Stat(value: '+25%', label: 'vs Last Month',  icon: Icons.trending_up_rounded),
  ];

  static const List<_ReportItem> _reports = [
    _ReportItem(
      title:     'Plant Disease Analysis Report',
      subtitle:  '45 images analyzed, 3 diseases detected',
      date:      'December 10, 2024',
      typeBadge: 'AI Analysis',
      type:      _ReportType.aiAnalysis,
    ),
    _ReportItem(
      title:     'Livestock Weight Monitoring',
      subtitle:  '156 animals tracked, avg weight: 425kg',
      date:      'December 8, 2024',
      typeBadge: 'Computer Vision',
      type:      _ReportType.computerVision,
    ),
    _ReportItem(
      title:     'Crop Recommendation Summary',
      subtitle:  '3 fields analyzed, recommendations provided',
      date:      'December 5, 2024',
      typeBadge: 'Machine Learning',
      type:      _ReportType.machineLearning,
    ),
    _ReportItem(
      title:     'Soil Analysis Report',
      subtitle:  'Fertility levels assessed for all zones',
      date:      'December 3, 2024',
      typeBadge: 'AI Analysis',
      type:      _ReportType.aiAnalysis,
    ),
    _ReportItem(
      title:     'Fruit Quality Assessment',
      subtitle:  '1,200 fruits graded, 78% Grade A',
      date:      'December 1, 2024',
      typeBadge: 'Computer Vision',
      type:      _ReportType.computerVision,
    ),
    _ReportItem(
      title:     'Monthly Farm Performance',
      subtitle:  'Comprehensive monthly analysis',
      date:      'November 30, 2024',
      typeBadge: 'Analytics',
      type:      _ReportType.analytics,
    ),
  ];

  Future<void> _pickDate({required bool isStart}) async {
    final now    = DateTime.now();
    final picked = await showDatePicker(
      context:     context,
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      firstDate:   DateTime(2020),
      lastDate:    now,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: Theme.of(ctx).colorScheme.copyWith(
            primary: AppColors.primary,
          ),
        ),
        child: child!,
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      if (isStart) _startDate = picked;
      else         _endDate   = picked;
    });
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'mm/dd/yyyy';
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$m/$d/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeading(context),
                const SizedBox(height: 20),
                _buildStatRow(),
                const SizedBox(height: 20),
                for (final r in _reports) ...[
                  _ReportCard(report: r),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                _buildGenerateCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeading(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reports',
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Access and download all AI-generated reports and analyses',
                style: tt.bodySmall?.copyWith(color: AppColors.textSubtle),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon:  const Icon(Icons.download_rounded, size: 16),
          label: const Text('Export All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow() {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 320) {
          return Column(
            children: [
              for (int i = 0; i < _stats.length; i++) ...[
                _StatCard(stat: _stats[i]),
                if (i < _stats.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }
        const gap       = 12.0;
        final cardWidth = (constraints.maxWidth - gap * 2) / 3;
        return Row(
          children: [
            for (int i = 0; i < _stats.length; i++) ...[
              SizedBox(width: cardWidth, child: _StatCard(stat: _stats[i])),
              if (i < _stats.length - 1) const SizedBox(width: gap),
            ],
          ],
        );
      },
    );
  }

  Widget _buildGenerateCard(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Generate New Report',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700, color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create a custom report by selecting the date range '
                'and AI tools to include',
            style: tt.bodySmall?.copyWith(color: AppColors.textSubtle),
          ),
          const SizedBox(height: 20),

          LayoutBuilder(
            builder: (_, c) {
              if (c.maxWidth > 480) {
                final hw = (c.maxWidth - 16) / 2;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: hw,
                      child: _DateField(
                        label:    'Start Date',
                        value:    _fmt(_startDate),
                        hasValue: _startDate != null,
                        onTap:    () => _pickDate(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: hw,
                      child: _DateField(
                        label:    'End Date',
                        value:    _fmt(_endDate),
                        hasValue: _endDate != null,
                        onTap:    () => _pickDate(isStart: false),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _DateField(
                    label:    'Start Date',
                    value:    _fmt(_startDate),
                    hasValue: _startDate != null,
                    onTap:    () => _pickDate(isStart: true),
                  ),
                  const SizedBox(height: 12),
                  _DateField(
                    label:    'End Date',
                    value:    _fmt(_endDate),
                    hasValue: _endDate != null,
                    onTap:    () => _pickDate(isStart: false),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              elevation: 0,
            ),
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }
}