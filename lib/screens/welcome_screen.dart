import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';
import 'login_screen.dart';

class SmartFarmDashboard extends StatefulWidget {
  const SmartFarmDashboard({super.key});

  @override
  State<SmartFarmDashboard> createState() => _SmartFarmDashboardState();
}

class _SmartFarmDashboardState extends State<SmartFarmDashboard> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_outlined, label: 'Welcome'),
    _NavItem(icon: Icons.local_florist_outlined, label: 'Plant Disease Detection'),
    _NavItem(icon: Icons.monitor_weight_outlined, label: 'Animal Weight Estimation'),
    _NavItem(icon: Icons.grass_outlined, label: 'Crop Recommendation'),
    _NavItem(icon: Icons.layers_outlined, label: 'Soil Type Analysis'),
    _NavItem(icon: Icons.apple_outlined, label: 'Fruit Quality Analysis'),
    _NavItem(icon: Icons.chat_bubble_outline, label: 'Smart Farm Chatbot'),
    _NavItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  final List<_FeatureCard> _features = [
    _FeatureCard(
      icon: Icons.local_florist_outlined,
      title: 'Plant Disease Detection',
      description: 'Detect plant diseases early using AI image analysis.',
    ),
    _FeatureCard(
      icon: Icons.monitor_weight_outlined,
      title: 'Animal Weight Estimation',
      description: 'Estimate animal weight accurately without physical scales.',
    ),
    _FeatureCard(
      icon: Icons.grass_outlined,
      title: 'Crop Recommendation',
      description: 'Get the best crop suggestions based on soil and climate data.',
    ),
    _FeatureCard(
      icon: Icons.layers_outlined,
      title: 'Soil Type Analysis',
      description: 'Analyze soil fertility and type using data or images.',
    ),
    _FeatureCard(
      icon: Icons.apple_outlined,
      title: 'Fruit Quality Analysis',
      description: 'Classify fruit quality and detect defects automatically.',
    ),
    _FeatureCard(
      icon: Icons.chat_bubble_outline,
      title: 'Smart Farm Chatbot',
      description: 'Ask questions and get instant farming advice.',
    ),
  ];

  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF7),
      body: Column(
        children: [
          _buildNavBar(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar) _buildSidebar(),
                Expanded(child: _buildMain(context)),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: showSidebar ? null : _buildBottomNav(),
    );
  }

  // ─── Top Navigation Bar ───────────────────────────────────────────────────

  Widget _buildNavBar(BuildContext context) {
    // Watch so the bar re-renders if auth state changes.
    final auth = context.watch<AuthProvider>();

    return Container(
      height: 64,
      color: Colors.white,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.08), width: 1.33),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Logo + App Name
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Smart Farm AI',
                style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
              ),
            ],
          ),

          // Center title
          const Expanded(
            child: Center(
              child: Text(
                'Welcome',
                style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
              ),
            ),
          ),

          // Right actions
          Row(
            children: [
              // Notification bell
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFB2C36),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),

              // Theme toggle
              Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.wb_sunny_outlined,
                  size: 20,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 4),

              // User avatar + name (live from AuthProvider)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          auth.displayName.isNotEmpty
                              ? auth.displayName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.displayName,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF1F2937)),
                        ),
                        Text(
                          auth.displayRole.toLowerCase(),
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Logout
              TextButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout,
                    size: 16, color: Color(0xFF6B7280)),
                label: const Text('Logout',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Left Sidebar ─────────────────────────────────────────────────────────

  Widget _buildSidebar() {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.black.withOpacity(0.08), width: 1.33),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(_navItems.length, (i) {
          final item = _navItems[i];
          final isSelected = _selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () => setState(() => _selectedIndex = i),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? Colors.white : const Color(0xFF1F2937),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: item.label.length > 20 ? 13 : 14,
                          color: isSelected ? Colors.white : const Color(0xFF1F2937),
                          letterSpacing: item.label.length > 20 ? -0.325 : 0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Main Content ─────────────────────────────────────────────────────────

  Widget _buildMain(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth > 600 ? screenWidth - 256 : screenWidth;
    final crossAxisCount = availableWidth > 900 ? 3 : availableWidth > 600 ? 2 : 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${auth.displayName}',
            style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
          ),
          const SizedBox(height: 7),
          const Text(
            'Use AI to improve your farming decisions',
            style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 32),
          _buildFeatureGrid(crossAxisCount),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(int crossAxisCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - (crossAxisCount - 1) * 24) / crossAxisCount;
        const cardHeight = 192.0;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: _features.map((feature) {
            return SizedBox(
              width: cardWidth,
              height: cardHeight,
              child: _buildFeatureCard(feature),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFeatureCard(_FeatureCard feature) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(feature.icon, color: const Color(0xFF4CAF50), size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            feature.title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              feature.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.625,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Bottom Nav (mobile) ──────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex < 4 ? _selectedIndex : 0,
      onTap: (i) => setState(() => _selectedIndex = i),
      selectedItemColor: const Color(0xFF4CAF50),
      unselectedItemColor: const Color(0xFF6B7280),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined), label: 'Plant'),
        BottomNavigationBarItem(
            icon: Icon(Icons.monitor_weight_outlined), label: 'Animal'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
      ],
    );
  }
}

// ─── Data Classes ─────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _FeatureCard {
  final IconData icon;
  final String title;
  final String description;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });
}
