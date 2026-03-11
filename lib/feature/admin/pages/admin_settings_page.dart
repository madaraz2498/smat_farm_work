import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminSettingsPage  —  personal profile, preferences, and danger zone.
// ─────────────────────────────────────────────────────────────────────────────
class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  final _nameCtrl  = TextEditingController(text: 'Admin User');
  final _emailCtrl = TextEditingController(text: 'admin@smartfarm.ai');

  var _darkMode         = false;
  var _pushNotifications = true;
  var _weeklyDigest     = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text('Manage your account and preferences', style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 24),

          // Avatar / profile summary
          _ProfileHeader(
            name:  _nameCtrl.text,
            email: _emailCtrl.text,
          ),
          const SizedBox(height: 20),

          // Profile form
          _Card(title: 'Profile Information', children: [
            _LabeledField(label: 'Full Name',      controller: _nameCtrl),
            const SizedBox(height: 14),
            _LabeledField(label: 'Email Address',  controller: _emailCtrl, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _LabeledField(label: 'Current Password', obscure: true, controller: TextEditingController()),
            const SizedBox(height: 14),
            _LabeledField(label: 'New Password',     obscure: true, controller: TextEditingController()),
            const SizedBox(height: 20),
            _PrimaryButton(label: 'Save Changes', onPressed: _onSave),
          ]),
          const SizedBox(height: 16),

          // Preferences
          _Card(title: 'Preferences', children: [
            _ToggleRow('Dark Mode',           'Switch app to dark theme',   _darkMode,          (v) => setState(() => _darkMode          = v)),
            _ToggleRow('Push Notifications',  'Receive push alerts',        _pushNotifications, (v) => setState(() => _pushNotifications  = v)),
            _ToggleRow('Weekly Digest Email', 'Summary email every Monday', _weeklyDigest,      (v) => setState(() => _weeklyDigest       = v)),
          ]),
          const SizedBox(height: 16),

          // Danger zone
          _DangerZone(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _onSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!'), backgroundColor: AppColors.primary),
    );
  }
}

// ── Profile header ─────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.email});
  final String name, email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Container(
            width:  56, height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('A',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.cardTitle, overflow: TextOverflow.ellipsis),
                Text(email, style: AppTextStyles.caption,  overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color:        AppColors.adminSurface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  ),
                  child: const Text('Super Admin',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.adminAccent)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Danger zone ────────────────────────────────────────────────────────────────

class _DangerZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
              const SizedBox(width: 8),
              const Text('Danger Zone',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error)),
            ],
          ),
          const SizedBox(height: 14),
          const Text('These actions are irreversible. Proceed with caution.',
            style: AppTextStyles.caption),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon:  const Icon(Icons.logout, size: 16),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side:            const BorderSide(color: AppColors.error),
                    padding:         const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon:  const Icon(Icons.delete_forever, size: 16),
                  label: const Text('Delete Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation:       0,
                    padding:         const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});
  final String       title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:    const EdgeInsets.all(AppSizes.pagePadding),
      decoration: BoxDecoration(
        color:        AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border:       Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow:   [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    this.obscure      = false,
    this.keyboardType,
  });
  final String                label;
  final TextEditingController controller;
  final bool                  obscure;
  final TextInputType?        keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller:     controller,
          obscureText:    obscure,
          keyboardType:   keyboardType,
          style:          const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled:         true,
            fillColor:      AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              borderSide:   BorderSide(color: Colors.black.withOpacity(0.12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              borderSide:   BorderSide(color: Colors.black.withOpacity(0.12)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusMid),
              borderSide:   const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow(this.label, this.desc, this.value, this.onChanged);
  final String label, desc;
  final bool   value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.label),
                Text(desc,  style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});
  final String       label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation:       0,
          padding:         const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
