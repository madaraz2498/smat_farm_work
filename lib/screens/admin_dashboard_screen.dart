import 'package:flutter/material.dart';
import 'package:smart_farm/screens/system_management_screen.dart';
import 'package:smart_farm/screens/system_reports_screen.dart';
import 'package:smart_farm/screens/user_management_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<_AdminNavItem> _navItems = [
    _AdminNavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    _AdminNavItem(icon: Icons.people_outline, label: 'User Management'),
    _AdminNavItem(icon: Icons.settings_outlined, label: 'System Management'),
    _AdminNavItem(icon: Icons.bar_chart_outlined, label: 'System Reports'),
  ];

  final List<_StatCard> _stats = [
    _StatCard(
      title: 'Total Users',
      value: '1,284',
      change: '+12% this month',
      icon: Icons.people_outline,
      color: Color(0xFF4CAF50),
      bgColor: Color(0xFFE8F5E9),
      positive: true,
    ),
    _StatCard(
      title: 'Active Sessions',
      value: '342',
      change: '+5% today',
      icon: Icons.online_prediction,
      color: Color(0xFF2196F3),
      bgColor: Color(0xFFE3F2FD),
      positive: true,
    ),
    _StatCard(
      title: 'AI Requests Today',
      value: '8,920',
      change: '+23% vs yesterday',
      icon: Icons.psychology_outlined,
      color: Color(0xFF9C27B0),
      bgColor: Color(0xFFF3E5F5),
      positive: true,
    ),
    _StatCard(
      title: 'System Alerts',
      value: '3',
      change: '-2 from yesterday',
      icon: Icons.warning_amber_outlined,
      color: Color(0xFFFF9800),
      bgColor: Color(0xFFFFF3E0),
      positive: false,
    ),
  ];

  final List<_RecentActivity> _activities = [
    _RecentActivity(
      user: 'Ahmed Hassan',
      action: 'Used Plant Disease Detection',
      time: '2 min ago',
      avatar: 'AH',
      color: Color(0xFF4CAF50),
    ),
    _RecentActivity(
      user: 'Sara Mohamed',
      action: 'Ran Crop Recommendation',
      time: '15 min ago',
      avatar: 'SM',
      color: Color(0xFF2196F3),
    ),
    _RecentActivity(
      user: 'Omar Khalil',
      action: 'Uploaded animal image',
      time: '34 min ago',
      avatar: 'OK',
      color: Color(0xFF9C27B0),
    ),
    _RecentActivity(
      user: 'Nour Ali',
      action: 'Chatbot conversation',
      time: '1 hr ago',
      avatar: 'NA',
      color: Color(0xFFFF9800),
    ),
    _RecentActivity(
      user: 'Mahmoud Samy',
      action: 'Soil Type Analysis',
      time: '2 hr ago',
      avatar: 'MS',
      color: Color(0xFFF44336),
    ),
  ];

  final List<_AIUsage> _aiUsage = [
    _AIUsage(label: 'Plant Disease', value: 0.72, color: Color(0xFF4CAF50)),
    _AIUsage(label: 'Animal Weight', value: 0.55, color: Color(0xFF2196F3)),
    _AIUsage(label: 'Crop Recommend', value: 0.43, color: Color(0xFF9C27B0)),
    _AIUsage(label: 'Soil Analysis', value: 0.38, color: Color(0xFFFF9800)),
    _AIUsage(label: 'Fruit Quality', value: 0.29, color: Color(0xFFF44336)),
    _AIUsage(label: 'Chatbot', value: 0.61, color: Color(0xFF00BCD4)),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: Column(
        children: [
          _buildTopBar(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar) _buildSidebar(),
                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.08))),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 3, offset: const Offset(0, 1))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text('Smart Farm AI', style: TextStyle(fontSize: 16, color: Color(0xFF1F2937))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(8)),
            child: const Text('Admin', style: TextStyle(fontSize: 11, color: Color(0xFFE65100), fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 22, color: Color(0xFF1F2937)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Container(
                width: 34, height: 34,
                decoration: const BoxDecoration(color: Color(0xFFE65100), shape: BoxShape.circle),
                child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
              ),
              const SizedBox(width: 8),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin User', style: TextStyle(fontSize: 13, color: Color(0xFF1F2937))),
                  Text('System Administrator', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.black.withOpacity(0.08))),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text('ADMIN PANEL', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w600, letterSpacing: 1.2)),
          ),
          ...List.generate(_navItems.length, (i) {
            final item = _navItems[i];
            final isSelected = _selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () {
                  if (i == 1) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const UserManagementScreen()));
                  } else if (i == 2) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SystemManagementScreen()));
                  } else if (i == 3) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SystemReportsScreen()));
                  } else {
                    setState(() => _selectedIndex = i);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
                      const SizedBox(width: 10),
                      Text(item.label, style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : const Color(0xFF1F2937))),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Admin Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          const Text('System overview and performance metrics', style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 24),

          // Stat Cards
          LayoutBuilder(builder: (ctx, constraints) {
            final cols = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 500 ? 2 : 1;
            return _buildStatGrid(cols);
          }),

          const SizedBox(height: 24),

          // Charts row
          LayoutBuilder(builder: (ctx, constraints) {
            if (constraints.maxWidth > 700) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: _buildRecentActivity()),
                  const SizedBox(width: 20),
                  Expanded(flex: 2, child: _buildAIUsageCard()),
                ],
              );
            }
            return Column(
              children: [
                _buildRecentActivity(),
                const SizedBox(height: 20),
                _buildAIUsageCard(),
              ],
            );
          }),

          const SizedBox(height: 24),
          _buildSystemStatusCard(),
        ],
      ),
    );
  }

  Widget _buildStatGrid(int cols) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: _stats.map((stat) {
        return LayoutBuilder(builder: (ctx, constraints) {
          return SizedBox(
            width: (MediaQuery.of(ctx).size.width - (MediaQuery.of(ctx).size.width > 700 ? 230 : 0) - 48 - (cols - 1) * 16) / cols,
            child: _buildStatCard(stat),
          );
        });
      }).toList(),
    );
  }

  Widget _buildStatCard(_StatCard stat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(stat.title, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: stat.bgColor, borderRadius: BorderRadius.circular(8)),
                child: Icon(stat.icon, size: 18, color: stat.color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(stat.value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                stat.positive ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: stat.positive ? const Color(0xFF4CAF50) : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 4),
              Text(
                stat.change,
                style: TextStyle(fontSize: 12, color: stat.positive ? const Color(0xFF4CAF50) : const Color(0xFFEF4444)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Activity', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
              TextButton(onPressed: () {}, child: const Text('View all', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13))),
            ],
          ),
          const SizedBox(height: 16),
          ..._activities.map((a) => _buildActivityRow(a)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(_RecentActivity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: activity.color.withOpacity(0.15), shape: BoxShape.circle),
            child: Center(child: Text(activity.avatar, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: activity.color))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.user, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                Text(activity.action, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Text(activity.time, style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        ],
      ),
    );
  }

  Widget _buildAIUsageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('AI Model Usage', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          const Text('Today\'s requests by model', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          const SizedBox(height: 20),
          ..._aiUsage.map((item) => _buildUsageBar(item)),
        ],
      ),
    );
  }

  Widget _buildUsageBar(_AIUsage item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.label, style: const TextStyle(fontSize: 12, color: Color(0xFF374151))),
              Text('${(item.value * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.value,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(item.color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('System Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildStatusChip('API Server', true),
              _buildStatusChip('Database', true),
              _buildStatusChip('Plant AI Model', true),
              _buildStatusChip('Animal AI Model', true),
              _buildStatusChip('Chatbot NLP', true),
              _buildStatusChip('Crop ML Model', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, bool online) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: online ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: online ? const Color(0xFF4CAF50).withOpacity(0.3) : const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7, height: 7,
            decoration: BoxDecoration(
              color: online ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontSize: 12, color: online ? const Color(0xFF2E7D32) : const Color(0xFFE65100))),
        ],
      ),
    );
  }
}

// ─── Data Classes ─────────────────────────────────────────────────────────────

class _AdminNavItem {
  final IconData icon;
  final String label;
  const _AdminNavItem({required this.icon, required this.label});
}

class _StatCard {
  final String title, value, change;
  final IconData icon;
  final Color color, bgColor;
  final bool positive;
  const _StatCard({
    required this.title, required this.value, required this.change,
    required this.icon, required this.color, required this.bgColor, required this.positive,
  });
}

class _RecentActivity {
  final String user, action, time, avatar;
  final Color color;
  const _RecentActivity({required this.user, required this.action, required this.time, required this.avatar, required this.color});
}

class _AIUsage {
  final String label;
  final double value;
  final Color color;
  const _AIUsage({required this.label, required this.value, required this.color});
}

// NOTE: Import the following in your project:
// import 'user_management_screen.dart';
// import 'system_management_screen.dart';
// import 'system_reports_screen.dart';
