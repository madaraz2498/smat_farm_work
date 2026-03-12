import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_farm/providers/auth_provider.dart';
import 'package:smart_farm/theme/app_theme.dart';
import 'package:smart_farm/widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameCtrl  = TextEditingController(text: 'Farm Owner');
  final _emailCtrl = TextEditingController(text: 'owner@smartfarm.com');
  final _phoneCtrl = TextEditingController(text: '+1234567890');

  String _themeMode = 'Light Mode';
  String _language  = 'English';
  bool   _pushNotif   = true;
  bool   _emailAlerts = true;

  static const _languages = ['English', 'Arabic', 'French'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const FeatureAppBar(

        title:    'Settings',
        svgPath:  'assets/images/icons/crop_icon.svg',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Page heading ─────────────────────────────────────────
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color:        AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: const Icon(Icons.settings_outlined,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text('Settings',
                      style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                ]),
                const SizedBox(height: 4),
                Text('Manage your account and application preferences',
                    style: tt.bodySmall?.copyWith(color: AppColors.textSubtle)),
                const SizedBox(height: 20),

                // ── Profile Settings card ─────────────────────────────────
                _SectionCard(children: [
                  const _SectionHeader(
                      icon: Icons.person_outline_rounded,
                      title: 'Profile Settings'),
                  const SizedBox(height: 20),

                  const _FieldLabel('Full Name'),
                  const SizedBox(height: 8),
                  _InputField(controller: _nameCtrl, hint: 'Full Name'),
                  const SizedBox(height: 16),

                  const _FieldLabel('Email'),
                  const SizedBox(height: 8),
                  _InputField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 16),

                  const _FieldLabel('Phone Number'),
                  const SizedBox(height: 8),
                  _InputField(
                      controller: _phoneCtrl,
                      hint: 'Phone Number',
                      type: TextInputType.phone),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSaved(context),
                      style: ElevatedButton.styleFrom(
                        padding:         const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 0,
                      ),
                      child: const Text('Save Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Theme Preference card ─────────────────────────────────
                _SectionCard(children: [
                  const _SectionHeader(
                      icon: Icons.palette_outlined,
                      title: 'Theme Preference'),
                  const SizedBox(height: 12),

                  _RadioRow(
                    label:    'Light Mode',
                    value:    'Light Mode',
                    groupVal: _themeMode,
                    onChanged: (v) => setState(() => _themeMode = v!),
                  ),
                  Divider(height: 1, color: AppColors.cardBorder),
                  _RadioRow(
                    label:    'Dark Mode',
                    value:    'Dark Mode',
                    groupVal: _themeMode,
                    onChanged: (v) => setState(() => _themeMode = v!),
                    filledDot: true,
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Language Selection card ───────────────────────────────
                _SectionCard(children: [
                  const _SectionHeader(
                      icon: Icons.language_rounded,
                      title: 'Language Selection'),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color:        AppColors.background,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                      border:       Border.all(color: AppColors.cardBorder),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:      _language,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSubtle),
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textDark),
                        dropdownColor: AppColors.surface,
                        borderRadius:  BorderRadius.circular(12),
                        items: _languages
                            .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                            .toList(),
                        onChanged: (v) => setState(() => _language = v!),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),

                // ── Notification Preferences card ─────────────────────────
                _SectionCard(children: [
                  const _SectionHeader(
                      icon: Icons.notifications_outlined,
                      title: 'Notification Preferences'),
                  const SizedBox(height: 12),

                  _CheckboxRow(
                    label:    'Push Notifications',
                    value:    _pushNotif,
                    onChanged: (v) => setState(() => _pushNotif = v ?? true),
                  ),
                  Divider(height: 1, color: AppColors.cardBorder),
                  _CheckboxRow(
                    label:    'Email Alerts',
                    value:    _emailAlerts,
                    onChanged: (v) => setState(() => _emailAlerts = v ?? true),
                  ),
                ]),
                const SizedBox(height: 24),

                // ── Sign out button ───────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showLogout(context),
                    icon: const Icon(Icons.logout_rounded,
                        size: 18, color: AppColors.error),
                    label: const Text('Sign Out',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side:    const BorderSide(color: AppColors.error),
                      shape:   RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMid)),
                      backgroundColor: const Color(0xFFFEF2F2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSaved(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:     Text('Profile saved'),
        backgroundColor: AppColors.primary,
        behavior:    SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sign Out',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark)),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(
              fontSize: 14, color: AppColors.textSubtle, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSubtle)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              context.read<AuthProvider>().logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sign Out',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─── Section card wrapper ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:   double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color:      Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset:     const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String   title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color:        AppColors.primarySurface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      const SizedBox(width: 12),
      Text(title,
          style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.textDark)),
    ]);
  }
}

// ─── Field label ──────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.textDark));
}

// ─── Input field ──────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String                hint;
  final TextInputType         type;

  const _InputField({
    required this.controller,
    required this.hint,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:   controller,
      keyboardType: type,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText:  hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textDisabled),
        filled:    true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide:   const BorderSide(color: AppColors.cardBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide:   const BorderSide(color: AppColors.cardBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            borderSide:   const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }
}

// ─── Radio row ────────────────────────────────────────────────────────────────

class _RadioRow extends StatelessWidget {
  final String   label;
  final String   value;
  final String   groupVal;
  final void Function(String?) onChanged;
  final bool     filledDot;

  const _RadioRow({
    required this.label,
    required this.value,
    required this.groupVal,
    required this.onChanged,
    this.filledDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt         = Theme.of(context).textTheme;
    final isSelected = value == groupVal;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              color:  isSelected ? AppColors.primary : AppColors.textSubtle,
              shape:  BoxShape.circle,
              border: Border.all(width: 2),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filledDot ? AppColors.textDark : AppColors.primary,
                ),
              ),
            )
                : null,
          ),
          const SizedBox(width: 12),
          Text(label,
              style: tt.bodyMedium?.copyWith(color: AppColors.textDark)),
        ]),
      ),
    );
  }
}

// ─── Checkbox row ─────────────────────────────────────────────────────────────

class _CheckboxRow extends StatelessWidget {
  final String label;
  final bool   value;
  final void Function(bool?) onChanged;

  const _CheckboxRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: tt.bodyMedium?.copyWith(color: AppColors.textDark)),
        ),
        Checkbox(
          value:       value,
          onChanged:   onChanged,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ]),
    );
  }
}