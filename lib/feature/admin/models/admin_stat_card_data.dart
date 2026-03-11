import 'package:flutter/material.dart';

/// Holds display data for a single summary (KPI) card.
class AdminStatCardData {
  final IconData icon;
  final Color    iconFg, iconBg;
  final Color    badgeFg, badgeBg;
  final String   badge, title, sub;

  const AdminStatCardData({
    required this.icon,
    required this.iconFg,
    required this.iconBg,
    required this.badge,
    required this.badgeFg,
    required this.badgeBg,
    required this.title,
    required this.sub,
  });
}
