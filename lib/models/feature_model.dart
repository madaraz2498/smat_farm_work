import 'package:flutter/material.dart';

/// Typed model for a dashboard feature card.
/// Replaces the private `_FeatureCard` data class in the original welcome_screen.
class FeatureModel {
  const FeatureModel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
