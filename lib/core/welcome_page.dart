import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

import '../core/app_strings.dart';
import '../models/feature_model.dart';
import '../models/nav_item_model.dart';
import '../widgets/feature_card.dart';

final List<NavItemModel> appNavItems = const [
  NavItemModel(icon: Icons.home_outlined,            label: AppStrings.navWelcome),
  NavItemModel(icon: Icons.local_florist_outlined,   label: AppStrings.navPlantDisease),
  NavItemModel(icon: Icons.monitor_weight_outlined,  label: AppStrings.navAnimalWeight),
  NavItemModel(icon: Icons.grass_outlined,           label: AppStrings.navCropRecommendation),
  NavItemModel(icon: Icons.layers_outlined,          label: AppStrings.navSoilAnalysis),
  NavItemModel(icon: Icons.apple_outlined,           label: AppStrings.navFruitQuality),
  NavItemModel(icon: Icons.chat_bubble_outline,      label: AppStrings.navChatbot),
  NavItemModel(icon: Icons.bar_chart_outlined,       label: AppStrings.navReports),
  NavItemModel(icon: Icons.settings_outlined,        label: AppStrings.navSettings),
];

final List<FeatureModel> dashboardFeatures = const [
  FeatureModel(
    icon: Icons.local_florist_outlined,
    title: AppStrings.featurePlantTitle,
    description: AppStrings.featurePlantDesc,
  ),
  FeatureModel(
    icon: Icons.monitor_weight_outlined,
    title: AppStrings.featureAnimalTitle,
    description: AppStrings.featureAnimalDesc,
  ),
  FeatureModel(
    icon: Icons.grass_outlined,
    title: AppStrings.featureCropTitle,
    description: AppStrings.featureCropDesc,
  ),
  FeatureModel(
    icon: Icons.layers_outlined,
    title: AppStrings.featureSoilTitle,
    description: AppStrings.featureSoilDesc,
  ),
  FeatureModel(
    icon: Icons.apple_outlined,
    title: AppStrings.featureFruitTitle,
    description: AppStrings.featureFruitDesc,
  ),
  FeatureModel(
    icon: Icons.chat_bubble_outline,
    title: AppStrings.featureChatTitle,
    description: AppStrings.featureChatDesc,
  ),
];

class SmartFarmDashboard extends StatefulWidget {
  const SmartFarmDashboard({super.key});

  @override
  State<SmartFarmDashboard> createState() => _SmartFarmDashboardState();
}

class _SmartFarmDashboardState extends State<SmartFarmDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebar = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _AppNavBar(userName: AppStrings.defaultUserName, userRole: AppStrings.defaultUserRole),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showSidebar)
                  _AppSidebar(
                    navItems: appNavItems,
                    selectedIndex: _selectedIndex,
                    onSelect: (i) => setState(() => _selectedIndex = i),
                  ),
                Expanded(
                  child: _selectedIndex == 0
                      ? const WelcomeBody()
                      : _PlaceholderBody(title: appNavItems[_selectedIndex].label),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: showSidebar ? null : _AppBottomNav(
        selectedIndex: _selectedIndex < 4 ? _selectedIndex : 0,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

class _AppNavBar extends StatelessWidget {
  const _AppNavBar({required this.userName, required this.userRole});

  final String userName;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.33),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.cardBorder, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: AppColors.cardBorder, blurRadius: 6, offset: Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.eco, color: AppColors.surface, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 16, color: AppColors.textDark),
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                AppStrings.welcomePageTitle,
                style: TextStyle(fontSize: 16, color: AppColors.textDark),
              ),
            ),
          ),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: const Icon(Icons.notifications_outlined, size: 20, color: AppColors.textDark),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.notifRed,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.wb_sunny_outlined, size: 20, color: AppColors.textDark),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.surface, size: 16),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                        Text(userRole,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSubtle)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppSidebar extends StatelessWidget {
  const _AppSidebar({
    required this.navItems,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<NavItemModel> navItems;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.33),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: List.generate(navItems.length, (i) {
          final item = navItems[i];
          final isSelected = selectedIndex == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: InkWell(
              onTap: () => onSelect(i),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isSelected
                      ? [BoxShadow(color: AppColors.cardBorder, blurRadius: 3, offset: Offset(0, 1))]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: 20,
                      color: isSelected ? AppColors.surface : AppColors.textDark,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        item.label,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: item.label.length > 20 ? 13 : 14,
                          color: isSelected ? AppColors.surface : AppColors.textDark,
                          letterSpacing: item.label.length > 20 ? -0.325 : 0,
                        ),
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
}

class _AppBottomNav extends StatelessWidget {
  const _AppBottomNav({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: List.generate(4, (i) {
        final item = appNavItems[i];
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }),
    );
  }
}

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.welcomePageTitle,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            AppStrings.welcomeSubtitle,
            style: TextStyle(fontSize: 16, color: AppColors.textSubtle),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: 2.1,
            ),
            itemCount: dashboardFeatures.length,
            itemBuilder: (context, index) => FeatureCard(feature: dashboardFeatures[index]),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Content for $title coming soon...',
        style: const TextStyle(fontSize: 18, color: AppColors.textSubtle),
      ),
    );
  }
}