import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

class AdminTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final bool showBurger;
  final VoidCallback onNotificationTap;

  const AdminTopBar({
    super.key,
    required this.pageTitle,
    this.showBurger = true,
    required this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.cardBorder,
            width: 1.3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [

          /// Burger Menu
          if (showBurger)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(
                  Icons.menu_rounded,
                  color: AppColors.textDark,
                  size: 22,
                ),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),

          /// Spacer left
          const SizedBox(width: 10),

          /// Page Title (CENTER)
          Expanded(
            child: Center(
              child: Text(
                pageTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),

          /// Actions
          _NotifBell(onTap: onNotificationTap),

          const SizedBox(width: 6),

          const _AdminAvatar(),
        ],
      ),
    );
  }
}

class _NotifBell extends StatelessWidget {
  final VoidCallback onTap;

  const _NotifBell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.textDark,
            size: 22,
          ),
          onPressed: onTap,
        ),
        Positioned(
          right: 6,
          top: 6,
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
    );
  }
}

class _AdminAvatar extends StatelessWidget {
  const _AdminAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          "A",
          style: TextStyle(
            color: AppColors.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}