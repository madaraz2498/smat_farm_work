import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FeatureAppBar
//
// The standard AppBar used by every feature screen (Plant Disease, Animal
// Weight, Crop Recommendation, Soil Analysis, Fruit Quality, Chatbot).
// ─────────────────────────────────────────────────────────────────────────────

class FeatureAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String svgPath;
  final List<Widget>? actions;
  final bool showBack;


  const FeatureAppBar({

    super.key,
    required this.title,
    required this.svgPath,
    this.actions,
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      leading: showBack
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.textDark,
              ),
            )
          : null,
      title: Row(
        children: [
          _IconChip(svgPath: svgPath, cs: cs),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: tt.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: const _BottomDivider(),
    );
  }
}

class _IconChip extends StatelessWidget {
  final String svgPath;
  final ColorScheme cs;

  const _IconChip({required this.svgPath, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Center(
        child: SvgPicture.asset(svgPath, width: 18, height: 18),
      ),
    );
  }
}

class _BottomDivider extends StatelessWidget implements PreferredSizeWidget {
  const _BottomDivider();

  @override
  Size get preferredSize => const Size.fromHeight(1);

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.cardBorder);
}

// ─────────────────────────────────────────────────────────────────────────────
// DashboardNavBar
// ─────────────────────────────────────────────────────────────────────────────

class DashboardNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userRole;
  final bool showBurger;
  final VoidCallback onNotificationTap;

  const DashboardNavBar({
    super.key,
    required this.userName,
    required this.userRole,
    required this.showBurger,
    required this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.33),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (showBurger)
            Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded,
                    color: AppColors.textDark, size: 22),
              ),
            ),
          _LogoChip(cs: cs),
          const SizedBox(width: 10),
          if (!showBurger)
            Text(
              'Smart Farm AI',
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textDark,
              ),
            ),
          const Spacer(),
          _NotifBell(onTap: onNotificationTap),
          const SizedBox(width: 4),
          const _ThemeToggle(),
          const SizedBox(width: 4),
          _UserChip(name: userName, role: userRole, cs: cs),
        ],
      ),
    );
  }
}

class _LogoChip extends StatelessWidget {
  final ColorScheme cs;
  const _LogoChip({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.eco_rounded, color: Colors.white, size: 20),
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
          onPressed: onTap,
          icon: const Icon(
            Icons.notifications_outlined,
            size: 22,
            color: AppColors.textDark,
          ),
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

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.wb_sunny_outlined,
          size: 20, color: AppColors.textDark),
    );
  }
}

class _UserChip extends StatelessWidget {
  final String name;
  final String role;
  final ColorScheme cs;
  const _UserChip({required this.name, required this.role, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration:
              const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.person_rounded, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: AppTextStyles.label.copyWith(color: AppColors.textDark)),
            Text(role,
                style: AppTextStyles.caption.copyWith(color: AppColors.textSubtle)),
          ],
        ),
      ],
    );
  }
}
