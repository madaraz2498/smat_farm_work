import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'login_screen.dart';
import 'user_management_page.dart';
import 'global_settings_page.dart';

// ─── Page index constants ─────────────────────────────────────────────────────

class _Pages {
  static const int dashboard = 0;
  static const int userManagement = 1;
  static const int globalSettings = 2;
}

// ─── Admin Dashboard Page ─────────────────────────────────────────────────────

/// The top-level shell for admin users.
/// Renders a persistent sidebar (desktop) or drawer (mobile) that includes
/// admin-only navigation items. Regular users can never reach this widget
/// because [LoginScreen] only routes here when [AuthProvider.isAdmin] is true.
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedPage = _Pages.dashboard;

  // ── Nav item definitions ──────────────────────────────────────────────────

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_outlined, label: 'Dashboard', page: _Pages.dashboard),
    _NavItem(icon: Icons.people_outline, label: 'User Management', page: _Pages.userManagement, isAdminOnly: true),
    _NavItem(icon: Icons.tune_outlined, label: 'Global Settings', page: _Pages.globalSettings, isAdminOnly: true),
  ];

  // ── Routing ───────────────────────────────────────────────────────────────

  Widget _buildPage() {
    switch (_selectedPage) {
      case _Pages.userManagement:
        return const UserManagementPage();
      case _Pages.globalSettings:
        return const GlobalSettingsPage();
      case _Pages.dashboard:
      default:
        return const _AdminDashboardContent();
    }
  }

  // ── Scaffold ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // ── Security guard ────────────────────────────────────────────────────
    // This should never be hit in normal flow (login already checks isAdmin),
    // but acts as a safety net if someone navigates here programmatically.
    if (!auth.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      drawer: showSidebar ? null : _buildDrawer(auth),
      body: Column(
        children: [
          _buildTopBar(context, auth, showSidebar),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar) _buildSidebar(auth),
                Expanded(child: _buildPage()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, AuthProvider auth, bool showSidebar) {
    return Container(
      height: 64,
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.08))),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 3,
              offset: const Offset(0, 1))
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Hamburger on mobile
          if (!showSidebar)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: Color(0xFF6B7280)),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),

          // Logo
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          const Text('Smart Farm AI',
              style: TextStyle(fontSize: 15, color: Color(0xFF1F2937))),
          const SizedBox(width: 8),
          // Admin badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Admin',
                style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFE65100),
                    fontWeight: FontWeight.w600)),
          ),

          const Spacer(),

          // Notifications
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                size: 22, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),

          // User chip + logout
          const SizedBox(width: 8),
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                    color: Color(0xFFE65100), shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    auth.displayName.isNotEmpty
                        ? auth.displayName[0].toUpperCase()
                        : 'A',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(auth.displayName,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF1F2937))),
                  const Text('Administrator',
                      style:
                          TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Logout button
          TextButton.icon(
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            icon: const Icon(Icons.logout,
                size: 16, color: Color(0xFF6B7280)),
            label: const Text('Logout',
                style:
                    TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          ),
        ],
      ),
    );
  }

  // ── Sidebar (desktop) ─────────────────────────────────────────────────────

  Widget _buildSidebar(AuthProvider auth) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            right: BorderSide(color: Colors.black.withOpacity(0.08))),
      ),
      child: _buildNavList(),
    );
  }

  // ── Drawer (mobile) ───────────────────────────────────────────────────────

  Widget _buildDrawer(AuthProvider auth) {
    return Drawer(
      backgroundColor: Colors.white,
      child: _buildNavList(),
    );
  }

  Widget _buildNavList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section label
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text('ADMIN PANEL',
              style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2)),
        ),
        ..._navItems.map((item) {
          final isSelected = _selectedPage == item.page;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () {
                setState(() => _selectedPage = item.page);
                // Close drawer on mobile if open
                if (Navigator.canPop(context) &&
                    MediaQuery.of(context).size.width <= 700) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(item.icon,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF6B7280)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Admin-only badge
                    if (item.isAdminOnly)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.25)
                              : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Admin',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFFE65100))),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 16),
        Divider(color: Colors.black.withOpacity(0.07)),
        const SizedBox(height: 8),

        // Back to main app
        InkWell(
          onTap: () {
            // Regular users see the regular dashboard — admin goes back too
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_outlined,
                    size: 18, color: Color(0xFF9CA3AF)),
                SizedBox(width: 10),
                Text('Sign out',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── _AdminDashboardContent ───────────────────────────────────────────────────
// The actual dashboard stats/widgets shown on page index 0.

class _AdminDashboardContent extends StatelessWidget {
  const _AdminDashboardContent();

  // Mock data — replace with real API data later.
  static const _totalUsers = 1284;
  static const _totalReports = 8920;

  static const List<_MockStatCard> _stats = [
    _MockStatCard(
      label: 'Total Users',
      value: '$_totalUsers',
      icon: Icons.people_outline,
      color: Color(0xFF4CAF50),
      bg: Color(0xFFE8F5E9),
      trend: '+12% this month',
      trendUp: true,
    ),
    _MockStatCard(
      label: 'Total Reports Generated',
      value: '$_totalReports',
      icon: Icons.bar_chart_outlined,
      color: Color(0xFF2196F3),
      bg: Color(0xFFE3F2FD),
      trend: '+23% vs yesterday',
      trendUp: true,
    ),
    _MockStatCard(
      label: 'Active Sessions',
      value: '342',
      icon: Icons.online_prediction,
      color: Color(0xFF9C27B0),
      bg: Color(0xFFF3E5F5),
      trend: '+5% today',
      trendUp: true,
    ),
    _MockStatCard(
      label: 'System Alerts',
      value: '3',
      icon: Icons.warning_amber_outlined,
      color: Color(0xFFFF9800),
      bg: Color(0xFFFFF3E0),
      trend: '-2 from yesterday',
      trendUp: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Greeting ────────────────────────────────────────────────────
          Text('Welcome back, ${auth.displayName}',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          const Text('Here\'s an overview of the platform right now.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 28),

          // ── Stat cards ───────────────────────────────────────────────────
          LayoutBuilder(builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 800
                ? 4
                : constraints.maxWidth > 500
                    ? 2
                    : 1;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _stats.map((s) {
                final w =
                    (constraints.maxWidth - (cols - 1) * 16) / cols;
                return SizedBox(width: w, child: _StatCard(stat: s));
              }).toList(),
            );
          }),

          const SizedBox(height: 28),

          // ── System status ────────────────────────────────────────────────
          _buildSystemStatusCard(),

          const SizedBox(height: 28),

          // ── AI model usage ───────────────────────────────────────────────
          _buildAiUsageCard(),
        ],
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return _SectionCard(
      title: 'System Status',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: const [
          _StatusChip(label: 'API Server', online: true),
          _StatusChip(label: 'Database', online: true),
          _StatusChip(label: 'Plant AI Model', online: true),
          _StatusChip(label: 'Animal AI Model', online: true),
          _StatusChip(label: 'Chatbot NLP', online: true),
          _StatusChip(label: 'Crop ML Model', online: false),
        ],
      ),
    );
  }

  Widget _buildAiUsageCard() {
    const models = [
      _BarData('Plant Disease', 0.72, Color(0xFF4CAF50)),
      _BarData('Animal Weight', 0.55, Color(0xFF2196F3)),
      _BarData('Crop Recommend', 0.43, Color(0xFF9C27B0)),
      _BarData('Soil Analysis', 0.38, Color(0xFFFF9800)),
      _BarData('Fruit Quality', 0.29, Color(0xFFF44336)),
      _BarData('Chatbot', 0.61, Color(0xFF00BCD4)),
    ];

    return _SectionCard(
      title: 'AI Model Usage Today',
      child: Column(
        children: models
            .map((m) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(m.label,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF374151))),
                          Text('${(m.value * 100).toInt()}%',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: m.color)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: m.value,
                          backgroundColor: Colors.grey.shade100,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(m.color),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ─── Reusable sub-widgets ─────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final _MockStatCard stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(stat.label,
                    style: const TextStyle(
                        fontSize: 13, color: Color(0xFF6B7280))),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: stat.bg,
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(stat.icon, size: 18, color: stat.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(stat.value,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                stat.trendUp
                    ? Icons.trending_up
                    : Icons.trending_down,
                size: 14,
                color: stat.trendUp
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Text(stat.trend,
                  style: TextStyle(
                      fontSize: 12,
                      color: stat.trendUp
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFEF4444))),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937))),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool online;
  const _StatusChip({required this.label, required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: online
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: online
                ? const Color(0xFF4CAF50).withOpacity(0.3)
                : const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: online
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: online
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE65100))),
        ],
      ),
    );
  }
}

// ─── Pure data classes ────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  final int page;
  final bool isAdminOnly;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.page,
    this.isAdminOnly = false,
  });
}

class _MockStatCard {
  final String label, value, trend;
  final IconData icon;
  final Color color, bg;
  final bool trendUp;
  const _MockStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bg,
    required this.trend,
    required this.trendUp,
  });
}

class _BarData {
  final String label;
  final double value;
  final Color color;
  const _BarData(this.label, this.value, this.color);
}
