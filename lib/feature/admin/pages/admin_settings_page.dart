import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/widgets/custom_app_bar.dart';
import '../widgets/seetings_tile.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// ADMIN SETTINGS PAGE
// Sections: Profile, System, User Management, Security, Logs, Danger Zone.
// ═══════════════════════════════════════════════════════════════════════════════

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  late final TextEditingController _adminNameCtrl;
  late final TextEditingController _adminEmailCtrl;
  late final TextEditingController _baseUrlCtrl;

  String _environment = 'Production';
  static const _kEnvironments = ['Production', 'Staging', 'Development'];

  bool _openRegistration = true;
  String _defaultRole = 'Farmer';
  static const _kRoles = ['Farmer', 'Agronomist', 'Researcher'];

  bool _twoFaRequired = false;
  bool _ipWhitelist = false;
  bool _auditLog = true;

  String _logLevel = 'Info';
  static const _kLogLevels = ['Verbose', 'Debug', 'Info', 'Warning', 'Error'];

  bool _maintenanceMode = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _adminNameCtrl = TextEditingController(text: user?.name ?? 'System Administrator');
    _adminEmailCtrl = TextEditingController(text: user?.email ?? 'admin@smartfarm.com');
    _baseUrlCtrl = TextEditingController(text: 'https://api.smartfarm.com/v1');
  }

  @override
  void dispose() {
    _adminNameCtrl.dispose();
    _adminEmailCtrl.dispose();
    _baseUrlCtrl.dispose();
    super.dispose();
  }

  void _showPickerDialog(String title, List<String> options, String current, ValueChanged<String> onSelect) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
        title: Text(title, style: AppTextStyles.cardTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) {
            final sel = opt == current;
            return ListTile(
              dense: true,
              title: Text(opt, style: TextStyle(color: sel ? AppColors.primary : AppColors.textDark, fontWeight: sel ? FontWeight.w600 : FontWeight.w400)),
              trailing: sel ? const Icon(Icons.check_rounded, color: AppColors.primary, size: 18) : null,
              onTap: () {
                onSelect(opt);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _confirmDangerAction(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(AppSizes.radiusSmall)),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
            ),
            const SizedBox(width: 12),
            Text(title, style: AppTextStyles.cardTitle),
          ],
        ),
        content: Text(message, style: AppTextStyles.pageSubtitle),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSubtle))),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final initials = _initials(user?.name ?? 'Admin');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pagePadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminSettingsHeading(initials: initials, name: user?.name ?? 'Admin', email: user?.email ?? 'admin@smartfarm.com'),
                const SizedBox(height: 24),
                
                // 1. Admin Profile
                SettingsSectionCard(
                  sectionIcon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Profile',
                  tiles: [
                    SettingsTileCard(
                      icon: Icons.badge_outlined,
                      label: 'Display Name',
                      type: SettingsTileType.input,
                      inputController: _adminNameCtrl,
                      inputHint: 'Administrator name',
                    ),
                    SettingsTileCard(
                      icon: Icons.email_outlined,
                      label: 'Admin Email',
                      type: SettingsTileType.input,
                      inputController: _adminEmailCtrl,
                      inputHint: 'admin@domain.com',
                      inputKeyboardType: TextInputType.emailAddress,
                      showDivider: true,
                    ),
                    SettingsTileCard(
                      icon: Icons.lock_reset_outlined,
                      label: 'Change Admin Password',
                      type: SettingsTileType.navigate,
                      onTap: () {},
                      showDivider: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. System Configuration
                SettingsSectionCard(
                  sectionIcon: Icons.dns_outlined,
                  title: 'System Configuration',
                  badge: 'Developer',
                  badgeColor: const Color(0xFF6366F1),
                  tiles: [
                    SettingsTileCard(
                      icon: Icons.link_rounded,
                      label: 'API Base URL',
                      type: SettingsTileType.input,
                      inputController: _baseUrlCtrl,
                      inputHint: 'https://api.yourdomain.com/v1',
                      inputKeyboardType: TextInputType.url,
                    ),
                    SettingsTileCard(
                      icon: Icons.layers_outlined,
                      label: 'Environment',
                      subtitle: _environment,
                      type: SettingsTileType.navigate,
                      onTap: () => _showPickerDialog('Environment', _kEnvironments, _environment, (v) => setState(() => _environment = v)),
                      showDivider: true,
                    ),
                    SettingsTileCard(
                      icon: Icons.tag_rounded,
                      label: 'API Version',
                      type: SettingsTileType.info,
                      infoValue: 'v1.0.0',
                      showDivider: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 3. User Management
                SettingsSectionCard(
                  sectionIcon: Icons.people_outline,
                  title: 'User Management',
                  badge: 'Admin Only',
                  tiles: [
                    SettingsTileCard(
                      icon: Icons.manage_accounts_outlined,
                      label: 'Default User Role',
                      subtitle: _defaultRole,
                      type: SettingsTileType.navigate,
                      onTap: () => _showPickerDialog('Default Role', _kRoles, _defaultRole, (v) => setState(() => _defaultRole = v)),
                      showDivider: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Danger Zone
                SettingsSectionCard(
                  sectionIcon: Icons.warning_amber_rounded,
                  title: 'Danger Zone',
                  badge: 'Irreversible',
                  badgeColor: AppColors.error,
                  tiles: [
                    SettingsTileCard(
                      icon: Icons.engineering_outlined,
                      label: 'Maintenance Mode',
                      subtitle: _maintenanceMode ? 'Platform is currently offline' : 'Put platform in maintenance mode',
                      type: SettingsTileType.toggle,
                      iconBg: const Color(0xFFFFFBEB),
                      iconColor: AppColors.warning,
                      toggleValue: _maintenanceMode,
                      onToggleChanged: (v) {
                        if (v) {
                          _confirmDangerAction('Maintenance Mode', 'This will lock out all users.', () => setState(() => _maintenanceMode = true));
                        } else {
                          setState(() => _maintenanceMode = false);
                        }
                      },
                    ),
                    SettingsTileCard(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      subtitle: 'End your admin session',
                      type: SettingsTileType.danger,
                      onTap: () => _confirmDangerAction('Sign Out', 'Your session will end.', () => context.read<AuthProvider>().logout()),
                      showDivider: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminSettingsHeading extends StatelessWidget {
  final String initials, name, email;
  const _AdminSettingsHeading({required this.initials, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 56, height: 56,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Center(child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(fontSize: 13, color: AppColors.textSubtle)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.shield_outlined, size: 12, color: AppColors.primary),
                SizedBox(width: 4),
                Text('Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  return name.isNotEmpty ? name[0].toUpperCase() : 'A';
}
