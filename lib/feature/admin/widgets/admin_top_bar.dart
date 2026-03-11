import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminTopBar
//
// Renders the 64-px top bar for the Admin shell.
// Adapts between wide (logo + title + user info) and narrow (hamburger + title).
// All text is wrapped in Flexible to prevent overflow.
// ─────────────────────────────────────────────────────────────────────────────
class AdminTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminTopBar({
    super.key,
    required this.pageTitle,
    this.onBack,
  });

  final String    pageTitle;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.topBarHeight);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > AppSizes.wideBreak;

    return Container(
      height: AppSizes.topBarHeight,
      decoration: BoxDecoration(
        color: AppColors.topBarBg,
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.08),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.only(left: wide ? 14 : 4, right: 12),
      child: wide ? _WideBar(pageTitle: pageTitle, onBack: onBack)
                  : _NarrowBar(pageTitle: pageTitle),
    );
  }
}

// ── Wide layout ───────────────────────────────────────────────────────────────

class _WideBar extends StatelessWidget {
  const _WideBar({required this.pageTitle, this.onBack});
  final String        pageTitle;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Back
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textDark),
          onPressed: onBack ?? () => Navigator.maybePop(context),
        ),
        const SizedBox(width: 4),

        // Logo circle
        Container(
          width:  36, height: 36,
          decoration: BoxDecoration(
            color:        AppColors.primary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.eco, color: AppColors.surface, size: 20),
        ),
        const SizedBox(width: 8),

        // App name
        Flexible(
          fit:   FlexFit.loose,
          child: Text(
            'Smart Farm AI',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textDark, fontSize: 14, fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const Spacer(),

        // Page title (centred)
        Flexible(
          fit:   FlexFit.loose,
          child: Text(
            pageTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textDark, fontSize: 16, fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const Spacer(),

        // Actions
        const _TopBarActions(),
        const SizedBox(width: 10),

        // User info
        Flexible(
          fit:   FlexFit.loose,
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Admin User',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: AppColors.textDark, fontSize: 13, fontWeight: FontWeight.w500,
                ),
              ),
              Text('Admin',
                style: TextStyle(color: AppColors.textDisabled, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Narrow layout ─────────────────────────────────────────────────────────────

class _NarrowBar extends StatelessWidget {
  const _NarrowBar({required this.pageTitle});
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Hamburger — must use Builder so Scaffold.of finds the correct context
        Builder(
          builder: (ctx) => IconButton(
            padding:     EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon:        const Icon(Icons.menu, color: AppColors.textDark),
            onPressed:   () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        const SizedBox(width: 6),

        // Page title
        Expanded(
          child: Text(
            pageTitle,
            overflow:  TextOverflow.ellipsis,
            maxLines:  1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textDark, fontSize: 15, fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 6),

        const _TopBarActions(),
      ],
    );
  }
}

// ── Shared action buttons ─────────────────────────────────────────────────────

class _TopBarActions extends StatelessWidget {
  const _TopBarActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notification bell with badge
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              padding:     EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon:        const Icon(Icons.notifications_outlined,
                  color: AppColors.textDark, size: 22),
              onPressed: () {},
            ),
            Positioned(
              right: 4, top: 4,
              child: Container(
                width:  8, height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.notifRed, shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),

        // Dark-mode toggle (stub)
        IconButton(
          padding:     EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon:        const Icon(Icons.dark_mode_outlined,
              color: AppColors.textDark, size: 22),
          onPressed: () {},
        ),
        const SizedBox(width: 6),

        // Admin avatar
        Container(
          width:  34, height: 34,
          decoration: const BoxDecoration(
            color: AppColors.primary, shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text('A',
              style: TextStyle(
                color: AppColors.surface, fontWeight: FontWeight.bold, fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
