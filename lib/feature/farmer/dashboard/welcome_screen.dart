import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/ai-models/animal_weight_screen.dart';
import 'package:smart_farm/feature/ai-models/crop_recommendation_screen.dart';
import 'package:smart_farm/feature/ai-models/fruit_quality_screen.dart';
import 'package:smart_farm/feature/ai-models/plant_disease_screen.dart';
import 'package:smart_farm/feature/ai-models/soil_analysis_screen.dart';
import 'package:smart_farm/feature/ai-models/chatbot_screen.dart';
import 'package:smart_farm/feature/settings/settings_screen.dart';
import 'package:smart_farm/providers/navigation_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import '../../../widgets/custom_app_bar.dart';
import '../reports_screen.dart';
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
//
// This widget intentionally contains ZERO layout or styling code.
// All visual decisions live in the widget files under ../widgets/.
// ═══════════════════════════════════════════════════════════════════════════════

/// The root shell of the SmartFarmAI dashboard.
///
/// Renders a persistent [DashboardSidebar] on screens ≥ 700 px wide, or a
/// hamburger-triggered [DashboardDrawer] on narrower screens.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // ── Breakpoint ────────────────────────────────────────────────────────────

  /// Screens wider than this value show the persistent sidebar.
  static const double _sidebarBreakpoint = 700;

  // ── Navigation ────────────────────────────────────────────────────────────

  /// Returns the screen widget for the given [navIndex].
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

  /// Pushes the target screen and resets the [NavigationProvider] on return.
  void _navigateTo(BuildContext context, int index) {
    // Update the provider before pushing so the sidebar highlight is instant.
    context.read<NavigationProvider>().setIndex(index);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _screenFor(index)),
    ).then((_) {
      // Reset to home when user pops back to the dashboard.
      context.read<NavigationProvider>().reset();
    });
  }

  /// Shows the notification dialog centred over the current route.
  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const NotificationDialog(),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > _sidebarBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.background,

      // Mobile drawer — null on desktop so Scaffold ignores it.
      drawer: showSidebar
          ? null
          : DashboardDrawer(
              navItems: kNavItems,
              onNavigate: (i) => _navigateTo(context, i),
            ),

      body: Column(
        children: [
          // ── Top navigation bar ───────────────────────────────────────
          DashboardNavBar(
            showBurger: !showSidebar,
            onNotificationTap: () => _showNotifications(context),
            userName: '',
            userRole: '',
          ),

          // ── Body: sidebar + content ──────────────────────────────────
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Persistent sidebar (desktop only)
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
