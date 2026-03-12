import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// SETTINGS TILE CARD & SECTION CARD
// ═══════════════════════════════════════════════════════════════════════════════

enum SettingsTileType { navigate, toggle, input, info, danger }

class SettingsTileCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Color? iconBg;
  final Color? iconColor;
  final SettingsTileType type;
  final VoidCallback? onTap;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggleChanged;
  final TextEditingController? inputController;
  final String? inputHint;
  final TextInputType? inputKeyboardType;
  final String? infoValue;
  final bool showDivider;

  const SettingsTileCard({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.iconBg,
    this.iconColor,
    this.type = SettingsTileType.navigate,
    this.onTap,
    this.toggleValue,
    this.onToggleChanged,
    this.inputController,
    this.inputHint,
    this.inputKeyboardType,
    this.infoValue,
    this.showDivider = false,
  });

  bool get _isDanger => type == SettingsTileType.danger;
  bool get _isInput => type == SettingsTileType.input;

  Color get _resolvedIconColor =>
      iconColor ?? (_isDanger ? AppColors.error : AppColors.primary);

  Color get _resolvedIconBg =>
      iconBg ?? (_isDanger ? const Color(0xFFFEF2F2) : AppColors.primarySurface);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider)
          const Divider(height: 1, color: AppColors.cardBorder),
        _wrapWithInkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: _isInput ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _resolvedIconBg,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: Icon(icon, size: 18, color: _resolvedIconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _isInput
                      ? _InputContent(label: label, controller: inputController!, hint: inputHint ?? '', keyboardType: inputKeyboardType)
                      : _LabelContent(label: label, subtitle: subtitle, isDanger: _isDanger),
                ),
                const SizedBox(width: 8),
                _buildTrailing(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    switch (type) {
      case SettingsTileType.navigate:
      case SettingsTileType.danger:
        return Icon(Icons.chevron_right_rounded, size: 20, color: _isDanger ? AppColors.error : AppColors.textSubtle);
      case SettingsTileType.toggle:
        return Switch(
          value: toggleValue ?? false,
          onChanged: onToggleChanged,
          activeTrackColor: AppColors.primary,
        );
      case SettingsTileType.info:
        return Text(infoValue ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textSubtle, fontWeight: FontWeight.w500));
      case SettingsTileType.input:
        return const SizedBox.shrink();
    }
  }

  Widget _wrapWithInkWell({required Widget child}) {
    final tappable = type == SettingsTileType.navigate || type == SettingsTileType.danger;
    if (!tappable || onTap == null) return child;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
      child: child,
    );
  }
}

class _LabelContent extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isDanger;
  const _LabelContent({required this.label, this.subtitle, required this.isDanger});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDanger ? AppColors.error : AppColors.textDark)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: const TextStyle(fontSize: 12, color: AppColors.textSubtle)),
        ],
      ],
    );
  }
}

class _InputContent extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  const _InputContent({required this.label, required this.controller, required this.hint, this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSubtle),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            isDense: true,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall), borderSide: const BorderSide(color: AppColors.cardBorder)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusSmall), borderSide: const BorderSide(color: AppColors.cardBorder)),
          ),
        ),
      ],
    );
  }
}

class SettingsSectionCard extends StatelessWidget {
  final IconData sectionIcon;
  final String title;
  final String? badge;
  final Color? badgeColor;
  final List<Widget> tiles;

  const SettingsSectionCard({
    super.key,
    required this.sectionIcon,
    required this.title,
    this.badge,
    this.badgeColor,
    required this.tiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(sectionIcon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.cardTitle),
                if (badge != null) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(99)),
                    child: Text(badge!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor ?? AppColors.primary)),
                  ),
                ],
              ],
            ),
          ),
          ...tiles,
        ],
      ),
    );
  }
}
