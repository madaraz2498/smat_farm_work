import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// DASHBOARD NAV BAR
// Top-level app bar for the Dashboard shell.
//
// Null-safety rule: user?.name and user?.role are accessed via null-aware
// operators. The .toLowerCase() call is guarded behind a null check so the
// app never crashes on an unauthenticated/anonymous state.
// ═══════════════════════════════════════════════════════════════════════════════

/// The top navigation bar rendered above the sidebar + content area.
///
/// Responsibilities:
/// - App branding (logo + name).
/// - Burger icon on mobile to open the [Scaffold] drawer.
/// - Notification bell with an unread-count badge.
/// - Compact user avatar + name / role display (null-safe).
class DashboardNavBar extends StatelessWidget {
  /// Whether to render the hamburger menu icon (true on narrow screens).
  final bool showBurger;

  /// Callback fired when the notification bell is tapped.
  final VoidCallback onNotificationTap;

  const DashboardNavBar({
    super.key,
    required this.showBurger,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    // ── Null-safe user fields ────────────────────────────────────────────────
    final user = context.watch<AuthProvider>().currentUser;
    final userName = user?.name ?? 'Farmer';
    // Only call .toLowerCase() when role is non-null to prevent NPE.
    final userRole =
        (user?.role != null && user!.role.isNotEmpty) ? user.role.toLowerCase() : '';

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border:
            Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1.33)),
      ),
      padding: EdgeInsets.only(
        left: showBurger ? 4.0 : AppSizes.pagePadding,
        right: AppSizes.pagePadding,
      ),
      child: Row(
        children: [
          // ── Burger (mobile only) ───────────────────────────────────────
          if (showBurger)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.textDark, size: 24),
                tooltip: 'Open menu',
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),

          if (showBurger) const SizedBox(width: 4.0),

          // ── Logo ──────────────────────────────────────────────────────
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.eco_rounded,
                color: Colors.white, size: 20),
          ),

          const SizedBox(width: 10),

          // ── App name ──────────────────────────────────────────────────
          const Text(
            'Smart Farm AI',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),

          const Spacer(),

          // ── Notification bell ─────────────────────────────────────────
          _NotificationBell(onTap: onNotificationTap),

          const SizedBox(width: 8.0),

          // ── User avatar ───────────────────────────────────────────────
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.person_rounded, color: Colors.white, size: 16),
          ),

          const SizedBox(width: 8.0),

          // ── User info (name + role) ────────────────────────────────────
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              if (userRole.isNotEmpty)
                Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSubtle,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}

// ─── _NotificationBell ────────────────────────────────────────────────────────

/// Bell icon button with a red unread-count dot overlay.
class _NotificationBell extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationBell({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              size: 22, color: AppColors.textDark),
          tooltip: 'Notifications',
          onPressed: onTap,
        ),
        Positioned(
          right: 8,
          top: 8,
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
