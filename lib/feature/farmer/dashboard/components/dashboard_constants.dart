import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD CONSTANTS
// Single source of truth for all static data consumed by Dashboard widgets.
// No widget should define inline data — reference this file instead.
// ═══════════════════════════════════════════════════════════════════════════════

// ─── NavItem ──────────────────────────────────────────────────────────────────

/// Represents a single sidebar / drawer navigation entry.
///
/// [svg] is optional; if null, [icon] is rendered as a fallback.
class NavItem {
  final IconData icon;
  final String label;
  final String? svg;

  const NavItem({
    required this.icon,
    required this.label,
    this.svg,
  });
}

// ─── FeatureItem ──────────────────────────────────────────────────────────────

/// Represents an AI feature card displayed on the Welcome grid.
class FeatureItem {
  final String svg;
  final String title;
  final String description;

  const FeatureItem({
    required this.svg,
    required this.title,
    required this.description,
  });
}

// ─── NotifItem ────────────────────────────────────────────────────────────────

/// Represents a single notification entry in the notification dialog.
class NotifItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const NotifItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// STATIC DATA LISTS
// ═══════════════════════════════════════════════════════════════════════════════

/// All sidebar / drawer navigation items.
const List<NavItem> kNavItems = [
  NavItem(
    icon: Icons.home_outlined,
    label: 'Welcome',
    svg: null,
  ),
  NavItem(
    icon: Icons.local_florist_outlined,
    label: 'Plant Disease Detection',
    svg: 'assets/images/icons/plant_icon.svg',
  ),
  NavItem(
    icon: Icons.monitor_weight_outlined,
    label: 'Animal Weight Estimation',
    svg: 'assets/images/icons/animal_icon.svg',
  ),
  NavItem(
    icon: Icons.grass_outlined,
    label: 'Crop Recommendation',
    svg: 'assets/images/icons/crop_icon.svg',
  ),
  NavItem(
    icon: Icons.layers_outlined,
    label: 'Soil Type Analysis',
    svg: 'assets/images/icons/soil_icon.svg',
  ),
  NavItem(
    icon: Icons.apple_outlined,
    label: 'Fruit Quality Analysis',
    svg: 'assets/images/icons/fruit_icon.svg',
  ),
  NavItem(
    icon: Icons.chat_bubble_outline,
    label: 'Smart Farm Chatbot',
    svg: 'assets/images/icons/chat_icon.svg',
  ),
  NavItem(
    icon: Icons.bar_chart_outlined,
    label: 'Reports',
    svg: null,
  ),
  NavItem(
    icon: Icons.settings_outlined,
    label: 'Settings',
    svg: null,
  ),
];

/// Feature cards shown on the dashboard welcome grid.
const List<FeatureItem> kFeatureItems = [
  FeatureItem(
    svg: 'assets/images/icons/plant_icon.svg',
    title: 'Plant Disease Detection',
    description: 'Detect plant diseases early using AI image analysis.',
  ),
  FeatureItem(
    svg: 'assets/images/icons/animal_icon.svg',
    title: 'Animal Weight Estimation',
    description: 'Estimate animal weight accurately without physical scales.',
  ),
  FeatureItem(
    svg: 'assets/images/icons/crop_icon.svg',
    title: 'Crop Recommendation',
    description: 'Get the best crop suggestions based on soil and climate data.',
  ),
  FeatureItem(
    svg: 'assets/images/icons/soil_icon.svg',
    title: 'Soil Type Analysis',
    description: 'Analyze soil fertility and type using data or images.',
  ),
  FeatureItem(
    svg: 'assets/images/icons/fruit_icon.svg',
    title: 'Fruit Quality Analysis',
    description: 'Classify fruit quality and detect defects automatically.',
  ),
  FeatureItem(
    svg: 'assets/images/icons/chat_icon.svg',
    title: 'Smart Farm Chatbot',
    description: 'Ask questions and get instant farming advice.',
  ),
];

/// Notification entries shown inside the notification dialog.
const List<NotifItem> kNotifItems = [
  NotifItem(
    icon: Icons.warning_amber_rounded,
    color: Color(0xFFF59E0B),
    title: 'Soil moisture low',
    subtitle: 'Field A moisture dropped below 30%.',
    time: '2 min ago',
  ),
  NotifItem(
    icon: Icons.local_florist_rounded,
    color: AppColors.primary,
    title: 'Disease risk detected',
    subtitle: 'Possible blight risk on tomato crops.',
    time: '1 hr ago',
  ),
  NotifItem(
    icon: Icons.monitor_weight_outlined,
    color: Color(0xFF6366F1),
    title: 'Weight report ready',
    subtitle: 'Animal batch #12 weight analysis done.',
    time: '3 hr ago',
  ),
  NotifItem(
    icon: Icons.cloud_outlined,
    color: Color(0xFF0EA5E9),
    title: 'Weather alert',
    subtitle: 'Heavy rain expected tomorrow morning.',
    time: 'Yesterday',
  ),
  NotifItem(
    icon: Icons.check_circle_outline_rounded,
    color: AppColors.primary,
    title: 'Crop recommendation ready',
    subtitle: 'Best crops for your soil type are ready.',
    time: 'Yesterday',
  ),
];
