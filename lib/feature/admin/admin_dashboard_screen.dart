import 'dart:math' as math;
import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ADMIN DASHBOARD SCREEN
//
// Single-file admin portal. Owns its own Scaffold, dark top-bar, and a fixed
// left sidebar. Content pages switch inline — the sidebar stays visible on
// every sub-page, matching the design reference screenshots exactly.
//
// Container rule (no crash):  color is ALWAYS inside BoxDecoration(color:…).
//                              Never as a sibling param alongside decoration:.
//
// Class order (Dart const-safe):
//   1. Color/layout constants
//   2. Immutable data classes  (must precede their const uses)
//   3. Shared helper widgets   (charts, cards, etc.)
//   4. Sub-page widgets        (Dashboard, UserMgmt, SystemMgmt, Reports, Settings)
//   5. AdminDashboardScreen shell
// ═══════════════════════════════════════════════════════════════════════════════

// ── 1. Constants ──────────────────────────────────────────────────────────────

const _kGreen        = Color(0xFF4CAF50);
const _kGreenLight   = Color(0xFFE8F5E9);
const _kGreenDark    = Color(0xFF2E7D32);
const _kDark         = Color(0xFFE8F5E9);
const _kBg           = Color(0xFFF4F6EF);
const _kWhite        = Colors.white;
const _kText1        = Color(0xFF1F2937);
const _kText2        = Color(0xFF6B7280);
const _kText3        = Color(0xFF9CA3AF);
const _kBorder       = Color(0x12000000);
const _kShadow       = Color(0x08000000);
const _kBlue         = Color(0xFF2196F3);
const _kBlueLight    = Color(0xFFE3F2FD);
const _kOrange       = Color(0xFFFF9800);
const _kOrangeLight  = Color(0xFFFFF3E0);
const _kOrangeDark   = Color(0xFFE65100);
const _kPurple       = Color(0xFF9C27B0);
const _kPurpleLight  = Color(0xFFF3E5F5);
const _kRed          = Color(0xFFF44336);
const _kCyan         = Color(0xFF00BCD4);
const double _kR     = 20; // card border-radius

// ── 2. Data classes ───────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem({required this.icon, required this.label});
}

class _SumCard {
  final IconData icon;
  final Color    iconFg, iconBg, badgeFg, badgeBg;
  final String   badge, title, sub;
  const _SumCard({
    required this.icon,    required this.iconFg,  required this.iconBg,
    required this.badge,   required this.badgeFg, required this.badgeBg,
    required this.title,   required this.sub,
  });
}

class _ActivityItem {
  final String name, action, time, initials;
  final Color  color;
  const _ActivityItem({
    required this.name,     required this.action,
    required this.time,     required this.initials,
    required this.color,
  });
}

class _UserData {
  final String name, email, role, status, joined, lastLogin;
  final int    requests;
  const _UserData({
    required this.name,     required this.email,
    required this.role,     required this.status,
    required this.joined,   required this.lastLogin,
    required this.requests,
  });
}

class _ModelData {
  final String name, version, type, accuracy;
  const _ModelData({
    required this.name,    required this.version,
    required this.type,    required this.accuracy,
  });
}

class _ReportFile {
  final String name, date, tag, size;
  const _ReportFile({
    required this.name, required this.date,
    required this.tag,  required this.size,
  });
}

// ── 3. Shared helpers ─────────────────────────────────────────────────────────

/// White rounded card. Color is always inside BoxDecoration — no crash possible.
class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const _Card({required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:        _kWhite,
        borderRadius: BorderRadius.circular(_kR),
        border:       Border.all(color: _kBorder),
        boxShadow: [BoxShadow(color: _kShadow, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }
}

/// Coloured pill badge.
class _Pill extends StatelessWidget {
  final String text;
  final Color  bg, fg;
  const _Pill(this.text, {required this.bg, required this.fg});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(text, style: TextStyle(fontSize: 11, color: fg, fontWeight: FontWeight.w600)),
  );
}

/// Section heading used by every sub-page.
class _PageHeading extends StatelessWidget {
  final String title, subtitle;
  const _PageHeading({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _kText1)),
      const SizedBox(height: 4),
      Text(subtitle, style: const TextStyle(fontSize: 14, color: _kText2)),
    ],
  );
}

/// Section card header row (icon chip + title + subtitle).
class _CardHeader extends StatelessWidget {
  final IconData icon;
  final Color    iconFg, iconBg;
  final String   title, subtitle;
  const _CardHeader({
    required this.icon,    required this.iconFg, required this.iconBg,
    required this.title,   required this.subtitle,
  });
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 38, height: 38,
        decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconFg, size: 18),
      ),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kText1)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: _kText2)),
      ]),
    ],
  );
}

// ── Line chart (CustomPainter) ────────────────────────────────────────────────

class _LineChart extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final double       height;
  const _LineChart({required this.values, required this.xLabels, this.height = 150});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: height,
        child: CustomPaint(painter: _LineChartPainter(values: values), size: Size.infinite),
      ),
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: xLabels.map((l) => Text(l, style: const TextStyle(fontSize: 11, color: _kText3))).toList(),
      ),
    ],
  );
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  _LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(math.max);
    if (maxV == 0) return;

    // Grid
    final grid = Paint()..color = _kText3.withOpacity(0.15)..strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    // Y-axis labels
    final tp = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= 4; i++) {
      tp.text = TextSpan(
        text: '${(maxV * i / 4).round()}',
        style: const TextStyle(fontSize: 10, color: _kText3),
      );
      tp.layout();
      final y = size.height * (1 - i / 4);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    const leftPad = 28.0;
    final usableW = size.width - leftPad;

    Offset pt(int i) => Offset(
      leftPad + i / (values.length - 1) * usableW,
      size.height - values[i] / maxV * size.height,
    );

    // Fill
    final fillPath = Path()..moveTo(pt(0).dx, size.height)..lineTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < values.length; i++) fillPath.lineTo(pt(i).dx, pt(i).dy);
    fillPath..lineTo(pt(values.length - 1).dx, size.height)..close();
    canvas.drawPath(
      fillPath,
      Paint()..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [_kGreen.withOpacity(0.20), _kGreen.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Line
    final line = Path()..moveTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < values.length; i++) line.lineTo(pt(i).dx, pt(i).dy);
    canvas.drawPath(
      line,
      Paint()..color = _kGreen..strokeWidth = 2.5
        ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
    );

    // Dots
    for (int i = 0; i < values.length; i++) {
      canvas.drawCircle(pt(i), 5, Paint()..color = _kWhite);
      canvas.drawCircle(pt(i), 3.5, Paint()..color = _kGreen);
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => old.values != values;
}

// ── Bar chart (widget-based) ──────────────────────────────────────────────────

class _BarChart extends StatelessWidget {
  final List<(String, double)> data;
  final double                 height;
  const _BarChart({required this.data, this.height = 140});

  @override
  Widget build(BuildContext context) {
    final maxV = data.map((d) => d.$2).reduce(math.max);
    return SizedBox(
      height: height + 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((d) {
          final barH = (d.$2 / maxV * height).clamp(8.0, height);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: barH,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Color(0xFF66BB6A), _kGreen],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(d.$1,
                      style: const TextStyle(fontSize: 11, color: _kText2),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Pie chart (CustomPainter) ─────────────────────────────────────────────────

class _PieChart extends StatelessWidget {
  final List<(String, double, Color)> segments;
  const _PieChart({required this.segments});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 160, height: 160,
            child: CustomPaint(
              painter: _PiePainter(segments: segments.map((s) => (s.$3, s.$2)).toList()),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10, runSpacing: 6,
          children: segments.map((s) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 10, height: 10,
                  decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Text('${s.$1}: ${(s.$2 * 100).round()}%',
                  style: const TextStyle(fontSize: 11, color: _kText2)),
            ],
          )).toList(),
        ),
      ],
    );
  }
}

class _PiePainter extends CustomPainter {
  final List<(Color, double)> segments;
  _PiePainter({required this.segments});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    double start = -math.pi / 2;
    for (final (color, frac) in segments) {
      final sweep = 2 * math.pi * frac;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), start, sweep, true,
        Paint()..color = color..style = PaintingStyle.fill,
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius), start, sweep, true,
        Paint()..color = _kWhite..style = PaintingStyle.stroke..strokeWidth = 2,
      );
      start += sweep;
    }
  }
  @override
  bool shouldRepaint(_PiePainter _) => false;
}

// ── 4a. Dashboard home page ───────────────────────────────────────────────────

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  // const data — declared BELOW _SumCard/_ActivityItem so Dart can resolve them
  static const List<_SumCard> _cards = [
    _SumCard(icon: Icons.people_outline,      iconFg: _kGreen,  iconBg: _kGreenLight,
        badge: '+12%',  badgeFg: _kGreenDark, badgeBg: _kGreenLight,
        title: 'Total Users',     sub: '1,247 registered'),
    _SumCard(icon: Icons.show_chart,          iconFg: _kGreen,  iconBg: _kGreenLight,
        badge: '+23%',  badgeFg: _kGreenDark, badgeBg: _kGreenLight,
        title: 'Total Analyses',  sub: '8,456 this month'),
    _SumCard(icon: Icons.settings_outlined,   iconFg: _kGreen,  iconBg: _kGreenLight,
        badge: 'All Online', badgeFg: _kGreenDark, badgeBg: _kGreenLight,
        title: 'AI Services',    sub: '6 of 6 active'),
    _SumCard(icon: Icons.trending_up_rounded, iconFg: _kBlue,   iconBg: _kBlueLight,
        badge: 'Top',     badgeFg: _kBlue,      badgeBg: _kBlueLight,
        title: 'Most Used',      sub: 'Plant Disease Detection'),
  ];

  static const List<_ActivityItem> _activities = [
    _ActivityItem(name: 'John Farmer',  action: 'Used Plant Disease Detection',    time: '2 minutes ago',  initials: 'JF', color: _kGreen),
    _ActivityItem(name: 'Sarah Miller', action: 'Completed Soil Analysis',          time: '15 minutes ago', initials: 'SM', color: _kBlue),
    _ActivityItem(name: 'Mike Johnson', action: 'Requested Crop Recommendation',    time: '1 hour ago',     initials: 'MJ', color: _kPurple),
    _ActivityItem(name: 'Emma Wilson',  action: 'Used Animal Weight Estimation',    time: '2 hours ago',    initials: 'EW', color: _kOrange),
    _ActivityItem(name: 'David Brown',  action: 'Analyzed Fruit Quality',           time: '3 hours ago',    initials: 'DB', color: _kRed),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeading(
            title:    'Admin Dashboard',
            subtitle: 'System-wide overview and analytics for Smart Farm AI platform',
          ),
          const SizedBox(height: 24),

          // Summary cards — responsive grid
          LayoutBuilder(builder: (_, c) {
            final cols = c.maxWidth > 800 ? 4 : c.maxWidth > 500 ? 2 : 1;
            final gap  = 14.0;
            final w    = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap, runSpacing: gap,
              children: _cards.map((s) => SizedBox(width: w, child: _buildSumCard(s))).toList(),
            );
          }),
          const SizedBox(height: 20),

          // Charts row
          LayoutBuilder(builder: (_, c) {
            if (c.maxWidth > 700) {
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(flex: 6, child: _buildUsageOverTimeCard()),
                const SizedBox(width: 16),
                Expanded(flex: 5, child: _buildServiceDistCard()),
              ]);
            }
            return Column(children: [
              _buildUsageOverTimeCard(),
              const SizedBox(height: 16),
              _buildServiceDistCard(),
            ]);
          }),
          const SizedBox(height: 20),

          _buildActiveUsersCard(),
          const SizedBox(height: 20),
          _buildActivityCard(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSumCard(_SumCard s) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: s.iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(s.icon, color: s.iconFg, size: 22),
              ),
              _Pill(s.badge, bg: s.badgeBg, fg: s.badgeFg),
            ],
          ),
          const SizedBox(height: 14),
          Text(s.title, style: const TextStyle(fontSize: 13, color: _kText2)),
          const SizedBox(height: 4),
          Text(s.sub,   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kText1)),
        ],
      ),
    );
  }

  Widget _buildUsageOverTimeCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.bar_chart_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
            title: 'Usage Over Time', subtitle: 'Monthly AI analyses trend',
          ),
          const SizedBox(height: 20),
          const _LineChart(
            values:  [150, 175, 220, 290, 330, 430],
            xLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            height:  150,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDistCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.donut_large_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
            title: 'Service Distribution', subtitle: 'Usage by AI service',
          ),
          const SizedBox(height: 20),
          const _PieChart(segments: [
            ('Plant Disease',  0.25, Color(0xFF1B5E20)),
            ('Chatbot',        0.21, _kGreen),
            ('Animal Weight',  0.18, Color(0xFF8BC34A)),
            ('Recommendation', 0.14, Color(0xFFA5D6A7)),
            ('Soil Analysis',  0.12, Color(0xFFC8E6C9)),
            ('Fruit Quality',  0.10, Color(0xFFDCEDC8)),
          ]),
        ],
      ),
    );
  }

  Widget _buildActiveUsersCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardHeader(
            icon: Icons.people_outline, iconFg: _kGreen, iconBg: _kGreenLight,
            title: 'Active Users', subtitle: 'Daily active users this week',
          ),
          const SizedBox(height: 20),
          const _BarChart(
            data: [
              ('Mon', 32), ('Tue', 43), ('Wed', 35),
              ('Thu', 52), ('Fri', 48), ('Sat', 25), ('Sun', 20),
            ],
            height: 140,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Recent System Activity',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _kText1)),
            TextButton(
              onPressed: () {},
              child: const Text('View all', style: TextStyle(color: _kGreen, fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 8),
          ..._activities.map((a) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: a.color.withOpacity(0.12), shape: BoxShape.circle,
                ),
                child: Center(child: Text(a.initials,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: a.color))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.name,   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1)),
                  Text(a.action, style: const TextStyle(fontSize: 12, color: _kText2)),
                ],
              )),
              Text(a.time, style: const TextStyle(fontSize: 11, color: _kText3)),
            ]),
          )),
        ],
      ),
    );
  }
}

// ── 4b. User Management page ──────────────────────────────────────────────────

class _UserManagementPage extends StatefulWidget {
  const _UserManagementPage();
  @override
  State<_UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<_UserManagementPage> {
  String _search = '';

  static const List<_UserData> _allUsers = [
    _UserData(name: 'John Farmer',   email: 'john.farmer@example.com',  role: 'Farmer', status: 'Active',   joined: 'Jan 15, 2024', lastLogin: '2 hrs ago',   requests: 234),
    _UserData(name: 'Sarah Miller',  email: 'sarah.miller@example.com', role: 'Farmer', status: 'Active',   joined: 'Feb 20, 2024', lastLogin: '1 day ago',   requests: 312),
    _UserData(name: 'Mike Johnson',  email: 'mike.johnson@example.com', role: 'Admin',  status: 'Active',   joined: 'Jan 10, 2024', lastLogin: '3 hrs ago',   requests: 891),
    _UserData(name: 'Emma Wilson',   email: 'emma.wilson@example.com',  role: 'Farmer', status: 'Active',   joined: 'Mar 5, 2024',  lastLogin: '5 min ago',   requests: 178),
    _UserData(name: 'David Brown',   email: 'david.brown@example.com',  role: 'Farmer', status: 'Inactive', joined: 'Feb 12, 2024', lastLogin: '2 weeks ago', requests: 45),
    _UserData(name: 'Lisa Anderson', email: 'lisa.anderson@example.com',role: 'Farmer', status: 'Active',   joined: 'Mar 18, 2024', lastLogin: '1 hr ago',    requests: 203),
    _UserData(name: 'Tom Harris',    email: 'tom.harris@example.com',   role: 'Farmer', status: 'Active',   joined: 'Jan 25, 2024', lastLogin: '30 min ago',  requests: 89),
    _UserData(name: 'Rachel Green',  email: 'rachel.green@example.com', role: 'Admin',  status: 'Active',   joined: 'Feb 8, 2024',  lastLogin: '4 hrs ago',   requests: 567),
  ];

  List<_UserData> get _filtered => _search.isEmpty
      ? _allUsers
      : _allUsers.where((u) =>
  u.name.toLowerCase().contains(_search.toLowerCase()) ||
      u.email.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  Color _roleColor(String r)   { return r == 'Admin' ? _kOrangeDark : _kGreen; }
  Color _statusColor(String s) {
    switch (s) {
      case 'Active':   return _kGreen;
      case 'Inactive': return _kOrange;
      default:         return _kRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _filtered;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeading(
            title:    'User Management',
            subtitle: 'Manage users, roles, and permissions across the Smart Farm AI platform',
          ),
          const SizedBox(height: 20),

          // Summary tiles
          LayoutBuilder(builder: (_, c) {
            const tiles = [
              ('Total Users',    '1,247', Icons.people_outline,              _kGreen,  _kGreenLight),
              ('Active Users',   '1,156', Icons.check_circle_outline,        _kGreen,  _kGreenLight),
              ('Inactive Users', '91',    Icons.pause_circle_outline,        _kOrange, _kOrangeLight),
              ('Admins',         '12',    Icons.admin_panel_settings_outlined,_kBlue,  _kBlueLight),
            ];
            final cols = c.maxWidth > 700 ? 4 : 2;
            final gap  = 14.0;
            final w    = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap, runSpacing: gap,
              children: tiles.map((t) => SizedBox(
                width: w,
                child: _Card(
                  padding: const EdgeInsets.all(16),
                  child: Row(children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: t.$5, borderRadius: BorderRadius.circular(12)),
                      child: Icon(t.$3, color: t.$4, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(t.$2, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _kText1)),
                      Text(t.$1, style: const TextStyle(fontSize: 12, color: _kText2)),
                    ]),
                  ]),
                ),
              )).toList(),
            );
          }),
          const SizedBox(height: 20),

          // Search
          _Card(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: const InputDecoration(
                hintText:   'Search by name or email...',
                hintStyle:  TextStyle(color: _kText3, fontSize: 14),
                prefixIcon: Icon(Icons.search, size: 20, color: _kText3),
                border:     InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Table
          _Card(
            padding: EdgeInsets.zero,
            child: Column(children: [
              // Header row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(_kR)),
                  border: Border(bottom: BorderSide(color: _kBorder)),
                ),
                child: const Row(children: [
                  Expanded(flex: 3, child: Text('User',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                  Expanded(flex: 3, child: Text('Email',   style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                  Expanded(flex: 2, child: Text('Role',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                  Expanded(flex: 2, child: Text('Status',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                  Expanded(flex: 2, child: Text('Joined',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                  SizedBox(width: 56, child: Text('Actions',style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2, letterSpacing: 0.5))),
                ]),
              ),
              if (users.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('No users found', style: TextStyle(color: _kText3)),
                )
              else
                ...users.asMap().entries.map((e) => _buildUserRow(e.value, e.key == users.length - 1)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(_UserData u, bool isLast) {
    final rc  = _roleColor(u.role);
    final sc  = _statusColor(u.status);
    final ini = u.name.split(' ').map((p) => p[0]).take(2).join();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: _kBorder)),
      ),
      child: Row(children: [
        Expanded(flex: 3, child: Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(color: rc.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text(ini, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: rc))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(u.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1),
              overflow: TextOverflow.ellipsis)),
        ])),
        Expanded(flex: 3, child: Row(children: [
          const Icon(Icons.email_outlined, size: 12, color: _kText3),
          const SizedBox(width: 4),
          Expanded(child: Text(u.email,
              style: const TextStyle(fontSize: 12, color: _kText2),
              overflow: TextOverflow.ellipsis)),
        ])),
        Expanded(flex: 2, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: rc.withOpacity(0.10), borderRadius: BorderRadius.circular(6),
          ),
          child: Text(u.role, style: TextStyle(fontSize: 12, color: rc, fontWeight: FontWeight.w500)),
        )),
        Expanded(flex: 2, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: sc.withOpacity(0.10), borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sc.withOpacity(0.3)),
          ),
          child: Text(u.status, style: TextStyle(fontSize: 11, color: sc, fontWeight: FontWeight.w600)),
        )),
        Expanded(flex: 2, child: Text(u.joined, style: const TextStyle(fontSize: 12, color: _kText2))),
        SizedBox(width: 56, child: Row(children: [
          _iconBtn(Icons.visibility_outlined, _kText2),
          _iconBtn(Icons.more_vert,           _kText2),
        ])),
      ]),
    );
  }

  Widget _iconBtn(IconData icon, Color c) => InkWell(
    onTap: () {},
    borderRadius: BorderRadius.circular(6),
    child: Padding(padding: const EdgeInsets.all(5), child: Icon(icon, size: 16, color: c)),
  );
}

// ── 4c. System Management page ────────────────────────────────────────────────

class _SystemManagementPage extends StatefulWidget {
  const _SystemManagementPage();
  @override
  State<_SystemManagementPage> createState() => _SystemManagementPageState();
}

class _SystemManagementPageState extends State<_SystemManagementPage> {
  bool _autoBackup   = true;
  bool _emailNotif   = true;
  bool _rateLimit    = true;
  bool _maintenance  = false;
  bool _debugLogging = false;

  static const List<_ModelData> _models = [
    _ModelData(name: 'Plant-CNN-v2.3',  version: '2.3.0', type: 'CNN',             accuracy: '94.2%'),
    _ModelData(name: 'Animal-CV-v1.8',  version: '1.8.2', type: 'Computer Vision', accuracy: '91.8%'),
    _ModelData(name: 'Crop-ML-v3.1',    version: '3.1.0', type: 'Machine Learning', accuracy: '89.5%'),
    _ModelData(name: 'Soil-DL-v2.0',    version: '2.0.1', type: 'Deep Learning',   accuracy: '92.3%'),
    _ModelData(name: 'Fruit-CV-v1.5',   version: '1.5.4', type: 'Computer Vision', accuracy: '90.7%'),
    _ModelData(name: 'Chat-NLP-v2.7',   version: '2.7.0', type: 'NLP',             accuracy: '96.1%'),
  ];

  static const List<(String, String)> _services = [
    ('Plant Disease Detection',  '99.9%'),
    ('Animal Weight Estimation', '99.7%'),
    ('Crop Recommendation',      '99.8%'),
    ('Soil Type Analysis',       '99.6%'),
    ('Fruit Quality Analysis',   '99.5%'),
    ('Smart Farm Chatbot',       '99.8%'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeading(
            title:    'System Management',
            subtitle: 'Monitor and manage all AI services and system components',
          ),
          const SizedBox(height: 20),

          // Status tiles
          LayoutBuilder(builder: (_, c) {
            final cols = c.maxWidth > 700 ? 3 : 1;
            final gap  = 14.0;
            final w    = (c.maxWidth - gap * (cols - 1)) / cols;
            final tiles = [
              ('System Status', 'All Systems Operational', Icons.power_settings_new_rounded, _kGreen,
              [('Uptime', '99.8%'), ('Response Time', '145ms')]),
              ('Database', 'Healthy', Icons.storage_outlined, _kBlue,
              [('Storage Used', '234 GB'), ('Connections', '156 active')]),
              ('AI Models', '6 of 6 Active', Icons.psychology_outlined, _kGreen,
              [('Avg Accuracy', '92.4%'), ('Total Requests', '8,456')]),
            ];
            return Wrap(
              spacing: gap, runSpacing: gap,
              children: tiles.map((t) => SizedBox(
                width: w,
                child: _Card(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: t.$4.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(t.$3, color: t.$4, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.$1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kText1)),
                          Text(t.$2, style: TextStyle(fontSize: 11, color: t.$4, fontWeight: FontWeight.w500)),
                        ],
                      )),
                    ]),
                    const SizedBox(height: 12),
                    ...t.$5.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.$1, style: const TextStyle(fontSize: 12, color: _kText2)),
                          Text(m.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _kText1)),
                        ],
                      ),
                    )),
                  ],
                )),
              )).toList(),
            );
          }),
          const SizedBox(height: 20),

          // AI Services Control
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardHeader(
                icon: Icons.power_settings_new_rounded, iconFg: _kGreen, iconBg: _kGreenLight,
                title: 'AI Services Control', subtitle: 'Enable or disable individual AI services',
              ),
              const SizedBox(height: 16),
              // ── AI Services grid — LayoutBuilder replaces fixed childAspectRatio
              //    (fixed ratio caused Column overflow on narrow screens)
              LayoutBuilder(builder: (_, constraints) {
                final cols  = constraints.maxWidth > 420 ? 2 : 1;
                final gap   = 10.0;
                final itemW = (constraints.maxWidth - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing:    gap,
                  runSpacing: gap,
                  children: _services.map((s) => SizedBox(
                    width: itemW,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color:        _kGreenLight,
                        borderRadius: BorderRadius.circular(12),
                        border:       Border.all(color: _kGreen.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        const Icon(Icons.check_circle, color: _kGreen, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(s.$1,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500,
                                    color: _kText1),
                                overflow: TextOverflow.ellipsis),
                            Text('Uptime: ${s.$2}',
                                style: const TextStyle(fontSize: 11, color: _kText2)),
                          ],
                        )),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color:        _kGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('online',
                              style: TextStyle(
                                  fontSize: 10, color: _kWhite,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ]),
                    ),
                  )).toList(),
                );
              }),
            ],
          )),
          const SizedBox(height: 20),

          // AI Model Management table
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardHeader(
                icon: Icons.model_training_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
                title: 'AI Model Management', subtitle: 'Monitor and manage deployed AI models',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: _kBorder))),
                child: const Row(children: [
                  Expanded(flex: 3, child: Text('Model Name', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2))),
                  Expanded(flex: 2, child: Text('Version',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2))),
                  Expanded(flex: 3, child: Text('Type',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2))),
                  Expanded(flex: 2, child: Text('Accuracy',   style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2))),
                  Expanded(flex: 2, child: Text('Status',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _kText2))),
                ]),
              ),
              ..._models.asMap().entries.map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: e.key < _models.length - 1
                      ? Border(bottom: BorderSide(color: _kBorder)) : null,
                ),
                child: Row(children: [
                  Expanded(flex: 3, child: Text(e.value.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1))),
                  Expanded(flex: 2, child: Text(e.value.version, style: const TextStyle(fontSize: 13, color: _kText2))),
                  Expanded(flex: 3, child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(e.value.type, style: const TextStyle(fontSize: 11, color: _kText1)),
                  )),
                  Expanded(flex: 2, child: Text(e.value.accuracy, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1))),
                  Expanded(flex: 2, child: Row(children: [
                    const Icon(Icons.check_circle, color: _kGreen, size: 14),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _kGreenLight, borderRadius: BorderRadius.circular(20)),
                      child: const Text('Active', style: TextStyle(fontSize: 11, color: _kGreenDark, fontWeight: FontWeight.w600)),
                    ),
                  ])),
                ]),
              )),
            ],
          )),
          const SizedBox(height: 20),

          // General System Settings
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardHeader(
                icon: Icons.settings_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
                title: 'General System Settings', subtitle: 'Configure system-wide preferences',
              ),
              const SizedBox(height: 8),
              _toggle('Auto-backup Database',  'Automatically backup database daily',   _autoBackup,   (v) => setState(() => _autoBackup   = v)),
              _toggle('Email Notifications',   'Send system alerts via email',           _emailNotif,   (v) => setState(() => _emailNotif   = v)),
              _toggle('API Rate Limiting',      'Limit API requests per user',            _rateLimit,    (v) => setState(() => _rateLimit    = v)),
              _toggle('Maintenance Mode',       'Enable system maintenance mode',         _maintenance,  (v) => setState(() => _maintenance  = v)),
              _toggle('Debug Logging',          'Enable detailed system logs',            _debugLogging, (v) => setState(() => _debugLogging = v), last: true),
            ],
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _toggle(String label, String desc, bool value, ValueChanged<bool> onChanged, {bool last = false}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1)),
            Text(desc,  style: const TextStyle(fontSize: 12, color: _kText3)),
          ])),
          Switch(value: value, onChanged: onChanged, activeColor: _kGreen),
        ]),
      ),
      if (!last) Divider(color: _kBorder, height: 1),
    ]);
  }
}

// ── 4d. System Reports page ───────────────────────────────────────────────────

class _SystemReportsPage extends StatefulWidget {
  const _SystemReportsPage();
  @override
  State<_SystemReportsPage> createState() => _SystemReportsPageState();
}

class _SystemReportsPageState extends State<_SystemReportsPage> {
  String _period = 'Last 30 Days';
  static const _periods = ['Today', 'Last 7 Days', 'Last 30 Days', 'Last 3 Months', 'This Year'];

  static const List<_ReportFile> _files = [
    _ReportFile(name: 'Monthly Usage Report',    date: 'Jun 1, 2024',  tag: 'Usage',       size: '2.4 MB'),
    _ReportFile(name: 'User Activity Analysis',  date: 'Jun 1, 2024',  tag: 'Users',       size: '1.8 MB'),
    _ReportFile(name: 'AI Model Performance',    date: 'May 25, 2024', tag: 'Performance', size: '3.2 MB'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeading(
            title:    'System Reports',
            subtitle: 'Comprehensive analytics and reporting for the Smart Farm AI platform',
          ),
          const SizedBox(height: 20),

          // Filters
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(children: [
                Icon(Icons.filter_list, color: _kGreen, size: 18),
                SizedBox(width: 8),
                Text('Report Filters', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kText1)),
              ]),
              const SizedBox(height: 4),
              const Text('Date Range', style: TextStyle(fontSize: 12, color: _kText2)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value:      _period,
                    isExpanded: true,
                    icon:       const Icon(Icons.keyboard_arrow_down, color: _kText2),
                    style:      const TextStyle(fontSize: 14, color: _kText1),
                    items:      _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged:  (v) => setState(() => _period = v!),
                  ),
                ),
              ),
            ],
          )),
          const SizedBox(height: 16),

          // KPI row
          LayoutBuilder(builder: (_, c) {
            const kpis = [
              ('Total Analyses', '8,456',  '+23% from last month', Icons.show_chart,      _kGreen,  _kGreenLight),
              ('Active Users',   '1,247',  '+12% from last month', Icons.people_outline,  _kBlue,   _kBlueLight),
              ('AI Services',    '6 Active','99.8% uptime',        Icons.settings_outlined,_kGreen, _kGreenLight),
              ('Avg Response',   '145ms',  '-8% from last month',  Icons.speed_outlined,  _kOrange, _kOrangeLight),
            ];
            final cols = c.maxWidth > 700 ? 4 : 2;
            final gap  = 14.0;
            final w    = (c.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap, runSpacing: gap,
              children: kpis.map((k) => SizedBox(
                width: w,
                child: _Card(padding: const EdgeInsets.all(16), child: Row(children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(color: k.$6, borderRadius: BorderRadius.circular(12)),
                    child: Icon(k.$4, color: k.$5, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(k.$1, style: const TextStyle(fontSize: 12, color: _kText2)),
                    Text(k.$2, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _kText1)),
                    Text(k.$3, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                        color: k.$3.startsWith('-') ? _kRed : _kGreen)),
                  ])),
                ])),
              )).toList(),
            );
          }),
          const SizedBox(height: 16),

          // Usage by Service + User Growth
          LayoutBuilder(builder: (_, c) {
            if (c.maxWidth > 700) {
              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _buildServiceBarCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildUserGrowthCard()),
              ]);
            }
            return Column(children: [
              _buildServiceBarCard(),
              const SizedBox(height: 16),
              _buildUserGrowthCard(),
            ]);
          }),
          const SizedBox(height: 16),

          // Daily Activity
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardHeader(
                icon: Icons.trending_up_rounded, iconFg: _kGreen, iconBg: _kGreenLight,
                title: 'Daily Activity', subtitle: 'Platform activity over the past week',
              ),
              const SizedBox(height: 20),
              const _LineChart(
                values:  [240, 260, 255, 310, 290, 265, 175],
                xLabels: ['Jun 1','Jun 2','Jun 3','Jun 4','Jun 5','Jun 6','Jun 7'],
                height:  140,
              ),
            ],
          )),
          const SizedBox(height: 16),

          // Generated Reports
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _CardHeader(
                    icon: Icons.description_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
                    title: 'Generated Reports', subtitle: 'Download historical reports',
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kGreen, foregroundColor: _kWhite,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    child: const Text('Generate New Report'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._files.map(_buildReportFileCard),
            ],
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildServiceBarCard() => _Card(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _CardHeader(
        icon: Icons.bar_chart_outlined, iconFg: _kGreen, iconBg: _kGreenLight,
        title: 'Usage by Service', subtitle: 'Total analyses per service',
      ),
      const SizedBox(height: 20),
      const _BarChart(
        data: [('Plant\nDisease', 360), ('Animal\nWeight', 240), ('Soil\nAnalysis', 200), ('Chatbot', 270)],
        height: 130,
      ),
    ],
  ));

  Widget _buildUserGrowthCard() => _Card(child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _CardHeader(
        icon: Icons.people_outline, iconFg: _kBlue, iconBg: _kBlueLight,
        title: 'User Growth', subtitle: 'New user registrations',
      ),
      const SizedBox(height: 20),
      const _LineChart(
        values:  [150, 190, 250, 300, 370, 450],
        xLabels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        height:  130,
      ),
    ],
  ));

  Color _tagColor(String tag) {
    switch (tag) {
      case 'Usage':       return _kGreen;
      case 'Users':       return _kBlue;
      case 'Performance': return _kPurple;
      default:            return _kOrange;
    }
  }

  Widget _buildReportFileCard(_ReportFile r) {
    final tc = _tagColor(r.tag);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color:        _kWhite,
        borderRadius: BorderRadius.circular(12),
        border:       Border.all(color: _kBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: _kGreenLight, borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.insert_drive_file_outlined, color: _kGreen, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kText1)),
              const SizedBox(height: 4),
              Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today_outlined, size: 11, color: _kText3),
                  const SizedBox(width: 4),
                  Text(r.date, style: const TextStyle(fontSize: 11, color: _kText2)),
                ]),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tc.withOpacity(0.12), borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(r.tag, style: TextStyle(fontSize: 11, color: tc, fontWeight: FontWeight.w600)),
                ),
                Text(r.size, style: const TextStyle(fontSize: 11, color: _kText3)),
              ]),
            ])),
          ]),
        ),
        const Divider(height: 1, thickness: 1, color: _kBorder),
        InkWell(
          onTap: () {},
          child: Container(
            width:   double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: const BoxDecoration(color: Color(0xFFF9FAFB)),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.download_outlined, size: 15, color: _kText2),
              SizedBox(width: 6),
              Text('Download', style: TextStyle(fontSize: 13, color: _kText2, fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── 4e. Settings page ─────────────────────────────────────────────────────────

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();
  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  bool _darkMode  = false;
  bool _notif     = true;
  bool _analytics = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeading(
            title:    'Settings',
            subtitle: 'Configure admin preferences and platform defaults',
          ),
          const SizedBox(height: 20),
          _Card(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Appearance & Preferences',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kText1)),
              const SizedBox(height: 12),
              _row('Dark Mode',          'Switch between light and dark themes',      _darkMode,  (v) => setState(() => _darkMode  = v)),
              _row('Push Notifications', 'Receive alerts and system notifications',   _notif,     (v) => setState(() => _notif     = v)),
              _row('Usage Analytics',    'Share anonymous data to improve platform',  _analytics, (v) => setState(() => _analytics = v), last: true),
            ],
          )),
        ],
      ),
    );
  }

  Widget _row(String label, String desc, bool value, ValueChanged<bool> onChanged, {bool last = false}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kText1)),
            Text(desc,  style: const TextStyle(fontSize: 12, color: _kText3)),
          ])),
          Switch(value: value, onChanged: onChanged, activeColor: _kGreen),
        ]),
      ),
      if (!last) Divider(color: _kBorder, height: 1),
    ]);
  }
}

// ── 5. Shell ──────────────────────────────────────────────────────────────────

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_outlined,              label: 'Admin Dashboard'),
    _NavItem(icon: Icons.people_outline,                  label: 'User Management'),
    _NavItem(icon: Icons.settings_applications_outlined,  label: 'System Management'),
    _NavItem(icon: Icons.bar_chart_outlined,              label: 'System Reports'),
    _NavItem(icon: Icons.tune_outlined,                   label: 'Settings'),
  ];

  String get _pageTitle => _navItems[_selectedIndex].label;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    return Scaffold(
      backgroundColor: _kBg,
      drawer: wide ? null : _buildDrawer(),
      body: Column(
        children: [
          _buildTopBar(wide),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wide) _buildSidebar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar — fully responsive, no overflow on any screen width ──────────────
  //
  //  LAYOUT STRATEGY
  //  ─────────────────────────────────────────────────────────────────────────
  //  Wide (≥700px):
  //    [←back] [logo 36] [Flexible: "Smart Farm AI"] [Spacer] [Flexible: title]
  //    [Spacer] [bell] [dark] [avatar] [Flexible: "Admin User\nAdmin"]
  //
  //  Narrow (<700px):
  //    [☰ menu] [Spacer] [Flexible: title — centred] [Spacer] [bell] [dark] [avatar]
  //    → Logo text + user-name text hidden to reclaim ~160px
  //
  //  All Text nodes that could grow unboundedly are wrapped in Flexible so they
  //  shrink before the Row ever overflows.
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildTopBar(bool wide) {
    // ── Right-side actions (shared between wide/narrow) ───────────────────────
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notification bell
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              padding:   EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon:      const Icon(Icons.notifications_outlined,
                  color: _kWhite, size: 22),
              onPressed: () {},
            ),
            Positioned(
              right: 4, top: 4,
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                    color: _kRed, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
        // Dark-mode toggle
        IconButton(
          padding:     EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon:        const Icon(Icons.dark_mode_outlined,
              color: _kWhite, size: 22),
          onPressed:   () {},
        ),
        const SizedBox(width: 6),
        // Avatar circle
        Container(
          width: 34, height: 34,
          decoration: const BoxDecoration(color: _kGreen, shape: BoxShape.circle),
          child: const Center(
            child: Text('A',
                style: TextStyle(color: _kWhite,
                    fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ),
      ],
    );

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color:     _kDark,
        boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.25), blurRadius: 4)],
      ),
      padding: EdgeInsets.only(left: wide ? 14 : 4, right: 12),
      child: wide
      // ── WIDE layout ───────────────────────────────────────────────────
          ? Row(
        children: [
          // Back arrow
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 18, color: _kWhite),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          // Logo + app name (shrinks if needed)
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: _kGreen,
                borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.eco, color: _kWhite, size: 20),
          ),
          const SizedBox(width: 8),
          Flexible(
            fit:   FlexFit.loose,
            child: Text(
              'Smart Farm AI',
              style: const TextStyle(color: _kWhite,
                  fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          // Centred page title
          const Spacer(),
          Flexible(
            fit:   FlexFit.loose,
            child: Text(
              _pageTitle,
              style: const TextStyle(color: _kWhite,
                  fontSize: 16, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const Spacer(),
          // Right actions + user name
          actions,
          const SizedBox(width: 10),
          Flexible(
            fit:   FlexFit.loose,
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Admin User',
                    style: TextStyle(color: _kWhite,
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Text('Admin',
                    style: TextStyle(color: _kText3, fontSize: 11)),
              ],
            ),
          ),
        ],
      )
      // ── NARROW layout — logo text + user-name text hidden ─────────────
          : Row(
        children: [
          // Hamburger
          Builder(
            builder: (ctx) => IconButton(
              padding:     EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon:        const Icon(Icons.menu, color: _kWhite),
              onPressed:   () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          const SizedBox(width: 6),
          // Centred page title fills all free space
          Expanded(
            child: Text(
              _pageTitle,
              style: const TextStyle(color: _kWhite,
                  fontSize: 15, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 6),
          // Right actions (no user-name text on narrow)
          actions,
        ],
      ),
    );
  }

  // ── Sidebar ──────────────────────────────────────────────────────────────────

  Widget _buildSidebar() {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color:  _kWhite,
        border: Border(right: BorderSide(color: _kBorder)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        children: List.generate(_navItems.length, (i) {
          final item = _navItems[i];
          final isSelected = _selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () => setState(() => _selectedIndex = i),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _kGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  Icon(item.icon,  size: 18, color: isSelected ? _kWhite : _kText2),
                  const SizedBox(width: 10),
                  Text(item.label, style: TextStyle(fontSize: 13, color: isSelected ? _kWhite : _kText1)),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDrawer() => Drawer(
    backgroundColor: _kWhite,
    child: _buildSidebar(),
  );

  // ── Content router ───────────────────────────────────────────────────────────

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1: return const _UserManagementPage();
      case 2: return const _SystemManagementPage();
      case 3: return const _SystemReportsPage();
      case 4: return const _SettingsPage();
      default: return const _DashboardPage();
    }
  }
}