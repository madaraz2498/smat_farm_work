import 'package:flutter/material.dart';

/// Typed model for a sidebar / bottom-nav navigation item.
/// Replaces the private `_NavItem` data class in the original welcome_screen.
class NavItemModel {
  const NavItemModel({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}
