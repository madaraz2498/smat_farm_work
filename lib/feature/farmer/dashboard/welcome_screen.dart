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

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD SCREEN  (Main Shell — Orchestrator Only)
//
// Responsibilities:
//   1. Build the Scaffold + responsive layout (sidebar vs drawer).
//   2. Delegate all UI rendering to dedicated child widgets.
//   3. Own the navigation logic (_navigateTo / _showNotifications).
// ═══════════════════════════════════════════════════════════════════════════════

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ── Breakpoint ────────────────────────────────────────────────────────────
  static const double _sidebarBreakpoint = 700;

  // ── Navigation ────────────────────────────────────────────────────────────
  static Widget _screenFor(int navIndex) {
    switch (navIndex) {
      case 1:
        return const PlantDiseaseScreen();
      case 2:
        return const AnimalWeightScreen();
      case 3:
        return const CropRecommendationScreen();
      case 4:
        return const SoilAnalysisScreen();
      case 5:
        return const FruitQualityScreen();
      case 6:
        return const ChatbotScreen();
      case 7:
        return const ReportsScreen();
      case 8:
        return const SettingsScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  void _navigateTo(BuildContext context, int index) {
    context.read<NavigationProvider>().setIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _screenFor(index)),
    ).then((_) {
      context.read<NavigationProvider>().reset();
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const NotificationDialog(),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // ✅ جلب بيانات اليوزر من AuthProvider
    final user = context.watch<AuthProvider>().currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > _sidebarBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,

      // ✅ Mobile drawer — يظهر لما يضغط على زرار الـ hamburger
      drawer: showSidebar
          ? null
          : SideBarDrawer(
        navItems: kNavItems,
        onNavigate: (i) => _navigateTo(context, i),
      ),

      body: Column(
        children: [
          // ── Top navigation bar ───────────────────────────────────────
          // ✅ DashboardNavBar بيعمل Scaffold.of(ctx).openDrawer() داخلياً
          //    لما showBurger = true، مش محتاج onBurgerTap منفصل
          DashboardNavBar(
            showBurger: !showSidebar,
            onNotificationTap: () => _showNotifications(context),
            // ✅ بيانات اليوزر الحقيقية بدل القيم الفارغة
            userName: user?.name ?? 'Farmer',
          ),

          // ── Body: sidebar + content ──────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Persistent sidebar (desktop only — شاشة > 700px)
                if (showSidebar)
                  DashboardSidebar(
                    navItems: kNavItems,
                    onNavigate: (i) => _navigateTo(context, i),
                  ),

                // Main scrollable content area
                Expanded(
                  child: DashboardMainContent(
                    features: kFeatureItems,
                    onFeatureTap: (featureIndex) {
                      // Feature cards map 1-to-1 to nav indices 1–6.
                      _navigateTo(context, featureIndex + 1);
                    },
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