import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/ai-models/animal_weight_screen.dart';
import 'package:smart_farm/feature/ai-models/crop_recommendation_screen.dart';
import 'package:smart_farm/feature/ai-models/fruit_quality_screen.dart';
import 'package:smart_farm/feature/ai-models/plant_disease_screen.dart';
import 'package:smart_farm/feature/ai-models/soil_analysis_screen.dart';
import 'package:smart_farm/feature/ai-models/chatbot_screen.dart';
import 'package:smart_farm/feature/farmer/settings/settings_screen.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import '../../../widgets/custom_app_bar.dart';
import '../reports/reports_screen.dart';
import 'components/dashboard_constants.dart';
import 'components/dashboard_main_content.dart';
import 'components/dashboard_sidebar.dart';
import 'components/notification_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0; // 0 = dashboard home

  static const double _sidebarBreakpoint = 700;

  // ── Body routing (Switches content based on Sidebar selection) ───────────
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return DashboardMainContent(
          features: kFeatureItems,
          onFeatureTap: (featureIndex) => _navigateTo(featureIndex + 1),
        );
      case 1: return const PlantDiseaseScreen();
      case 2: return const AnimalWeightScreen();
      case 3: return const CropRecommendationScreen();
      case 4: return const SoilAnalysisScreen();
      case 5: return const FruitQualityScreen();
      case 6: return const ChatbotScreen();
      case 7: return const ReportsScreen();
      case 8: return const SettingsScreen();
      default:
        return DashboardMainContent(
          features: kFeatureItems,
          onFeatureTap: (i) => _navigateTo(i + 1),
        );
    }
  }

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const NotificationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > _sidebarBreakpoint;
    
    // Get current nav item info for the AppBar
    final currentItem = kNavItems[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.background,

      // Mobile Drawer (SideBarDrawer)
      drawer: showSidebar
          ? null
          : SideBarDrawer(
              navItems: kNavItems,
              onNavigate: _navigateTo,
            ),

      body: Column(
        children: [
          // ── Unified Top Nav Bar ──────────────────────────────────────────
          CustomAppBar(
            isDashboard: _selectedIndex == 0,
            title: currentItem.label,
            svgPath: currentItem.svg,
            showBurger: !showSidebar,
            showBack: false, // No back needed since sidebar is persistent/accessible
            userName: user?.name ?? 'Farmer',
            userRole: user?.role ?? 'Farmer',
            onNotificationTap: () => _showNotifications(context),
          ),

          // ── Main Content Area ────────────────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Persistent Sidebar (Desktop)
                if (showSidebar)
                  DashboardSidebar(
                    navItems: kNavItems,
                    selectedIndex: _selectedIndex,
                    onNavigate: _navigateTo,
                  ),

                // Dynamic Body
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: KeyedSubtree(
                      key: ValueKey<int>(_selectedIndex),
                      child: _buildBody(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
