import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/feature/farmer/dashboard/components/feature_card.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'dashboard_constants.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD MAIN CONTENT
// The scrollable welcome area + responsive feature card grid.
// ═══════════════════════════════════════════════════════════════════════════════

class DashboardMainContent extends StatelessWidget {
  final List<FeatureItem> features;
  final void Function(int featureIndex)? onFeatureTap;

  const DashboardMainContent({
    super.key,
    required this.features,
    this.onFeatureTap,
  });

  static const double _maxCardWidth = 360.0;
  static const double _cardHeight = 192.0;
  static const double _cardGap = AppSizes.itemPadding;

  int _cols(double available) {
    if (available >= 900) return 3;
    if (available >= 500) return 2;
    return 1;
  }

  double _cardWidth(double available, int cols) {
    final gapTotal = _cardGap * (cols - 1);
    final computed = (available - gapTotal) / cols;
    return computed.clamp(0.0, _maxCardWidth);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user?.name ?? 'Farmer';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, $userName 👋',
            style: AppTextStyles.pageTitle,
          ),
          const SizedBox(height: 6),
          Text(
            'Use AI to improve your farming decisions',
            style: AppTextStyles.pageSubtitle,
          ),
          const SizedBox(height: AppSizes.pagePadding),
          LayoutBuilder(
            builder: (_, constraints) {
              final available = constraints.maxWidth;
              final cols = _cols(available);
              
              if (cols == 1) {
                return Column(
                  children: List.generate(features.length, (i) {
                    final f = features[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: _cardGap),
                      child: FeatureCard(
                        svgPath: f.svg,
                        title: f.title,
                        description: f.description,
                        onTap: onFeatureTap != null ? () => onFeatureTap!(i) : null,
                      ),
                    );
                  }),
                );
              }

              final w = _cardWidth(available, cols);
              return Wrap(
                spacing: _cardGap,
                runSpacing: _cardGap,
                children: List.generate(features.length, (i) {
                  final f = features[i];
                  return SizedBox(
                    width: w,
                    height: _cardHeight,
                    child: FeatureCard(
                      svgPath: f.svg,
                      title: f.title,
                      description: f.description,
                      fixedHeight: true,
                      onTap: onFeatureTap != null ? () => onFeatureTap!(i) : null,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
