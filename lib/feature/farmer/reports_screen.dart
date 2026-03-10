import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// REPORTS SCREEN
//
// CRITICAL FILE-ORDER RULE (Dart const context):
//   Every class used in a `const` expression MUST be declared BEFORE
//   the class that contains that expression.
//
//   Correct declaration order in this file:
//     1. Enums + pure data classes  (_ReportType, _ReportItem, _Stat)
//     2. Stateless sub-widgets      (_StatCard, _ReportCard, _DateField, _Badge)
//     3. Screen widget              (ReportsScreen + _ReportsScreenState)
//
// Violating this order causes a silent const-initialization failure at
// runtime → blank body with no visible error in debug mode.
// ═══════════════════════════════════════════════════════════════════════════════

// ─── 1. Enums ─────────────────────────────────────────────────────────────────

/// Controls the leading icon on each report card.
enum _ReportType { aiAnalysis, computerVision, machineLearning, analytics }

// ─── 2. Pure data classes ─────────────────────────────────────────────────────

class _ReportItem {
  final String      title;
  final String      subtitle;
  final String      date;
  final String      typeBadge;
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
  const _Stat({
    required this.value,
    required this.label,
    required this.icon,
  });
}

// ─── 3. Sub-widgets ───────────────────────────────────────────────────────────

/// Pill-shaped label badge.
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
        borderRadius: AppRadius.radiusFull,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize:   11,
          fontWeight: FontWeight.w500,
          color:      textColor,
        ),
      ),
    );
  }
}

/// One stat tile (Total Reports / This Month / vs Last Month).
class _StatCard extends StatelessWidget {
  final _Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border:       Border.all(color: AppColors.border),
        boxShadow:    AppShadows.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color:        AppColors.primaryLight,
              borderRadius: AppRadius.radiusMd,
            ),
            child: Icon(stat.icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
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
                  style: tt.bodySmall?.copyWith(color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Full report row card with icon, text, badges, and Download button.
class _ReportCard extends StatelessWidget {
  final _ReportItem report;
  const _ReportCard({required this.report});

  IconData get _icon {
    switch (report.type) {
      case _ReportType.aiAnalysis:    return Icons.local_florist_outlined;
      case _ReportType.computerVision: return Icons.monitor_weight_outlined;
      case _ReportType.machineLearning: return Icons.grass_outlined;
      case _ReportType.analytics:     return Icons.bar_chart_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border:       Border.all(color: AppColors.border),
        boxShadow:    AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Top: icon + text + badges ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leading icon chip
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color:        AppColors.primaryLight,
                    borderRadius: AppRadius.radiusMd,
                  ),
                  child: Icon(_icon, color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: AppSpacing.md),
                // Text
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
                        style: tt.bodySmall?.copyWith(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Metadata row
                      Wrap(
                        spacing:            6,
                        runSpacing:         4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 12, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Text(
                                report.date,
                                style: tt.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color:    AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          _Badge(
                            label:     report.typeBadge,
                            bgColor:   const Color(0xFFF3F4F6),
                            textColor: AppColors.textMuted,
                          ),
                          _Badge(
                            label:     'Completed',
                            bgColor:   AppColors.primaryLight,
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
          const Divider(height: 1, thickness: 1, color: AppColors.border),

          // ── Download button ───────────────────────────────────────────
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.download_outlined,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Download',
                    style: tt.bodyMedium?.copyWith(
                      color:      AppColors.textMuted,
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

/// Tappable date input field that opens a date picker.
class _DateField extends StatelessWidget {
  final String       label;
  final String       value;
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
            fontWeight: FontWeight.w500,
            color:      AppColors.textDark,
          ),
        ),
        const SizedBox(height: 7),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: 13),
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: AppRadius.radiusMd,
              border:       Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: tt.bodyMedium?.copyWith(
                      color: hasValue
                          ? AppColors.textDark
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_month_outlined,
                  size:  18,
                  color: hasValue ? AppColors.primary : AppColors.textMuted,
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

  // ── Date picker state ──────────────────────────────────────────────────────
  DateTime? _startDate;
  DateTime? _endDate;

  // ── Static data — NOTE: _Stat and _ReportItem are defined ABOVE this class ──
  static const List<_Stat> _stats = [
    _Stat(value: '24',   label: 'Total Reports',  icon: Icons.description_outlined),
    _Stat(value: '6',    label: 'This Month',      icon: Icons.calendar_today_outlined),
    _Stat(value: '+25%', label: 'vs Last Month',   icon: Icons.trending_up_rounded),
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

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FeatureAppBar(
        title:   'Reports',
        svgPath: 'assets/images/icons/reports_icon.svg',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xxxl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Heading + Export All ────────────────────────────────
                _buildHeading(context),
                const SizedBox(height: AppSpacing.xl),

                // ── 3 stat cards ────────────────────────────────────────
                _buildStatRow(),
                const SizedBox(height: AppSpacing.xl),

                // ── Report card list ────────────────────────────────────
                for (final r in _reports) ...[
                  _ReportCard(report: r),
                  const SizedBox(height: AppSpacing.md),
                ],
                const SizedBox(height: AppSpacing.sm),

                // ── Generate New Report ─────────────────────────────────
                _buildGenerateCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Heading row ────────────────────────────────────────────────────────────

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
                  fontWeight: FontWeight.w700,
                  color:      AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Access and download all AI-generated reports and analyses',
                style: tt.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        ElevatedButton.icon(
          onPressed: () {},
          icon:  const Icon(Icons.download_rounded, size: 16),
          label: const Text('Export All'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radiusMd,
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  // ── Stat row — LayoutBuilder ensures bounded width for Expanded cards ───────

  Widget _buildStatRow() {
    return LayoutBuilder(
      builder: (_, constraints) {
        // On very narrow screens fall back to vertical layout
        if (constraints.maxWidth < 320) {
          return Column(
            children: [
              for (int i = 0; i < _stats.length; i++) ...[
                _StatCard(stat: _stats[i]),
                if (i < _stats.length - 1)
                  const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        }
        final gap       = AppSpacing.md;
        final cardWidth = (constraints.maxWidth - gap * 2) / 3;
        return Row(
          children: [
            for (int i = 0; i < _stats.length; i++) ...[
              SizedBox(width: cardWidth, child: _StatCard(stat: _stats[i])),
              if (i < _stats.length - 1) SizedBox(width: gap),
            ],
          ],
        );
      },
    );
  }

  // ── Generate New Report card ───────────────────────────────────────────────

  Widget _buildGenerateCard(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: AppRadius.radiusLg,
        border:       Border.all(color: AppColors.border),
        boxShadow:    AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          // Heading
          Text(
            'Generate New Report',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color:      AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Create a custom report by selecting the date range '
                'and AI tools to include',
            style: tt.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Date fields — side-by-side on wide, stacked on narrow
          LayoutBuilder(
            builder: (_, c) {
              if (c.maxWidth > 480) {
                final hw = (c.maxWidth - AppSpacing.lg) / 2;
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
                    const SizedBox(width: AppSpacing.lg),
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
                  const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.xl),

          // Generate button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl, vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.radiusFull,
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