import 'package:flutter/material.dart';
import 'package:smart_farm/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// admin_forms.dart
//
// All admin dialog / form functions live here so that page files stay thin.
// Call these static helpers from any admin page.
// ─────────────────────────────────────────────────────────────────────────────
class AdminForms {
  AdminForms._();

  // ── Add User dialog ────────────────────────────────────────────────────────
  static Future<void> showAddUser(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const _AddUserDialog(),
    );
  }

  // ── Generate Report dialog ─────────────────────────────────────────────────
  static Future<void> showGenerateReport(BuildContext context) {
    return showDialog(
      context: context,
      builder: (_) => const _GenerateReportDialog(),
    );
  }

  // ── Confirm Delete dialog ──────────────────────────────────────────────────
  static Future<bool> showConfirmDelete(
    BuildContext context, {
    required String itemName,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDeleteDialog(itemName: itemName),
    );
    return result ?? false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _AddUserDialog
// ─────────────────────────────────────────────────────────────────────────────
class _AddUserDialog extends StatefulWidget {
  const _AddUserDialog();

  @override
  State<_AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<_AddUserDialog> {
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool   _saving   = false;


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding:    const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:        AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_add_outlined,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Add New Admin', style: AppTextStyles.cardTitle),
                  ),
                  IconButton(
                    icon:      const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Email
              _FormField(
                label: 'Email Address',
                hint:  'e.g. ahmed@smartfarm.ai',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),


              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:  AppColors.textSubtle,
                        side:             BorderSide(color: Colors.black.withOpacity(0.15)),
                        padding:          const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saving ? null : _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation:       0,
                        padding:         const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white,
                              ),
                            )
                          : const Text('Add Admin'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSave() async {
    if (_nameCtrl.text.trim().isEmpty || _emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.'),
            backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1)); // simulate API call
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameCtrl.text.trim()} added successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GenerateReportDialog
// ─────────────────────────────────────────────────────────────────────────────
class _GenerateReportDialog extends StatefulWidget {
  const _GenerateReportDialog();

  @override
  State<_GenerateReportDialog> createState() => _GenerateReportDialogState();
}

class _GenerateReportDialogState extends State<_GenerateReportDialog> {
  String _period  = 'Last 7 Days';
  String _format  = 'CSV';
  bool   _exporting = false;

  static const _periods = ['Today', 'Last 7 Days', 'Last 30 Days', 'This Year'];
  static const _formats = ['CSV', 'PDF', 'Excel'];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:    const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:        const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bar_chart_outlined,
                        color: AppColors.info, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Generate Report', style: AppTextStyles.cardTitle),
                  ),
                  IconButton(
                    icon:      const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _DropdownField(
                label: 'Report Period', value: _period, items: _periods,
                onChanged: (v) => setState(() => _period = v),
              ),
              const SizedBox(height: 14),

              _DropdownField(
                label: 'Export Format', value: _format, items: _formats,
                onChanged: (v) => setState(() => _format = v),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _exporting ? null : _onExport,
                  icon:  const Icon(Icons.download_outlined, size: 16),
                  label: _exporting
                      ? const Text('Generating…')
                      : Text('Export as $_format'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                    elevation:       0,
                    padding:         const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onExport() async {
    setState(() => _exporting = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$_period report exported as $_format!'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConfirmDeleteDialog
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog({required this.itemName});
  final String itemName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLarge)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:    const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:        const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.delete_outline,
                    color: AppColors.error, size: 28),
              ),
              const SizedBox(height: 16),
              const Text('Confirm Delete', style: AppTextStyles.cardTitle),
              const SizedBox(height: 8),
              Text('Are you sure you want to delete "$itemName"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSubtle,
                        side: BorderSide(color: Colors.black.withOpacity(0.15)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation:       0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable field widgets (private to this file)
// ─────────────────────────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType,
  });
  final String             label, hint;
  final TextEditingController controller;
  final TextInputType?     keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller:   controller,
          keyboardType: keyboardType,
          style:        const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText:        hint,
            hintStyle:       AppTextStyles.caption,
            contentPadding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled:          true,
            fillColor:       AppColors.background,
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

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String             label, value;
  final List<String>       items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 6),
        Container(
          width:   double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color:        AppColors.background,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            border:       Border.all(color: Colors.black.withOpacity(0.12)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:      value,
              isExpanded: true,
              style:      const TextStyle(fontSize: 13, color: AppColors.textDark),
              items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
              onChanged: (v) { if (v != null) onChanged(v); },
            ),
          ),
        ),
      ],
    );
  }
}
