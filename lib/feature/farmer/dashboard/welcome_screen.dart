// welcome_screen.dart
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
import 'package:smart_farm/providers/navigation_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';

import '../../../widgets/custom_app_bar.dart';
import '../reports/reports_screen.dart';
import 'components/dashboard_constants.dart';
import 'components/dashboard_main_content.dart';
import 'components/dashboard_sidebar.dart';
import 'components/notification_dialog.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const double _sidebarBreakpoint = 700;

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const NotificationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final nav = context.watch<NavigationProvider>();

    final selectedIndex = nav.selectedIndex;

    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > _sidebarBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,

      // Mobile Drawer
      drawer: showSidebar
          ? null
          : SideBarDrawer(
        navItems: farmerNavItems,
        onNavigate: (i) =>
            context.read<NavigationProvider>().setIndex(i),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ─────────────────────────────────────────────
            // Top Navbar
            // ─────────────────────────────────────────────
            DashboardNavBar(
              showBurger: !showSidebar,
              onNotificationTap: () => _showNotifications(context),
              userName: user?.name ?? 'Farmer',
            ),

            // ─────────────────────────────────────────────
            // Body
            // ─────────────────────────────────────────────
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showSidebar)
                    DashboardSidebar(
                      navItems: farmerNavItems,
                      selectedIndex: selectedIndex,
                      onNavigate: (i) =>
                          context.read<NavigationProvider>().setIndex(i),
                    ),

                  Expanded(
                    child: IndexedStack(
                      index: selectedIndex,
                      children: const [
                        DashboardMainContent(
                          features: kFeatureItems,
                        ),
                        PlantDiseaseScreen(),
                        AnimalWeightScreen(),
                        CropRecommendationScreen(),
                        SoilAnalysisScreen(),
                        FruitQualityScreen(),
                        ChatbotScreen(),
                        ReportsScreen(),
                        SettingsScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}