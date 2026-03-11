import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

/// Icon-chip + title + subtitle row used at the top of every section card.
class AdminCardHeader extends StatelessWidget {
  final IconData icon;
  final Color    iconFg, iconBg;
  final String   title, subtitle;

  const AdminCardHeader({
    super.key,
    required this.icon,
    required this.iconFg,
    required this.iconBg,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width:  38,
          height: 38,
          decoration: BoxDecoration(
            color:        iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconFg, size: 18),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize:   14,
                fontWeight: FontWeight.w600,
                color:      AppColors.textDark,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textSubtle),
            ),
          ],
        ),
      ],
    );
  }
}