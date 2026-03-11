import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'dashboard_constants.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// NOTIFICATION DIALOG
// Modal dialog that renders the notification list.
// Call via: showDialog(context: ctx, builder: (_) => const NotificationDialog())
// ═══════════════════════════════════════════════════════════════════════════════

/// A floating dialog that displays the user's latest farm notifications.
///
/// The list is driven by [kNotifItems] from [dashboard_constants.dart].
/// Constrained to [maxWidth: 420] so it looks great on all screen sizes.
class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ────────────────────────────────────────────────
            _NotifHeader(count: kNotifItems.length),

            // ── Scrollable list ───────────────────────────────────────
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: kNotifItems.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.cardBorder),
                itemBuilder: (_, i) => _NotifTile(notif: kNotifItems[i]),
              ),
            ),

            // ── Footer ────────────────────────────────────────────────
            _NotifFooter(onMarkAllRead: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}

// ─── _NotifHeader ─────────────────────────────────────────────────────────────

class _NotifHeader extends StatelessWidget {
  final int count;
  const _NotifHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          // Bell icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            ),
            child: const Icon(Icons.notifications_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 10),

          // Title
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),

          const Spacer(),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.notifRed,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Close
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded,
                size: 20, color: AppColors.textSubtle),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

// ─── _NotifTile ───────────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final NotifItem notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: notif.color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        ),
        child: Icon(notif.icon, color: notif.color, size: 20),
      ),
      title: Text(
        notif.title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            notif.subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.textSubtle),
          ),
          const SizedBox(height: 4),
          Text(
            notif.time,
            style: TextStyle(
                fontSize: 11,
                color: AppColors.textSubtle.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

// ─── _NotifFooter ─────────────────────────────────────────────────────────────

class _NotifFooter extends StatelessWidget {
  final VoidCallback onMarkAllRead;
  const _NotifFooter({required this.onMarkAllRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: TextButton(
        onPressed: onMarkAllRead,
        child: const Text(
          'Mark all as read',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
