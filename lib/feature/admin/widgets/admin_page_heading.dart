import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Large page heading (title + subtitle) reused on every Admin sub-page.
class AdminPageHeading extends StatelessWidget {
  final String title, subtitle;

  const AdminPageHeading({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize:   22,
            fontWeight: FontWeight.bold,
            color:      AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 14, color: AppColors.textSubtle),
        ),
      ],
    );
  }
}