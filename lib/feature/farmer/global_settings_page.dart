import 'package:flutter/material.dart';

/// Admin-only settings page for managing system-wide AI thresholds
/// and platform behaviour.  All values are local state for now —
/// wire them to your API when the backend is ready.
class GlobalSettingsPage extends StatefulWidget {
  const GlobalSettingsPage({super.key});

  @override
  State<GlobalSettingsPage> createState() => _GlobalSettingsPageState();
}

class _GlobalSettingsPageState extends State<GlobalSettingsPage> {
  // ── AI confidence thresholds (0.0 – 1.0) ─────────────────────────────────
  double _plantConfidence = 0.75;
  double _animalConfidence = 0.70;
  double _cropConfidence = 0.65;
  double _soilConfidence = 0.70;
  double _fruitConfidence = 0.72;

  // ── Platform toggles ──────────────────────────────────────────────────────
  bool _maintenanceMode = false;
  bool _registrationOpen = true;
  bool _emailNotifications = true;
  bool _autoBackup = true;

  // ── Quota fields ──────────────────────────────────────────────────────────
  final _maxRequestsCtrl = TextEditingController(text: '500');
  final _sessionTimeoutCtrl = TextEditingController(text: '60');

  bool _saved = false;

  @override
  void dispose() {
    _maxRequestsCtrl.dispose();
    _sessionTimeoutCtrl.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Settings saved successfully.'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text('Global Settings',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937))),
          const SizedBox(height: 4),
          const Text(
              'System-wide configuration for AI models and platform behaviour.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280))),
          const SizedBox(height: 28),

          // ── AI Confidence thresholds ────────────────────────────────────
          _sectionCard(
            title: 'AI Confidence Thresholds',
            subtitle:
                'Minimum confidence score required before a result is shown to users.',
            child: Column(
              children: [
                _threshold(
                  label: 'Plant Disease Detection',
                  icon: Icons.local_florist_outlined,
                  color: const Color(0xFF4CAF50),
                  value: _plantConfidence,
                  onChanged: (v) =>
                      setState(() => _plantConfidence = v),
                ),
                _threshold(
                  label: 'Animal Weight Estimation',
                  icon: Icons.monitor_weight_outlined,
                  color: const Color(0xFF2196F3),
                  value: _animalConfidence,
                  onChanged: (v) =>
                      setState(() => _animalConfidence = v),
                ),
                _threshold(
                  label: 'Crop Recommendation',
                  icon: Icons.grass_outlined,
                  color: const Color(0xFF9C27B0),
                  value: _cropConfidence,
                  onChanged: (v) =>
                      setState(() => _cropConfidence = v),
                ),
                _threshold(
                  label: 'Soil Type Analysis',
                  icon: Icons.layers_outlined,
                  color: const Color(0xFFFF9800),
                  value: _soilConfidence,
                  onChanged: (v) =>
                      setState(() => _soilConfidence = v),
                ),
                _threshold(
                  label: 'Fruit Quality Analysis',
                  icon: Icons.apple_outlined,
                  color: const Color(0xFFF44336),
                  value: _fruitConfidence,
                  onChanged: (v) =>
                      setState(() => _fruitConfidence = v),
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Platform toggles ────────────────────────────────────────────
          _sectionCard(
            title: 'Platform Controls',
            child: Column(
              children: [
                _toggle(
                  label: 'Maintenance Mode',
                  desc: 'Temporarily blocks all user access while you update the system.',
                  value: _maintenanceMode,
                  activeColor: const Color(0xFFEF4444),
                  onChanged: (v) =>
                      setState(() => _maintenanceMode = v),
                ),
                _toggle(
                  label: 'Open Registration',
                  desc: 'Allow new users to create accounts.',
                  value: _registrationOpen,
                  activeColor: const Color(0xFF4CAF50),
                  onChanged: (v) =>
                      setState(() => _registrationOpen = v),
                ),
                _toggle(
                  label: 'Email Notifications',
                  desc: 'Send system-level alerts and reports via email.',
                  value: _emailNotifications,
                  activeColor: const Color(0xFF2196F3),
                  onChanged: (v) =>
                      setState(() => _emailNotifications = v),
                ),
                _toggle(
                  label: 'Automatic Daily Backup',
                  desc: 'Back up the database every night at 02:00 UTC.',
                  value: _autoBackup,
                  activeColor: const Color(0xFF9C27B0),
                  onChanged: (v) => setState(() => _autoBackup = v),
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Quotas ──────────────────────────────────────────────────────
          _sectionCard(
            title: 'Usage Limits',
            child: Column(
              children: [
                _inputRow(
                  label: 'Max AI Requests / User / Day',
                  hint: 'e.g. 500',
                  controller: _maxRequestsCtrl,
                ),
                const SizedBox(height: 16),
                _inputRow(
                  label: 'Session Timeout (minutes)',
                  hint: 'e.g. 60',
                  controller: _sessionTimeoutCtrl,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: const Text('Save All Settings',
                  style: TextStyle(fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section card wrapper ──────────────────────────────────────────────────

  Widget _sectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937))),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF9CA3AF))),
          ],
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // ── Threshold slider row ──────────────────────────────────────────────────

  Widget _threshold({
    required String label,
    required IconData icon,
    required Color color,
    required double value,
    required ValueChanged<double> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('${(value * 100).toInt()}%',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 7),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: color,
              thumbColor: color,
              inactiveTrackColor: Colors.grey.shade200,
              overlayColor: color.withOpacity(0.15),
            ),
            child: Slider(
              value: value,
              min: 0.5,
              max: 0.99,
              divisions: 49,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('50%',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF9CA3AF))),
                Text('99%',
                    style: TextStyle(
                        fontSize: 10, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Toggle row ────────────────────────────────────────────────────────────

  Widget _toggle({
    required String label,
    required String desc,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937))),
                const SizedBox(height: 2),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }

  // ── Input row ─────────────────────────────────────────────────────────────

  Widget _inputRow({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F2937))),
        ),
        SizedBox(
          width: 110,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF), fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.12)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.12)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: Color(0xFF4CAF50)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
